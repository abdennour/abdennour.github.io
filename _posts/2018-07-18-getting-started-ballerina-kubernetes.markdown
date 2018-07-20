---
layout: post
comments: true
title:  "Getting Started - Ballerina Language with Kubernetes"
date:   2018-07-18 22:27:13 +0304
categories: Microservice CloudNative Ballerina Programming Language Kubernetes DevOps Abdennour Tunisia
excerpt: "Focus on developing your microservices, and Ballerina will generate the suitable Kubernetes templates for you."
image: "/assets/microservice/ballerina-k8s.png"
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

# 2. Hello World Service/API

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
You can define endpoints as many as you want, then bind one of them to your service.

**Related commit**

- [1b45ff3](https://github.com/abdennour/helloworld-ballerina-kubernetes/commit/1b45ff338963b04fe75e1e3a2c12493f1ea23108)

**Run it**

```sh
ballerina run hello_api.bal
```

**Validate**

```sh
curl -s http://localhost:8888/sayHello
# Hello API from elegance.abdennoor.com!
```


# 3. Hello World Kubernetes

As you noted, Ballerina provides a set of annotations that are useful to change the behaviour of the logic whenever it is decorated.

The scope of the annotation can be :

- Service : like `@http:ServiceConfig`

```java
@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> hello bind helloListener {
    //....
}    
```

- Microservice: like `@http:ResourceConfig`

```java
service<http:Service> hello bind helloListener {    
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    sayHello (endpoint caller, http:Request request) {
        //......
    }
}        
```

With the same approach, integration with Kubernetes is done by using Kubernetes annotations supported by Ballerina Platform:
- `@kubernetes:Service` annotation should decorate Ballerina `endpoint`.
- `@kubernetes:Deployment` annotation should decorate Ballerina `service`.

**Snippet**

```java
import ballerina/http;
import ballerina/log;
import ballerinax/kubernetes;


@kubernetes:Service {
    serviceType: "NodePort",
    name: "ballerina-demo"

}
endpoint http:Listener helloListener {
    port:8888
};

@kubernetes:Deployment {
    enableLiveness: true,
    image: "abdennour/ballerina-demo",
    name: "ballerina-demo"
}
@http:ServiceConfig {
    basePath: "/"
}
service<http:Service> hello bind helloListener {
    sayHello (endpoint caller, http:Request request) {
        http:Response response = new;
        response.setPayload("Hello Kubernetes from elegance.abdennoor.com!");
         _ = caller -> respond(response);
    }
}

```


**Related commit**

- [11ad13e](https://github.com/abdennour/helloworld-ballerina-kubernetes/commit/11ad13ed7bfeccd854fef3ab06981dfd07d1acc6)

**Build it**

When you build a Ballerina code with Kubernetes annotations, The platform generate a set of files, namely:

1. `.balx` which is bytecode after compile (like `.class` in java)
2. Generate Dockerfile and Kubernetes templates inside `kubernetes/` directory.
3. Build the docker image according to the Dockerfile which is already scaffolded according to the usage of `@kubernetes:*` annotations.


```sh
eval $(minikube docker-env);
ballerina build hello_kubernetes.bal
```

![ballerina Build Kubernetes]({{ "/assets/post-ballerina-k8s/ballerina_build_hello_k8s.png" | absolute_url }})

**Run it**

In order to make the application up and running in Kubernetes, there are two more steps after the build step: 

1. Push the docker image to the registry (not required with minikube).
2. Deploy the kubernetes templates using `kubectl`

```sh
#1.  Push the docker image to the registry
docker push abdennour/ballerina-demo # NOT needed with "eval $(minikube docker-env)"

# 2.Deploy the kubernetes templates using
kubectl apply -f kubernetes/
```

**Validate**

```sh
BASE_URL=$(minikube service ballerina-demo --url)
curl -s ${BASE_URL}/sayHello
# Hello Kubernetes from elegance.abdennoor.com!
```

Congratulations! The Ballerina helloworld is now up and running in Kubernetes.


![ballerina Build Kubernetes]({{ "/assets/post-ballerina-k8s/deploy_in_minikube.png" | absolute_url }})



## Conclusion

"Ballerina is a compiled, type-safe, concurrent programming language targeting microservice development and integration".

Ballerina proves that it is a diffrent language by introducing new programing paradigms. Since the language is still under development, we hope it will be mature as soon as possible.
