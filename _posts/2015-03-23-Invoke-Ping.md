---
layout: post
title: Invoke-Ping&#58; Testing connectivity in parallel
excerpt: "Building reusable tools"
tags: [PowerShell, Tools]
modified: 2015-03-23 22:00:00
date: 2015-03-23 22:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /invoke-ping/lego.png
---
{% include _toc.html %}

I grew up playing with legos. They were fun, and they spurn the imagination. You might start with a block or a premade prop. You put things together, maybe follow the instructions, and eventually let your imagination run wild building whatever comes to mind. Perhaps a [car](http://www.extremetech.com/extreme/173167-worlds-first-full-size-lego-car-can-hit-20-mph-powered-by-insane-1048-piston-compresed-air-engine).

I use the lego anecdote when talking about PowerShell with newcomers. You might start with single cmdlets and premade functions. You can pipe them together, follow some examples and blog posts, and eventually get the hang of building [advanced functions](https://ramblingcookiemonster.wordpress.com/2013/12/08/building-powershell-functions-best-practices/) and modules to meet your needs and imagination.

Modular code is one of the many [benefits to scripting](http://ramblingcookiemonster.github.io/Why-PowerShell/) and programming in general. Let's take a look at a practical example, with a function that can speed up testing connectivity to systems.

### Test-Connection

One of the first commands you learn in PowerShell is [Test-Connection](https://technet.microsoft.com/en-us/library/hh849808.aspx). It does the trick, but it's not exactly speedy. Let's pretend I want to run against all the servers in my organization, but want to skip over systems that don't respond:

![Test Connection Is Slow](/images/invoke-ping/QuietLong.png)

Thirty minutes tests my patience, and wouldn't it be nice to have a single command rather than writing logic for looping and output?

### Faster!

A few years back, Boe Prox wrote [a great article](http://learn-powershell.net/2012/05/10/speedy-network-information-query-using-powershell/) on using runspaces to speed up network information queries. I mashed together some of Boe's code with some crude duct tape, and rolled out the first iteration of [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel). Sergei Vorobev contributed a number of helpful ideas, including adding Pester tests and [automated testing through AppVeyor](https://ramblingcookiemonster.wordpress.com/2015/02/25/fun-with-github-pester-and-appveyor/).

Invoke-Parallel is like a mashup of Foreach-Object and Invoke-Command. You can use it to run a script block against a collection of objects (like foreach), and it does it incredibly quickly, but you need to be wary that runspaces are fairly independent. You need to consciously pass in variables and load modules as needed, similar to Invoke-Command.

![Invoke-Parallel](/images/invoke-ping/InvokeParallel.png)

Pretty good! I can live with 45 seconds, but it's pretty bare bones, and it's not abstract enough. What if I want to test remote registry, remote RPC, SMB, or other connectivity?

### Test-Server

Justin Rich has a handy tool we can use for these connectivity tests - [Test-Server](https://gallery.technet.microsoft.com/scriptcenter/Powershell-Test-Server-e0cdea9a).

A few tweaks to Test-Server, and we have the ingredients for a convenient and fast solution that works in PowerShell 2:

* [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel)
* [Test-Connection](https://technet.microsoft.com/en-us/library/hh849808.aspx?f=255&MSPPError=-2147217396)
* [Test-Server](https://gallery.technet.microsoft.com/scriptcenter/Powershell-Test-Server-e0cdea9a)

### Invoke-Ping

All we need to do now is bundle these ingredients into a simple to use package, [Invoke-Ping](https://gallery.technet.microsoft.com/scriptcenter/Invoke-Ping-Test-in-b553242a). Hit the link, download and unblock the .ps1, and load it up!

```powershell
# dot source the function  
    . "\\Path\To\Invoke-Ping.ps1"  
  
# Get help for Invoke-Ping 
    Get-Help Invoke-Ping -Full 
     
# Check for WSMan, Remote Registry, Remote RPC, RDP, and SMB (via C$) connectivity against 3 machines 
    Invoke-Ping Server1, Server2, Server3 -Detail * 
```

There are a few ways to run it:

#### Standard

![Plain](/images/invoke-ping/IPPlain.png)

This simply runs Test-Connection and returns a selection of properties.

#### Quiet

![Quiet](/images/invoke-ping/QuietOne.png)

This executes the same code as the plain example, but we only return responding computer names.

This is a great way to filter out systems that don't respond to ping. Remember our original thirty minute query? We can get it down to less than 45 seconds:

![Quiet Filter](/images/invoke-ping/Quiet.png)

#### Detail

Finally, what if we want more details?  Here are a few examples; note that you can specify which tests to perform:

![All details](/images/invoke-ping/DetailAll.png)

![Select details](/images/invoke-ping/DetailSelect.png)

### Wrapping up

Snippets of code are great, and they have their place. If you really want to save time, consider building re-usable tools that you can use across solutions and within other tools. If you follow [best practices](https://ramblingcookiemonster.wordpress.com/2013/12/08/building-powershell-functions-best-practices/) and conventions, your functions and modules will integrate with the wider PowerShell ecosystem.

Once you get the hang of it, adding the scaffolding around a function becomes second nature, and you may find yourself preferring to start with the assumption that you will be writing a function.

Happy scripting!