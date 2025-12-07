import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from './AuthContext';
import AuthModal from './AuthModal';
import './Collection.css';

function Collection() {
  // Auth states
  const { user, logout, loading: authLoading, getAuthHeaders } = useAuth();
  const navigate = useNavigate();
  const [showAuthModal, setShowAuthModal] = useState(false);
  
  // Collection states
  const [collection, setCollection] = useState([]);
  const [filteredCollection, setFilteredCollection] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [selectedCard, setSelectedCard] = useState(null);
  const [showModal, setShowModal] = useState(false);

  const getImagePath = (imageId) => {
    if (imageId.match(/^\d+$/)) {
      return String(imageId).padStart(3, '0');
    } else {
      const match = imageId.match(/^(\d+)([a-z]*)$/i);
      if (match) {
        return match[1].padStart(3, '0') + match[2];
      } else {
        return imageId;
      }
    }
  };

  // Check if user is logged in
  useEffect(() => {
    if (!authLoading && !user) {
      setShowAuthModal(true);
    }
  }, [user, authLoading]);

  // Fetch collection with auth
  useEffect(() => {
    if (user) {
      fetch('http://localhost:3001/api/collection', {
        headers: getAuthHeaders()
      })
        .then(res => res.json())
        .then(data => {
          setCollection(data);
          setFilteredCollection(data);
          setLoading(false);
        })
        .catch(err => {
          console.error('Error fetching collection:', err);
          setLoading(false);
        });
    } else {
      setLoading(false);
    }
  }, [user]);

  // Filter by search query
  useEffect(() => {
    if (searchQuery.trim() === '') {
      setFilteredCollection(collection);
    } else {
      const filtered = collection.filter(card =>
        card.card_name.toLowerCase().includes(searchQuery.toLowerCase())
      );
      setFilteredCollection(filtered);
    }
  }, [searchQuery, collection]);

  const updateQuantity = async (printingId, change) => {
    const card = collection.find(c => c.printing_id === printingId);
    const newQuantity = card.quantity + change;

    try {
      const response = await fetch(`http://localhost:3001/api/collection/${printingId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          ...getAuthHeaders()
        },
        body: JSON.stringify({ quantity: newQuantity })
      });

      if (response.ok) {
        // Refresh collection
        const updatedCollection = await fetch('http://localhost:3001/api/collection', {
          headers: getAuthHeaders()
        }).then(r => r.json());
        setCollection(updatedCollection);
      }
    } catch (err) {
      console.error('Error updating quantity:', err);
    }
  };

  const openModal = (card) => {
    setSelectedCard(card);
    setShowModal(true);
  };

  const closeModal = () => {
    setShowModal(false);
    setSelectedCard(null);
  };

  const handleAuthModalClose = () => {
    setShowAuthModal(false);
    if (!user) {
      navigate('/');
    }
  };

  // Get stats
    const totalCards = Array.isArray(collection) && collection.length > 0 
    ? collection.reduce((sum, card) => sum + card.quantity, 0) 
    : 0;
    const uniqueCards = Array.isArray(collection) ? collection.length : 0;

  // Show loading while checking auth
  if (authLoading) {
    return <div style={{textAlign: 'center', padding: '40px'}}>Loading...</div>;
  }

  return (
    <div className="collection-page">
      <div className="nav-bar">
        <Link to="/" style={{ textDecoration: 'none' }}>
          <button>Home</button>
        </Link>
        <button>Decks</button>
        <Link to="/card-library" style={{ textDecoration: 'none' }}>
          <button>Card Library</button>
        </Link>
        <button>Your Collection</button>
        
        {user ? (
          <div style={{ marginLeft: 'auto', display: 'flex', gap: '10px', alignItems: 'center' }}>
            <span style={{ color: '#333' }}>Welcome, {user.username}!</span>
            <button onClick={logout}>Logout</button>
          </div>
        ) : (
          <button 
            onClick={() => setShowAuthModal(true)}
            style={{ marginLeft: 'auto' }}
          >
            Login
          </button>
        )}
      </div>

      {user ? (
        <div className="collection-container">
          <h2>My Collection</h2>

          {/* Stats Section */}
          <div className="collection-stats">
            <div className="stat-card">
              <h3>{totalCards}</h3>
              <p>Total Cards</p>
            </div>
            <div className="stat-card">
              <h3>{uniqueCards}</h3>
              <p>Unique Cards</p>
            </div>
            <div className="stat-card">
              <h3>{Math.round((uniqueCards / 310) * 100)}%</h3>
              <p>Collection Complete</p>
            </div>
          </div>

          {/* Search Bar */}
          <div className="search-section">
            <input 
              type="text"
              placeholder="Search cards by name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="search-input"
            />
          </div>

          {/* Collection Grid */}
          {loading ? (
            <p style={{textAlign: 'center', padding: '40px'}}>Loading collection...</p>
          ) : collection.length === 0 ? (
            <div className="empty-collection">
              <p>Your collection is empty!</p>
              <Link to="/card-library">
                <button className="browse-btn">Browse Card Library</button>
              </Link>
            </div>
          ) : filteredCollection.length === 0 ? (
            <div className="empty-collection">
              <p>No cards found matching "{searchQuery}"</p>
            </div>
          ) : (
            <div className="collection-grid">
              {filteredCollection.map(card => (
                <div 
                  key={card.collection_id}
                  className="collection-card"
                >
                  <div className="card-quantity-badge">{card.quantity}x</div>
                  <img 
                    src={`/images/${getImagePath(card.image_id)}_origins.avif`}
                    alt={card.card_name} 
                    className="card-image"
                    onClick={() => openModal(card)}
                    onError={(e) => {
                      e.target.src = '/images/placeholder.png';
                    }}
                  />
                  <div className="card-controls">
                    <button 
                      className="qty-btn"
                      onClick={() => updateQuantity(card.printing_id, -1)}
                    >
                      -
                    </button>
                    <span className="quantity">{card.quantity}</span>
                    <button 
                      className="qty-btn"
                      onClick={() => updateQuantity(card.printing_id, 1)}
                    >
                      +
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      ) : (
        <div style={{textAlign: 'center', padding: '60px'}}>
          <h2>Please log in to view your collection</h2>
          <button 
            onClick={() => setShowAuthModal(true)}
            style={{
              padding: '12px 24px',
              background: '#4a90e2',
              color: 'white',
              border: 'none',
              borderRadius: '6px',
              fontSize: '16px',
              cursor: 'pointer',
              marginTop: '20px'
            }}
          >
            Login / Sign Up
          </button>
        </div>
      )}

      {/* Modal */}
      {showModal && selectedCard && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="modal-close" onClick={closeModal}>✕</button>
            
            <div className="modal-body">
              <div className="modal-image-container">
                <img 
                  src={`/images/${getImagePath(selectedCard.image_id)}_origins.avif`}
                  alt={selectedCard.card_name}
                  className="modal-card-image"
                  onError={(e) => {
                    e.target.src = '/images/placeholder.png';
                  }}
                />
              </div>

              <div className="modal-details">
                <h2>{selectedCard.card_name}</h2>
                
                <div className="detail-row">
                  <span className="detail-label">Quantity Owned:</span>
                  <span className="detail-value">{selectedCard.quantity}</span>
                </div>

                <div className="detail-row">
                  <span className="detail-label">Type:</span>
                  <span className="detail-value">{selectedCard.card_type}</span>
                </div>

                <div className="detail-row">
                  <span className="detail-label">Domain:</span>
                  <span className="detail-value">{selectedCard.domain}</span>
                </div>

                {selectedCard.rarity && (
                  <div className="detail-row">
                    <span className="detail-label">Rarity:</span>
                    <span className="detail-value">{selectedCard.rarity}</span>
                  </div>
                )}

                {selectedCard.energy !== null && selectedCard.energy !== undefined && (
                  <div className="detail-row">
                    <span className="detail-label">Energy:</span>
                    <span className="detail-value">{selectedCard.energy}</span>
                  </div>
                )}

                {selectedCard.might !== null && selectedCard.might !== undefined && (
                  <div className="detail-row">
                    <span className="detail-label">Might:</span>
                    <span className="detail-value">{selectedCard.might}</span>
                  </div>
                )}

                {selectedCard.power !== null && selectedCard.power !== undefined && (
                  <div className="detail-row">
                    <span className="detail-label">Power:</span>
                    <span className="detail-value">{selectedCard.power}</span>
                  </div>
                )}

                {selectedCard.ability_text && (
                  <div className="detail-section">
                    <span className="detail-label">Ability:</span>
                    <p className="ability-text">{selectedCard.ability_text}</p>
                  </div>
                )}

                <div className="detail-row">
                  <span className="detail-label">Collector Number:</span>
                  <span className="detail-value">{selectedCard.collector_number}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Auth Modal */}
      <AuthModal show={showAuthModal} onClose={handleAuthModalClose} />
    </div>
  );
}

export default Collection;