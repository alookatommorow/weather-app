import React from 'react';
import { createRoot } from 'react-dom/client';
import { Weather } from './components/Weather';

const container = document.getElementById('root');
const root = createRoot(container);

document.addEventListener('DOMContentLoaded', () => {
  root.render(<Weather />);
});