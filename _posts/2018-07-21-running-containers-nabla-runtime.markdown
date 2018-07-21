---
layout: post
comments: true
title:  "Successfully Running Containers with NABLA runtime"
date:   2018-07-21 18:42:44 +0122
categories: Microservice Container Nabla Kubernetes OCI DevOps Abdennour Tunisia
excerpt: "Provision from Scratch an Ubuntu server for running Containers with Nabla runtime, and how to assign Nabla pods to Kubernetes nodes"
image: "/assets/post-running-containers-nabla-runtime/nabla-internals.png"
---

## Introduction

The security of containers is acheived by enhancing the level of **isolation**, a such concept that exists clearly with virtual machines since it is running under hypervisor. 

Nabla brings a new approach for container isolation. The isolation "comes from limiting access to the host kernel via the blocking of system calls. "[1]

The approach is well detailed in the [official website](https://nabla-containers.github.io/).

Nevertheless, this is the architecture of Nabla container:

![Nabla container internals]({{ "/assets/post-running-containers-nabla-runtime/nabla-internals.png" | absolute_url }})


## Prerequisites

* Vagrant (+ Virtualbox), then:

```sh
git clone https://github.com/abdennour/hello-nabla-container.git && cd hello-nabla-container;
vagrant up;
```

* Or in general, you could take the script [scripts/nabla.sh](https://github.com/abdennour/hello-nabla-container/blob/ecac7d6/scripts/nabla.sh) and run it on Ubuntu machine.


## Provision the machine

# Install dependencies

- Install `docker-ce`

```sh
apt-get -yq update
apt-get -y upgrade
# Install docker community edition
apt-get remove docker docker-engine docker.io -y;

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

apt-get update -y && apt-get upgrade -y;
apt-get install -y docker-ce;
```

- Install `Go`

```sh
cd /tmp
curl -O https://storage.googleapis.com/golang/go1.10.3.linux-amd64.tar.gz
tar -xvf go1.10.3.linux-amd64.tar.gz
mv go /usr/local
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
```

# Install NABLA runtime

The official website explains [how to setup NABLA](https://nabla-containers.github.io/2018/06/28/nabla-setup/), however, it does NOT leverage the `systemd` module of the modern linux systems. That's why, I didn't follow the same approach (`/etc/docker/daemon.json`), instead, I leveraged `systemd`.

```sh
# download "runnc" source code
go get github.com/nabla-containers/runnc
cd ${GOPATH}/src/github.com/nabla-containers/runnc

# build the binary "runnc" and other binaries needed
make container-build

# Validate the Build
ls -lh build/{nabla-run,runnc,runnc-cont}

# Install "runnc"
cd ${GOPATH}/src/github.com/nabla-containers/runnc
make container-install

# Validate the Install
ls -lh /usr/local/bin/{nabla-run,runnc,runnc-cont}
ls -lh /opt/runnc/lib/{ld-linux-x86-64.so.2,libc.so.6,libseccomp.so.2}

# Configure NABLA runtime with docker
apt-get install -y genisoimage
mkdir -p /etc/systemd/system/docker.service.d/
cat > /etc/systemd/system/docker.service.d/nabla-containers.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D --add-runtime nabla-runtime=/usr/local/bin/runnc
EOF
systemctl daemon-reload
systemctl restart docker
docker run hello-world
```

If you want to make `Nabla` as the default runtime and avoid specifying the argument `--runtime=nabla-runtime` with each `docker run`, you may need to replace:

```
ExecStart=/usr/bin/dockerd -D --add-runtime nabla-runtime=/usr/local/bin/runnc
```

By 

```
ExecStart=/usr/bin/dockerd -D --add-runtime nabla-runtime=/usr/local/bin/runnc --default-runtime=nabla-runtime
```

Now, it is time to **bake** this machine and consider it as image (box) to spin up other duplicated machines with Nabla Runtime; successfully installed and configured.


## Run a demo : Node application running inside Nabla container

# Download the application

```sh
export GOPATH=$HOME/go
go get github.com/abdennour/nabla-demo-apps
```

Take a look at [the code](https://github.com/abdennour/nabla-demo-apps) of this Node application, namely:

- [app/app.js](https://github.com/abdennour/nabla-demo-apps/blob/master/node-express/app/app.js)
- [Dockerfile.nabla](https://github.com/abdennour/nabla-demo-apps/blob/master/node-express/Dockerfile.nabla)

As you may note: 

- The base docker images (.i.e: `FROM nablact/nabla-node-base`) are baked in [nabla-base-build](https://github.com/nabla-containers/nabla-base-build) repository.

- All those base images define `ENTRYPOINT *.nabla` as the last layer of its *Dockerfile*.

- The image of the main container should be built from one of [nabla base images](https://github.com/nabla-containers/nabla-base-build), however, you are still able to use community images for non-main containers by leveraging the [**multi-stage** builds](https://docs.docker.com/develop/develop-images/multistage-build/).


# Build the docker image for the node application

```sh
cd ${GOPATH}/src/github.com/abdennour/nabla-demo-apps/node-express
docker build -t node-express-nabla -f Dockerfile.nabla .
# Validate the build
docker images | grep node-express-nabla
```

# Run the demo

```sh
# Run the demo - run it in background with "-t -d"
docker run --rm -t -d --runtime=nabla-runtime -p 9090:8080 node-express-nabla
```

We reached the moment of truth: 

```sh
curl -s http://localhost:9090
# Hello Nabla from http://elegance.abdennoor.com !
```
To understand more the stdout of the last command, take a look again at : https://github.com/abdennour/nabla-demo-apps/blob/master/node-express/app/app.js



## Prospects

Since it is possible to set the default runtime of docker to be `NABLA`, thus, it is possible to have a Kubernetes cluster with nodes (workers) with NABLA as default container runtime. 

Then, label those nodes with a specific label:

```sh
# containerRuntime=nabla
kubectl label nodes nod1.example.com containerRuntime=nabla
```

After that, you can assign/schedule pods to those nodes by using the `nodeSelector` property.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-node-express-nabla
spec:
  containers:
    - name: demo-node-express-nabla
      image: "node-express-nabla"
  nodeSelector:
    containerRuntime: nabla
```


## References

- https://nabla-containers.github.io/2018/06/28/nabla-setup/

- https://github.com/nabla-containers/runnc/issues/25

- https://medium.com/@patdhlk/how-to-install-go-1-9-1-on-ubuntu-16-04-ee64c073cd79

- https://stackoverflow.com/questions/45023363/what-is-docker-io-in-relation-to-docker-ce-and-docker-ee