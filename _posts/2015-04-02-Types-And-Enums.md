---
layout: post
title: Find and Explore &#46;NET Types and Enums in PowerShell
excerpt: "Without the fun [] :: () syntax."
tags: [PowerShell, Tools, DotNet, Quick hit]
modified: 2015-04-02 22:00:00
date: 2015-04-02 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /types-enums/hat.png
---
{% include _toc.html %}

There's a PSBlogWeek going on, with some great posts and fun topics to get your thoughts churning! Adam Bertram wrote [a nice article](http://www.adamtheautomator.com/psbloggingweek-dynamic-parameters-and-parameter-validation/) on dynamic parameters - these [are certainly fun](http://stackoverflow.com/a/23001637/3067642), but I've run into issues with dynamic parameters in the past, and generally try to avoid them unless absolutely necessary.

This morning, PowerShell.com posted a great tip: [Clever Parameter Validation](http://powershell.com/cs/blogs/tips/archive/2015/04/02/clever-parameter-validation.aspx). Long story short, you can use ValidateSet or Enums to improve user experience. But how do you find enums? And how do you know what they enumerate?

### Finding Enums

The first thing we need to do is find those Enums! Check out [Get-Type](https://gallery.technet.microsoft.com/scriptcenter/Get-Type-Get-exported-fee19cf7) on the Technet Gallery for a simple function to help find these.

Behind the scenes, we use .NET reflection. We call ```[AppDomain]::CurrentDomain.GetAssemblies()```, run ```GetExportedTypes()``` on the resulting objects, and filter the results based on parameters the user provides. These words and the syntax we use confuse me, so I use Get-Type.

Download the ps1, load it up, and we can start to discover all the available types in your session:

```powershell
#Add Get-Type to your session:
    . "\\Path\To\Get-Type.ps1"

#Get help for Get-Type
    Get-Help Get-Type -Full

#List all enums in your session
    Get-Type -IsEnum
```

![IsEnum output](/images/types-enums/isenum.png)

Nice! Maybe I'm working with [EPPlus and Excel through PowerShell](http://ramblingcookiemonster.github.io/PSExcel-Intro/) and want to see what enums the EPPlus library offers:

```powershell
Get-Type -IsEnum -Module EPPlus.dll
```

![IsEnum module output](/images/types-enums/isenumepplus.png)

Very cool! I get a list of all enums in the EPPlus library. Maybe I want to offer a parameter that lists chart types, without manually speciying a ValidateSet that may need changing down the line:

```powershell
Get-Type -IsEnum -Module EPPlus.dll -FullName *chart*
```

![IsEnum fullname output](/images/types-enums/isenumeppluschart.png)

eChartType sounds interesting, but how do I know if this is what I want? What options will it give me?

### Exploring Enums

Looking at the values behind an enum is fairly straightforward, we can use the GetValues method of System.Enum. Let's look at the enum values for DayOfWeek:

```powershell
[enum]::GetValues( 'System.DayOfWeek' )
```

![Enum GetValues](/images/types-enums/getvalues.png)

.NET is quite powerful and a fantastic tool to have in your toolbelt. Unfortunately, I'm forgetful at times, and prefer the friendly verb-noun names of PowerShell functions, along with the abstraction they give us. Here's a quick function to pull out those enum values, without all the .NET syntax, and which can take pipeline input:

{% gist 3e01f840e4160136523d %}

Dot source or paste this function into your session, and let's see if we can pull out some enum values for chart types:

```powershell
Get-Type -IsEnum -Module EPPlus.dll -FullName *eChartType | Get-EnumValues
```

![eChartType values](/images/types-enums/excharttype.png)

Awesome! I can use this as a parameter in [PSExcel's Add-PivotTable and Export-XLSX](http://ramblingcookiemonster.github.io/PSExcel-Intro/#create-pivot-tables-and-charts), thanks to the [idea and code from Doug Finke](https://github.com/dfinke/ImportExcel).

![Add-PivotTable -ChartType](/images/types-enums/charttype.gif)

This was just one example, there are plenty of enums out there that you can take advantage of:

![Add-PivotTable -ChartType](/images/types-enums/enumcount.png)

### Explore!

That's about it, this should give you enough tools to go out and explore the types and enums you have available to you! You might even consider [creating your own](http://www.powershellmagazine.com/2012/10/01/pstip-creating-flagged-enumerations-in-powershell/) - this will [get easier in PowerShell 5](http://www.sapien.com/blog/2015/01/05/enumerators-in-windows-powershell-5-0/), but I prefer down-level compatibility.

I walked through a few helpful toys. If you want to get into some power tools, and .NET doesn't scare you, check out tools like [ILSpy](http://ilspy.net/) and Oisin Grehan's [Poke](https://github.com/oising/poke). If you aren't working with .NET through PowerShell yet, don't let these scare you off; most of us (inculding myself) don't need to dive into the weeds as deeply as these allow.

As scary as .NET is, at some point you will likely run into something you simply can't do without it. Thankfully, the Internet is riddled with examples and helpful tidbits on how to do this - good luck!