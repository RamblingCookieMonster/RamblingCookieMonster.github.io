---
layout: page
title: Dealing with the Click&ndash;Next&ndash;Admin
excerpt: "It won't be easy"
tags: [PowerShell, Rambling, Automation, Devops, Tools, Module]
modified: 2015-05-10 22:00:00
date: 2015-05-10 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /rabbitmq/next.png
---
{% include _toc.html %}

### Rambling

It's been a fun few weeks. The PowerShell Summit, Build, and Ignite, back-to-back-to-back.

I'm finally catching up on some of the ideas and takeaways from the [PowerShell Summit](http://ramblingcookiemonster.github.io/PowerShell-Summit-Wrap/). One of the fun *oh, I have to try that!* ideas came up when [Chris Duck](https://twitter.com/gpduck) and [Jason Morgan](https://twitter.com/rjasonmorgan) started chatting about something called [RabbitMQ](https://www.rabbitmq.com/getstarted.html), a messaging solution.

The timing worked out perfectly. I'm running into more and more processes that I want to automate, that require some form of orchestration. We'll likely go with an orchestration product at some point, but the idea of locking myself into a specific vendor's specific version of an orchestrator product is not something I'm going to rush into.

I'll cover a quick overview of RabbitMQ, some notes on a simple setup, and of course, an example illustrating how to use RabbitMQ in your PowerShell solutions.

**Disclaimer: This was my first forray into the world of messaging, I am by no means an expert**

### RabbitMQ

Paraphrasing their [front page](https://www.rabbitmq.com/), RabbitMQ is a robust, easy to use, cross platform, open source solution for messaging.

Messaging... isn't that something for developers? I work on the systems side of things, why would I need that? It turns out this can be quite helpful in the world of IT professionals. Let's look at one example among many.

### Example: Active Directory User Migration

Let's take a hypothetical scenario. You want to design tooling for Active Directory user migrations. Here are a few of the tasks you've identified that you need done, for each user:

* Migrate the user account with ADMT
* Create a home share if it does not exist
* Move user data from home share on source domain to home share on target domain

You've determined that the first two steps can occur as quickly as possible with no impact to existing users or production resources. Unfortunately, migrating user data

* Avoid fragile, monolithic scripts
* Avoid complex, non-standard "messaging" - Oh, my script watches for a file/Windows event/SQL data change, etc.
* Deliver messages reliably
* Perform tasks in order
* Buffer things up, process at your leisure
* 


Cheeky:
https://www.youtube.com/watch?v=ZQogoEVXBSA
http://www.rabbitmq.com/resources/google-tech-talk-final/alexis-google-rabbitmq-talk.pdf

RabbitMq tutorial:
https://www.rabbitmq.com/getstarted.html

AMQP model overview:
https://www.rabbitmq.com/tutorials/amqp-concepts.html

Clustering:
https://www.rabbitmq.com/clustering.html

Wonder if you could make a practical #PowerShell training test evaluated with #Pester? This also looks cool: https://github.com/vors/HellOps