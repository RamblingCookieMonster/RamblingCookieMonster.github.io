---
layout: post
title: REST, PowerShell, and Infoblox
excerpt: "More PowerShell modules, please"
tags: [PowerShell, Automation, Modules, Infoblox, API, REST]
modified: 2015-02-07 18:00:00
date: 2015-02-07 18:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /legacy/softwaredefinedeverything.png
---
{% include _toc.html %}

*Edit: Wrote [a follow-up](http://ramblingcookiemonster.github.io/Querying-the-Infoblox-Web-API/) illustrating a few of these issues through a rudimentary Infoblox PowerShell module.*

A short while back, someone asked if I would be up for writing about calling the Infoblox web API through PowerShell. I don’t have extensive experience with this topic, but this is a great opportunity to discuss REST APIs, and the interfaces vendors expose to their customers.

There won’t be any Infoblox PowerShell in this post, that’s in the pipeline.

## Interfaces – Software Defined Everything!

With the movement towards software defined everything, more and more products are exposing APIs and interfaces we can control, configure, and orchestrate with.

In general, this is a good thing. Having a nice API is an important first step, but more is needed. Folks like [Helge Klein](https://helgeklein.com/blog/2014/11/vendors-need-powershell-sdks/) and others with development experience are well served by an API. But what about those of us working on the systems side? Even if we have a loose grasp on the topic, we lose much of the consistency and intuitiveness Jeffrey Snover [aimed for](http://www.jsnover.com/Docs/MonadManifesto.pdf) with PowerShell.

## Why PowerShell?

I grew up playing with Lego, figuring out how to piece together contraptions that don’t come with instructions. I do something similar at work today – I take the commands and consistent syntax and conventions of PowerShell, and put them together to build solutions that vendors don’t provide, or that we can’t afford. Unfortunately, not all vendors provide PowerShell support, so we need to build it ourselves.

This brings us to APIs, including C, Java, .NET, and of course, RESTful APIs. Most of these are beyond the skillset of a good number of systems administrators or engineers, including myself. Some of these APIs are more approachable than others, but vendors do us a disservice by limiting their interfaces to these.

## Why APIs Aren’t Enough

As an engineer, I often need to integrate a variety of technologies. Many of these have fantastic PowerShell modules, from [VMware’s PowerCLI](https://www.vmware.com/support/developer/PowerCLI/), to Microsoft’s ActiveDirectory module, to Cisco’s UCS PowerTool. I can rely on the consistency and conventions of PowerShell, and spend my time considering the logic and design of a solution, rather than combing through documentation and figuring out the nuances of invoking a specific, obscure, poorly documented method of an API.

What does it mean if your product doesn’t have a PowerShell module, but may need integration with the wider Microsoft ecosystem?

* Admins and engineers across the industry waste time and duplicated effort attempting to use your API or binaries through PowerShell
* Admins and engineers who may not be subject matter experts in your technology end up trying to piece things together, leading to potentially buggy or feature-poor implementations. You as the vendor have the knowledge here, why not help out and ensure a smooth, consistent experience with your product?
* Admins and engineers who may not have a strong background in PowerShell end up trying to piece a module or functions together, leading to potentially buggy and inconsistent implementations
* Even if you have an SME for the technology in question who is fluent in PowerShell, they now get to spend copious amounts of time reading through your API documentation and figuring out how to ‘PowerShell-ize’ it

## API Overload

Infoblox is one of many examples. EMC Isilon and XtremIO. Citrix NetScaler and Provisioning Services. Commvault Simpana. Thycotic Secret Server. BMC ARS. A wide range of products out there provide no PowerShell module, or something nearly unusable.

Microsoft isn’t immune. SQL Server management often relies on the SMO. A variety of Exchange tasks force you to use the Managed API or EWS. Good luck doing anything useful with the Group Policy module, or even finding an interface to AGPM – DSC is great, but you’re kidding yourself if you think Group Policy is going away any time soon.

Some of these APIs are better than others. A REST API generally means I need to dig through documentation and spend a good deal of time learning the ins-and-outs of your API. Despite being a bit dated, at least with a web service I have tools to discover the methods, constructors, and other details that help when wrapping an API in PowerShell. With REST?  Who knows what you’re going to get, good luck reading and experimenting!

## Closing

How do we solve this problem? A few suggestions:

Vendors – if your product is commonly used in the Microsoft ecosystem, provide a PowerShell module. Don’t just wrap some binaries or APIs in a format that makes sense to you. Follow the standard conventions and best practices for PowerShell that have made it the successful tool that it is today. The [Monad Manifesto](http://www.jsnover.com/Docs/MonadManifesto.pdf) should be required reading material for anyone responsible for implementing your PowerShell support.

Microsoft – lead by example. The inclusion of PowerShell in the (server) Common Engineering Criteria was a great start. Take steps to encourage your product groups to provide better and more wide-spread PowerShell solutions. Perhaps consider taking similar steps to encourage and assist other vendors.

Engineers and admins – if you have input on the decision making process, strongly consider whether PowerShell should be a factor in this. It can be incredibly painful ending up with a critical technology that you can’t control programmatically, or with an interface you have no familiarity with or interest in learning. Java or C? Not for me. If you do end up with these technologies, pressure the vendor to include an accessible PowerShell interface. If a vendor doesn’t hear you tell them you want a PowerShell interface, how will they get the prioritization to build one?

Lastly, while this is a big pain point for me, it’s still fantastic to have [a glue language like PowerShell](http://ramblingcookiemonster.github.io/Why-PowerShell/) that can piece together well written PowerShell modules, .NET libraries, REST APIs, and everything else.

*Disclaimer: This assumes you are locked into the Microsoft ecosystem and standardize on PowerShell.*

*Thumb credit to [Jerry King](http://www.tomsitpro.com/articles/sdx-software-defined-kitchen-sink,1-1085.html)*