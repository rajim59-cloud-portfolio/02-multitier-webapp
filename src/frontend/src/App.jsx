import { useEffect, useState } from 'react';
import './App.css';

const API_URL = import.meta.env.VITE_API_URL || '';

function App() {
  const [backendStatus, setBackendStatus] = useState('checking');
  const [timestamp, setTimestamp] = useState(null);

  useEffect(() => {
    // ─── Health check: backend reachable? ─────────────────────────
    const checkHealth = async () => {
      try {
        const res = await fetch(`${API_URL}/api/health`);
        if (res.ok) {
          const data = await res.json();
          setBackendStatus('connected');
          setTimestamp(data.timestamp || new Date().toISOString());
        } else {
          setBackendStatus('error');
        }
      } catch {
        setBackendStatus('unreachable');
      }
    };

    checkHealth();
    const interval = setInterval(checkHealth, 30000); // every 30s
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="app">
      <header className="app-header">
        <h1>Student Management</h1>
        <p className="subtitle">Multi-Tier Web App · Project 02</p>
      </header>

      <main className="app-main">
        <section className="card">
          <h2>Backend connectivity</h2>
          <div className={`status status-${backendStatus}`}>
            <span className="status-dot" />
            <span className="status-text">
              {backendStatus === 'checking' && 'Checking…'}
              {backendStatus === 'connected' && 'Connected'}
              {backendStatus === 'error' && 'Error response'}
              {backendStatus === 'unreachable' && 'Unreachable'}
            </span>
          </div>
          {timestamp && (
            <p className="status-meta">
              Last response: {new Date(timestamp).toLocaleString()}
            </p>
          )}
        </section>

        <section className="card">
          <h2>Coming soon</h2>
          <ul className="placeholder-list">
            <li>Student list (Day 3)</li>
            <li>Add student form (Day 3)</li>
            <li>Edit / delete (Day 3)</li>
          </ul>
        </section>
      </main>

      <footer className="app-footer">
        <span>Deployed on Azure App Service · Built with React + Vite</span>
      </footer>
    </div>
  );
}

export default App;