---
layout: page
title: Building a PowerShell Module
excerpt: "closed as off topic"
tags: [PowerShell, Tools, SQL, SQLite, Practical]
modified: 2015-04-04 22:00:00
date: 2015-04-04 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /module/StackLogo.png
---
{% include _toc.html %}

### Rambling

A while back, someone mentioned it might be fun to document the PowerShell-module-writing-process. This has been done before, but I figure it would be fun to post my own process, from initial idea through publication on the official PowerShellGallery.com site.

I recently discussed the [August Scripting Games puzzle](TBD) on PowerShell.org, which involved querying a web API to produce expected output. It turns out this is a very common need, and many of the modules we end up writing abstract these web APIs into handy PowerShell modules.

We're going to make the assumption you know what a module is. If not, be sure to [spend some time learning PowerShell](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/) before continuing here!

This post will use the StackExchange API as an example, allowing you to follow along at home.

### Why Modules?

Advanced functions will take you far with PowerShell. If you aren't writing these today, be sure to start encapsulating your code in these re-usable tools. But... they have their limits. Here are a few reasons you might use a module, among others:

* Simplify code organization
* Group related functions together
* Share state between functions, but not with the user
* Re-use "helper functions" that you don't want exposed the user
* Improve discoverability
* Simplify distribution

In our example, we can organize a set of functions for hitting the StackExchange API into one module. Let's start by looking at the ingredients:

### The Ingredients

There are many ways to create a module, from slapping the .psm1 extension onto a file, to a fully fledged binary module [written in C#](http://www.powershellmagazine.com/2014/03/18/writing-a-powershell-module-in-c-part-1-the-basics/). We'll take a common middle ground here, and use the following ingredients:

* **[A Module Manifest](https://msdn.microsoft.com/en-us/library/dd878297)**. This is a .psd1 file that describes your module. PSStackExchange.psd1
* **A Root Module**. In our case, a script module .psm1 file. This is just PowerShell code to run when importing the module. PSStackExchange.psm1
* **Exported Functions**. These are the Advanced Functions the end user can run from our module. For example, Get-SEAnswer.ps1 or Get-SEUser.ps1
* **Private Functions**. These are optional "helper functions" that we want to use in our exported function, that the end user shouldn't see. For example, Add-ObjectDetail.ps1 or Join-Parts.ps1
* **Libraries**. These are optional .NET or other libraries used by your module. Often stored in a Module\lib\ folder and specified in the module manifest 'RequiredAssemblies'
* **Exported Variables**. These are optional variables to export. It's generally frowned upon to expose variables in the global scope, but exceptions exist where this is helpful.
* **Formats**. These are optional format.ps1xml formats to help [decorate your output](http://ramblingcookiemonster.github.io/Decorating-Objects/), often specified in the module manifest 'FormatsToProcess'. PSStackExchange.Format.ps1xml
* **Readme.md**. If you're [using GitHub](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) or another common code repository, the Readme.md is a handy front-page for your project
* **AppVeyor.yml**. If you're using a code repository, [AppVeyor](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/#continuous-integration) provides free continuous integration and delivery for open source projects.

We have our ingredients, let's come up with a recipe for a module!

### The Recipe

Here's how I commonly organize my modules. We'll use PSStackExchange as an example, substitute this out for your own module name!

* Valid Module Path
  * PSStackExchange\
    * Private\
      * Private-Function1.ps1
      * Private-Function2.ps1
    * lib\ (Not used in this module)
      * Some.Library.dll
    * bin\ (Not used in this module)
      * SomeDependency.exe
    * Exported-Function1.ps1
    * Exported-Function2.ps1
    * PSStackExchange.ps1xml
    * PSStackExchange.psd1
    * PSStackExchange.psm1

If we're going to be adding our project to GitHub or a similar code repository, we might have a little more scaffolding:

* Repository Root
  * PSStackExchange\ ...
  * Tests\
    * Integration
      * PSStackExchange.Integration.Tests.ps1
    * Unit
      * PSStackExchange.Unit.Tests.ps1
  * README.md
  * AppVeyor.yml

We're going to do this in a few quick steps:

* Create a GitHub repository
* Create the module and scaffolding around it
* Hook up AppVeyor and publish the module

This might take a few minutes the first time you run through it, but you can borrow and tweak this same scaffolding for each module you write.

Let's get to work!

### Following the Recipe

There's no real order to this, depending on what you do or don't incorporate, don't feel like you need to follow this to the letter.

#### Create a GitHub repository.

This should be pretty straightforward. If you haven't used GitHub before, the following might help:

* [GitHub for PowerShell Projects](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/#continuous-integration)
* [PowerShell.org TechSession: A Crash Course in Version Control and Git](https://www.youtube.com/watch?v=wmPfDbsPeZY) and [presentation materials](https://github.com/RamblingCookieMonster/Git-Presentation)

All we need to do is:

* Create an account on GitHub, download GitHub for Windows
* Create a New Repository (We'll call it PSStackExchange, and pick the MIT license)
* Clone PSStackExchange using GitHub for Windows

Let's move on to creating the important bit, the module itself.

#### Create the Module and scaffolding around it

I ran through the following code to get started. Typically I'll just copy the scaffolding from another module, create a new GUID in the psd1, and tweak other module specific references.

TODO: Insert gist

In our case, we have a few StackExchange focused advanced functions that hopefully follow [a few best practices](http://ramblingcookiemonster.github.io/Building-PowerShell-Functions-Best-Practices/), and some private helper functions that we don't want to export; Add-ObjectDetail, and Join-Parts.

In the PSStackExchange.psm1 we just load up public and private functions. If a module is a work-in-progress, I'll usually export $Public.Basename to avoid hard coding functions to export in the psd1.





Mention scripting games
Function best practices, e.g. unapproved verbs

organizing code, making it more re-usable, easier to publish

Where do modules go
Benefits - publish, internal modules, etc.

about_Modules
How to write a module manifest https://msdn.microsoft.com/en-us/library/dd878297 - handy for discoverability with Get-Module and Get-Command

MSDN Windows PowerShell Modules: https://msdn.microsoft.com/en-us/library/dd878324(v=vs.85).aspx

Michael Sorens - https://www.simple-talk.com/dotnet/.net-tools/further-down-the-rabbit-hole-powershell-modules-and-encapsulation/

about_Help! en-us
