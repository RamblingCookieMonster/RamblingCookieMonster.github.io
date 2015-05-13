---
layout: page
title: Source Control Survey Results
excerpt: "What's source control?"
tags: [PowerShell, Rambling, Automation, Devops]
modified: 2015-05-10 22:00:00
date: 2015-05-10 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /rabbitmq/next.png
---
{% include _toc.html %}

### Rambling

I've been spamming various mediums this past week, looking for victims to participate in an informal, poorly thought out survey on source control for the IT professional.



Why source control:

Long story short? You can find out **who** made a change, **when** they made it, **what** the change was, and generally, **why** it was made

The need for source control is not new. You can find a variety of resources on this:

* [The Operations Report Card](http://www.opsreportcard.com/section/6)
* [Why should I use version control?](http://stackoverflow.com/questions/1408450/why-should-i-use-version-control)
* [A Visual Guide to Version Control](http://betterexplained.com/articles/a-visual-guide-to-version-control/)
### Synopsis
* [Mercurial: The Definitive Guide](http://hgbook.red-bean.com/read/how-did-we-get-here.html)
* [Why Use a Version Control System?](http://www.git-tower.com/learn/git/ebook/mac/basics/why-use-version-control)

### Methods

Tweets, PowerShell.org, Reddit.com/r/sysadmin, an ArsTechnica thread.

### Data

Raw data

Stats

Title
Environment
Experience
Home Use
Work Use
Team Use

Environment seems to be a key indicator - the *nix environment is oriented around documents, which are a perfect fit for source control. Some of the more popular source control solutions are geared towards this environment; for example, an IT professional in a *nix environment will likely be quite familiar with the SSH keys used in git.

    Environment BY Average Experience:
    *nix = 3 - A good deal
    Hetero = 2.39 - Moderate to a good deal
    MS = 1.99 - Just under moderate

    Environment BY Home Use
    *nix = 35 / 6
    Hetero = 42 / 22
    MS = 49 / 41

    Environment BY Work Use
    *nix = All 41.... TODO - NICE
    Hetero = 45 / 19
    MS = 59 / 31

    Environment BY Team Use 
    *nix = 38 / 3
    Hetero = 39/25
    MS = 33 / 57    TODO - WAT


### Conclusion

### Boring bits: Methodology

PowerShell Unplugged http://channel9.msdn.com/Events/Ignite/2015/BRK4451