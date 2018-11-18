---
layout: post
comments: true
title:  "The Mariage among Blockchain/Ethereum Tech, Container Tech and React/Redux framework"
date:   2018-11-18 18:33:59 +0328
categories: blockchain blockchain-technology ethereum ethereum-contract ethereum-token erc721 react redux redux-form truffle truffle-testing docker containers metamask ganache rinkeby solidity javascript
excerpt: "This is about my implementation of the 5th project during my nanodegree, Blockchain Developer nanodegree, with Udacity. Everything is running in container; Local ethereum network with Ganache, Smart contracts with Truffle, Frontend with React and Redux and API with NodeJS. All are running in containers"
image: "/assets/blockchain/marriage-blockchain-container-react.png"
---

# Introduction

After 3 months of starting the [blockchain nanodegree](https://udacity.com/course/blockchain-developer-nanodegree--nd1309), the [fifth project](https://review.udacity.com/#!/rubrics/2297/view) was assigned. It is a special project; it is not like other projects. It's the time to develop a real blockchain application with Ethereum framework. Briefly, it is about developing my first [Dapp](https://ethereum.stackexchange.com/a/384/46309).

## Design

After finishing watching the required learning materials for the fifth project, I realized that running a Dapp require a lot of tools and frameworks.

I designed my solution to run each component in container:

- **Ganache** (Old name is TestRPC) A local ethereum network
- **Truffle** This is the development environment of development Dapp and namely the smart contracts
- **frontend** This is the web application that reads injected Web3 from Metamask, call contracts and send transactions
- **API** This is the place where you expose your RESTFul API if needed.

## Advantages of running Dapp in containers:

By running my Dapp in containers with an orchestration (Docker compose),  I took advantage of the following:

- **Mitigate the amount of documentation** Instead of writing in the README `"install Ganache version x.x, install node modules, install truffle version,...blah blah"` , `docker-compose up -d` is the only command that you will need to have all services up and running.

- **Avoid hard coding** During Dapp implementation, one of steps is copy the compiled contract, namely [ABI](https://solidity.readthedocs.io/en/develop/abi-spec.html) from the truffle project and paste it in the frontend app as JSON file. 
By running both components (truffle and frontend) inside containers, you could share the ABI between "truffle" service and "frontend" service using **volumes** and no copy/paste is required.

- **DNS Discovery** By orchestrating containers with Docker compose , each container can communicate/ping the other container by its name.
That's why, you can note the following, in `truffle` configuration file for example:

```js
  networks: {
    // ganache-cli
    development: {
      host: 'ganache', // <--- SEE HERE
      port: 8545,
      network_id: '*' // Match any network id
    },
  }  
```

## Implementation

In this article, I will share the docker-compose code which puts all together: 

- **Ganache service** This is a local ethereum network with 10 blockchain accounts:


```yaml
# from ./docker-compose.yaml
  ganache:
    image: 'trufflesuite/ganache-cli:v6.1.8'
    # tty: true
    restart: always
    ports:
      - '${PORT_GANACHE}:8545'
    command: -m ${MNEMONIC}
    environment:
      - TERM=xterm

```

- **truffle/contracts service**: It is the place where I developed smart contract with a heavy tests.

```yaml
# from ./docker-compose.yaml
  contracts:
    build:
      target: contracts
      context: ./smart_contracts
      dockerfile: ./contracts.Dockerfile
    restart: always
    working_dir: /app
    volumes:
      - './smart_contracts:/app'
      - contracts-node-modules:/app/node_modules
      - contracts-build:/app/build/contracts
    environment:
      - INFURA_RINKEBY_ENDPOINT=${INFURA_RINKEBY_ENDPOINT}
      - MNEMONIC=${MNEMONIC} 
```

If you are curious to know what's inside `contracts.Dockerfile`, it is simply a base of the `node:10-alpine` where `npm start` is an alias of `gulp` to watch contracts changes and compile (`truffle compile`) them in realtime.

- **Frontend Service** This is React+Redux application to interact with smart contract deployed in the public test network (Rinkeby).
It is expected to develop this frontend inside one file "index.html", however, I took the decision to adopt `create-react-app` as framework for my frontend service.

Indeed, all calls to smart contracts are asynchronous and it's worth to write a clean code while interacting with these contracts.
By developing the frontend with "create-react-app", I was able to leverage the component-based architecture.

In addition, this frontend detects the curent user from the browser addon "MetaMask" (See the video in the last section).

```yaml 
frontend:
    build:
      context: ./frontend
      dockerfile: ./frontend.Dockerfile
    restart: always
    working_dir: /app
    depends_on:
      - contracts
    volumes:
      - './frontend:/app'
      - contracts-build:/app/src/build_contracts
      - frontend-node-modules:/app/node_modules
    ports:
      - '${PORT_CLIENT}:3000'
    environment:
      - NODE_ENV=development
      - REACT_APP_CONTRACT_ADDRESS=${RINKEBY_CONTRACT_ADDRESS}
      - REACT_APP_PORT_GANACHE=${PORT_GANACHE}
```
Did you note that the **frontend** service depends on **contracts** service? 
Did you note that both **frontend** and **contracts** services are sharing a volume called (`contracts-build`)?

Indeed, the **frontend** service requires the existence of `ABI` file which is the compiled contract generated by `truffle compile` (running inside the **contracts** service). That's why, the frontend service must wait for the contract service to be up and running.


## Udacity Review

It was my pleasure to receive an outstanding review. Basically, I can see "Awesome" flag everywhere.

![Udacity Review Awesome](/assets/blockchain/udacity-awesome-flag.png)


it was so cute to see the reviewer illustrates his satisfication by posting the below image saying 

> You've made it!! Great job!! I've liked the way you've structured your code and functions, a nice test implementation as well!

> Keep it up, let's rock the next module! 👍🏼

<div align="center">
   <img src="https://media.giphy.com/media/ely3apij36BJhoZ234/giphy.gif?%22Logo%20Title%20Text%201%22" alt="Decentralized Star Notary - Reviewer Feedback">
</div>
.  


## Dapp is up and running

Enjoy the demo on Youtube 👇🏻 :

<div align="center">
  <a href="https://www.youtube.com/watch?v=Zhq6yBViIdY" target="_blank">
    <img src="https://img.youtube.com/vi/Zhq6yBViIdY/0.jpg" alt="Demo Dapp Ethereum in Docker">
  </a>
</div>