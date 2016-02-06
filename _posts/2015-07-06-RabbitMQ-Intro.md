---
layout: post
title: RabbitMQ and PowerShell
excerpt: "You've got mail"
tags: [PowerShell, Automation, Devops, Tools, Module]
modified: 2015-07-06 22:00:00
date: 2015-07-06 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /rabbitmq/mailbox.png
---
{% include _toc.html %}

### Rambling

I'm finally catching up on some of the ideas and takeaways from the [PowerShell Summit](http://ramblingcookiemonster.github.io/PowerShell-Summit-Wrap/). One of the fun *oh, I have to try that!* ideas came up when [Chris Duck](https://twitter.com/gpduck) and [Jason Morgan](https://twitter.com/rjasonmorgan) started chatting about something called [RabbitMQ](https://www.rabbitmq.com/getstarted.html), a messaging solution.

The timing worked out perfectly. I'm running into more and more processes where tooling or automation would require some form of orchestration. We'll likely go with a COTS product at some point, but the idea of locking myself into a specific vendor's specific version of an orchestration solution is not something I'm going to rush into.

Let's run through a quick overview of RabbitMQ, some notes on a basic install, and some PowerShell tools you could use to help manage and use RabbitMQ in your own solutions.

**Disclaimer**: *This was my first foray into the world of messaging, I am by no means an expert*

### RabbitMQ

