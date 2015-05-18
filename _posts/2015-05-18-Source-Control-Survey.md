---
layout: post
title: Source Control Survey Results
excerpt: "What's source control?"
tags: [PowerShell, Rambling, Automation, Devops, GitHub, Source Control, Revision Control, Version Control]
modified: 2015-05-18 22:00:00
date: 2015-05-18 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /source-control/ItsEasyJustFollowThisModel.png
---
{% include _toc.html %}

### Rambling

Given all the recent excitement around tools like Desired State Configuration, Chef, Puppet, Pester, AppVeyor, and more, you might assume source control was well established in the IT community. After all, what good is your infrastructure-as-code if it's not in source control? How will you automatically kick off testing and deployment upon commit, without a version control system to commit to?

Don Jones recently asked a crowd whether they were using source control, during the [PowerShell Unplugged](http://channel9.msdn.com/Events/Ignite/2015/BRK4451) Ignite session with Jeffrey Snover. I followed up to ask how much of the audience had raised their hands; Don guessed about 10 percent.

That's interesting. Ignite is not cheap, and this was a PowerShell specific session. With all the hoopla around technologies and processes that benefit from or even require source control, you would think a significant proportion of the audience might have raised their hands.

I created a poorly thought out, informal survey, and pestered folks to participate. Thanks to everyone who helped out! My hope is that we might extract some insight, or at the very least, shine some light on and start a discussion around this important piece of the puzzle that many seem to be missing.

### Wait, Why Source Control?

I'm not going to bore you with [yet another list of reasons to use source control](http://stackoverflow.com/questions/1408450/why-should-i-use-version-control). Long story short, you should be using source control whether you work alone or with a team, whether you are a developer or an IT professional, and whether you work in a Microsoft environment or any other.

Source control is an integral part of IT. Tom Limoncelli and Peter Grace list source control as one of 32 fundamental 'best practices' for high performance sysadmin teams in [the Operations Report Card](http://www.opsreportcard.com/section/6).

If you still aren't convinced that source control is important, here are a few more references that might give you a reason:

* [A Visual Guide to Version Control](http://betterexplained.com/articles/a-visual-guide-to-version-control/)
* [Mercurial: The Definitive Guide](http://hgbook.red-bean.com/read/how-did-we-get-here.html)
* [Why Use a Version Control System?](http://www.git-tower.com/learn/git/ebook/mac/basics/why-use-version-control)

### The Survey

I had a hard time coming up with meaningful questions, choices, and phrasing. There's a lot more to ask, but I wanted to keep it simple enough that most folks would take the time to finish the survey.

You're more than welcome to check out the specific questions and phrasing by flipping through [the survey](http://bit.ly/VCSForIT).

The results are not representative, so take everything here with a grain of salt; that being said, if you've been around IT, you might not find these surprising.

The raw data is available [here](/images/source-control/VCSSurveyRaw.xlsx). For a basic report, check out the [TypeForm results](https://pscookiemonster.typeform.com/report/RRc2Oj/XrQF). These are a bit boring though, let's dig in!

### Source Control Use by Job Function

First, a quick glimpse at source control usage broken down by job function. We excluded job functions with less than 5 respondents.

[![UseByJobFunction](/images/source-control/UseByJobFunction.png)](/images/source-control/UseByJobFunction.png)

Let's loosely group the job functions into developer and IT professional buckets - we'll keep Software and Developer functions in the developer group, and drop everything else in the IT professional group:

[![UseByDevVsITPro](/images/source-control/UseByDevVsITPro.png)](/images/source-control/UseByDevVsITPro.png)

My takeaway? We have work to do. Less than 50 percent of responding IT professionals work on teams that use source control.

### Source Control Use by Environment

Let's focus on the IT professionals, and look at whether working in a Microsoft, *nix, or heterogeneous environment might impact source control use.

[![UseByEnvironment](/images/source-control/UseByEnvironment.png)](/images/source-control/UseByEnvironment.png)

Things get ugly for the Microsoft ecosystem here.

* 100 percent of *nix ecosystem respondents use version control at work.
* 60 percent of Microsoft ecosystem respondents use version control at work, and only one third work on teams that use source control.

The 60 percent number seems high. I suspect this includes folks who do not use source control consistently (I'm in this boat). Breaking down the survey's consistency question, based on my perception of whether the wording indicated strong, loose, or no consistency of source control use, Microsoft environments were more likely to have loose or no consistency, while *nix environments were more likely to have strong consistency.

My takeaway? Microsoft should take action to improve source control use among IT professionals. Perhaps with simple, easy to use tools that interface with existing technologies, priced in accordance with the value placed on source control by IT professionals in Microsoft environments.

### Perceived Road Blocks to Using Source Control

What might be holding up the use of source control? The choices I provided here could use some work, but there are a few clear culprits:

[![PerceivedRoadBlocks](/images/source-control/PerceivedRoadBlocks.png)](/images/source-control/PerceivedRoadBlocks.png)

If teams aren't buying in, and no one is championing source control, how can we expect it to flourish?

My takeaway? We need more champions from all sides; IT professionals, management, and vendors. I know we have other priorities, like [dealing with click-next-admins](http://ramblingcookiemonster.github.io/Dealing-With-The-Click-Next-Admin/), but using source control is a base capability. How many well performing IT departments don't have a ticketing or monitoring system?

### What Keeps the Road Blocks Up?

Here, we stray further into conjecture.

#### Experience

How many of you like to use technology you aren't experienced with? This is a bit of a chicken-and-egg scenario, but Microsoft respondents were the least experienced with source control, by their own accord:

[![ExperienceByEvironment](/images/source-control/ExperienceByEvironment.png)](/images/source-control/ExperienceByEvironment.png)

Services like GitHub, with its straightforward Windows client, are starting to get IT professionals like myself into the mix. This won't be enough. Not everyone takes their curiosity and explores at home, we need something as simple to use at work.

#### Tooling

Let's look at the source control solutions used by IT professionals in Microsoft environments where teams were using source control:

[![VCSForMSTeams](/images/source-control/VCSForMSTeams.png)](/images/source-control/VCSForMSTeams.png)

* Team Foundation Server at the top? This seems like a red flag. How many organizations shell out for TFS for their IT professionals? TFS is overkill for many IT professional teams who aren't using source control yet.
* GitHub came next. This is a solid source control solution, but some respondents listed GitHub because they keep PowerShell tools in it, not necessarily configuration files or internal scripts.

Let's pretend you're planning to implement a DVCS solution for an IT team. What do you go with? [I asked this](http://arstechnica.com/civis/viewtopic.php?f=20&t=1229433) a while back, and I still don't know what the best solution would be.

* Do you pay for an on premise solution like [Stash](https://www.atlassian.com/software/stash/) or [GitHub Enterprise](https://enterprise.github.com/features)? I've heard good things, but costs start to add up if you have a decent sized team, and you might need more management buy-in and priority, which can be tough when there aren't many on your team pushing for this.
* Do you let GitHub, BitBucket, or another service host your repositories off premise? I would be perfectly comfortable with this, but this might be a tough sell for some. Costs start to add up if you don't want to pile a bunch of unrelated projects and files into one repository, or have a decent sized team.
* Do you roll your own? Roll your own on top of a service like [GitLab Community Edition](https://about.gitlab.com/features/)? There are a number of solutions out there, but the potential need to support these, the perceived lack of a de facto best choice, and the fact that many of these run over *nix systems might preclude some from going this route.

### Next Steps

There is a huge market of Microsoft oriented IT teams across the world. With a host of solutions and services that rely on or benefit from source control, you would think someone would step in and produce a solution, even if their motivation were market share and revenue, rather than improving the state of IT across organizations of all types.

Thoughts on improving the situation:

* **IT Professionals**
  * Learn to use source control.
  * Encourage your teams to use it.
  * If it's appropriate, show [that tools like GitHub are simple](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) for public facing repositories.
  * Show them some of the benefits that could be had with continuous integration and deployment. Wouldn't it be nice to modify a configuration file, have a set of tests run, and automatically have it deployed to right spot?
  * Sell your management on the important technologies that require source control, where appropriate. It's much easier to encourage your team to use source control when you have a solution in place and ready to use.
  * Be realistic. You might be a wizard. Your co-workers (and I) are not. They will need a simple to use tool that doesn't throw up barriers greater than the perceived value. Giving them a git CLI option and telling them to follow some [git flow model](http://nvie.com/posts/a-successful-git-branching-model/) will scare some folks away.
* **Management**
  * This isn't a nice to have. This is [a key capability](http://www.opsreportcard.com/section/6) for high performance sysadmin teams. Without this, you'll miss out on important ideas like infrastructure-as-code, continuous integration, and continuous deployment, not to mention source control itself.
  * Encourage your teams to use it.
  * Re-prioritize. Solutions like [Atlassian Stash](https://www.atlassian.com/software/stash) and [GitHub Enterprise](https://enterprise.github.com/features) are reasonably priced for the value they provide. If you have a talented team and want to dedicate resources to this, build your own system over something like [GitLab CE](https://about.gitlab.com/features/) or [Bonobo Git Server](https://bonobogitserver.com/). If you prefer hosted services, go with [GitHub](https://github.com/pricing) or [BitBucket](https://bitbucket.org/plans).
  * Once you have a solution in place, strive for consistency. If half your critical projects and configurations aren't in source control, and two thirds of your team has no idea how to use source control, something went wrong.
* **Vendors** - Microsoft in particular
  * Provide simple to use VCS solutions targeting IT professionals, that work in a Microsoft or *nix environment.
  * Re-consider your pricing. If IT professionals aren't placing much value in source control, you need to convince them otherwise, or adjust your prices.
  * This is likely a sizable market. Do some research. If you can capture a good portion of source control for Microsoft environments, you might do well, and improve your customer's IT capabilities.
  * Microsoft: You're including a testing framework (Pester) in Windows, pushing tools like Desired State Configuration and solutions like Chef, and you have a captive audience. Why not provide a simple version control solution oriented around IT professionals, on top of your full scale TFS solution?

There isn't a simple answer to this, and I would love to hear other ideas on how we can improve the consistency of source control use amongst IT professionals.

#### Rambling Addendum

Wow! Forgot how terrible I am with Excel. It was much easier to group, filter, sort, and analyze the data in PowerShell, [sending the data out](http://ramblingcookiemonster.github.io/PSExcel-Intro/) at the end for silly charts.

I also ran into a fun issue. I had a PowerShell script to analyze this data so I could incorporate new responses as they came in. Should have had it in source control; re-wrote one of the chart sections, saved, came back another day, realized I wanted the old code. Spent valuable time re-writing it. How fitting.

Thank you to all the participants, and anyone still reading : )

Cheers!