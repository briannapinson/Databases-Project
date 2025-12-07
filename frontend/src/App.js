import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { AuthProvider } from './AuthContext';
import LandingPage from './LandingPage';
import CardLibrary from './CardLibrary';
import Collection from './Collection';
import './App.css';

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/card-library" element={<CardLibrary />} />
          <Route path="/collection" element={<Collection />} />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;