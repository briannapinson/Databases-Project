import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from './AuthContext';
import AuthModal from './AuthModal';
import './LandingPage.css';

function LandingPage() {
  const { user, logout } = useAuth();
  const [showAuthModal, setShowAuthModal] = useState(false);

  return (
    <div className="landing-page">
      <div className="nav-bar">
        <button>Decks</button>
        <Link to="/card-library" style={{ textDecoration: 'none' }}>
          <button>Card Library</button>
        </Link>
        <Link to="/collection" style={{ textDecoration: 'none' }}>
          <button>Your Collection</button>
        </Link>
        
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

      <h1 id="title">The Nexus</h1>

      <footer>
        <h3>Weekly Video Features</h3>
        <div className="weeklyVideos">
          <iframe 
            src="https://www.youtube.com/embed/twvw-sUwCWA?si=biyTZIwIVCUGRrKa" 
            title="YouTube video player" 
            frameBorder="0" 
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
            referrerPolicy="strict-origin-when-cross-origin" 
            allowFullScreen
          />
          <iframe 
            src="https://www.youtube.com/embed/Y8iXKokw_7I?si=VtJODJgFphfWwMbE" 
            title="YouTube video player" 
            frameBorder="0" 
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
            referrerPolicy="strict-origin-when-cross-origin" 
            allowFullScreen
          />
          <iframe 
            src="https://www.youtube.com/embed/0F2UsMf26ZI?si=GhIWp58lcp5BeXwz" 
            title="YouTube video player" 
            frameBorder="0" 
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
            referrerPolicy="strict-origin-when-cross-origin" 
            allowFullScreen
          />
        </div>
      </footer>

      <AuthModal show={showAuthModal} onClose={() => setShowAuthModal(false)} />
    </div>
  );
}

export default LandingPage;