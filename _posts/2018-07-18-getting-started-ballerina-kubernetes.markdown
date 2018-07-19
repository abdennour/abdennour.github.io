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


# Hello World

**Snippet**

```java
import  ballerina/io;

function main (string... args) {
    io:println("Hello World From elegance.abdennoor.com!");
}
```


**Related Commit** 