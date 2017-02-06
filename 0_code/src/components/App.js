// @flow
import React, {createElement as e} from 'react';
import TodoList from './TodoList';

const App = () =>
  <div>
    <h1>Todo MVC</h1>
    <p>
      What would you like to do today?
    </p>
    <TodoList/>
  </div>

export default App;
