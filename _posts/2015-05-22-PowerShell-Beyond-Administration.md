---
layout: post
title: Quick Hit&#58; PowerShell, Beyond the Target Audience
excerpt: "Why not?"
tags: [PowerShell, Rambling]
modified: 2015-05-22 22:00:00
date: 2015-05-22 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /Beyond-Sysadmin/question.png
---
{% include _toc.html %}

### Rambling

This evening, I noticed a question about using PowerShell to work with Excel.

![Tweet](/images/Beyond-Sysadmin/tweet.png)

This reminded me: why does Microsoft focus on IT oriented audiences with PowerShell? Let's look at their phrasing:

> helps **IT** professionals and power users control and automate the **administration** of the Windows operating system and applications

> designed especially for system **administration**

It's interesting to note that Jeffrey Snover's [manifesto](http://www.jsnover.com/Docs/MonadManifesto.pdf) that started this all called out other audiences and use cases with more general terms:

> GUI users who want to **automate their operations**

> power users who want to **interact with** the system through command line

On the IT front, Windows PowerShell has come a long way. Microsoft includes it in their [CEC](http://www.microsoft.com/CEC/en/us/cec-overview.aspx), ensuring wide coverage *for their Server services and products*. Third parties like Citrix, VMware, and Cisco embrace it *for IT services and products*. It's [very important](https://www.penflip.com/powershellorg/why-powershell) for IT folks on the Microsoft side of the fence.

But beyond administration? I've seen requests for it, often with the response "but PowerShell is for administration!" This seems odd. Why not target other audiences?

### Fun examples

What if you want to work with Microsoft SQL, rather than administer it? You're relegated to .NET libraries; if you want these abstracted out into task based commands as Jeffrey envisioned, you could work with [SQLPSX](http://sqlpsx.codeplex.com/), last updated in 2011. By the way, someone needs to bring this to GitHub and shock it back to life... it's fantastic, but would benefit from contributions.

How about Microsoft Office? I remember skimming [this April fools article](https://4sysops.com/archives/breaking-news-office-to-support-powershell/) before my coffee, and getting a bit excited. Why is that April fools? Why does Microsoft not support working with Office products through PowerShell?

Saveen Reddy has done some [fantastic stuff with Visio](http://viziblr.com/news/2014/5/7/my-visio-presentation-from-the-powershell-summit-2014.html). He's not even with the Visio team!

Doug Finke wrote [ImportExcel](https://github.com/dfinke/ImportExcel), a sweet module for working with Excel, which [I hastily borrowed](http://ramblingcookiemonster.github.io/PSExcel-Intro/) and extended, before realizing Doug was planning to extend his project (sorry Doug!).

As someone who has spent time outside the IT world, I would have been very happy to have had PowerShell to work with Excel, rather than learning some obtuse, delicate VBA language that I would never use again. On occasion, when a mundane, non-IT task comes up, I can often save hours of time and ensure consistent results by using PowerShell. I wonder how I would survive as a knowledge worker without PowerShell.

IT folks who lack a development backgrounds benefit from PowerShell's task based nature. Rather than figuring out how to define complex algorithms to sort, group, or filter, we can focus on the tasks at hand and use built-in commands for these, regardless of where the data is coming from or going to. It turns out this would be a huge benefit to folks outside of IT as well.

Who knows. You might pique the attention of a more diverse audience and bring some fresh ideas and insight into the world of IT and development.

### Why not?

I'm tapering out, it's almost dinner time. Also, I'm having trouble coming up with valid reasons to constrain PowerShell to IT or the dev world.

Some might point to the myriad [click-next admins](http://ramblingcookiemonster.github.io/Dealing-With-The-Click-Next-Admin/) who weigh our IT departments down and can't be bothered to learn a language; if IT folks don't learn it, why would others? I would argue that even if you had fewer knowledge workers outside of IT open to learning a language, a certain proportion would absolutely pick this up and prosper.

It's not cross platform. True. I'm hoping we see Jeffrey's prediction that PowerShell will go open source come true; paired with an already open source .NET Core, chances are we might see a cross platform PowerShell. Oh. Also, Windows and Office are still pretty prevalent in the enterprise, so I don't see cross platform being a necessity, yet.

It's not a priority. I get this. Microsoft is already a behemoth and is trying to improve their agility. If Minecraft and other ideas that get youth into code end up working out, wouldn't it be nice to have a platform that could be used to interact with your full range of products and services, rather than the small piece of the pie that is IT?

Cheers!