Paraphrasing their [front page](https://www.rabbitmq.com/), RabbitMQ is a robust, easy to use, cross platform, open source solution for messaging.

Messaging... isn't that something for developers? I work on the systems side of things, why would I need that? It turns out messaging can be quite helpful in the world of IT professionals.

* Avoid fragile, monolithic scripts
* Share data between scripts running on various systems and platforms
* Avoid complex, non-standard "messaging" - Oh, my script watches for a file / Windows event / SQL data change, etc.
* Deliver messages reliably
* Perform tasks in order
* Buffer things up, process at your leisure

References on messaging abound, from the [cheeky](https://www.youtube.com/watch?v=ZQogoEVXBSA) ([pres materials](http://www.rabbitmq.com/resources/google-tech-talk-final/alexis-google-rabbitmq-talk.pdf)), to [high level conceptual bits](https://www.rabbitmq.com/tutorials/amqp-concepts.html), to [practical RabbitMq tutorials](https://www.rabbitmq.com/getstarted.html).

A common analogy on the basics, apologies if I butcher this:

* Your various scripts (*publishers*) are sending mail (*messages*)
* The mail might have an address (*routing key*) to help route it to the right recipient
* The mail gets dropped in a USPS mailbox (an *exchange*)
* The mail is routed (*binding*) to the appropriate recipient mailboxes (*queues*)
* The recipients (*consumers*) might stop by a PO box to pick up their mail, or might have it delivered (*subscriptions*)

[![Basic illustration](/images/rabbitmq/hello-world-example-routing.png)](https://www.rabbitmq.com/tutorials/amqp-concepts.html)

Finally, here's a simple example showing two independent sessions talk to each other through PSRabbitMQ:

![Listener gif](/images/rabbitmq/Listener.gif)

Let's look at setting up a single RabbitMQ server.

### Basic installation

If you're planning to use this for more than a quick POC, [read up](http://www.rabbitmq.com/admin-guide.html) and configure per your own needs and requirements.

Some rough notes taken during the single server POC deployment we stood up:

* Specify a base path, unless you want RabbitMQ running out of AppData

```powershell
$rabbitdir = 'C:\RabbitMQ'
mkdir $rabbitdir
mkdir $rabbitdir\ssl
[Environment]::SetEnvironmentVariable("RABBITMQ_BASE", $rabbitdir, "Machine")
```

* [Download and install Erlang](http://www.erlang.org/download.html) - I went with x64
* [Install RabbitMQ](http://www.rabbitmq.com/install-windows.html)
* If you're planning to use SSL, grab the latest OpenSSL (variety of [sources](http://indy.fulgan.com/SSL/)), drop the files in C:\RabbitMQ\ssl
* Enable the web interface and RESTful API

```powershell
# Change this out depending on your RabbitMQ install location:
$sbin = "C:\Program Files (x86)\RabbitMQ Server\rabbitmq_server-3.5.3\sbin"

& $sbin\rabbitmq-plugins.bat enable rabbitmq_management

#commit changes be re-installing service
& $Sbin\rabbitmq-service.bat stop
& $Sbin\rabbitmq-service.bat remove
& $Sbin\rabbitmq-service.bat install
& $Sbin\rabbitmq-service.bat start
```

At this point, you should be able to browse to http://localhost:15672, but we aren't done yet!

* Set up SSL. Some of this might be redundant

```powershell
# Open PowerShell.exe - this won't work in the ISE
# I copied my certs here temporarily...
# I have my domain's wildcard cert in a contoso.org.pfx file and CA public certs in public.cer and publitROOT.cer
$rabbitdir = 'C:\RabbitMQ'
cd $rabbitdir\ssl

#Certs for your CA
.\openssl x509 -inform der -in public.cer -out public.pem
.\openssl x509 -inform der -in publicROOT.cer -out publicROOT.pem

# Add the contents of publicROOT.pem to public.pem
# Use PowerShell, notepad2, or something else that won't mess with encoding.

.\openssl pkcs12 -in contoso.org.pfx -out server.key -nocerts -nodes #pw prompt here
.\openssl rsa -in server.key -out rsa.server.key
.\openssl pkcs12 -in contoso.org.pfx -out server.pem -nokeys #pw prompt here
```

* Create a [rabbitmq.config](https://gist.github.com/RamblingCookieMonster/d0ca18ca59ee11082bb8) file in $env:RABBITMQ_BASE that we set earlier. Adjust SSL options as needed.
* Re-install the service one more time...

```powershell
#commit changes be re-installing service
& $Sbin\rabbitmq-service.bat stop
& $Sbin\rabbitmq-service.bat remove
& $Sbin\rabbitmq-service.bat install
& $Sbin\rabbitmq-service.bat start
```

* Configure accounts. Be sure to remove the default guest account!

```powershell
#Add users and passwords. This admin account has access to everything...
& $Sbin\rabbitmqctl.bat add_user administrator "SUPERSECUREPASSWORD!"
& $Sbin\rabbitmqctl.bat set_permissions administrator ".*" ".*" ".*"
& $Sbin\rabbitmqctl.bat set_user_tags administrator administrator

#Example adding my self with access to all queues, and as an administrator
& $Sbin\rabbitmqctl.bat add_user cmonster "SUPERSECUREPASSWORD!"
& $Sbin\rabbitmqctl.bat set_permissions cmonster ".*" ".*" ".*"
& $Sbin\rabbitmqctl.bat set_user_tags cmonster administrator

#The permissions section is a regex for what queues you have access to, CONFIGURE, WRITE, READ.  I have .* (regex for EVERYTHING!) for each, meaning I can config, write, and read anything
#https://www.rabbitmq.com/access-control.html
#https://www.rabbitmq.com/man/rabbitmqctl.1.man.html#Access%20control

#Delete the guest account, it has full admin and is evil.
& $Sbin\rabbitmqctl.bat delete_user guest
```

Hopefully everything worked and you can now browse to https://servername.contoso.org:15671! If you skipped the SSL and rabbitmq.config, you should be able to hit http://localhost:15672.

NOTE: Consult someone who knows what they are doing if SSL is important to you. Borrowed some of this from [here](http://weblogs.asp.net/jeffreyabecker/Using-SSL-client-certificates-for-authentication-with-RabbitMQ).

#### Troubleshooting

This might not work the first time.

* You might need to start SSL in the Erlang environment. Open werl.exe, run *ssl:start().* That period is part of the syntax.
* Your rabbitmq.config file might point to the wrong path for your certs, because you mistyped it like me : )
* Assuming you set your base to C:\RabbitMQ, check C:\RabbitMQ\Log\rabbit@*your_hostname_here*.log, look up the errors you see
* Google around for other common RabbitMQ or Erlang troubleshooting steps.

Thankfully, Jason Morgan might be working on a DSC resource for this!

![A DSC Resource for RabbitMQ?](/images/rabbitmq/dscresource.png)

We have a RabbitMQ server up and running! What can we do with it?

### Managing RabbitMQ with RabbitMQTools

A while back, Mariusz Wojcik wrote a fairly complete module for managing RabbitMQ via the REST API: RabbitMQTools. This fit the bill, but I needed HTTPS support, and I prefer a Credential parameter to a plaintext password.

Download the [fork of RabbitMQTools](https://github.com/RamblingCookieMonster/RabbitMQTools/archive/master.zip), unblock the archive, and add it to one of your module paths.

{% gist 0771c69f3d408c44c754 %}

This code created a simple fanout exchange:

[![Fanout exchange](/images/rabbitmq/exchange-fanout.png)](https://www.rabbitmq.com/tutorials/amqp-concepts.html)

This means any message we send to the exchange is repeated to all queues bound to that exchange. A broadcast, if you will.

### Sending and receiving messages with PSRabbitMQ

RabbitMQTools is pretty handy, and you can even send and receive messages with it, but it's not quite as efficient as using the RabbitMQ .NET client. Chris Duck was generous enough to share some sanitized code for a RabbitMQ module, which I proceeded to rudely muck up : )

Download [PSRabbitMQ](https://github.com/RamblingCookieMonster/PSRabbitMQ), unblock the [archive](https://github.com/RamblingCookieMonster/PSRabbitMq/archive/master.zip), and add it to one of your module paths.

{% gist 505b8440cf0a9e44ec5c %}

### Wrap

A big thanks to Mariusz and Chris for RabbitMQTools and the RabbitMQ module, respectively.

Definitely check out RabbitMQ if a messaging tool would benefit your PowerShell and other solutions. At the very least, if you're trying to beat back orchestration pushers from VMware, Microsoft, BMC, Citrix, and the various other vendors, a little experience with RabbitMQ and [SQL server](https://ramblingcookiemonster.wordpress.com/2014/03/12/sql-for-powershell-for-sql-newbies/) should keep them at bay.

That's about it! You can get pretty deep down the rabbit hole with messaging and RabbitMQ, the examples here just glanced the surface.

#### Rambling aside

Congrats to June Blender et al for their recent MVP awards! June [posted a connect issue](https://connect.microsoft.com/PowerShell/feedbackdetail/view/1351032/add-powershell-tab-and-examples-to-net-reference-pages-in-msdn) back in May to highlight the need for PowerShell examples in the MSDN .NET references, which would be absolutely fantastic.

On top of PowerShell examples in the .NET references, would love to see a tool that could generate usable (even if not optimal) PowerShell code from C# snippets. With so many third party solutions illustrating their .NET usage through C#, wouldn't it be great to have a tool to convert the [RabbitMQ](http://www.rabbitmq.com/tutorials/tutorial-one-dotnet.html) and myriad other .NET examples to PowerShell? Hopefully we see something interesting from [Adam Driscoll](https://github.com/adamdriscoll/PowerShellCodeDomProvider), Microsoft, or the wider community.

Cheers!