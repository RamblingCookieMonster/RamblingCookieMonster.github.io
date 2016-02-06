---
layout: post
title: Keeping Up With Tools
excerpt: "A full time job"
tags: [Rambling, Quick Hit, Tools]
modified: 2015-05-02 22:00:00
date: 2015-05-02 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /tools/wrench.png
---
{% include _toc.html %}

Tools are a common topic in many IT communities. They can simplify and improve our workflows, enable processes, and fit together to build new solutions. Some are just a helpful convenience.

How do we keep up with these?

### Today

For all their benefits, your best bet for keeping up to date on these tools today involves combing blogs and social media like Twitter, checking for the occasional updates to canonical references like [Scott Hanselman's list](http://hanselman.com/tools), and exploring links and notes in your favorite projects.

#### Blogs and Social Media

I use the term blog loosely, perhaps covering everything with an RSS feed. These can introduce you to some fantastic tools, and give you practical examples of how to use them. [Posh-SSH](http://www.powershellmagazine.com/2014/07/03/posh-ssh-open-source-ssh-powershell-module/) popped up on the PowerShell Magazine feed a while back. [Mouse Without Borders](http://www.microsoft.com/en-us/download/details.aspx?id=35460) turned up at one point, which I now rely on to seamlessly control a few computers at my desk, and an HTPC from my couch.

Social media like Twitter can be insightful as well. Nowadays, I pretty much rely on this to discover new tools and services. It would be impractical to read through every tweet, but retweets, favorites, and following the right folks can help you pick out particularly handy tools:

![Posh-SSH](/images/tools/poshssh.png)

SSH from PowerShell you say?

![ImportExcel](/images/tools/importexcel.png)

[No more relying on COM](http://ramblingcookiemonster.github.io/PSExcel-Intro/) to manipulate Excel files!

![Octotree](/images/tools/octotree.png)

Octotree is handy, but certainly not a life changer. It got me thinking - how on earth would I have found this if I didn't catch Matt's tweet?

Websites and Twitter are inefficient. You might miss a tool or idea, and how do you search for these after the fact if you don't know they exist?

#### Tool lists

There are tool lists galore out there.

* [Scott Hanselman's Ultimate Developer and Power Users Tool List for Windows](http://www.hanselman.com/tools)
* [SecTools.org Top 125 Network Security Tools](http://sectools.org/)
* [Shameless Plug - my favorite tools](http://ramblingcookiemonster.github.io/Pages/Tools/index.html)

On top of these, you will find a variety of community [posts](http://www.reddit.com/r/sysadmin/comments/1yxouf/whats_your_omgthankyou_freeware_list/) asking about favorite tools and tips, [perhaps](https://news.ycombinator.com/item?id=6946354) even oriented around the tool lists themselves.

These are a great source for discovering tools, but they likely won't be as comprehensive, and might not cover your particular area as deeply as you would want. They are also difficult to maintain, and might fall out of date (*/me patiently waits for Scott Hanselman to update his list*).

#### Exploring

You can always go out and explore.

On GitHub the other day, I noticed Joey Aiello open up a repository:

![Open sourced DscResources](/images/tools/joey.png)

Clicking through, I noticed a badge I hadn't seen before:

![Ready badge](/images/tools/readybadge.png)

That badge [took me to a cool service](https://waffle.io/powershell/dscresources) which helps you manage GitHub issues. Sergei mentioned this and a few other GitHub related tools on Twitter - I asked how he discovered these handy services, and it turns out he had been exploring as well:

![GitHub services](/images/tools/vors.png)

You could also search through various systems for something you are interested in. For example, you might [search GitHub](https://github.com/search?l=powershell&q=stars%3A%3E1&s=stars&type=Repositories) for the most starred PowerShell repositories.

Stumbling across new tools and services happens, but it requires a bit of effort, and a little luck. Searching requires that you know what you are looking for, which might be tough if you didn't realize a tool or service existed.

#### The problem

These methods aren't very efficient with our time, and can leave us in the dark if we overlook a particularly handy tool or service. Keeping up with everything could be enough to fill a full time job.

This can be particularly fun if you enjoy learning. I would rather spend time learning the core ideas behind databases, web servers, DVCSs, CI/CD, unit testing, and other areas, rather than trying to sift through the toolsets to work with these.

### Tomorrow

I'm hoping we see a solution to this at some point. Why is there not a repository of IT / Dev tools, similar to the StackExchange's [repository of questions](http://stackoverflow.com/) and answers that we all rely on?

You can stop reading here, might get a bit boring, but here's an outline of a solution I would find helpful:

#### Basic metadata

* Tool name
* Synopsis
* Latest version
* Last update date

#### Links

Many to many relationship, covering related external links:

* Official website
* Official download site
* Repository, if open source
* License
* Wikis, guides, etc.

#### Tags, not buckets

Buckets frustrate me. Unless you have mutually exclusive categories, you need tags, not buckets.

You might want tags related to functionality, operating environment, related services, competing services, etc.

For example, I might tag AppVeyor as follows:

* Continuous Integration
* Continuous Deployment
* Continuous Delivery
* Microsoft
* Windows
* Hosted Service
* GitHub
* BitBucket
* Jenkins
* Travis CI

It would thus turn up if I searched for the GitHub tag, or a combination of Windows and Continuous Integration tags.

#### Community engagement

Some sort of system for simple comments for a particular tool might be helpful, with a moderation system in place to avoid going the youtube direction. How does the tool solve a particular problem? Does it integrate well with a particular toolset? Are there major shortcomings when using it in a particular scenario?

A voting mechanism could help identify popular tools. Might need consideration for how certain competitors might abuse the system (maybe vote up only, similar to hacker news).

Lastly, a reasonable gamification system might encourage using the repository.

#### Process

* Would need to balance the need for community contribution with the ability for authors and organizations behind a tool to control details about it.
* Would need advanced search capabilities (e.g. by specific badges, combination of badges, update date, regular expressions, etc.).
* Would need strong moderation to avoid spam, duplicate submissions, inaccurate submissions, and other problematic input.

There's a lot more that would need to be considered, but from my perspective, it would be well worth it and would benefit the entire IT / Dev community.

### Wishful thinking

Could someone please build this for me? : )

Until we see a more centralized solution, be sure to keep an eye out on websites and social media, check out the variety of tool lists and their discussions, and explore around to find new tools, services, and ideas.

Even if you think a tool is well established or obvious, it doesn't hurt to share it. We have new folks in the field every day, and even a veteran will miss the occasional invaluable tool.

Cheers!
