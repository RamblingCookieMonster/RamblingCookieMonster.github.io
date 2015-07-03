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

I'm finally catching up on some of the ideas and takeaways from the [PowerShell Summit](http://ramblingcookiemonster.github.io/PowerShell-Summit-Wrap/). One of the fun *oh, I have to try that!* ideas came up when [Chris Duck](https://twitter.com/gpduck) and [Jason Morgan](https://twitter.com/rjasonmorgan) started chatting about something called [RabbitMQ](https://www.rabbitmq.com/getstarted.html), a messaging solution.

The timing worked out perfectly. I'm running into more and more processes where tooling or automation would require some form of orchestration. We'll likely go with an orchestration product at some point, but the idea of locking myself into a specific vendor's specific version of an orchestrator product is not something I'm going to rush into.

I'll cover a quick overview of RabbitMQ, some notes on a basic install, and walk through some basic examples illustrating how to manage and work with RabbitMq through PowerShell.

**Disclaimer: This was my first forray into the world of messaging, I am by no means an expert**

### RabbitMQ

Paraphrasing their [front page](https://www.rabbitmq.com/), RabbitMQ is a robust, easy to use, cross platform, open source solution for messaging.

Messaging... isn't that something for developers? I work on the systems side of things, why would I need that? It turns out messaging can be quite helpful in the world of IT professionals.

* Avoid fragile, monolithic scripts
* Share data between scripts running on various systems
* Avoid complex, non-standard "messaging" - Oh, my script watches for a file/Windows event/SQL data change, etc.
* Deliver messages reliably
* Perform tasks in order
* Buffer things up, process at your leisure

References on messaging abound, from the [cheeky](https://www.youtube.com/watch?v=ZQogoEVXBSA) ([pres materials](http://www.rabbitmq.com/resources/google-tech-talk-final/alexis-google-rabbitmq-talk.pdf)), to [high level conceptual bits](https://www.rabbitmq.com/tutorials/amqp-concepts.html), to [practical RabbitMq tutorials](https://www.rabbitmq.com/getstarted.html).

### Basic installation

There's much more to it, but here's the overview:

* [Download and install Erlang](http://www.erlang.org/download.html)
* [Install RabbitMq](http://www.rabbitmq.com/install-windows.html)
* Specify a base path, unless you want it running out of AppData...

{% highlight powershell %}
$rabbitdir = 'C:\RabbitMQ'
mkdir $rabbitdir
[Environment]::SetEnvironmentVariable("RABBITMQ_BASE", $rabbitdir, "Machine")
{% endhighlight %}

* Restart the RabbitMq service, it should start back up in the new directory.

At this point, you should be able to browse to http://localhost:15761, but we aren't done yet!

* Set up SSL. Some of this might be redundant.

{% highlight powershell %}
#Open a command prompt or PowerShell Window - this won't work in the ISE

# Create an SSL folder in your RabbitMq folder and copy certs to it temporarily...
# I have my domain's wildcard cert in a contoso.org.pfx file and CA public certs in public.cer and publitROOT.cer
cd $rabbitdir\ssl

#Certs for your CA
.\openssl x509 -inform der -in public.cer -out public.pem
.\openssl x509 -inform der -in publicROOT.cer -out publicROOT.pem

#Now add the contents of publicROOT to public - use notepad2 or something that won't mess with encoding.

#Certs
.\openssl pkcs12 -in contoso.org.pfx -out server.key -nocerts -nodes
.\openssl rsa -in server.key -out rsa.server.key 
.\openssl pkcs12 -in contoso.org.pfx -out server.pem -nokeys
{% endhighlight %}

* Fix your rabbitmq.config file, stored in $env:RABBITMQ_BASE that we set earlier.

```
{ssl_listeners, [5671]},

%% Optional config for REST API SSL:

    {ssl_options, [{cacertfile,"C:/RabbitMQ/ssl/public.pem"},
                  {certfile,"C:/RabbitMQ/ssl/server.pem"},
                  {keyfile,"C:/RabbitMQ/ssl/rsa.server.key"},
                  {verify,verify_none},
                  {depth, 2},
                  {fail_if_no_peer_cert,false},
                  {versions, ['tlsv1.2', 'tlsv1.1']}
                  ]}
```

* Enable the REST API

```
# Change this out depending on your path to RabbitMq server install:
$sbin = "C:\Program Files (x86)\RabbitMQ Server\rabbitmq_server-3.5.1\sbin"

& $sbin\rabbitmq-plugins.bat enable rabbitmq_management

#commit changes be re-installing service
& $Sbin\rabbitmq-service.bat stop
& $Sbin\rabbitmq-service.bat remove
& $Sbin\rabbitmq-service.bat install
& $Sbin\rabbitmq-service.bat start
```

* Configure accounts. Be sure to remove guest!

```
#Add users and passwords
& $Sbin\rabbitmqctl.bat add_user administrator SUPERSECUREPASSWORD!
& $Sbin\rabbitmqctl.bat set_permissions administrator ".*" ".*" ".*"
& $Sbin\rabbitmqctl.bat set_user_tags administrator administrator

#Example adding my self with access to all queues, and as an administrator
& $Sbin\rabbitmqctl.bat add_user cmonster "SUPERSECUREPASSWORD!"
& $Sbin\rabbitmqctl.bat set_permissions cmonster ".*" ".*" ".*"
& $Sbin\rabbitmqctl.bat set_user_tags cmonster administrator

#The permissions section is a regex for what queues you have access to, CONFIGURE, WRITE, READ.  I have .* (regex for EVERYTHING!) for each, meaning I can config, write, read everything
#https://www.rabbitmq.com/access-control.html
#https://www.rabbitmq.com/man/rabbitmqctl.1.man.html#Access%20control

#Delete the guest account, it has full admin and is evil.
& $Sbin\rabbitmqctl.bat delete_user guest
```

Hopefully everying worked and you can now browse to https://servername.contoso.org:15671

#### Troubleshooting

This might not work the first time.

* You might need to start SSL in the Erlang environment. Open werl.exe, run ssl:start().  That period is part of the syntax.
* Your rabbitmq.config file might point to the wrong path for your certs, because you mistyped it like me : )
* Assuming you set your base to C:\RabbitMq, check C:\RabbitMq\Log\rabbit@<your hostname here>.log, look up the errors you see
* Google around for other common rabbitmq or erlang troubleshooting steps.

Thankfully, Jason Morgan might be working on a DSC resource for this!

![A DSC Resource for RabbitMq?](/images/rabbitmq/dscresource.png)

### Managing RabbitMq with RabbitMqTools

A while back, Mariusz Wojcik wrote a fairly complete module for managing RabbitMq - RabbitMqTools. This fit the bill, but I needed HTTPS support, and I really prefer a Credential parameter to a plaintext password.

Download the [fork of RabbitMQTools](https://github.com/RamblingCookieMonster/RabbitMQTools/archive/master.zip), unblock the archive, and add it to one of your module paths.

{% gist 0771c69f3d408c44c754 %}

### Sending and receiving messages with PSRabbitMq

RabbitMqTools is pretty handy, and you can even send and receive messages with it, but it's not quite as efficient as using the RabbitMq .NET client. Chris Duck was generous enough to share some sanitized code for a RabbitMq module, which I proceeded to rudely muck up : )

Download [PSRabbitMQ](https://github.com/RamblingCookieMonster/PSRabbitMq), unblock the [archive](https://github.com/RamblingCookieMonster/PSRabbitMq/archive/master.zip), and add it to one of your module paths.

{% gist 505b8440cf0a9e44ec5c %}

### Wrap

This is a great tool to have in your belt, definitely consider checking it out if it would benefit your PowerShell solutions. At the very least, if you're a grouchy old man grimacing and shaking his cane at the newfangled orchestration tools, this might keep those tools at bay for a bit longer : )

That's about it! You can get pretty deep down the rabbit hole with messaging and RabbitMq, the examples here just glanced the surface.

