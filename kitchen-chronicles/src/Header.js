import React, { useState, useEffect } from 'react';
import './App.css';
import NavBar from './NavBar.js';
import logo from './logo.png';

function Header() {
  const [isMobile, setIsMobile] = useState(window.innerWidth <= 768);
  const [menuOpen, setMenuOpen] = useState(false);

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth <= 768);
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const toggleMenu = () => {
    setMenuOpen(!menuOpen);
  };

  return (
    <header className="header c-flex-box">
      <div className="r-flex-box">
        <img className="icon" src={logo} />
        {isMobile ? (
          <button onClick={toggleMenu} className="hamburger-icon">
          </button>
        ) : (
          <NavBar />
        )}
      </div>
      {isMobile && menuOpen && (
        <div className="mobile-menu">
          {/* Render your mobile menu content here */}
          <NavBar />
        </div>
      )}
    </header>
  );
}

export default Header;

