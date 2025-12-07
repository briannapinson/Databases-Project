# Riftbound Card Collection Manager - Setup Instructions

## Prerequisites
Install:
- Node.js (v16 or higher)
  https://nodejs.org/en
- PostgreSQL (v15 or higher)
  https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

## Database Setup

1. Access the SQL Shell (psql) and create a new PostgreSQL database:
```sql
   CREATE DATABASE riftbounddb;
```

2. Connect to database:
```sql
  \c riftbounddb
```

3. Import the database:
```sql
   \i 'C:/Users/YourName/Downloads/riftbound_backup.sql';   // Example path
```

Tips:
   - Ensure file path is accurate and wrapped in single quotes.
   - All backslashes are changed to forward slashes in path.
   - Path must include the riftbound_backup.sql file.

4. If import is successful, you are free to close the shell with
```sql
   \q
```

## Backend Setup

1. Navigate to the backend folder using terminal in VS Code or Command Prompt:
```bash
   cd backend
```

2. Install dependencies:
```bash
   npm install
   npm install dotenv
```

Tips:
If you encounter an issue that 'npm' is not recognized, visit this link for a comprehensive guide and fix:
https://www.codewithharry.com/blogpost/solving-npm-not-recognized-error-windows

Thanks, Harry. 

3. Create a .env file and update database credentials:
```javascript
      DB_USER=postgres
      DB_HOST=localhost
      DB_NAME=riftbounddb
      DB_PASSWORD=Enter-your-DB-password-here
      DB_PORT=5432
      JWT_SECRET=Your-Secret-Key
      PORT=3001
```
Tips:
To generate a random key, use this command in the terminal and copy into the .env file for JWT_SECRET:
```bash
    node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

4. Start the backend server:
```bash
   node server.js
```

## Frontend Setup
Note: Keep the backend server running. Open a new terminal window and navigate back to the project root before proceeding.

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
