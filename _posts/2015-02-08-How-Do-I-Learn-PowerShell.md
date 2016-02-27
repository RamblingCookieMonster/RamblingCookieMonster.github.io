---
layout: post
title: How Do I Learn PowerShell?
excerpt: "Books, practice, and community"
tags: [PowerShell, Rambling, Learning]
modified: 2015-02-08 22:00:00
date: 2015-02-08 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /legacy/books.gif
---
{% include _toc.html %}

I often see questions on how to learn PowerShell. Rather than address these each time they come up, figured it was time for a post. [PowerShell is a critical skill](http://ramblingcookiemonster.github.io/Why-PowerShell) for anyone working in IT on the Microsoft side of the fence. Anyone from a service desk associate to printer admin to DBA to developer would benefit from learning it!

There’s no single answer to the question; reflecting back on my path, the following seems like a decent recipe for learning PowerShell. Long story short? Practice, practice, practice, build some formal knowledge, and participate in the community.

## First Things First

There are [books, videos, cheat sheets, and blog posts galore](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html). Before any of this, get a system up and running with PowerShell. I assume you can search for the details on how to do the following:

* Download the latest Windows Management Framework and requisite .NET Framework – .NET 4.5 and WMF 4 at the moment. Even if you target a lower version PowerShell, the newer ISE will make learning and every day use more pleasant
* Set your execution policy as appropriate, keeping in mind it’s just a seatbelt (I use Bypass on my computers). You do read code before you run it, right?
* Update your help. If using PowerShell 3 or later, run PowerShell as an administrator and run Update-Help -Force
* This is standard fare for any technology, but remind yourself of the importance of testing. Test against a test environment or target where possible. Consider all the corner cases and scenarios that your code should handle. Test one, few, many, in batches, and finally, all. Consider using read-only or verbose output before sending those results to commands that change things. Read up on –Whatif, –Confirm, and where these don’t work. Don’t be this guy:

![I don't always test my code...](/images/legacy/test.png)

Okay, enough disclaimers. Start exploring and experimenting. A solid foundation built on books and other references is incredibly helpful, but experience is even more important. If you tell yourself “I’ll learn PowerShell when I have more time,” you’ve already lost. You learn through practice and experience; you’re not going to magically learn PowerShell in some boot camp, training program, or book if you don’t regularly use it in the real world.

## I Only Learn By Doing!

Building a foundation for PowerShell knowledge is important. You should spend time working with the language, but this isn’t a language where you can ignore formal knowledge; your assumptions will bite you, cause frustration, and lead to poor code. This is not your standard shell or scripting language for a few key reasons:

* **PowerShell is both a shell and a scripting language**; the shell isn’t a slightly different environment where you might run into odd quirks that don’t expose themselves in a script. The scripting side doesn’t have more powerful language than the shell. They are one and the same. This leads to interesting design decisions. Shell users know that ‘&#62;’ is a redirection operator. Developers and scripters know that ‘&#62;’ is a comparison operator. This is one of several conflicts between shell and scripting expectations that makes PowerShell a bit unique, and can inspire wharrgarbl even from talented developers.

* **PowerShell targets IT professionals and power users**, rather than developers. A developer might expect an escape character to be a ‘\’. If Microsoft chose this, we would need to escape every single slash in a path: “C:&#92;&#92;This&#92;&#92;Is&#92;&#92;A&#92;&#92;Pain”. Few IT professionals in the Microsoft ecosystem would use a language like that. Several design decisions like this may confuse seasoned developers.

If you come in as an experienced scripter or developer, you might get serious heartburn if you make assumptions and don’t look at PowerShell for what it is. Even developers like Helge Klein (author of delprof2 and other tools) [make this mistake](https://helgeklein.com/blog/2014/11/hate-powershell). Several of my talented co-workers who are more familiar with C# and .NET, or Python/Perl and various shell languages have made this mistake as well. Like most languages, if you’re going to use it, you should spend some time with formal reading material, and should avoid assumptions.

## Formal Resources

Hopefully you’ve decided to look at some formal learning materials!  I keep a list of the resources I find helpful for [learning PowerShell here](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html).

Prefer books?

* If you’re a beginner without much scripting / code experience, check out [Learn Windows PowerShell 3 in a Month of Lunches](http://www.manning.com/jones3/).
* If you have experience with scripting and code, [Windows PowerShell in Action](http://www.manning.com/payette2/) is the way to go. This is as deep as it gets, short of in-depth, lengthy blog posts, and you get to read about the reasons behind the language design. Knowing the reason for ‘greater than’ being -gt rather than &#62; should quell your heartburn.
* Strapped for cash? [Mastering PowerShell](http://powershell.com/cs/blogs/ebookv2/default.aspx) is a great free book
* Want to know what started this all? Read Jeffrey Snover’s [Monad Manifesto](http://www.jsnover.com/Docs/MonadManifesto.pdf). This isn’t on PowerShell per se, but it gives insight into the vision behind the language.

Prefer videos?

* [Getting Started with PowerShell 3.0](http://channel9.msdn.com/Series/GetStartedPowerShell3)
* [Advanced Tools and Scripting with PowerShell 3.0](http://channel9.msdn.com/series/advpowershell3)
* Several CBT resources, including [PluralSight](http://www.pluralsight.com/search/?searchTerm=powershell), have great PowerShell material
* Keep in mind a video will not cover nearly as much as a book can. Don't skip a book!

Prefer training?

There are plenty of training opportunities. Keep in mind that training might cater to the lowest common denominator in the room, and that a few hours, even at breakneck speed, won’t be enough. Of course, this could be my own bias showing.

## Join the Community!

The community is a great place learn, and to get ideas for what you can do with PowerShell.

* Find popular repositories and publications on sites like [GitHub](https://github.com/search?l=powershell&q=stars%3A%3E1&s=stars&type=Repositories) and [Technet Gallery](https://gallery.technet.microsoft.com/). Dive into the underlying code and see how and why it works. Experiment with it. Keep in mind that popular code does not mean good code. Contribute your own code when and if you are comfortable with it

* Drop in and get to know the communities. [Get an invite](http://slack.poshcode.org/) to the PowerShell Slack team, or stop by #PowerShell on IRC ([Freenode](https://webchat.freenode.net/), bridged with Slack). Check out [Twitter](http://www.reddit.com/r/sysadmin/comments/2nx8to/what_other_sites_have_similar_content_to_rsysadmin/cmi0cu9), if you don’t use it, you might be surprised at how valuable it can be. Join the [PowerShell.org](http://powershell.org/) community. Keep an eye out for other communities that might be more specific to your interests or needs.

* Look for blogs – some might cover general PowerShell, other’s might cover your IT niche. I keep [a few here](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html), but there are many others.

* Participate in a local PowerShell user group. There’s no single way to find these, look at [PowerShellGroup.org](http://powershellgroup.org/), [PowerShell.org](http://powershell.org/wp/user-groups/), and ask around.

As you spend time working with PowerShell and following or participating in the community, you will find some community members that you can generally rely on. [PowerShell MVPs](http://mvp.microsoft.com/en-us/search-mvp.aspx?ex=PowerShell), the [PowerShell team](http://blogs.msdn.com/b/powershell/), and other respected community members put out some fantastic material.

Unfortunately, because everyone loves to contribute, you will find plenty of outdated, inefficient, incorrect, or downright dangerous code out there. This is another reason I tend to steer folks towards curated, formal resources at the onset, so that they can learn enough to recognize bad code at a glance.

## Spend Some Time With PowerShell

At this point, you should be good to go! A few suggestions that I’ve found helpful along my way:

* **You can use PowerShell to learn PowerShell** – Get-Command, Get-Help, and Get-Member are hugely beneficial. The Get-Help about_* topics might seem dry, but their content is as good as any book.

* **[Building functions](http://ramblingcookiemonster.github.io/Building-PowerShell-Functions-Best-Practices/) can be helpful** – focus on modular code that you can use across scenarios. Don’t limit yourself by adding GUIs, requiring manual input from Read-Host, or other restrictive designs.

  * As an example, I borrowed code from Boe Prox to write [Invoke-Parallel](https://gallery.technet.microsoft.com/scriptcenter/Run-Parallel-Parallel-377fd430) a while back. I use it to speed up many solutions. I borrowed jrich523’s [Test-Server](https://gallery.technet.microsoft.com/scriptcenter/Powershell-Test-Server-e0cdea9a), glued it together with Invoke-Parallel, and now I have [Invoke-Ping](http://ramblingcookiemonster.github.io/Invoke-Ping/). This lets me parallelize tests against thousands of nodes for services like remote registry, remote RPC, SMB, and RDP. Many of our production scripts start out by querying for a list of nodes and filtering this list with Invoke-Ping. The key is that I have re-usable tools and components that can be integrated across a variety of solutions, not just one-off scripts that are only helpful in a single use case.

* **Spend a few minutes every day!**

  * Don’t hold up urgent production troubleshooting if you aren’t ready, but consider revisiting the scenario afterwards. Could you have used PowerShell to detect the issue before it happened? Could you use PowerShell to implement the fix? If you had an issue distributed across many systems, would it have saved time to use PowerShell to troubleshoot

  * Have a project, task, or tedious manual step to accomplish? Would it make sense to use PowerShell? Spend a little time and see if you can script this out, or write a function to do the work.

  * Start with read only commands. Yes, automation and configuration are important, but you can learn a lot about PowerShell and your environment just by running ‘Get’ commands. This is a great way to learn more about technology in general as well! If I come across a piece of technology that I want to learn, perhaps Infoblox Grid Manager, Citrix NetScaler, SQL Server, or Microsoft Hyper-V, I ask for test access or build my own and try to query it with PowerShell. This helps me learn the basics of many technologies, gives me experience with PowerShell, and gets me involved with a number of fun projects. A month down the line when they want to automate or build tooling for something, we already have some basic tools and experience working with it!

  * Don’t be discouraged. If you had no scripting experience, you’re going to have some growing pains. Work through them, it will be worth it in the end. You will find that most of what you learn can be applied to other areas of PowerShell, given shared conventions and syntax. Don’t be this guy: ‘We have to make changes to 1,000 print queues, we need more FTEs to click through all the menus!’ – No, if you had someone with basic understanding of PowerShell, you could have it done more consistently, and with a tool you could re-use, likely in less time. Who wants to go clicking through 1,000 GUIs anyways? Sounds horrid.

Good luck, whichever route you take!