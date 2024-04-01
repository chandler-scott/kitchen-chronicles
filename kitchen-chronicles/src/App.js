import React from 'react';
import { BrowserRouter as Router} from "react-router-dom";
import './App.css';
import Header from './Header.js'
import Content from './Content.js'

function App() {
  return (
    <Router>
      <div className="App">
        <Header/>
        <Content/>
        <footer className="footer c-flex-box"> Copyright ©chandler-scott </footer>
      </div>
    </Router>
  );
}

export default App;
