---
layout: page
title: Validation and Error Handling
excerpt: "It won't be easy"
tags: [PowerShell, Rambling, Automation, Devops, Tools, Module]
modified: 2015-05-25 22:00:00
date: 2015-05-25 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /error-handling/warning.png
---
{% include _toc.html %}

### Rambling

A short while back, Adam Bertram was looking for suggestions on a theme for a PowerShell blog week. I suggested validation and error handling - these may seem dry, and are often ovelooked, despite being absolutely critical for reliability and consistency. June corrected my phrasing:

[Not dry](/images/error-handling/june.png)!

Haven't seen anything on this, so here's a quick hit on validation, sanitization, error handling, and other important practices.

### What Could Go Wrong?

This is a good question to ask yourself as you write code, PowerShell or otherwise. What could intentionally or unintentionally go wrong? Ask this question often, and you will generally end up with a more reliable, consistent, and secure solution.

Some variations to consider:

* What could go wrong... with the provided input?
* What could go wrong... with the data being processed?
* What could go wrong... with my expectations?
* What could go wrong... with the operating environment?
* What could go wrong... with my code?

When you first start considering these questions, you might wonder if they are really worth the extra time and thought. "What are the chances!" you might ask. If you find yourself taking shortcuts, be sure to consider the implications if something does indeed go wrong.

So what could happen when something goes wrong? A few examples:

* You're only reading data... but that data feeds management decisions or processes down the line. You might provide bad data to downstream processes.
* You're changing data... what if you change the wrong data? Will you know it changed? How many business processes or services will it impact?
* You're removing data... you just deleted production data! Hopefully you have backups. Will you notice in time to restore without a significant impact?
* You exposed your service to injection... you suffer unintentional or intentional injection. Could be SQL injection, code injection, you name it. Not good!

Let's look at an example scenario, and walk through these questions along the way.

### The Scenario

You create secondary high privilege accounts every so often; for example, my standard cmonster account might get a cmonsterDA account for desktop administration, cmonsterSA for server administration, and so on.

You have more interesting things to work on, so you decide to build tooling or automation for this ([Why else?](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter2.txt)). You want the following basic steps:

* Create an account in Active Directory
* Assign the account to a privileged Security Group, 'Server Admins'
* Send a notification e-mail to the account's owner

Phrasing:

* Standard account: this would refer to the owner's account, for example, cmonster
* Admin account: this would refer to the owner's new admin account, for example, cmonsterSA

Let's create a simple example script, and walk through it:

{% gist 132f13fb1d0e35ce9657 %}

Let's dissect this line by line.  Note that in the real world, you might consider these questions as you write each line, rather than after the fact.

### What Could Go Wrong?

#### Line 2: Bad Input

Input can be dangerous. .  In our example, we take in a SamAccountName.

The idea with input validation is that you should control and limit the input that you take, to avoid surprising outcomes. There are a number of options:

* Use built in PowerShell functionality for validation. Boe Prox wrote [a great post](http://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/) on this, and [about_Functions_Advanced_Parameters](https://technet.microsoft.com/en-us/library/hh847743.aspx) has a few tips as well.
* [Use an Enum](http://ramblingcookiemonster.github.io/Types-And-Enums/) that restricts you to a few specific choices, or a strong type, such as [int] or [string[]] to indicate exactly what type of data to take in.
* In some cases, you might want to allow arbitrary input, performing validation later in your code.

#### Scenario: Input Validation

In our scenario, the only input is the samaccountname for an existing standard account. Let's think of a few things we should validate:

* The account should exist in active directory
* The account should be a standard account with an e-mail address, to allow notification down the line
* Can anyone request an administrative account? Would it be worth validating their authority to request this? Perhaps anyone in a 'System Admin Team' security group is allowed to request an admin account. Perhaps your ticketing system has a REST API or SQL data with authorization information for the request.

In this case, I would likely validate the input inside the script or function itself, given that it might clutter up a [ValidateScript()] attribute.

I might load up a [light-weight tool for ADSI queries](https://gallery.technet.microsoft.com/scriptcenter/Get-ADSIObject-Portable-ae7f9184), verify that the input account exists in AD, verify that it has a mail attribute, and validate that it [has group membership](https://gallery.technet.microsoft.com/scriptcenter/Get-ADGroupMembers-Get-AD-0ee3ae48) in 'System Admin Team'.

What could have gone wrong? What if the wrong account went through, and I automatically provisioned a high privilege account for someone not in the 'System Admin Team', sending out a nice e-mail to them letting them know how to log in to their new account? This is a relatively tame example.

### Sanitization, Expectation Management, and Bad Code

