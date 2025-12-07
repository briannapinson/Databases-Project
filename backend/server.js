

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const { router: authRouter, verifyToken } = require('./auth');
require('dotenv').config();


const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'riftbounddb',
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

console.log('DB Env Loaded:', {
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD ? '***SET***' : 'MISSING!',  // Don't log full pass
  port: process.env.DB_PORT
});

// Make pool available to routes
app.use((req, res, next) => {
  req.pool = pool;
  next();
});

// Auth routes
app.use('/api/auth', authRouter);

// Test endpoint
app.get('/api/test', (req, res) => {
  res.json({ message: 'Backend is working!' });
});

// Get all cards (no auth required)
app.get('/api/cards', async (req, res) => {
  try {
    const query = `
      SELECT 
        cp.card_id,
        c.card_name,
        c.card_type,
        c.domain,
        c.energy,
        c.might,
        c.power,
        c.ability_text,
        c.flavor_text,
        c.artist,
        c.collector_number,
        cp.printing_id,
        cp.rarity,
        cp.signed,
        cp.overnumbered,
        cp.alt_art,
        CASE
          WHEN cp.signed = true THEN 'signed'
          WHEN cp.alt_art = true AND cp.overnumbered = false THEN 'alt_art'
          ELSE 'regular'
        END as printing_type,
        cp.printing_id as image_id
      FROM card_printing cp
      INNER JOIN card c ON cp.card_ID = c.card_ID
      ORDER BY 
        cp.card_id,
        CASE 
          WHEN cp.printing_id ~ '^[0-9]+$' THEN 0
          ELSE 1
        END,
        cp.printing_id
    `;
    
    const result = await pool.query(query);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching cards:', err);
    res.status(500).json({ error: 'Database error', details: err.message });
  }
});

// Get card by ID (no auth required)
app.get('/api/cards/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM card WHERE card_ID = $1', [id]);
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Search cards by name (no auth required)
app.get('/api/cards/search/:query', async (req, res) => {
  try {
    const { query } = req.params;
    const result = await pool.query(
      'SELECT * FROM card WHERE card_NAME ILIKE $1 LIMIT 20',
      [`%${query}%`]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});

// Get collection for logged-in user (auth required)
app.get('/api/collection', verifyToken, async (req, res) => {
  try {
    console.log('Fetching collection for user:', req.userId);
    
    // Get user's collection_id
    const collectionResult = await pool.query(
      'SELECT collection_ID FROM collection WHERE USER_ID = $1',
      [req.userId]
    );

    if (collectionResult.rows.length === 0) {
      // Create collection if it doesn't exist
      const newCollection = await pool.query(
        'INSERT INTO collection (USER_ID) VALUES ($1) RETURNING collection_ID',
        [req.userId]
      );
      console.log('Created new collection:', newCollection.rows[0]);
      return res.json([]);
    }

    const collectionId = collectionResult.rows[0].collection_id;
    console.log('Found collection ID:', collectionId);

    const result = await pool.query(`
      SELECT 
        cc.collection_id,
        cc.printing_id,
        cc.quantity,
        cc.condition,
        c.card_id,
        c.card_name,
        c.card_type,
        c.domain,
        c.energy,
        c.might,
        c.power,
        c.ability_text,
        c.collector_number,
        cp.rarity,
        cp.signed,
        cp.overnumbered,
        cp.alt_art,
        CASE
          WHEN cp.signed = true THEN 'signed'
          WHEN cp.alt_art = true AND cp.overnumbered = false THEN 'alt_art'
          ELSE 'regular'
        END as printing_type,
        cp.printing_id as image_id
      FROM collection_card cc
      JOIN card_printing cp ON cc.PRINTING_ID = cp.PRINTING_ID
      JOIN card c ON cp.card_ID = c.card_ID
      WHERE cc.collection_ID = $1
      ORDER BY c.card_ID
    `, [collectionId]);
    
    console.log('Found', result.rows.length, 'cards in collection');
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching collection:', err);
    res.status(500).json({ error: 'Database error', details: err.message });
  }
});

// Add card to collection (auth required)
app.post('/api/collection', verifyToken, async (req, res) => {
  try {
    const { printing_id, quantity = 1 } = req.body;
    console.log('Adding to collection:', { userId: req.userId, printing_id, quantity });

    // Get or create user's collection
    let collectionResult = await pool.query(
      'SELECT collection_ID FROM collection WHERE USER_ID = $1',
      [req.userId]
    );

    let collectionId;
    if (collectionResult.rows.length === 0) {
      const newCollection = await pool.query(
        'INSERT INTO collection (USER_ID) VALUES ($1) RETURNING collection_ID',
        [req.userId]
      );
      collectionId = newCollection.rows[0].collection_id;
      console.log('Created new collection:', collectionId);
    } else {
      collectionId = collectionResult.rows[0].collection_id;
      console.log('Using existing collection:', collectionId);
    }

    // Check if card already exists in collection
    const existing = await pool.query(
      'SELECT * FROM collection_card WHERE collection_ID = $1 AND PRINTING_ID = $2',
      [collectionId, printing_id]
    );

    if (existing.rows.length > 0) {
      console.log('Updating existing card quantity');
      const result = await pool.query(
        'UPDATE collection_card SET QUANTITY = QUANTITY + $1 WHERE collection_ID = $2 AND PRINTING_ID = $3 RETURNING *',
        [quantity, collectionId, printing_id]
      );
      res.json(result.rows[0]);
    } else {
      console.log('Inserting new card');
      const result = await pool.query(
        `INSERT INTO collection_card (collection_ID, PRINTING_ID, QUANTITY, CONDITION, DATE_ADDED)
         VALUES ($1, $2, $3, $4, CURRENT_DATE) RETURNING *`,
        [collectionId, printing_id, quantity, 'Near Mint']
      );
      res.json(result.rows[0]);
    }
  } catch (err) {
    console.error('Error adding to collection:', err);
    res.status(500).json({ error: 'Database error', details: err.message });
  }
});

// Update quantity in collection (auth required)
app.patch('/api/collection/:printingId', verifyToken, async (req, res) => {
  try {
    const { printingId } = req.params;
    const { quantity } = req.body;
    console.log('Updating quantity:', { userId: req.userId, printingId, quantity });

    // Get user's collection_id
    const collectionResult = await pool.query(
      'SELECT collection_ID FROM collection WHERE USER_ID = $1',
      [req.userId]
    );

    if (collectionResult.rows.length === 0) {
      return res.status(404).json({ error: 'Collection not found' });
    }

    const collectionId = collectionResult.rows[0].collection_id;

    if (quantity <= 0) {
      console.log('Deleting card from collection');
      await pool.query(
        'DELETE FROM collection_card WHERE collection_ID = $1 AND PRINTING_ID = $2',
        [collectionId, printingId]
      );
      res.json({ deleted: true });
    } else {
      console.log('Updating card quantity');
      const result = await pool.query(
        'UPDATE collection_card SET QUANTITY = $1 WHERE collection_ID = $2 AND PRINTING_ID = $3 RETURNING *',
        [quantity, collectionId, printingId]
      );
      res.json(result.rows[0]);
    }
  } catch (err) {
    console.error('Error updating collection:', err);
    res.status(500).json({ error: 'Database error', details: err.message });
  }
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});