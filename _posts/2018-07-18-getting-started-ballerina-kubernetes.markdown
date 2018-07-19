---
layout: post
comments: true
title:  "Getting Started - Ballerina Language with Kubernetes"
date:   2018-06-20 05:27:00 +0454
categories: Microservice CloudNative Ballerina Programming Language Kubernetes DevOps Abdennour Tunisia
excerpt: "..."
image: "assets/microservice/ballerina-k8s.png"
---

## Introduction

After building your application/microservice, you start thinking about deploying it to Kubernetes cluster. Thus, a set of kubernetes resources (deployment, service, ingress,...) should be implemented in order to achieve that.

However, using [Ballerina](https://ballerina.io/), a Cloud Native Programming Language, eases the development of microservices by smoothly integrating them with Kubernetes. Indeed, Ballerina provides a set of  elegant annotations (`@kubernetes:*`) to scaffold Kubernetes resources throughout the "Build" stage.  


## Prerequisites

* Docker.

```sh
brew install docker
```

* Minikube or any Kubernetes Cluster.

```sh
brew install minikube # More details: https://kubernetes.io/docs/tasks/tools/install-minikube/

minikube start 
# Starting local Kubernetes v1.10.0 cluster...

minikube status
# minikube: Running ...

eval $(minikube docker-env);
# Point docker CLI to communicate with minikube directly
```



* Ballerina Platform

https://ballerina.io/downloads/

```sh
which ballerina
# /Library/Ballerina/ballerina-0.975.1
```

For productivity concerns, **VisualCode** is a recommended editor to develop Ballerina code; It has a popular Ballerina extension that should be installed too.

After installing the extension, editor's settings should be updated as following:

```
    "ballerina.home": "/Library/Ballerina/ballerina-0.975.1"
```

Note that, `/Library/Ballerina/ballerina-0.975.1` is the output of `which ballerina` command line.


## Getting Started 

![ballerina banner]({{ "/assets/post-ballerina-k8s/banner.png" | absolute_url }})

# 1. Hello World

**Snippet**

```java
import  ballerina/io;

function main (string... args) {
    io:println("Hello World From elegance.abdennoor.com!");
}
```

**Related Commit** 

- [623e36f](https://github.com/abdennour/helloworld-ballerina-kubernetes/commit/623e36fa11b111e0a06991dd0710ca50fd89e015)


**Test it**

```
ballerina run hello.bal
```

![ballerina run hello.bal]({{ "/assets/post-ballerina-k8s/ballerina_run_hello.png" | absolute_url }})

# 2. Hello World API

**Snippet**

```java
import ballerina/http;
import ballerina/log;

endpoint http:Listener helloListener {
    port:8888
};

@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> hello bind helloListener {
    sayHello (endpoint caller, http:Request request) {
        http:Response response = new;
        response.setPayload("Hello API from elegance.abdennoor.com!");
         _ = caller -> respond(response);
    }
}
```
This is a simple web service that was bounded to an HTTP endpoint with port 8888.

**Related commit**

- [1b45ff3](https://github.com/abdennour/helloworld-ballerina-kubernetes/commit/1b45ff338963b04fe75e1e3a2c12493f1ea231085)

**Test it**

```sh
ballerina run hello_api.bal
```

**Validate**

```sh
curl -s http://localhost:8888/sayHello
# Hello API from elegance.abdennoor.com!
```