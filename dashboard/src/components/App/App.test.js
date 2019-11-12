import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import App from './App';

import '../Header';

jest.mock('../Header', () => {
  return function DummyHeader() {
    return <div className="Header">chattermill mocked header</div>;
  };
});

let container = null;

beforeEach(() => {
  container = document.createElement('div');
  document.body.appendChild(container);
});

afterEach(() => {
  unmountComponentAtNode(container);
  container.remove();
  container = null;
});

it('renders without crashing', () => {
  act(() => {
    render(<App />, container);
  });
  expect(container.querySelector('.App .Header').textContent).toContain('chattermill mocked header');
  expect(container.querySelector('.App span').textContent).toContain('Reviews dashboard');
});