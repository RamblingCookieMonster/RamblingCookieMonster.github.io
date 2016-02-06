---
layout: post
title: Finding Evil LDAP Queries
excerpt: "(|(uid=*)(sAMAccountName=*z))"
tags: [PowerShell, Tools, SQL, SQLite, Practical]
modified: 2015-10-02 22:00:00
date: 2015-10-02 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /ldap/hourglasses.png
---
{% include _toc.html %}

# Rambling

A while back, I noticed an intriguing tweet from Mark Morowczynski at Microsoft:

![tweet](/images/ldap/tweet.png)

Long story short, Mark explains how to search for and analyze [expensive, inefficient, and long running LDAP queries in Active Directory](http://blogs.technet.com/b/askpfeplat/archive/2015/05/11/how-to-find-expensive-inefficient-and-long-running-ldap-queries-in-active-directory.aspx). Bookmarked.

This week, Mark's article came in quite handy.

# The Fun Begins

Wednesday morning, someone asked about some SCOM alerts for AD. We see these every so often, and I started explaining that sites with one or two domain controllers lead to somewhat common and often innocuous AD Site Performance Health Degraded alerts.

I don't like assumptions though. Interesting. All the domain controllers in one site are at 100% CPU, with crazy CPU queues. This wasn't a site getting disconnected, or a one-off evil LDAP query. Looks like we get to dive into Mark's post!

# Finding Expensive, Inefficient, or Long Running LDAP Queries

## Prerequisites

Okay! I know I saw 'PowerShell' when skimming the article, this should be quick and easy, or so I thought.

The final stages of our 2012 R2 roll out are scheduled for next week, so we need to [install KB2800945](https://support.microsoft.com/en-us/kb/2800945/en-us) on any remaining 2008 R2 domain controllers, and reboot.

AD is somewhat important, and a juicy target - if you have a tight ship and this is a rare scenario, consider opening a ticket with Microsoft and triggering your (security) incident response process here.

## The Registry

Once our prerequisites are in place, we need to flip a few values in the registry.

Oh. There's a screen shot of the registry in the blog post. And a table with registry keys and values. Guess we'll write [a PowerShell function](https://github.com/RamblingCookieMonster/PSLDAPQueryLogging/blob/master/PSLDAPQueryLogging/Public/Enable-LDAPQueryLogging.ps1)!

I'm all for quickly fighting fires with a GUI, but I realize I don't want to deal with enabling and disabling this manually on several machines. Writing a quick POC function will be far faster. Particularly given that this is a simple registry change, and that Shay Levy has written the fantastic [PSRemoteRegistry](https://psremoteregistry.codeplex.com/), which I no longer consider a dependency. Just say no to providers that don't let you hit remote systems.

All we do here is enable logging, and set a few parameters that Mark suggested.

```powershell
Set-RegDWord -ComputerName $Computer -Hive LocalMachine -Key 'System\CurrentControlSet\Services\NTDS\Diagnostics' -Value '15 Field Engineering' -data 5
Set-RegDWord -ComputerName $Computer -Hive LocalMachine -Key 'SYSTEM\CurrentControlSet\Services\NTDS\Parameters' -Value 'Expensive Search Results Threshold' -data 0
Set-RegDWord -ComputerName $Computer -Hive LocalMachine -Key 'SYSTEM\CurrentControlSet\Services\NTDS\Parameters' -Value 'Inefficient Search Results Threshold' -data 0
Set-RegDWord -ComputerName $Computer -Hive LocalMachine -Key 'SYSTEM\CurrentControlSet\Services\NTDS\Parameters' -Value 'Search Time Threshold (msecs)' -data 100
```

That's it! My domain controllers are now logging event 1644, with details on each LDAP query that meets the thresholds I just set; in this case, anything taking over 100ms. Time for coffee.

## Collecting the Results

This could be outdated or flat out ignorant knowledge, but I recall wevtutil epl being incredibly fast, as compared to reading events using Get-WinEvent (or Get-EventLog, eek!). I'm a fan of using tools that meet your needs. In this case, quickly exporting an evtx is a simple one liner.

```powershell
Invoke-Command -ComputerName $Computer {wevtutil epl 'Directory Service' "\\$Using:Computer\c$\$ENV:ComputerName-Evil.evtx"}
```

Alrighty, the events are there. Oh. Be sure your Directory Services event log is large enough to catch enough data. Maybe [use DSC](https://github.com/PowerShell/xWinEventLog).

At this point, I [reverse](https://github.com/RamblingCookieMonster/PSLDAPQueryLogging/blob/master/PSLDAPQueryLogging/Public/Disable-LDAPQueryLogging.ps1) the registry changes I made, and get ready for some fun with Excel!

## Parsing and Interpreting the Results

Mark links to [a script](https://gallery.technet.microsoft.com/scriptcenter/Event-1644-reader-Export-45205268) that helps read Event 1644 data. This is quite handy, and it's awesome that folks are trying to use PowerShell, but the methodology leaves a bit to be desired.

* Install Excel, so that you can access the COM interface. [Sigh](http://ramblingcookiemonster.github.io/PSExcel-Intro/).
* Read the script and Get-Help. No parameters. Sigh.
* Run the script, follow the Read-Host guide. Sigh.
* If you're like many folks out there, you might get a few errors. My output was still usable.

At this point, you can browse around the results in Excel, [ as Mark explains in his post](http://blogs.technet.com/b/askpfeplat/archive/2015/05/11/how-to-find-expensive-inefficient-and-long-running-ldap-queries-in-active-directory.aspx#Analyzing).

In our case, the TopTime-IP section came in handy. A single system is making a huge portion of these queries, including a number of 8+ second queries using UID, which isn't indexed. I gleefully brandish my pitchfork and run a reverse lookup.

![Wat](/images/ldap/wat.png)

Hopefully this pointed you in the right direction or right at the culprit. Depending on what you do or don't find, there are a variety of helpful resources:

* [Indexing](http://blogs.technet.com/b/askpfeplat/archive/2012/11/11/mcm-active-directory-indexing-for-the-masses.aspx). Active Directory sits on a database. Like most database engines, your domain controllers will be much, much happier if queries use an indexed attribute.
* Developers, vendors, and sysadmins might not be familiar with how evil the queries they write can be. [Long story](https://msdn.microsoft.com/en-us/library/ms808539.aspx) short? Be as specific as possible. Start as deep as you can, set your search scope as tight as possible, and follow efficient query practices like using indexed attributes, returning only the attributes you need, and keeping your wild cards at the end of a string, not the start.
* Other tools, like the [AD data collector sets](http://blogs.technet.com/b/askds/archive/2010/06/08/son-of-spa-ad-data-collector-sets-in-win2008-and-beyond.aspx), [SPA](http://blogs.technet.com/b/yongrhee/archive/2014/02/01/tool-server-performance-advisor-spa-v3-1-to-troubleshoot-high-cpu-in-lsass-in-ad-domain-controllers.aspx), WireShark, or [Microsoft Message Analyzer](https://technet.microsoft.com/en-us/library/jj714801.aspx) might come in handy.
* We're assuming you ruled out other common causes, like non-LSASS offenders, mis-sized domain controllers, and other scenarios. Google and MSFT resources are your friend : )

Now, what about next time?

# PowerShell Modules: Write Them

[Abstraction is important](http://powershell.org/wp/2015/08/16/abstraction-and-configuration-data/). Don't think in terms of "writing scripts", try to think in terms of writing re-usable tools: functions. Once you're comfy writing these tools, you need a toolbox to put them in: modules.

Want to forget about tools and toolboxes to an extent? [Desired State Configuration](https://channel9.msdn.com/Series/Getting-Started-with-PowerShell-Desired-State-Configuration-DSC) and configuration management solutions that layer on top might be up your alley. But I digress, and it's important to note that configuration management isn't a panacea; Do you plan to change your configurations for a class of system just to enable diagnostics on a handful of instances? Nope.

I used a quick [recipe for building a PowerShell module](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/), published the obnoxiously-named [PSLDAPQueryLogging](https://github.com/RamblingCookieMonster/PSLDAPQueryLogging) module to GitHub and the PowerShell Gallery, and I'm ready for next time!

Here's a quick snippet where I enable logging on all domain controllers, pull back the logs, and disable logging:

{% gist f4322853e049f2ec85c6 %}

# Get On With It!

Be sure to [share your modules](http://powershell.org/wp/2015/09/06/writing-and-publishing-powershell-modules/) on GitHub and the [PowerShell Gallery](https://www.powershellgallery.com/pages/GettingStarted). Languages like [Perl](https://www.perl.org/about/whitepapers/perl-cpan.html), [Python](https://pypi.python.org/pypi), and [Ruby](https://rubygems.org/) all have repositories like this, each with thousands and thousands of modules. We  have 321. Let's get to work!

Barring the occasional *I have to share it!* discoveries, this will likely be my last post for some time; life is about to get crazy at home. In a good way. Cheers!