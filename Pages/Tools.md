---
layout: page
title: Tools of the Trade
tags: [Tools, PowerShell, Microsoft]
modified: 2015-03-21
comments: true
image:
  feature: banner.jpg
---
{% include _toc.html %}
In many IT focused community websites, the topic of tools comes up quite often.  Rather than replying with a new or modified list each time, I’m keeping an updated list here.

### Disclaimers:

* I’m a ‘Systems Engineer’ in a Microsoft and VMware environment – this list will focus mostly on tools found in these environments.
* This page was inspired by Scott Hanselman’s list of tools, and will include a good deal of overlap.  His list is a bit more comprehensive and the comments include other suggestions; take a look!
* This isn’t a comprehensive list.  This is a list of tools I regularly use and find invaluable.

### IT tools:

* [PowerShell](http://ramblingcookiemonster.github.io/Why-PowerShell/) - Version 3.0 or later, using the ISE.  From my perspective, anyone working in IT supporting a Microsoft environment should already know or start learning PowerShell for their own and their employer's benefit.
* [Pester](https://github.com/pester/Pester) - Testing framework for PowerShell. It’s quite comforting knowing that I have a set of tests and don’t need to worry about whether I remembered to test each scenario manually. It also enables [fun with GitHub and AppVeyor](https://ramblingcookiemonster.wordpress.com/2015/02/25/fun-with-github-pester-and-appveyor/).
* [SysInternals](http://technet.microsoft.com/en-us/sysinternals) – Be sure to check out the entire SysInternals suite, and consider keeping it up to date with a quick script pulling from [here](http://live.sysinternals.com/).  [Process Monitor](http://technet.microsoft.com/en-us/sysinternals/bb896645.aspx) (procmon) and [Process Explorer](http://technet.microsoft.com/en-us/sysinternals/bb896653.aspx) (procexp) get the most use, followed by [PsExec](http://technet.microsoft.com/en-us/sysinternals/bb897553.aspx) and [AutoRuns](http://technet.microsoft.com/en-us/sysinternals/bb963902.aspx).
* [WMI Explorer](https://wmie.codeplex.com/) - Simplified discovery and exploration of WMI
* [Terminals](http://terminals.codeplex.com/) – A great open source RDP (and other) manager.  There are other options, none have persuaded me to leave Terminals.
* [Performance Monitor](http://technet.microsoft.com/en-us/library/cc749249.aspx) (perfmon) – Sooner or later you will need to use it.  Even if you implement Operations Manager or another monitoring system that watches performance counters, you will likely need to dive into counters not covered by those systems.
* [Resource Monitor](http://blogs.technet.com/b/askperf/archive/2012/02/01/using-resource-monitor-to-troubleshoot-windows-performance-issues-part-1.aspx) (resmon) – More robust than task manager, not quite as daunting as Process Explorer.
* [WinDirStat](http://windirstat.info/) – colorful breakdown showing you what is taking up space.  As of May 2013, the last update was November 2011.
* [SpaceSniffer](http://www.uderzo.it/main_products/space_sniffer/index.html) – Less colorful breakdown showing you what is taking up space.  Keeps up as you make changes.
* [Log Parser](http://www.microsoft.com/en-us/download/details.aspx?id=24659) and [Log Parser Studio](http://blogs.technet.com/b/exchange/archive/2013/06/17/log-parser-studio-2-2-is-now-available.aspx) – Query data from various logs
* [EventCombMT](http://www.microsoft.com/en-us/download/details.aspx?id=18465) – I usually stick to PowerShell, but this can come in handy every so often when delving into Event Logs.
* [Microsoft Management Console](http://technet.microsoft.com/en-us/library/cc709659.aspx) (mmc) / Remote Server Administration Tools (RSAT) – I load mine up with Active Directory Sites and Services, Active Directory Domains and Trusts, Active Directory Users and Computers, ADSI Edit, Certificates, DFS Management, DNS, Group Policy Management, Hyper-V Manager, IIS. Also, Computer Management, Event Viewer, Share and Storage Management, Shared Folders, and Task Scheduler. There is some overlap, which can be helpful in multitasking.
* [Client Hyper-V](http://technet.microsoft.com/en-us/library/hh857623.aspx) – We’re a VMware shop, but for quick tests and other use on the desktop, having a built in hypervisor with PowerShell support is invaluable.
* [PowerCLI](http://communities.vmware.com/community/vmtn/server/vsphere/automationtools/powercli?view=discussions) – Hyper-V isn’t the only hypervisor with great PowerShell support.
* [Operations Manager](http://technet.microsoft.com/en-us/library/hh205987.aspx) – If you are licensed for System Center and have a Microsoft ecosystem, OpsMgr is a great way to monitor this.  Also look into the rest of the bundle (ConfigMgr, Orchestrator, etc.)
* [RegScanner](http://www.nirsoft.net/utils/regscanner.html) – Ever get tired of rapidly pressing f3 in regedit?  This tool quickly scans the registry and simply shows you a list of all matches.  Various options for filtering included!
* [WireShark](http://www.wireshark.org/) (formerly Ethereal) – Packet capture and analysis
* [Message Analyzer](http://www.microsoft.com/en-us/download/details.aspx?id=40308) - Similar to WireShark, geared to the Microsoft world.  Handy for analyzing captures from the built in [netsh](http://blogs.msdn.com/b/canberrapfe/archive/2012/03/31/capture-a-network-trace-without-installing-anything-works-for-shutdown-and-restart-too.aspx) tool
* [Fiddler](http://www.telerik.com/fiddler) - Peak into your HTTP and HTTPS traffic.  Is the header for your REST API call correct?
* [Chart Controls](http://archive.msdn.microsoft.com/mschart) – Build charts with .NET.  You can [integrate](http://bytecookie.wordpress.com/2012/04/13/tutorial-powershell-and-microsoft-chart-controls-or-how-to-spice-up-your-reports/) this with your PowerShell functions or scripts.  If you are a non-profit or could justify the cost, [Highcharts](http://www.highcharts.com/demo/) are a little prettier and more interactive, but slightly less PowerShell friendly.
* [Notepad2](http://www.flos-freeware.ch/notepad2.html) – I’ve completely replaced notepad with this.  All text files are associated with it, and the alias ‘n’ opens it from PowerShell.  Scott’s blog has some other options, this was a good balance between functionality and light weight.  Some co-workers swear by [Notepad++](http://notepad-plus-plus.org/).  I now use [Sublime Text](http://www.sublimetext.com/) 3 when a quick and dirty notepad2 session is not enough.
* SQL. A basic grasp of SQL means you can deliver solutions and tooling with a more robust back end, or query existing solutions on demand.  [SQLite](http://ramblingcookiemonster.github.io/SQLite-and-PowerShell/) and [MSSQL](https://ramblingcookiemonster.wordpress.com/2014/03/12/sql-for-powershell-for-sql-newbies/) on the Microsoft side of the house.
* [The Practice of System and Network Administration](http://www.amazon.com/Practice-System-Network-Administration-Second/dp/0321492668) – If there were one book everyone working in or with IT should read, this would be it.  It’s ancient in this line of work (2007), but still holds true.  [A follow-up](http://the-cloud-book.com/book.html) is now available.

### General tools

* [Mouse without Borders](http://www.microsoft.com/en-us/download/details.aspx?id=35460) – Control up to four Windows computers with one mouse and keyboard, including copying and pasting text.  This changed the way I work.  It’s also quite handy for controlling a presentation PC from the back of a room, or an HTPC from the couch.  The license used to be a bit ambiguous – [not any more](https://officelabs.blob.core.windows.net/public/MouseWithoutBordersLicense.htm), you are free to use this at work!
* [OneNote](http://office.microsoft.com/en-us/onenote/) – Great for managing notes and other content collaboratively or for myself.
* [7 Zip](http://www.7-zip.org/) – integrates with Windows, wide compatibility, free, command line you can integrate into your PowerShell functions or scripts.
* [SkyDrive](https://skydrive.live.com/) – There are many cloud storage options, find one that works for you.
* [SSD](http://arstechnica.com/civis/viewtopic.php?f=11&t=39354) – not a tool per se, but opens up many options.  Lighter, less power use, no issues being bumped, fast seek time (no heads to move across a spindle), more IOPS than most RAID setups.  If you plan on running a hypervisor, this is essential.  All of my work and home computers have an SSD.  Well worth cost.
* [GifCam](http://blog.bahraniapps.com/gifcam/) - Portable, flexible, easy to use gif recorder.
* [GitHub](https://github.com/) - Version control is invaluable even outside of IT.  I prefer [Mercurial](http://hginit.com/) and Git.  [BitBucket](https://bitbucket.org/) is another solid host.

### Other helpful lists

* [Scott Hanselman's Ultimate Developer and Power Users Tool List for Windows](http://www.hanselman.com/tools)
* [SecTools.org](http://sectools.org/)

That’s it for now.  Do you have any favorite tools?  Feel free to comment!