---
layout: post
title: Building a PowerShell Module
excerpt: "closed as off topic"
tags: [PowerShell, Tools, SQL, SQLite, Practical]
modified: 2016-07-24 5:30:00
date: 2015-09-06 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /module/StackLogo.png
---
{% include _toc.html %}

### Rambling

A while back, someone mentioned it might be fun to document the PowerShell-module-writing-process. This has been done before, but I figure it would be fun to post my own process, from initial idea through publication on the official PowerShellGallery.com site.

I recently discussed the [August Scripting Games puzzle](http://powershell.org/wp/2015/08/30/2015-august-scripting-games-wrap-up/) on PowerShell.org, which involved querying a web API. It turns out this is a very common need, and many of the modules we write abstract out these APIs into handy PowerShell functions and modules.

We're going to make the assumption you know what a module is, and that you have some experience writing PowerShell functions. If not, be sure to spend some time [learning PowerShell](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/) before continuing here!

This post will cover my typical formula for writing a module, using the Stack Exchange API as an example. Feel free to [browse the PSStackExchange code](https://github.com/RamblingCookieMonster/PSStackExchange/commit/db1277453374cb16684b35cf93a8f5c97288c41f) on your own.

### Why Modules?

Advanced functions will take you far with PowerShell. If you aren't writing functions today, be sure to start encapsulating your code in these re-usable tools. But... they have their limits. Here are a few reasons you might bundle your advanced functions in a module:

* Simplify code organization
* Group related functions together
* Share state between functions, but not with the user
* Re-use "helper functions" that you don't want exposed to the user
* Improve discoverability: ```Find-Module MyModule``` or ```Get-Command -Module MyModule```
* Simplify distribution: ```Install-Module MyModule```

In our example, we will organize a set of Stack Exchange functions into one module.

### This Seems Complicated!

Doing this from scratch might take you a little time. Thankfully, once you write a module or two, you can quickly get started by copying it and tweaking a few files. Don't be scared off by the length of this post; writing your own modules is well worth spending a few minutes to pick up the basics!

### The Ingredients

There are many ways to create a module, from slapping a .psm1 extension onto a file, to compiling a fully fledged binary module [from C#](http://www.powershellmagazine.com/2014/03/18/writing-a-powershell-module-in-c-part-1-the-basics/). We'll take a common middle ground here, and use the following ingredients:

* **[A Module Manifest](https://msdn.microsoft.com/en-us/library/dd878297)**. This is a .psd1 file that describes your module. [PSStackExchange.psd1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/PSStackExchange.psd1)
* **A Root Module**. In our case, a script module .psm1 file. This is just PowerShell code to run when importing the module. [PSStackExchange.psm1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/PSStackExchange.psm1)
* **Exported (Public) Functions**. These are the advanced functions an end user can run from our module. For example, [Get-SEQuestion.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/Public/Get-SEQuestion.ps1) or [Get-SEObject.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/Public/Get-SEObject.ps1)
* **Private Functions**. These are optional "helper functions" that we want to use in our exported functions, that the end user shouldn't see. For example, [Add-ObjectDetail.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/Private/Add-ObjectDetail.ps1) or [Join-Parts.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/Private/Join-Parts.ps1)
* **Formats**. These are optional format.ps1xml formats to help [decorate your output](http://ramblingcookiemonster.github.io/Decorating-Objects/), often specified in the module manifest 'FormatsToProcess'. [PSStackExchange.Format.ps1xml](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/PSStackExchange.Format.ps1xml)
* **Readme**. If you're [using GitHub](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) or another common code repository, the Readme.md is a handy front page for your project, written using simple [Markdown](https://help.github.com/articles/github-flavored-markdown/) rather than HTML
* **AppVeyor config**. If you're using a supported version control solution, [AppVeyor](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/#continuous-integration) enables simple and free continuous integration and delivery for open source projects. [AppVeyor.yml](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/appveyor.yml)

We have our ingredients, let's look at a recipe for a module!

### The Recipe

We're going to do this in a few quick steps:

* Create a GitHub repository
* Create the module and scaffolding around it
* Hook up AppVeyor and publish the module

This might take a few minutes the first time you run through it, but you can borrow and tweak this same scaffolding for each module you write. In fact, you might find or write helper PowerShell modules and tools that simplify this process.

Let's get to work!

### Following the Recipe

There's no real order to this; depending on what you do or don't incorporate, don't feel like you need to follow this to the letter.

#### Create a GitHub Repository.

This should be pretty straightforward. If you haven't used GitHub before, the following might help:

* [GitHub for PowerShell Projects](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects)
* [PowerShell.org TechSession: A Crash Course in Version Control and Git](https://www.youtube.com/watch?v=wmPfDbsPeZY) and [presentation materials](https://github.com/RamblingCookieMonster/Git-Presentation)

All we need to do is:

* Create an account on GitHub, download GitHub for Windows
* Create a new repository (We'll call it PSStackExchange, and pick the MIT license)
* Clone PSStackExchange using GitHub for Windows

Let's move on to the most important bit, the module itself.

#### Create the Module and Scaffolding Around It

Here's how I typically organize my modules. We'll use PSStackExchange as an example, substitute this out for your own module!

* [PSStackExchange\\](https://github.com/RamblingCookieMonster/PSStackExchange/tree/db1277453374cb16684b35cf93a8f5c97288c41f)
  * en-US\\ (or locales of choice)
    * about_PSStackExchange.help.txt
  * Private\\ 
    * Join-Parts.ps1
    * Get-SEData.ps1
    * ...
  * Public\\ 
    * Get-SEObject.ps1
    * Search-SEQuestion.ps1
    * ...
  * lib\\ (Not used in this module)
    * Some.Library.dll
  * bin\\ (Not used in this module)
    * SomeDependency.exe
  * PSStackExchange.Format.ps1xml
  * PSStackExchange.psd1
  * PSStackExchange.psm1

If we're going to be adding our project to GitHub or a similar code repository, we add a little more scaffolding:

* [Repository Root](https://github.com/RamblingCookieMonster/PSStackExchange/tree/db1277453374cb16684b35cf93a8f5c97288c41f)
  * PSStackExchange\\ (Module folder described above)
  * Tests\\ 
      * PSStackExchange.Tests.ps1
      * Appveyor.Pester.ps1
  * README.md
  * AppVeyor.yml

I ran through the following code to get started. Typically I'll just copy the scaffolding from another module, create a new GUID in the psd1, and tweak other module specific references.

{% gist 12c4eb61dde8b2703184 %}

In our case, we have a few Stack Exchange advanced functions that hopefully follow [a few best practices](http://ramblingcookiemonster.github.io/Building-PowerShell-Functions-Best-Practices/), some private helper functions that we don't want the user to see, and a few other files to cover testing and usability.

In [PSStackExchange.psm1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/PSStackExchange.psm1) we load our public and private functions. If a module is a work-in-progress, I'll usually export $Public.Basename to avoid hard coding functions to export in the psd1. Once a module is released, I try to add the public functions to the psd1.

If you're writing a module, you should consider writing [Pester](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/#pester) tests for it. It's quite comforting to have a suite of tests that run automatically after each change you push, rather than assuming the code you write was correct, or attempting to manually test your code after each change. Give it a shot! We include a few superficial tests in [PSStackExchange.Tests.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/Tests/PSStackExchange.Tests.ps1).

Lastly, we include some usability features. We add an [about_PSStackExchange](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/en-US/about_PSStackExchange.help.txt) help topic, we [decorate our output](http://ramblingcookiemonster.github.io/Decorating-Objects/) with the [PSStackExchange.Format.ps1xml file](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/PSStackExchange/PSStackExchange.Format.ps1xml), and we add some notes on how to install and use the module in the [README.md](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/README.md).

We're good to go! Let's look at how we can publish this module for others to use and improve.

#### Hook up AppVeyor and Publish the Module

The content of our module is ready to publish. Before we publish this, we'll enable continuous integration with some handy automated testing through AppVeyor.

First, we [set up our project in AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/) by adding [appveyor.yml](https://github.com/RamblingCookieMonster/PSStackExchange/blob/master/appveyor.yml) to the repository, and adding the GitHub project to our AppVeyor account. We abstract out the calls to Pester in [AppVeyor.Pester.ps1](https://github.com/RamblingCookieMonster/PSStackExchange/blob/db1277453374cb16684b35cf93a8f5c97288c41f/Tests/appveyor.pester.ps1), using some [ideas from here](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/).

Next, we push the changes we've made on our computer up to GitHub. Our code is now published, and AppVeyor will start [running a build](https://ci.appveyor.com/project/RamblingCookieMonster/psstackexchange/build/1.0.3).

Lastly, we want to publish our module in the [PowerShell Gallery](https://www.powershellgallery.com/), giving end users with PowerShell 5 a simple way to find and install your module. We could hook this up to automatically run in AppVeyor, but that's [a topic for later](http://ramblingcookiemonster.github.io/PSDeploy-Inception/).

* Sign on to PowerShellGallery.com with your Microsoft account
* Get your API key (find it [here](https://www.powershellgallery.com/account))
* Publish your module!

{% gist e7b381e6bf42c411765e %}

Our module [is now live](https://www.powershellgallery.com/packages/PSStackExchange/) on PowerShell Gallery!

### How I Write Modules, Summarized

Whew! That was a long post. Thankfully, most of this stuff can be re-used in each module you write. Let's review the steps:

* Create a GitHub repository
* Create the module and scaffolding around it
* Hook up AppVeyor and publish the module

The first and last step take a minute or two each. The module and scaffolding around it can be copied and tweaked, which should only take a few minutes. Most of your time will be spent writing the advanced functions for the module.

### PSStackExchange

The module is published and ready to use! I'm on another computer with PowerShell 5, I can get up and running with a few lines of code:

{% gist 09f717821ce056a6dfe2 %}

Here's some output from the examples:

![Get-SEObject](/images/module/Get-SEObject.png)

![Search-SEQuestion](/images/module/Search-SEQuestion.png)

### Wrapping Up

That's about it! If you aren't writing modules already, you should definitely consider it. Looking for further reading? Here are a few references that might come in handy:

* [Module Design Rules](https://github.com/RamblingCookieMonster/RamblingCookieMonster.github.io/blob/master/images/module/PSSummit2014-Freiheit-ModuleDesignRules.pptx?raw=true) - This is from the 2014 PowerShell Summit, thanks to Kirk Freiheit
* [Further Down the Rabbit Hole: PowerShell Modules and Encapsulation](https://www.simple-talk.com/dotnet/.net-tools/further-down-the-rabbit-hole-powershell-modules-and-encapsulation/)
* [How to Write a Module Manifest](https://msdn.microsoft.com/en-us/library/dd878297)
* [Windows PowerShell Modules](https://msdn.microsoft.com/en-us/library/dd878324(v=vs.85).aspx)
* [about_Modules](https://technet.microsoft.com/en-us/library/hh847804.aspx)
* [Building PowerShell Functions - Best Practices](https://ramblingcookiemonster.wordpress.com/2013/12/08/building-powershell-functions-best-practices/) - Shameless plug. Includes a number of references.
* [Learn PowerShell Toolmaking in a Month of Lunches](https://www.manning.com/books/learn-powershell-toolmaking-in-a-month-of-lunches)
* [Free eBook on PowerShell Advanced Functions](http://mikefrobbins.com/2015/04/17/free-ebook-on-powershell-advanced-functions/)
* [The PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle)
* [Monad Manifesto](http://www.jsnover.com/Docs/MonadManifesto.pdf) - This gives a nice overview of the vision and goals set out for PowerShell. If you're writing modules for public consumption, consider reading this, to avoid publishing something as awful as Citrix' PVS "PowerShell" snapin.

#### Side Note for Vendors

Writing PSStackExchange [reminded me](http://ramblingcookiemonster.github.io/REST-PowerShell-and-Infoblox/) how important it is for vendors of enterprise products to provide PowerShell modules that wrap their product's API. Despite a nice API and decent documentation, writing a feature-poor PowerShell module for this was just as painful as [wrapping the Infoblox API](http://ramblingcookiemonster.github.io/Querying-the-Infoblox-Web-API/).

Vendors: If your competition provides a PowerShell module and you do not, there's a good chance I'll push for your competitor's product. This is a major value-add if you do it right and follow PowerShell conventions.

Cheers!



*EDIT July 2016*: Updated links to PSStackExchange to [link to a specific point in time](https://twitter.com/psCookieMonster/status/757372331362779136).  The current version of this project may see updates to illustrate things like PSDeploy.