---
layout: post
title: Building PowerShell Functions&#58; Best Practices
excerpt: "That we sometimes break"
tags: [PowerShell, Best Practices, Tools]
modified: 2015-03-25 00:00:00
date: 2013-12-08 00:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /building-functions-best-practices/check.png
---
{% include _toc.html %}

I spend a good deal of time wrapping common tasks into PowerShell functions. Here are a few best practices I've picked up along the way.  My apologies if I miss any attributions!

### Suggested Best Practices

#### Write your function with one purpose

* Write your function with one purpose.  Don’t build in everything but the kitchen sink.
  * This is one of PowerShell’s strengths – there are existing functions to work with input or output objects, or you can write your own set of functions to work together.

#### Follow naming conventions

* Follow naming conventions.
  * Use the Verb-Noun format, use an approved verb, and ensure that your Noun is unique and will not collide with another author’s function now or in in the future.
    * [Approved Verbs](http://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx)
    * Example:  I’m writing commands to work with a Hyper-V lab.  Set-Lab and Get-Lab are generic and may be used by another author.  I can add a prefix like HV to avoid this – Set-HVLAB and Get-HVLab
  * Use common parameter names and types as appropriate.
    * Example:  Use ComputerName to specify systems.  Do not use ComputerNames, Computer, PC, or any other non-standard parameter name.  If desired, provide an alias for the parameter.

#### Use the built in comment-based help system

* Use the built in comment-based help system.  At a minimum, provide a helpful synopsis, description, parameter (for all), and example
  * [About_Comment_Based_Help](http://technet.microsoft.com/en-us/library/dd819489.aspx)
  * [Comment your way to help](http://technet.microsoft.com/en-us/magazine/hh500719.aspx)

#### Let PowerShell do the work for you

* Let PowerShell do the work for you.  Always use [cmdletbinding()], which allows you to take advantage of the following:
  * Common parameters such as -Verbose and -ErrorAction
  * SupportsShouldProcess to allow -Confirm and -Whatif parameters
  * Set advanced [Parameter()] attributes such as Mandatory and ValueFromPipeline
  * Use Parameter Sets
  * [About_Functions_Advanced](http://technet.microsoft.com/en-us/library/hh847806.aspx)
  * [About_Common_Parameters](http://technet.microsoft.com/en-us/library/hh847884.aspx)
  * [About_Functions_Advanced_Parameters](http://technet.microsoft.com/en-us/library/hh847743.aspx)
  * [About_Functions_CmdletBindingAttribute](http://technet.microsoft.com/en-us/library/hh847872.aspx)

#### Use advanced parameters

* Use advanced parameters for validation, accepting pipeline input, specifying mandatory parameters, and other functionality, where possible and appropriate.
  * [About_Functions_Advanced_Parameters](http://technet.microsoft.com/en-us/library/hh847743.aspx)
  * [Tips on Implementing Pipeline Support](http://learn-powershell.net/2013/05/07/tips-on-implementing-pipeline-support/)

#### Provide flexibility with your parameters

* Provide flexibility with your parameters.  Provide default values, allow arrays instead of single objects, allow wildcards, and provide other helpful parameter features.
  * Example:  `[string[]]$ComputerName = $env:computername` is more helpful than `[string]$ComputerName`

#### Document your code for yourself, readers, and users

* Document your code for yourself, readers, and users.
  * Use write-verbose, write-debug and write-error to provide insight at the shell
  * Comment your code in everyday language for readers.  If you used a specific command or logic for a reason, explain why it was necessary and why changing it could break things.
  * Use full command names and full named parameters.  This makes the code more readable.  It also prevents issues that could arise if you rely on aliases or positional parameters.

#### Avoid dependencies

* Avoid dependencies.  This includes external scripts and modules, binaries, or features exclusive to PowerShell or .NET Framework versions.  If you must include dependencies, be sure to indicate this and provide appropriate error handling.
  * Example:  Get-ADGroupMember requires the ActiveDirectory module.  Instead of relying on this, [include or write your own function](http://gallery.technet.microsoft.com/scriptcenter/Get-ADGroupMembers-Get-AD-0ee3ae48).
  * Example:  To create a new object, use `New-Object -TypeName PSObject -Property @{A=1; B="Two" } | Select-Object A, B` instead of `[PSCustomObject]@{A=1; B=”Two”}` to provide compatibility with PowerShell 2.

#### Provide error handling with helpful messages

* Provide error handling with helpful messages
  * [An Introduction to Error Handling in PowerShell](http://blogs.msdn.com/b/kebab/archive/2013/06/09/an-introduction-to-error-handling-in-powershell.aspx)
  * [About_Try_Catch_Finally](http://technet.microsoft.com/en-us/library/hh847793.aspx)
  * [About_Continue](http://technet.microsoft.com/en-us/library/hh847821.aspx)
  * [About_Break](http://technet.microsoft.com/en-us/library/hh847873.aspx)

#### Do not break the user’s environment

* Do not break the user’s environment.  Don’t touch the global scope.
  * [About_Scopes](http://technet.microsoft.com/en-us/library/hh847849.aspx)

#### Test, Test, Test!

* Test, Test, Test!  Test any reasonable scenario your function might run under.
  * Test with and without a profile.  Test with 64 and 32 bit PowerShell hosts.  Test with the ISE and Console Host.  Test with a single-threaded apartment and multi-threaded apartment.  Test with and without the administrative token, with and without actual administrative authority.

#### If your function provides output, use objects

* If your function provides output, use objects.
  * Do not output strings.  Do not use Write-Host.  Do not format the results.  You and your users will get the most out of PowerShell when you provide output in objects, that can be passed down the pipeline to other commands.
  * [Creating Custom Objects](http://social.technet.microsoft.com/wiki/contents/articles/7804.powershell-creating-custom-objects.aspx)

### Why bother?

* Following these best practices will help you and the greater PowerShell community if you chose to share your code.
* Your function will fit into the PowerShell world, enabling integration with the many technologies PowerShell can work with.
* Your function will be usable by wider audiences, who may even provide suggestions and tweaks to help improve it.
* Your function will be flexible and gracefully handle various scenarios you throw at it.
* Your function will last.  If you avoided or accounted for dependencies, your function should withstand changes to PowerShell, the .NET Framework, and the user’s environment.
* These practices apply to scripts as well.  You can use the majority of these best practices when writing scripts, rather than functions.

### Illustrating the best practices

We will look at [Get-InstalledSoftware](http://gallery.technet.microsoft.com/scriptcenter/Get-InstalledSoftware-Get-5607a465), a quick function that extracts installed software details from the registry.

#### Write your function with one purpose

This function does one thing: get installed software.

**Follow naming conventions**

Get-InstalledSoftware follows the Verb-Noun naming format, uses an approved verb, and uses typical parameter names such as ComputerName… but the function name is not unique.  In fact, there is another script out there with the same name.  Perhaps I should have chosen a better example!

**Use the built in comment-based help system**

The help system provides a synopsis, a description that points out prerequisites, describes each parameter, provides two examples, and provides a link that will take the user to the Technet Gallery page if they use Get-Help Get-InstalledSoftware –Online

**Let PowerShell do the work for you**

The function uses [cmdletbinding()] and many of the features it enables.

**Use advanced parameters**

This function uses advanced parameters for computername.  This allows input from the pipeline (e.g. an array of strings), input from the pipeline by property name (e.g. an array of objects with a computername property), and validates that the argument is not null or empty.

**Provide flexibility with your parameters**

ComputerName is given a default value of the local machine and allows an array of strings rather than a single string.  The Publisher and DisplayName parameters are used with the –Match operator and can thus take in regular expressions.

**Document your code for yourself, readers, and users**

The code uses Write-Verbose and Write-Error.  Comments explain what is happening.  The ‘help’ information describes prerequisites, and if connectivity fails, verbose output suggests where to start troubleshooting.  Aliases are not used in the function.

**Avoid dependencies**

This code does depend on certain factors – privileges, connectivity, and the Remote Registry service.  This is detailed in the help information and in the verbose output.  Language, including the output objects we create, is compatible with PowerShell v2.

**Provide error handling with helpful messages**

Try/Catch blocks are used to capture errors where they would likely occur, and are used in a way that will allow continued processing if errors occur.  For example, if multiple computers are specified and one fails, we move to the next computer (continue), rather than breaking execution of the command.

**Do not break the user’s environment**

The global scope is not altered by this function

**Test, Test, Test!**

This script was tested in a limited number of expected scenarios.  With and without a profile.  In the ISE and console host.  With and without the administrative token.

One scenario that illustrates the importance of testing is this command’s behavior in a 32 bit session on a 64 bit machine.  In this scenario, the script will miss 64 bit items, and will pull double copies of everything else (the native and Wow6432Node keys will point to the same location).  I added this to the description.  Ideally I should test for and handle this, but doing so would add undue overhead to a lightweight function for what I consider a niche scenario.

**If your function provides output, use objects.**

This function provides object based output.  Not text.  Not a CSV.  You can use the output with any number of built in or custom commands.

### Get-InstalledSoftware in action

* The end user can use the built in Get-Help command for help.  The online switch takes you right to the TechNet gallery site.

    [![Help](/images/building-functions-best-practices/help_thumb.png)](/images/building-functions-best-practices/help.png)

    [![Help Online](/images/building-functions-best-practices/help-online_thumb.png)](/images/building-functions-best-practices/help-online.png)

* We can pass in multiple computers and filter Publisher and DisplayName using regular expressions

    [![flexible parameters](/images/building-functions-best-practices/flexible-parameters_thumb.png)](/images/building-functions-best-practices/flexible-parameters.png)

    [![flexible parameters 2](/images/building-functions-best-practices/flexible-parameters2_thumb.png)](/images/building-functions-best-practices/flexible-parameters2.png)

### Helpful resources

The following resources will provide further help and suggestions for best practices when writing PowerShell.

* [PowerShell Best Practices: Advanced Functions](http://blogs.technet.com/b/heyscriptingguy/archive/2014/05/30/powershell-best-practices-advanced-functions.aspx) - Ed Wilson
* [PowerShell Best Practices: Simple Functions](http://blogs.technet.com/b/heyscriptingguy/archive/2014/05/29/powershell-best-practices-simple-functions.aspx) - Ed Wilson
* [Grown-Up PowerShell Functions](https://www.simple-talk.com/sql/sql-tools/the-posh-dba-grown-up-powershell-functions/) – Laerte Junior
* Advanced Functions [Part 1](http://msmvps.com/blogs/richardsiddaway/archive/2010/04/05/advanced-functions-part-1.aspx), [Part 2](http://msmvps.com/blogs/richardsiddaway/archive/2010/04/06/advanced-functions-part-2.aspx), [Part 3](http://msmvps.com/blogs/richardsiddaway/archive/2010/04/14/advanced-functions-part-3.aspx), [Update](http://msmvps.com/blogs/richardsiddaway/archive/2011/06/05/advanced-function-update.aspx), [Template](http://msmvps.com/blogs/richardsiddaway/archive/2011/05/24/advanced-function-template.aspx) – Richard Siddaway
* [Writing Cmdlets in Script](http://technet.microsoft.com/en-us/magazine/ff677563.aspx) – Don Jones
* [The Advanced Function Lifecycle](http://technet.microsoft.com/en-us/magazine/hh413265.aspx) – Don Jones
* [My 12 PowerShell Best Practices](http://windowsitpro.com/blog/my-12-powershell-best-practices) – Don Jones
* [PowerShell Script Module Best Practices](http://www.digitaltapestry.net/blog/powershell-script-module-best-practices) - William Kempf
* My 10 best practices leading to the Scripting Games 2012 – [Part 1](http://www.powershellmagazine.com/2012/03/20/my-10-best-practices-leading-to-the-scripting-games-2012-%E2%80%93-part-i/), [Part 2](http://www.powershellmagazine.com/2012/03/22/my-10-best-practices-leading-to-the-scripting-games-2012-%E2%80%93-part-ii/) – Ifiok Moses
* [The Unofficial PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle)
* [Other PowerShell resources I’ve found helpful](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html) – Cheat sheets, books, blogs, videos, etc.

Good luck!  If you do end up writing advanced functions, please consider posting them to websites like [PoshCode](http://poshcode.org/), [TechNet Script Gallery](http://gallery.technet.microsoft.com/scriptcenter/), or [GitHub](https://github.com/search?q=powershell&ref=cmdform)!