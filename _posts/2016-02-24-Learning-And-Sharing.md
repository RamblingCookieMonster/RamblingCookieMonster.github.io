---
layout: post
title: "On Learning, Sharing, and My First Tech Job"
excerpt: "Hippie mumbo jumbo"
tags: [PowerShell]
modified: 2016-02-23 22:00:00
date: 2016-02-23 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /about/nameplate.png
---
{% include _toc.html %}

## Rambling

Over the weekend, a fun thing happened on Twitter.  Someone encouraged folks to post about their first tech job.

[![FirstTechJob](/images/learn/firsttechjob.png)](https://twitter.com/garethr/status/701099443857309696)

It brought to mind two of my primary motivations: learning, and sharing.

### FirstTechJob

I lucked out.  While I've always been enthusiastic about computing, when I first applied for a job in IT, my experience consisted of an unrelated undergrad degree (brains!), a co-op in risk and compliance (not very technical), and being a student in a networking and systems administration program at a local university.

As much as you learn in school, we all know that nothing can make up for actual experience in the real world.  I still have no idea what I'm doing, but I had even less of a clue back then.

So! I applied for a few jobs.  I was assuming a help desk job would be the only option, probably on an odd shift.

I didn't hear back from most places.  Eventually I took a shot in the dark, and applied for a data interfaces job at a local hospital; something I had no business applying for.  I chatted with the hiring manager, the place seemed nice, but I was clearly not the best fit.  Thankfully, they ended up passing my resume along, and I got a random call for a site support position.

That was it!  I started working with Windows in a domain environment for the first time, helping folks with their laptops, desktops, and other client systems.  Somehow, I managed to (mostly) steer clear of printers.

## Learning

### Rambling

Learning is so important in the world of technology.  If you don't enjoy learning, you're going to hate working in IT.  Or you'll be *that guy/girl*, the one who [happily resorts to clicking next](http://ramblingcookiemonster.github.io/Dealing-With-The-Click-Next-Admin/), no matter how much encouragement and support you give them to learn more and help themselves and their team.

[![Not everyone](/images/learn/noteveryone.png)](https://twitter.com/jepayneMSFT/status/701136556338184192)

I started out as *that guy*, more out of ignorance than intention.  I tried to eek out my co-workers' years of wisdom.  I learned about important technologies at each job along the way.  When I moved up to a third level support role, I learned more about servers and networking, and got a superficial introduction to Active Directory, VMware, and at the suggestion of a mentor, VBscript.

That last bit panned out.  I moved into a systems engineer role immediately after the exposure to VBscript, probably way before I was ready.  So I dove in!  VBscript was a pain, but the [value of scripting](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter2.txt) was clear: thankfully PowerShell was already well established!

Rather than picking a narrow field to specialize in, I decided to focus on something that applies across IT: scripting! I started [learning PowerShell](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/), and continue to learn more to this day.  One of the many [benefits to PowerShell](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter3.txt) is that you can use it to glue together pretty much any technology.  I used this to learn more, and to get involved in interesting projects.  SQL Server, Infoblox, Isilon, vCenter, Active Directory, SCOM, you name it.

I'm following the same pattern today, and am starting to to learn *nix toolsets and basics, Python, Ruby, Puppet, Salt, and more.  The yaks are lining up.

### Takeaway

These helped me out.  Take this with a grain of salt, but I suspect they may help you as well:

* **Be curious**.  Explore.  If you don't enjoy learning, steer clear of IT
* ***It's not my job* is a terrible excuse**.  Always be open to learning topics outside of your current role
* **Find and learn force-multipliers that apply across most jobs in IT**.  Scripting (e.g. PowerShell), data manipulation (e.g. SQL), and others like these are valuable skills
* **You don't need to specialize**.  Knowing a broad range of topics at shallow to intermediate depth, and a few at extensive depth can be quite valuable

## Sharing

### Rambling

Learning and sharing go hand in hand.  Many of the resources I found most helpful were shared by other IT professionals: code snippets, functions, tools, libraries, ideas, questions and answers, you name it.

So!  I tried to contribute back.

I started out by just sharing tips, tricks, and [tools](http://ramblingcookiemonster.github.io/Pages/Tools/index.html) with co-workers.  Eventually I picked up PowerShell, and started sharing snippets, and modules (think of them like toolboxes) with a bunch of handy functions (tools) oriented around our environment.

I enjoyed sharing with co-workers, so I took it to the next stage, and started a blog.  Nothing too exciting, I mostly shared tech news and ideas to start.  A first look at PowerShell Web Access in the wild.  Details on the awesome new PowerShell 3.  A [PowerShell Cheat Sheet](http://ramblingcookiemonster.github.io/Pages/PowerShellResources/index.html#cheat-sheets-and-quick-references).  A few months after starting, I released my first function (a fork of Shay Levy's code), [Get-NetworkStatistics](https://gallery.technet.microsoft.com/scriptcenter/Get-NetworkStatistics-66057d71).

I've been sharing ever since.  If a function or module is general purpose, doesn't include business logic, and is easily sanitized, I publish it.  I didn't explicitly ask my boss, although the topic came up a few times.  I'd rather ask for forgiveness than permission, but you might have a tighter risk appetite, or work for a more litigious employer.

I find that topic irksome.  Employers benefit from more informed IT practitioners.  Preventing IT folks from sharing their work holds back both the employer and IT practitioners who could have benefited from the knowledge.  It also creates some uncertainty, where the more risk-averse among us avoid sharing, even if they aren't under contractual obligation to hoard knowledge.

We all benefit from sharing.  Rather than having every IT professional write duplicate tools, with no feedback or contributions from others, it makes more sense to share our code and ideas.  Less duplication of effort, more eyes on the code or ideas, more feedback from folks taking your ideas or code and using them in new and different ways; this benefits the practice of IT itself.  Heck, it might not be the intent, but if you read the LOPSA code of ethics, they mention how important sharing is:

[![LOPSA Education](/images/learn/lopsa.png)](https://lopsa.org/CodeOfEthics)

### Takeaway

Again, I found these beneficial, but take them with a grain of salt:

* Share.  **You'll learn more**.  You might polish your code and follow practices you would otherwise ignore.  You'll probably want to review information and learn more about the topic at hand before you post about it
* Share.  **You might get helpful feedback** and end up with a better solution
* Share.  **You'll help others in IT**, who in turn might share their own ideas and code
* Share.  **It looks good to many employers**.  All else being equal, if I'm looking at two candidates, and only one of them has code and ideas open to the public, they'll probably get the nod
* **Don't rule out sharing off-hand**.  Consider the risk and reward of sharing your sanitized code and ideas
* **Provide digestible details**.  What's the goal of your code?  How do we install it?  How do we use it?  Readme.md files or short blog posts go a long way.  As silly as it sounds, animated gifs are a great way to quickly get across an idea.

## Closing.

That's about it!

I owe a debt of gratitude to my co-workers, and the various PowerShell and other IT communities and contributors out there.  If they hadn't shared their knowledge, I wouldn't have had the same resources to learn with, and wouldn't be able to share back the little that I can.

Don't be afraid of learning something new, and share what you're learning along the way.  I went from "what's PowerShell?" to "[Why PowerShell?](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter1.txt)." in a few short years.  Years sounds like a long time, but spending a little time every day was all it took.

Cheers!  Hopefully back to posting more technical content soon.