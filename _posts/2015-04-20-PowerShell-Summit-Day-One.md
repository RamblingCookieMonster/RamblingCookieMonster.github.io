---
layout: post
title: PowerShell Summit NA 2015&#58; Day One
excerpt: "Overload"
tags: [PowerShell, Rambling, Quick Hit]
modified: 2015-04-21 22:00:00
date: 2015-04-20 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /pshsummit/pshsummit.png
---
{% include _toc.html %}

This is a quick hit on my thoughts after the first day (and [pre-event fun](https://onedrive.live.com/?cid=d4b8e51b855f08af&id=D4B8E51B855F08AF%21137929&sff=1&authkey=%21AKc-yMjpq6tAcTM&v=3) - thanks to Will Anderson for the pics) of the PowerShell summit.

### Why you should go

![The Best PowerShell Event](/images/pshsummit/best.png)

I'm not particularly social. I have a tough time starting conversations, or joining a group discussion. That being said, over the course of a pre-event-pub-gathering and the official first day, I've had the opportunity to talk to someone who (will have) [contributed code to Windows](https://twitter.com/RJasonMorgan/status/590246665820311553), PowerShell MVPs galore, a number of talented folks who use PowerShell on a daily basis, and ended up sitting with a few PowerShell PMs for a 'hackathon' - more food and drinking than coding, thankfully for me.

I have a laundry list of ideas and technologies to check out when I get home, and this was the first day.

Oh. There's also [a good deal of content](https://www.youtube.com/playlist?list=PLfeA8kIs7CochwcgX9zOWxh4IL3GoG05P), and being on site allows you to ask questions, and follow-up with the experts after the talks.

### Fun Bits

![Jeffrey's Tweet](/images/pshsummit/pester.png)

Hands down, the announcement that Pester will be in Windows was the most exciting unveiling today.  What does this mean?

* Folks like [Dave Wyatt](https://twitter.com/MSH_Dave), [Jakub Jareš](https://twitter.com/nohwnd), and [Scott Muc](https://twitter.com/ScottMuc) (among [the many other contributors](https://github.com/pester/Pester/graphs/contributors)) will have contributed to Microsoft Windows.
* Precedent. As far as I understand, and I could be wrong, this is the first open source piece of software they will be pulling into Windows. Either way, this is exciting, and I expect to see more on this front: integration of open source components, or open sourcing existing components.

All the talks I went to were valuable, no duds yet:

* Dave Wyatt gave [a great talk on Pester testing](https://www.youtube.com/watch?v=SftZCXG0KPA).  Rumor has it he was nervous; it certainly didn't show!
* Jason Morgan gave [a helpful session](https://www.youtube.com/watch?v=qcbjgtAFjjI) on large scale monitoring. If you came expecting a demonstration using notepad (yes, we might have seen one last year...) with specific examples you could pull from Google, you might have been disappointed. As someone who has to deal with monitoring at (slightly lower) scale, I already have a few ideas to implement from this talk.
* Microsoft is contributing to [poshtools](https://github.com/adamdriscoll/poshtools). [This looks fantastic](https://www.youtube.com/watch?v=eRILgGQb_hQ), and I love Visual Studio for C# and other projects where I can use the Express edition, but... Until I can use this in Visual Studio Express, this is a no go for me, and many other IT professionals. Licensing prevents me from using Community edition, and dissuades me from using workarounds.

Also, cookies.  Thanks to Chris G., there will be no cookie withdrawal this weekend.

### Shameless Plug

Many of you have been using GitHub, Pester, and CI/CD tools like AppVeyor for some time. They are new and exciting to me, so I wrote a few quick posts on them. Basic stuff for some, but I had always been a bit intimidated by these.  Unit testing and continuous integration? Those are dev processes!

I work in Window Server, AD, vCenter, Citrix, System Center, MDT, and a hodge podge of other IT specific technologies every day, but adding GitHub, Pester, and AppVeyor to my toolbelt has been incredibly valuable thus far.  Give it a shot!  Who knows, your code might end up in Windows.

* [GitHub for PowerShell Projects](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) - Yet another 'getting started with GitHub' post, focusing on PowerShell projects.
* [Fun with GitHub, Pester, and AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/) - My first post on this toolset, giving an overview of each tool.
* [Github, Pester, and AppVeyor: Part 2](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/) - Mostly rambling.
* [Testing DSC Configurations with Pester and AppVeyor](http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/) - Quick integration testing for DSC resources and configurations.
* [Sergei Vorobev from the MSFT Windows PowerShell team will discuss GitHub, Pester and AppVeyor](https://www.crowdcast.io/e/vipug-2015-05) - Will be recorded, but stop by for the live show May 7th.
* [Contributing guidelines for the DSC Resources GitHub repository](https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md) - More helpful tips on using GitHub, and details on how to contribute to MSFT's DSC Resources.
* [Edit: Final session of the summit](https://www.youtube.com/watch?v=2QuoneqfJJM).

Come say hi if you're at the summit - I'm not social enough to start up too many conversations, but I do love talking shop!