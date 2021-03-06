import React from 'react';
import { create } from 'axios';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import AverageApi from './AverageApi';

function DummyChart({ dataset, categories, title }) {
  return (
    <div className="Chart">
      {title} : {dataset[0].sentiment}
      {dataset[1].sentiment} : {categories}
    </div>
  );
}

jest.mock('axios', () => ({ create: jest.fn() }));

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

it('renders data when api returns data', done => {
  const getMock = jest.fn();
  create.mockReturnValueOnce({ get: getMock });
  const promise = Promise.resolve({
    data: {
      averages: [
        { name: 'Bar', id: 541, sentiment: 0.67 },
        { name: 'Baz', id: 451, sentiment: -0.25 },
      ],
    },
  });

  getMock.mockReturnValueOnce(promise);

  const mockCallback = jest.fn();

  act(() => {
    render(
      <AverageApi key={123} selectedId={123} callback={mockCallback}>
        {{
          render: function render(data) {
            return <DummyChart dataset={data.dataset} categories={data.categories} title="Average sentiment by categories" />;
          },
        }}
      </AverageApi>,
      container,
    );
  });

  promise.then(_data => {
    expect(mockCallback.mock.calls.length).toBe(1);

    expect(container.querySelector('.Chart').textContent).toBe('Average sentiment by categories : 0.67-0.25 : BarBaz');
    done();
  });
});

it('renders nothing when api returns empty', done => {
  const getMock = jest.fn();
  create.mockReturnValueOnce({ get: getMock });
  const promise = Promise.resolve({
    data: { averages: [] },
  });
  getMock.mockReturnValueOnce(promise);

  const mockCallback = jest.fn();

  act(() => {
    render(
      <AverageApi key={123} selectedId={123} callback={mockCallback}>
        {{
          render: function render(_) {
            return 'fail!';
          },
        }}
      </AverageApi>,
      container,
    );
  });
  promise.then(_ => {
    expect(mockCallback.mock.calls.length).toBe(1);
    expect(container.textContent).toBe('');
    done();
  });
});
