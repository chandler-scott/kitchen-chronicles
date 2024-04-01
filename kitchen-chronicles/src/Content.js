import React from 'react';
import { Routes, Route } from "react-router-dom";
import './App.css'
import HomePage from './HomePage.js'
import AllRecipesPage from './AllRecipesPage.js'
import RecipePage from './RecipePage.js'
import IngredientsPage from './IngredientsPage.js'
import NewRecipePage from './NewRecipePage.js'


function Content() {
  return (
    <div className="content c-flex-box">
      <Routes>
        <Route path="/" element={<HomePage/>}/>
        <Route path="/all" element={<AllRecipesPage/>}/>
        <Route path="/recipe" element={<RecipePage/>}/>
        <Route path="/new" element={<NewRecipePage/>}/>
        <Route path="/ingredients" element={<IngredientsPage/>}/>
      </Routes>
    </div>
  );
}

export default Content;
