# Riftbound Card Collection Manager - Setup Instructions

## Prerequisites
- Node.js (v16 or higher)
- PostgreSQL (v15 or higher)
- npm

## Database Setup

1. Create a new PostgreSQL database:
```sql
   CREATE DATABASE riftbounddb;
```

2. Import the database:
```bash
   psql -U postgres -d riftbounddb -f riftbound_backup.sql
```

## Backend Setup

1. Navigate to the backend folder:
```bash
   cd backend
```

2. Install dependencies:
```bash
   npm install
```

3. Update database credentials in `server.js` if needed:
```javascript
   const pool = new Pool({
     user: 'postgres',
     host: 'localhost',
     database: 'riftbounddb',
     password: 'YOUR_PASSWORD', // Change this
     port: 5432,
   });
```

4. Start the backend server:
```bash
   node server.js
```

## Frontend Setup

1. Navigate to the frontend folder:
```bash
   cd frontend
```

2. Install dependencies:
```bash
   npm install
```

3. Start the development server:
```bash
   npm start
```

4. Open your browser to `http://localhost:3000`

## Default Users
No default users - create an account through the registration page.

## Features
- Browse card library (310 cards from Origins Main set)
- User authentication
- Personal card collections
- Search and filter cards
- Track card quantities