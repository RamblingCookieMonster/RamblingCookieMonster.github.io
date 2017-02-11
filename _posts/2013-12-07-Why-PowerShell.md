---
layout: post
title: Why PowerShell?
excerpt: "Because"
tags: [PowerShell, Learning]
modified: 2015-03-25 00:00:00
date: 2015-03-25 00:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /why-powershell/logo.png
---
{% include _toc.html %}

*Edit*: This material has been adapted and augmented by Don Jones into the [Why PowerShell?](https://www.gitbook.com/book/devopscollective/why-powershell-/details) eBook.

I often find myself explaining why someone with responsibilities on the Microsoft side of the fence should learn PowerShell.  I decided to write this as a reference going forward.

I won’t be arguing for PowerShell over other Microsoft languages such as VBScript or batch, or general purpose languages such as Python or Perl.  There is a place for all of these languages, but if you work with the Microsoft and surrounding ecosystems, PowerShell is an important language to learn.

### Why Scripting?

Before we dive into PowerShell itself, let’s tackle the importance of scripting and automation, an integral facet of PowerShell.

You’ve probably seen [this XKCD comic](http://xkcd.com/1205/) or something similar to justify scripting.  While saving time is certainly a factor behind the importance of scripting and automation, it is hardly the only justification.  Here are a few others to consider:

* **Consistency**.  A scripted solution will run the exact same script every time.  No risk of typos, forgetting to complete the task, or doing the task incorrectly.
* **Audit trail**.  There are many tasks where having an audit trail would be helpful, perhaps including what task was performed, important results, errors that occurred, when the task ran, who ran it, and so forth.
* **Modular code**.  I might spend more time on a particular function than time savings justify, but I can generally re-use or borrow ideas from the code later.
* **Documentation**.  Is there documentation for the task?  Is it up to date?  A well written and commented script can generally serve as a helpful base level of documentation that might not exist for a manual task.
* **Education**.  Scripting out a task will improve your scripting ability and potentially give you deeper insight into what you are doing than the black box of a GUI.
* **Motivation**.  When I was starting out in support, an engineer asked me to help script out alerting, logging, and resolution of a few basic common issues we ran into.  This gave me the opportunity to learn more and grow.  Scripting is a great way to get folks to learn, assuming they want to.
* **Change of pace**.  Repetition is not fun.  Removing or minimizing it will improve morale.
* **Delegation**.  With a scripted solution, you can typically delegate more functions closer to the teams best equipped to handle them, giving you more time to focus on the important stuff.

The moral of the story is that scripting and automation is important, which is just one factor behind the value of learning PowerShell.

### Why PowerShell?

Microsoft describes PowerShell as “a task-based command-line shell and scripting language… built on the .NET Framework.”  What is so great about PowerShell?  Why should you use it?

#### PowerShell is both a command-line shell and scripting language

* Fight fires quickly using existing or custom PowerShell commands or scripts at the shell, no need to compile code.  Develop your code at the command line before creating a function or script around it.  Write quick and dirty scripts that you will use a single time or a handful of times.  Write formal, readable, production level scripts that will maintain your services for years.
* What is the cost of this investment?  Learning PowerShell.  Pretty reasonable, considering you will likely need to do so regardless of your current language of choice, assuming you work with the Microsoft ecosystem.

#### PowerShell can interact with a dizzying number of technologies.

* .NET Framework, the Registry, COM, WMI, ADSI.  Exchange, Sharepoint, Systems Center, Hyper-V, SQL.  [VMware vCenter](http://www.vmware.com/support/developer/PowerCLI/), Cisco UCS, Citrix XenApp and XenDesktop.  REST APIs, XML, CSV, JSON, websites, [Excel](http://ramblingcookiemonster.github.io/PSExcel-Intro/) and other Office applications.  [C# and other languages](http://www.dougfinke.com/blog/index.php/2010/08/29/how-to-load-net-assemblies-in-a-powershell-session/), DLLs and other binaries, including *nix tools.  A language that can work with and integrate these various technologies can be incredibly valuable.
* Windows is not text based.  Sooner or later you will need to do something that you can’t do with *nix tools and other text based languages.  Many of the technologies that PowerShell can interact with simply do not have text based interfaces, and may not even be directly accessible from more formal languages like Perl or Python.

#### PowerShell is object-based.

* This gives us incredible flexibility.  Filter, sort, measure, group, compare or take other actions on objects as they pass through the pipeline.  Work with properties and methods rather than raw text.
* If you have spent time deciphering and programmatically working with text based output, you know how frustrating it can be.  What delimiter do I split on?  Is there even a delimiter?  What if a particular result has a blank entry for a column?  Do I need to count characters in each column?  Will this count vary depending on the output?  With objects, this is all done for you, and makes it quite simple to tie together commands and data across various technologies.
* Microsoft is putting its full weight behind PowerShell.

#### PowerShell isn’t going away.

* It is a requirement in the [Microsoft Common Engineering Criteria](http://www.microsoft.com/cec/en/us/cec-overview.aspx#man-windows), and a Server product cannot be shipped without a PowerShell interface.
* In many cases Microsoft uses it to build the GUI management consoles for its products.  Some tasks can’t be performed in the GUI and can only be completed in PowerShell.
* Regardless of how far Microsoft shifts to the *aaS side of the spectrum, they support PowerShell for both on-premise and hosted solutions.

#### Consolidate and multiply your learning

* Your reward for learning PowerShell is the impoved ability to control and automate the many technologies it integrates with. I can use the same set of commands to filter, export, redirect, modify, extend, and perform actions against output for all of these technologies. I can pick up my PowerShell skills and take them in any direction I need - Hyper-V, vCenter, SQL, AD, XenApp, and more.
* Your reward for learning specific tools or executables such as net.exe or schtasks.exe, is the ability to work with those specific tools.
* I'm not knocking these, and they are incredibly helpful to know, but coming from the Unix/Linux side of the house, you would need to know a shell language (bash), various tools (awk, sed, grep) a general purpose language (Perl, Python), and perhaps a language like Ruby for configuration management. In the Microsoft world? You can go quite far with PowerShell.

#### PowerShell can help anyone working in the Microsoft ecosystem

* PowerShell is not just for systems administrators.
* Douglas Finke wrote [a great, quick read](http://shop.oreilly.com/product/0636920024491.do) on what developers and others can get out of PowerShell.  His blog [Development in a Blink](http://dougfinke.com/blog/), and Joel Bennett’s Huddled Masses provide helpful development-oriented PowerShell articles.  Given the object-based nature of PowerShell and tight integration with .NET and other technologies, this shouldn’t be surprising.
* The Desktop side isn’t excluded.  Windows 7 and later include PowerShell.  Audit local administrators and other details across your domain.  Support end users without interruption.  Tie together various desktop tools that have a command line interface.  Build [a GUI interface for your Support staff](http://gallery.technet.microsoft.com/Arposh-Windows-System-a1beb102) that can easily be modified by non-developers.
* DBAs on the Microsoft side of the house benefit from PowerShell as well.  Gather an [inventory of your SQL instances](http://learn-powershell.net/2013/09/15/find-all-sql-instances-using-powershell-plus-a-little-more/).  Monitor SQL performance.  Write tools that fit your exact needs rather than spending money on proprietary, not-tailored-to-you solutions.  Chad Miller of the now defunct [Sev17](http://sev17.com/) has written many posts on [PowerShell for SQL](http://cmille19.wordpress.com/2009/04/19/the-value-proposition-of-powershell-to-dbas/).

### Where can I learn more?

There is a wealth of information on PowerShell.  I keep a running list of resources I’ve found helpful in learning and using PowerShell [right here](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html), covering cheat sheets, blogs, videos, books and more.

What resources you find the most helpful will depend on your experience, role, and preferences.

* Anyone with development or scripting experience should pick up [PowerShell in Action v2](http://www.manning.com/payette2/).  It’s written by the co-designer and principle author of PowerShell, Bruce Payette, and is the standard reference.  It provides the best depth you will get short of verbose articles on the web, gives insight into some of the design decisions behind the language, and is perfectly applicable today despite being written for PowerShell v2.  [Windows PowerShell for Developers](http://shop.oreilly.com/product/0636920024491.do) is more narrowly focused but a good read for the experienced.
* Those without scripting or development experience might want to start with lighter reading, such as [Learn Windows PowerShell 3 in a Month of Lunches](http://www.manning.com/jones3/), or [Windows PowerShell Cookbook](http://shop.oreilly.com/product/0636920024132.do).
* Want to learn on the fly?  PowerShell includes [everything you need to learn directly from the shell](https://ramblingcookiemonster.wordpress.com/2013/07/20/learning-and-exploring-powershell/).  Get-Command, Get-Help, Get-Member, and Select-Object will get you exploring and learning PowerShell.
* Stuck with something?  Join one of the numerous communities.  [#PowerShell on Freenode](http://webchat.freenode.net/?channels=PowerShell).  Ask a question with #PowerShell on Twitter.  Post a question to [reddit](http://www.reddit.com/r/PowerShell/), [PowerShell.org](http://powershell.org/wp/forums/), the [TechNet forums](http://social.technet.microsoft.com/Forums/), or [stackoverflow](http://stackoverflow.com/).
* Prefer videos?  Jeffrey Snover and Jason Helmick hosted two free  PowerShell sessions that have proven quite popular.
  * [Getting Started with PowerShell 3.0](http://channel9.msdn.com/Series/GetStartedPowerShell3)
  * [Advanced Tools and Scripting with PowerShell 3.0](http://channel9.msdn.com/Series/advpowershell3)

### A closing example

Let’s illustrate one solution using PowerShell that ties together a number of technologies.

We use Systems Center Operations Manager (SCOM) as part of our monitoring solution.  We use vmware vCenter as our virtualization management solution.  If you have used SCOM, you know how sparse and bland the notifications can be.  Let’s take a look at an example:

![A boring alert](/images/why-powershell/alertText.png)

You get basic information about the alert, and only the alert.  Nothing about the rule/monitor that generated it.  No suggestions on how to fix it.  Nothing to highlight important details, just plain text.  For this particular monitor, you don’t even get details on the disk space that triggered the low disk space alert!  If you try to foist this type of notification upon your teams, there is a good chance they won’t be happy.  You might even end up with a new monitoring solution.

We decided to use PowerShell as follows:

* A PowerShell script regularly collects inventory details on servers from Active Directory and vCenter, [populating a SQL database](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1).
* SCOM is configured to create a file based on the alert, rather than send an e-mail directly.  A customized PowerShell ‘[Script Daemon](http://gallery.technet.microsoft.com/scriptcenter/Invoke-PSDaemon-Multithread-e72fc90e)’ watches the SCOM alert folder, and runs a PowerShell alert processing script for every alert generated.  If more than a specified number of alerts are generated in a short period, they are grouped into a single notification with a synopsis table and attached HTML details.  All alert processing is parallelized using a RunspacePool.
* The PowerShell alert processing script lets us run anything we want based on the alert.  This means we can…
  * Gather context for every alert, including alert details from SCOM, the inventory database (e.g. who is responsible for the server, class of the server), and even the server itself (in this example, current disk space free, and disk space taken by certain folders).
  * Take action based on this information, perhaps adding or removing recipients, attempting to remediate and including results in the e-mail, adding troubleshooting suggestions, querying our change management database to determine whether any expected changes are underway, etc.
  * [Build an HTML notification](http://gallery.technet.microsoft.com/scriptcenter/PowerShell-HTML-Notificatio-e1c5759d) from the resulting objects and send it out via e-mail.

Remember the boring alert with no context?  Here’s what we see now:

[![A more detailed alert](/images/why-powershell/alert1_thumb.png)](/images/why-powershell/alert1.png)

[![A more detailed alert](/images/why-powershell/alert2_thumb.png)](/images/why-powershell/alert2.png)

**Good luck!**  PowerShell can be a great benefit to you, your career, and your employer.