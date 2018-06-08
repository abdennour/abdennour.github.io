---
layout: post
comments: true
title:  "Successfully Running Kata Containers in the Cloud"
date:   2018-06-09 01:27:00 +0233
categories: GCP Google-Cloud AWS Kata Cloud Containers VM DevOps Abdennour Tunisia
---

# Introduction

Before 2 hours from now, I attended [TGI episode about Kata containers](https://www.youtube.com/watch?v=ixs2-UnWiGU) and I learned that Kata containers requires enabling nested virtualization.
In the moment that I wrote this article, I cannot run Kata in AWS EC2 (Ubuntu) instance. Indeed, I am getting this error : `failed to initialize KVM: No such file or directory: unknown.`.

Fortunately, one of attendees posted a link during that episode: [Google Cloud - Enabling Nested Virtualization for VM Instances](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances).

Hence, I decided to give GCP a shot and trying it out.

# Prerequisites

- Having a Google Cloud account
- `gcloud` CLI is available and authenticated

# Creating VM with nested Virtualization enabled

**1. Create a Disk from Ubuntu image**

```sh
gcloud compute disks create disk-1 \
    --zone=us-central1-a \
    --type=pd-standard \
    --image=ubuntu-1604-xenial-v20180522 \
    --image-project=ubuntu-os-cloud --size=10GB
```

**Note:** The rest of steps are already mentioned in this [link](https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances)

**2. Create an Image with nested virtualization enabled**

```sh
gcloud compute images create ubuntu-1604-nested-virtualization \
  --source-disk disk-1 --source-disk-zone us-central1-a \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
```

**3. Create new instance from that image**

```sh
gcloud compute instances create example-nested-virtualization \
  --zone us-central1-b \
  --image ubuntu-1604-nested-virtualization
```

**4. SSH to the new instance**

```sh
gcloud compute ssh example-nested-virtualization
```

**5. verification of nested virtualization**

```sh
cat /proc/cpuinfo | grep vmx
# It should return something in the stdout
```


# Provision the machine for Kata Container


**1. Install Kata dependencies**

```sh
cat /proc/cpuinfo | grep vmx
sudo -E apt-get -y install apt-transport-https ca-certificates wget software-properties-common
curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
arch=$(dpkg --print-architecture)
sudo -E add-apt-repository "deb [arch=${arch}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo -E apt-get update
sudo -E apt-get -y install docker-ce
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/release/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list"
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/release/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
sudo -E apt-get update
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/kata-containers.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D --add-runtime kata-runtime=/usr/bin/kata-runtime --default-runtime=kata-runtime
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

```

For more details about this script (line by line), check out [KATA installation guide](https://github.com/kata-containers/documentation/blob/master/install/ubuntu-installation-guide.md)

# Run a sample

```sh
sudo docker run -ti busybox sh
```

Congratulations! Kata is successfully running.
