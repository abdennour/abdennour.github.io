---
layout: post
title:  "How to use Mufa with ⚛ React"
date:   2017-02-17 15:27:00 +0820
categories: javascript react reactjs event-driven pubsub
---

Building two applications SPA & API is the trend of software architecture nowadays. Hence, a communication between those two kind of applications becomes inevitable .

 Indeed, SPA requires an agent to send HTTP request  to the API application ,then , it receives the HTTP response.

The question that should be risen actually is

> How to maintain a good architecture of SPA application that communicates with server side ?



One of the most famous SPA framework is `ReactJS`.

`ReactJs` is coming with encapsulating the view with its logic . This encapsulation merges the controller and the view in one component  ( class ) .


Maintaining separation of layers is a main concern for a clean architecture as it is mentioned a while ago.

This separation can be implemented using `Pub/Sub` (publish/subscribe) pattern ; where layerA subscribes on events triggered by layerB and vice versa.

[Mufa](https://github.com/abdennour/mufa) is a topic-based publish/subscribe library written in JavaScript.




# Mufa Usage:

Mufa interface provides 3 main methods:

- **publish** (or fire) : is called in events handlers.
- **subscribe** (or on) : is called in componentDidMount.
- **unsubscribe** (or off) : is called in componentWillUnmount

```js

import { fire, subscribe, unsubscribe } from 'mufa';
// more elegance
import { on, fire, off } from 'mufa';
```

Assuming a communication between two React components that don't share the same context (`ReactDOM.render` is used twice ), Mufa intervenes here to make an elegant communication between those components.




```js

const { on, fire } = window.mufa; // If you are using it from CDN ( For modularity, we recommend use NPM)

class App extends React.Component {
  state = { input: '' };

  componentDidMount() {
    on('second_app_change_state', (...args) => {
      this.setState(...args);
    });
  }

  setStateAndFire() {
    fire('app_change_state', ...arguments);
    super.setState(...arguments);
  }

  render() {
    return <div>SecondApp is saying : " {this.state.input} "</div>;
  }
}

class SecondApp extends React.Component {
  componentDidMount() {
    on('app_change_state', (...args) => {
      this.setState(...args);
    });
  }

  setStateAndFire() {
    this.setState(...arguments);
    fire('second_app_change_state', ...arguments);
  }

  handleKeyUp = (event) => {
    this.setStateAndFire({ input: event.target.value });
  }

  render() {
    return (
      <div>
        <input
          type="text"
          onKeyUp={this.handleKeyUp}
          placeholder="Write something here you will see it in App component"
        />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById('my-app'));
ReactDOM.render(<SecondApp />, document.getElementById('my-second app'));
```


# API Documentation:

MUFA API documentation is published under [abdennour.github.io/mufa](http://abdennour.github.io/mufa/)
