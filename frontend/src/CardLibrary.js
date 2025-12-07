import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './App.css';
import { useAuth } from './AuthContext';
import AuthModal from './AuthModal';

function CardLibrary() {  
  const [cards, setCards] = useState([]);
  const [filteredCards, setFilteredCards] = useState([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedDomains, setSelectedDomains] = useState([]);
  const [selectedRarities, setSelectedRarities] = useState([]);
  const [selectedTypes, setSelectedTypes] = useState([]);
  const [loading, setLoading] = useState(true);
  
  const [energyRange, setEnergyRange] = useState([0, 12]);
  const [mightRange, setMightRange] = useState([0, 10]);
  const [powerRange, setPowerRange] = useState([0, 4]);
  
  // Modal state
  const [selectedCard, setSelectedCard] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [showFilters, setShowFilters] = useState(true);
  
  // Dropdown states
  const [showRarityDropdown, setShowRarityDropdown] = useState(false);
  const [showTypeDropdown, setShowTypeDropdown] = useState(false);

  // Define filter options
  const rarities = ['Common', 'Uncommon', 'Rare', 'Epic', 'Overnumbered'];
  const types = ['Legend', 'Champion', 'Unit', 'Spell', 'Signature Spell', 'Signature Unit', 'Signature Gear', 'Gear', 'Battlefield'];

  // User Authentication
  const { user, logout, getAuthHeaders } = useAuth();
  const [showAuthModal, setShowAuthModal] = useState(false);

  // Helper function to format image path
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

  // Fetch cards from backend with error handling
  useEffect(() => {
    fetch('http://localhost:3001/api/cards')
      .then(res => {
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res.json();
      })
      .then(data => {
        console.log('Fetched data:', data);
        console.log('Is array?', Array.isArray(data));
        
        const cardsArray = Array.isArray(data) ? data : [];
        setCards(cardsArray);
        setFilteredCards(cardsArray);
        setLoading(false);
      })
      .catch(err => {
        console.error('Error fetching cards:', err);
        setCards([]);
        setFilteredCards([]);
        setLoading(false);
      });
  }, []);

  // Filter cards when any filter changes
  useEffect(() => {
    if (!Array.isArray(cards)) {
      console.error('Cards is not an array:', cards);
      setFilteredCards([]);
      return;
    }

    let filtered = cards;

    if (searchQuery) {
      filtered = filtered.filter(card =>
        card.card_name && card.card_name.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }

    if (selectedDomains.length > 0) {
      filtered = filtered.filter(card =>
        card.domain && selectedDomains.some(domain => card.domain.includes(domain))
      );
    }

    if (selectedRarities.length > 0) {
      filtered = filtered.filter(card =>
        card.rarity && selectedRarities.includes(card.rarity)
      );
    }

    if (selectedTypes.length > 0) {
      filtered = filtered.filter(card =>
        card.card_type && selectedTypes.includes(card.card_type)
      );
    }

    if (energyRange[0] !== 0 || energyRange[1] !== 12) {
      filtered = filtered.filter(card =>
        card.energy !== null && card.energy !== undefined && 
        card.energy >= energyRange[0] && card.energy <= energyRange[1]
      );
    }

    if (mightRange[0] !== 0 || mightRange[1] !== 10) {
      filtered = filtered.filter(card =>
        card.might !== null && card.might !== undefined && 
        card.might >= mightRange[0] && card.might <= mightRange[1]
      );
    }

    if (powerRange[0] !== 0 || powerRange[1] !== 4) {
      filtered = filtered.filter(card =>
        card.power !== null && card.power !== undefined && 
        card.power >= powerRange[0] && card.power <= powerRange[1]
      );
    }

    setFilteredCards(filtered);
  }, [searchQuery, selectedDomains, selectedRarities, selectedTypes, energyRange, mightRange, powerRange, cards]);

  const toggleDomain = (domain) => {
    if (selectedDomains.includes(domain)) {
      setSelectedDomains(selectedDomains.filter(d => d !== domain));
    } else {
      setSelectedDomains([...selectedDomains, domain]);
    }
  };

  const toggleRarity = (rarity) => {
    if (selectedRarities.includes(rarity)) {
      setSelectedRarities(selectedRarities.filter(r => r !== rarity));
    } else {
      setSelectedRarities([...selectedRarities, rarity]);
    }
  };

  const toggleType = (type) => {
    if (selectedTypes.includes(type)) {
      setSelectedTypes(selectedTypes.filter(t => t !== type));
    } else {
      setSelectedTypes([...selectedTypes, type]);
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

  const addToCollection = async (printingId) => {
    if (!user) {
      setShowAuthModal(true);
      return;
    }

    try {
      const response = await fetch('http://localhost:3001/api/collection', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...getAuthHeaders()
        },
        body: JSON.stringify({ printing_id: printingId, quantity: 1 })
      });

      if (response.ok) {
        alert('Added to collection!');
      } else {
        const error = await response.json();
        alert(error.error || 'Failed to add to collection');
      }
    } catch (err) {
      console.error('Error adding to collection:', err);
      alert('Failed to add to collection');
    }
  };

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (!e.target.closest('.filter-btn')) {
        setShowRarityDropdown(false);
        setShowTypeDropdown(false);
      }
    };
    document.addEventListener('click', handleClickOutside);
    return () => document.removeEventListener('click', handleClickOutside);
  }, []);

  return (
    <div className="App">
      <div className="nav-bar">
        <Link to="/" style={{ textDecoration: 'none' }}>
          <button>Home</button>
        </Link>
        <button>Decks</button>
        <button>Card Library</button>
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
      
      {/* Card Library Header */}
      <div className="card-library-header">
        <h2>Card Library</h2>
      </div>
      
      {/* Filter Box */}
      <div className="filter-box">
        {/* Search bar at top */}
        <div className="search-bar">
          <input 
            type="text" 
            className="search-input" 
            placeholder="Search cards..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          <div className="filter-buttons">
            <div className="dropdown-wrapper">
              <button 
                className="filter-btn"
                onClick={(e) => {
                  e.stopPropagation();
                  setShowRarityDropdown(!showRarityDropdown);
                  setShowTypeDropdown(false);
                }}
              >
                Rarity ▼
              </button>
              {showRarityDropdown && (
                <div className="filter-dropdown">
                  {rarities.map(rarity => (
                    <label key={rarity} className="filter-option">
                      <input
                        type="checkbox"
                        checked={selectedRarities.includes(rarity)}
                        onChange={() => toggleRarity(rarity)}
                      />
                      <span>{rarity}</span>
                    </label>
                  ))}
                </div>
              )}
            </div>

            <div className="dropdown-wrapper">
              <button 
                className="filter-btn"
                onClick={(e) => {
                  e.stopPropagation();
                  setShowTypeDropdown(!showTypeDropdown);
                  setShowRarityDropdown(false);
                }}
              >
                Type ▼
              </button>
              {showTypeDropdown && (
                <div className="filter-dropdown">
                  {types.map(type => (
                    <label key={type} className="filter-option">
                      <input
                        type="checkbox"
                        checked={selectedTypes.includes(type)}
                        onChange={() => toggleType(type)}
                      />
                      <span>{type}</span>
                    </label>
                  ))}
                </div>
              )}
            </div>

            <button 
              className="filter-btn"
              onClick={() => setShowFilters(!showFilters)}
            >
              ⊗ {showFilters ? 'Hide' : 'Show'}
            </button>
          </div>
        </div>

        {/* Two-column layout: Domains and Sliders */}
        {showFilters && (
          <div className="filter-container">
            {/* Left column: Domains */}
            <div className="domain-section">
              <h4>Domains</h4>
              <div className="domain-grid">
                {['Fury', 'Calm', 'Mind', 'Body', 'Chaos', 'Order'].map(domain => (
                  <button 
                    key={domain}
                    className={`domain-button ${selectedDomains.includes(domain) ? 'active' : ''}`}
                    onClick={() => toggleDomain(domain)}
                  >
                    <img 
                      src={`/images/${domain}.webp`} 
                      alt={`${domain} Button`} 
                      className="domain-icon"
                    />
                  </button>
                ))}
              </div>
            </div>

            {/* Right column: Stat sliders */}
            <div className="stat-filters">
              <div className="stat-filter">
                <div className="stat-header">
                  <label>Energy (0-12)</label>
                  <span className="stat-any">
                    {(energyRange[0] === 0 && energyRange[1] === 12) ? 'Any' : `${energyRange[0]}-${energyRange[1]}`}
                  </span>
                </div>
                <div className="slider-container">
                  <div className="slider-track"></div>
                  <input type="range" min="0" max="12" value={energyRange[0]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val <= energyRange[1]) setEnergyRange([val, energyRange[1]]);
                    }}
                    className="slider slider-min"
                  />
                  <input type="range" min="0" max="12" value={energyRange[1]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val >= energyRange[0]) setEnergyRange([energyRange[0], val]);
                    }}
                    className="slider slider-max"
                  />
                  <div className="slider-ticks">
                    <span className="tick">0</span>
                    <span className="tick">2</span>
                    <span className="tick">4</span>
                    <span className="tick">6</span>
                    <span className="tick">8</span>
                    <span className="tick">10</span>
                    <span className="tick">12</span>
                  </div>
                </div>
              </div>

              <div className="stat-filter">
                <div className="stat-header">
                  <label>Might (0-10)</label>
                  <span className="stat-any">
                    {(mightRange[0] === 0 && mightRange[1] === 10) ? 'Any' : `${mightRange[0]}-${mightRange[1]}`}
                  </span>
                </div>
                <div className="slider-container">
                  <div className="slider-track"></div>
                  <input type="range" min="0" max="10" value={mightRange[0]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val <= mightRange[1]) setMightRange([val, mightRange[1]]);
                    }}
                    className="slider slider-min"
                  />
                  <input type="range" min="0" max="10" value={mightRange[1]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val >= mightRange[0]) setMightRange([mightRange[0], val]);
                    }}
                    className="slider slider-max"
                  />
                  <div className="slider-ticks">
                    <span className="tick">0</span>
                    <span className="tick">2</span>
                    <span className="tick">4</span>
                    <span className="tick">6</span>
                    <span className="tick">8</span>
                    <span className="tick">10</span>
                  </div>
                </div>
              </div>

              <div className="stat-filter">
                <div className="stat-header">
                  <label>Power (0-4)</label>
                  <span className="stat-any">
                    {(powerRange[0] === 0 && powerRange[1] === 4) ? 'Any' : `${powerRange[0]}-${powerRange[1]}`}
                  </span>
                </div>
                <div className="slider-container">
                  <div className="slider-track"></div>
                  <input type="range" min="0" max="4" value={powerRange[0]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val <= powerRange[1]) setPowerRange([val, powerRange[1]]);
                    }}
                    className="slider slider-min"
                  />
                  <input type="range" min="0" max="4" value={powerRange[1]}
                    onChange={(e) => {
                      const val = parseInt(e.target.value);
                      if (val >= powerRange[0]) setPowerRange([powerRange[0], val]);
                    }}
                    className="slider slider-max"
                  />
                  <div className="slider-ticks">
                    <span className="tick">0</span>
                    <span className="tick">1</span>
                    <span className="tick">2</span>
                    <span className="tick">3</span>
                    <span className="tick">4</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Card count */}
      <div className="cards-count-container">
        <button className="variant-button">
          Showing {Array.isArray(filteredCards) ? filteredCards.length : 0} cards
        </button>
      </div>

      {/* Card grid */}
      {loading ? (
        <p style={{textAlign: 'center', padding: '40px'}}>Loading cards...</p>
      ) : !Array.isArray(filteredCards) || filteredCards.length === 0 ? (
        <p style={{textAlign: 'center', padding: '40px'}}>No cards found</p>
      ) : (
        <div className="card-grid">
          {filteredCards.map(card => (
            <div 
              key={card.printing_id}
              className="card"
              onClick={() => openModal(card)}
            >
              <img 
                src={`/images/${getImagePath(card.image_id)}_origins.avif`}
                alt={card.card_name} 
                className="card-image"
                onError={(e) => {
                  console.error('Failed to load:', e.target.src);
                  e.target.src = '/images/placeholder.png';
                }}
              />
            </div>
          ))}
        </div>
      )}

      {/* Modal */}
      {showModal && selectedCard && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="modal-close" onClick={closeModal}>✕</button>
            
            <div className="modal-body">
              <div className="modal-image-container">
                <div style={{display: 'flex', flexDirection: 'column', gap: '15px', width: '100%'}}>
                  <img 
                    src={`/images/${getImagePath(selectedCard.image_id)}_origins.avif`}
                    alt={selectedCard.card_name}
                    className="modal-card-image"
                    onError={(e) => {
                      console.error('Failed to load:', e.target.src);
                      e.target.src = '/images/placeholder.png';
                    }}
                  />
                  <button 
                    className="add-to-collection-btn"
                    onClick={() => addToCollection(selectedCard.printing_id)}
                  >
                    Add to Collection
                  </button>
                </div>
              </div>

              <div className="modal-details">
                <h2>{selectedCard.card_name}</h2>
                
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

                {selectedCard.flavor_text && (
                  <div className="detail-section">
                    <span className="detail-label">Flavor Text:</span>
                    <p className="flavor-text">"{selectedCard.flavor_text}"</p>
                  </div>
                )}

                <div className="detail-row">
                  <span className="detail-label">Artist:</span>
                  <span className="detail-value">{selectedCard.artist}</span>
                </div>

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
      <AuthModal show={showAuthModal} onClose={() => setShowAuthModal(false)} />
    </div>
  );
}

export default CardLibrary;