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

Given all the recent excitement about tools like Desired State Configuration, Chef, Puppet, Pester, AppVeyor, and related tools, you might assume source control was well established in the IT Pro community. After all, what good is your infrastructure-as-code if it's not in source control? How would you automatically kick off testing and deployment upon commit, without a version control system to commit to?

Folks with experience, or any visibility into IT will realize this is not the case. 

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

Source Control Use by Job Title
    Developers are clearly ahead. IT Professionals are using source control more than their teams.

    Takeaway? Leadership and individuals using source control should push harder for source control. Find tools to simplify using VCS, and consider sensible policies.  Everything into the VCS is not a sensible policy, if you aren't coming from strong existing use of a VCS...

Environment By Use
    Let's strip out the software and developer titles and focus on IT professionals. With this data, 100 % of the *nix ecosystem respondents use version control at work, with just under 90 % of their teams using it.

    The Microsoft ecosystem, which had far more repondents, was in a sorry state.  Just over 30 % of respondents say their team uses version control. 60 % say they use it at work.

    Between IT professionals in *nix, Microsoft, and heterogeneous ecosystems, those in the Microsoft ecosystem used source control less at home, work, and amongst their teams.

    Takeaway? Should Microsoft do more to encourage source control use? What can they do? We need simple, easy to use tools that interface and bridge existing technologies. They should be priced in accordance with the current (low) value that Microsoft places on source control, but might serve as a gateway to further MS Dev products.

Environment by average experience
    This is a bit of a chicken and egg scenario - Microsoft administrators have the lowest experience on average; could their inexperience be putting them off using version control? Is version control a common competency in the *nix ecosystem?

    Environment seems to be a key indicator - the *nix environment is oriented around documents, which are a perfect fit for source control. Some of the more popular source control solutions are geared towards this environment; for example, an IT professional in a *nix environment will likely be quite familiar with the SSH keys used in git.

    Environment BY Average Experience:
    *nix = 3 - A good deal
    Hetero = 2.39 - Moderate to a good deal
    MS = 1.99 - Just under moderate

SO! IT Pros, and Microsoft IT Pro's in particular need more experience, exposure, and encouragement!

WHAT ELSE?





General comments
It's for your own benefit as much or more than it is for others!    @rnelson0, http://rnelson0.com

Can't understand why infrastructure is so far behind development 
IT pros dont see it as an issue. They dont come from a dev background
I love the idea of source control, but find it difficult to get buy in from the rest of my team.
At first mercurial seemed like a hindrance, but after using it for a couple months I dont know how this company survived so long?
Most IT pros outside of dev heavy teams seem to only write basic scripts (if at all), so have no need for source control.

Most of the time, it just adds complexity to the process.There should be an automated system that automatically does source control with out user intervention.  

Suggestions on what to put into source control (without saying "everything").

This definitely needs more adoption. We just need a uniform way to sell it. For myself, I've literally had to point to a download link only on a private repo and let them know to create a user. >>>Still doesn't help with participation. I could probably sell it better if I knew it better but lack of adoption means it is used less overall.
 >>>I think it is a foreign concept, especially for non-Linux guys. Sysadmins feel they have enough to keep up with and can't add version control to the list, especially if they feel the old way is "good enough". @Codetocope

 Ensure it's easier to use source control than not or people won't use it.

Outreach is very important; having a demo, best practice documents and virtual appliances would go a long way toward getting buy in for this.  

Think it should be marketed better, The community as a whole may talk about it, but I don't feel it in practice @schlauge

If you do use SC, whats making it difficult. Our primary blocker is the knowledge it takes to make sure you dont screw things up 
it needs to be easier @jrich523

As a syseng,  a lot of the code we've got is all over the place.  as such It takes effort to use Source control.  It's worth it, though... It's difficult to convince my colleagues of that though. they think that Altiris is good enough for versioning.  Lots of push back to using HG or Git

INANE!  Source control is for americans. 

DON'T FEAR IT, HONEST!

it's possible that the low take-up is just due to lack of knowledge of a solution! @girlgerms

I need to find a method to get buy-in on version control. Tempted to remove some file shares at this point in time...

We need it. Badly. @vhusker

Would love to get to know how others implements VCS

It is sad how few use it or realize how beneficial it can be. I often hear that there isn't time to implement or learn it. I feel there isn't enough time to ignore it. @brandonpadgett

we all agree we should, we should have a simple way of implementing

ON CONSISTENCY:
I commit all my code that is steril from company information to private GitHub repositories; nothing is provided by the company. That has been the case for my previous job, as well. 

If you want to deal with the pain of making changes that can't be reverted easily, you are free to hurt yourself. @cetanu

Source control isn't used. At all. Ever. @girlgerms







No hard numbers, but looking at the 'Consistency' phrasing, splitting answers into none, loose, mixed, or strong, Microsofties were more likely to have no or loose consistency, *nix were more likely to have mandated or strong consistency, heterogeneous fell in the middle.

Consistency
    Mandated
    Strong
    Mixed
    Loose
    None
    No Answer
    WTF?

### Conclusion

### Boring bits: Methodology

PowerShell Unplugged http://channel9.msdn.com/Events/Ignite/2015/BRK4451