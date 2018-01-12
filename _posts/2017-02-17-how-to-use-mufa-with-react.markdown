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

`Mufa` is a topic-based publish/subscribe library written in JavaScript. Mufa compatible with babel syntax.





# Conclusion


publish (fire) : is called in events handlers.
subscribe (on) : is called in componentDidMount.
unsubscribe (off) : is called in componentWillUnmount
