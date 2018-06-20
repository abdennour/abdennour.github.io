---
layout: post
comments: true
title:  "Getting Started with Krypton - New way to secure your SSH keys"
date:   2018-06-20 05:27:00 +0454
categories: Security Kryptonite Krypton Infrastructure Encryption Abdennour Tunisia
excerpt: "Krypton is a new way to deal with your SSH keys. You will still able to use the public key in your laptop, however, you secure the private with a hardware which is your phone device "
image: "assets/krypton/accept-request.png"
---

## Introduction

Krypton is a new way to deal with your SSH keys (namely the private one). You will still able to use the public key in your laptop, however, you secure the private with a hardware which is your phone device.

Since the official documentation is the best friend for researchers, [krypt.co](https://krypt.co/docs/security/threat-model.html) explains why using Krypton to store SSH keys:

> Storing your SSH keys locally, encrypted or not, poses the risk of the plaintext key falling into adversarial hands, immediately compromising every server you have access to.

> With Krypton, even the worst compromise is limited to only SSH logins explicitly authorized by you. At the core, phone operating systems are built with better sandboxing than their desktop counterparts. This is why security experts like Matt Green recommend phones for your most sensitive data.


## Prerequisites

1- Laptop with Unix kernel (macOS, Debian, RedHAT). I will use my Macbook for this demo.

2- Real phone device with OS: Android or iOS.

or

Virtual device which requires:

* Virtualbox 5.2.6 or up
* Genymotion 2.10.0 or up

Nevertheless, I am still not sure if it will work with Virtual devices.
Indeed, I opened [an issue](https://github.com/kryptco/kr/issues/216) about the compatibility of Krypton with virtual devices.

## Getting Started


# Install Krypton on Laptop


```sh
# For MacOS
brew install kryptco/tap/kr
# For other OSs, check out: https://krypt.co/docs/start/installation.html
```

# Install Kryptonite on phone device

- Open browser (.i.e: Chrome)
- Navigate to : [https://get.krypt.co](https://get.krypt.co)
- This link redirects you to the AppStore if your device is iOS and to GooglePlay if it is android
- Install the application

# Pairing Phone device and Laptop

- [Laptop] Run `kr pair`
- A QR Code displays as stdout of the previous command

![kr pair QR code]({{ "assets/krypton/kr-pair-qr-code.png" | absolute_url }})

- [Phone] Scan this QR code using the recently installed mobile app "Kryptonite".

![Scan QR code]({{ "assets/krypton/scan-qr-code.webp" | absolute_url }})

By now, pairing step is done successfully.
To verify that, `~/.ssh/config` should contain something like the following:

```
# Added by Krypton
Host *
	IdentityAgent ~/.kr/krd-agent.sock
	ProxyCommand /usr/local/bin/krssh %h %p
	IdentityFile ~/.ssh/id_krypton
	IdentityFile ~/.ssh/id_ed26633
	IdentityFile ~/.ssh/id_rsa
	IdentityFile ~/.ssh/id_ecdsa
	IdentityFile ~/.ssh/id_dsa%
```

# The moment of Truth


- [Laptop] SSH to test server

```sh
ssh me.krypt.co
```

![SSH Test Server]({{ "assets/krypton/ssh-test-server.png" | absolute_url }})

As you can see, the `ssh` process is waiting approval from the Krypton mobile app.

Absolutely, I received a notification in the mobile phone to approve the ssh access:

![notification wait approval]({{ "assets/krypton/notify-wait-approval.png" | absolute_url }})

- [Phone] Now, go ahead and accept the request.

![]({{ "assets/krypton/accept-request.png" | absolute_url }})

i.e: Tap "ONCE" option.

- [Laptop] Return back now to your terminal:

![SSH successfully]({{ "assets/krypton/ssh-success.png" | absolute_url }})

 You are successfully SSH to the test server. Congratulations!


## What's next ?

Now, it's time to reinforce your Infrastructure security by using [krypton with your Bastion hosts (Jump server)](https://krypt.co/docs/ssh/using-a-bastion-host.html).

Good luck!
