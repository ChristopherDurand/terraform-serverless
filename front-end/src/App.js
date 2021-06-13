import logo from './logo.svg';
import './App.css';
import axios from 'axios';
function App() {
  const handleClick1 = async event => {
    axios.get('/api/foods').then(response => console.log(response));
  }
  const handleClick2 = event => {
    axios.get('/api/pets').then(response => console.log(response));
  }
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <button onClick={handleClick1}>
          Endpoint 1
        </button>
        <button onClick={handleClick2}>
          Endpoint 1
        </button>
        
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
