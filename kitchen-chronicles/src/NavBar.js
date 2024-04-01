import React from 'react';
import { Link } from 'react-router-dom';
import './NavBar.css'

function NavBar() {
  return (
    <div className="nav">
      <Link className="nav-link" to='/'>Home</Link> 
      <Link className="nav-link" to='/ingredients'>Ingredients</Link> 
      <Link className="nav-link" to='/all'>All Recipes</Link> 
      <Link className="nav-link" to='/new'>New Recipes</Link> 
    </div>
  );
}

export default NavBar;
