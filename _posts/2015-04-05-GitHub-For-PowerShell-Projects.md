---
layout: post
title: GitHub for PowerShell Projects
excerpt: "Yet Another GitHub Walkthrough"
tags: [PowerShell, Tools, GitHub, AppVeyor, Pester, Open Source]
modified: 2015-07-15 05:30:00
date: 2015-04-05 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /github-intro/github.png
---
{% include _toc.html %}

### Rambling

Rewind to January 2014. I had roughly six months to wrap up a graduate program, and didn't have time for the disasters that can occur if you don't use [version control](http://stackoverflow.com/a/1408464/3067642). GitHub fit the bill, so I joined up. Nearly a year went by before I received my first pull requests and started playing with Pester and AppVeyor (thanks to Sergei!). Once I started collaborating with others, I realized how helpful and beneficial this ecosystem can be.

Today, I'm hoping to share some of the lessons learned, and provide yet another "getting started with GitHub," walk through, focusing on (but not limited to) some of the benefits to your PowerShell projects.

This post will walk through a general workflow for using GitHub. For simplicity's sake, we will use GitHub.com and the [GitHub for Windows](https://windows.github.com/) client. As a PowerShell user, I hope you take a moment to dive into Git and the command line workflow, but there's no shame in sticking with the client, or [alternatives](https://www.atlassian.com/software/sourcetree/overview).

## Prerequisites

* [Sign up](https://github.com/join) for a GitHub.com account. The free plan is pre-selected. [Example](/images/github-intro/signup.gif).
* [Download GitHub for Windows](https://windows.github.com/).
* Verify your e-mail from the confirmation e-mail you receive.

That's it, you're on GitHub!

## Configure the GitHub Client

This is almost as easy as signing up.

* Open the client for the first time, authenticate, and configure the user name and e-mail for your commits.
* You can [keep your e-mail private](https://help.github.com/articles/keeping-your-email-address-private/) using *username*@users.noreply.github.com.

[![Configure Github client](/images/github-intro/configure_thumb.gif)](/images/github-intro/configure.gif)

That's it, we have GitHub installed, now it's time to start using it!

GitHub took care of a few things behind the scenes, including setting up an SSH key and adding it to your account. You can see these on your [account settings page](/images/github-intro/ssh.png).

## Create a Repository

Let's create a repository. We'll call it PowerShell.

[![Create the repository](/images/github-intro/createrepo_thumb.gif)](/images/github-intro/createrepo.gif)

There's no hard and fast rule on what goes in here. You might have a repository with a smorgasbord of [your favorite functions](https://github.com/RamblingCookieMonster/PowerShell), another for [one specific function](https://github.com/RamblingCookieMonster/invoke-parallel), and one for [a module](https://github.com/RamblingCookieMonster/PSExcel). When you get more involved and collaborate with others, sticking to more targeted repositories will simplify things.

You don't need to create a readme.md, but these are a handy way to build a 'front page' for your repository. These [use markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet), which sacrifices flexibility for a simple to use syntax. You're actually reading a website generated [from markdown](https://raw.githubusercontent.com/RamblingCookieMonster/RamblingCookieMonster.github.io/master/_posts/2015-04-05-GitHub-For-PowerShell-Projects.md) right now.

We chose the MIT license. I base my licensing decisions on the fact that I grew up near Boston. Really though, don't ignore this. GitHub makes [choosing a license](http://choosealicense.com/) incredibly straightforward. Microsoft employees might not contribute to a GPL project. Some folks might not be able to use your code if you have no license:

![Lawyers](/images/github-intro/license.png)

## Do Stuff

That's it! Now we can do stuff.

### Clone the Repository

Let's clone the PowerShell repository we created and edit it on our desktop:

[![Clone](/images/github-intro/clone_thumb.gif)](/images/github-intro/clone.gif)

### Commit and Push

Make some changes. Add a file, change a file, remove a file, do whatever comes to mind. At some point, you want to commit your changes, and basically tell Git "hey, take a quick snapshot of this project."

[![Commit](/images/github-intro/commit_thumb.gif)](/images/github-intro/commit.gif)

The GitHub client sees that I have changes to my files; I describe what I changed in the commit message, and hit commit. I can browse through the specific files, and the GitHub client will highlight new lines in green, removed lines in red.

When we make a commit to a cloned repository, it doesn't change the actual repository on GitHub. We need to push our changes up to GitHub. Notice that we have 'Unsynced Changes', and the Sync button has a badge to tell us we have one commit to push:

[![Push](/images/github-intro/push_thumb.gif)](/images/github-intro/push.gif)

If I made changes on another computer or on GitHub.com directly, that Sync button would have a badge telling me there are changes I don't have, that I might want to pull down.

![Pull](/images/github-intro/syncdown.png)

That's it for the basics! I can now continue making changes, commit, push, repeat. If this is all you're after, you can stop here, but there's much more we can do!

## Get Involved

GitHub is all about collaboration. How can you get involved?

### Open an Issue

You don't need to code to get involved! Did you find a bug in a project on GitHub? Do you have a feature suggestion? A question?

[Open an issue](https://guides.github.com/features/issues/) for the project. Browsing around GitHub, you might notice that most projects have an issues page!

### Work on a Project

Start small. Consider minor bug fixes, documentation, and other minor changes to start; you want to build a relationship and trust with whomever maintains a project. Jumping in with a complete overhaul might not be the most tactful way to do this.

### Fork a Project

Forking a project basically makes a copy that you can work on, separate from the project you fork.

I'll fork a project from my real GitHub account, and clone it down to my PC to start working on it:

[![Fork](/images/github-intro/fork_thumb.gif)](/images/github-intro/fork.gif)

Once I fork the project, I can follow the previous notes on cloning, committing, and pushing. These will all affect my own fork of the project.

Now it's time to give back!

### Submit Pull Requests

I've made some changes to Wait-Path, committed them, and pushed the changes to GitHub. If I want to contribute to the original Wait-Path project, I can submit a Pull Request, asking to merge my changes into the original Wait-Path project.

[![Pull request](/images/github-intro/pullrequest_thumb.gif)](/images/github-intro/pullrequest.gif)

### Merge Pull Requests

Maybe someone has contributed to your project! On my ramblingcookiemonster account, I see that I have unread notifications, and can see the Wait-Path pull request from pscookiemonster:

[![Pull request notification](/images/github-intro/unreadnotifications.png)](/images/github-intro/unreadnotifications.png)

Those changes look good to me, so let's merge in the code:

[![Merge](/images/github-intro/merge_thumb.gif)](/images/github-intro/merge.gif)

### Continuous Integration

When I opened the pull request, did you notice it turn orange and let me know it was waiting for the AppVeyor build to complete?

When I logged on as ramblingcookiemonster, I saw this:

[![AppVeyor Caution](/images/github-intro/appveyorcaution.png)](/images/github-intro/appveyorcaution.png)

A short while later, this changed:

[![AppVeyor success](/images/github-intro/appveyorgreen.png)](/images/github-intro/appveyorgreen.png)

Long story short, I'm using GitHub, Pester, and AppVeyor to enable version control, testing, and continuous integration for this project. Had my code failed the Pester tests, AppVeyor and GitHub would tell us that the build was broken.

Definitely check this out, it's quite handy having AppVeyor automatically run my Pester tests, with a friendly heads up right in GitHub. Here are some posts on the topic:

* [Fun with Github, Pester, and AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/)
* [Github, Pester, and AppVeyor: Part Two](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/)
* [Testing DSC Configurations with Pester and AppVeyor](http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/)
* [A PowerShell Module Release Pipeline](http://ramblingcookiemonster.github.io/PSDeploy-Inception/)

### Etiquette

For all of these, follow [the golden rule](http://en.wikipedia.org/wiki/Golden_Rule).

Would you want to receive an issue mentioning a bug, without details on how to reproduce the bug, whether troubleshooting steps were taken, and other important details?

Would you want to receive a pull request that changed hundreds of lines of code without explanation?

### Staying up to Date

If you want to take a peak at what others are doing, consider following them, or their projects. This will pull interesting information into your front page feed on GitHub:

![Following](/images/github-intro/following.png)

Interesting... What's that?  [ScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)?  Looks like Microsoft open sourced their Script Analyzer tool for PowerShell!

## Next Steps

We're seeing more and more PowerShell projects on GitHub, and with slick toolsets like GitHub, Pester, and AppVeyor, this is a great place to keep your code and collaborate with others. Who knows, [CoreCLR](https://github.com/dotnet/coreclr) is on GitHub, at some point, you might see [PowerShell itself](https://twitter.com/nicemarmot/status/461642016548347904) on GitHub.

**Edits**:

* Microsoft released the [DSC Resources on GitHub](https://github.com/PowerShell/DscResources).  This means you can contribute, and receive the benefit from community contributions to DSC. They included [a handy guide](https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md) to contributing.
* At the [2015 PowerShell Summit](http://ramblingcookiemonster.github.io/PowerShell-Summit-Day-One/), they announced that Pester will be included with Windows. This means folks like [Dave Wyatt](https://twitter.com/MSH_Dave), [Jakub Jareš](https://twitter.com/nohwnd), and [Scott Muc](https://twitter.com/ScottMuc) will have contributed to Windows... Pretty cool!

Keep an eye out for myriad tools that can integrate with GitHub. Even something as simple as a [Chrome plugin](https://chrome.google.com/webstore/detail/octotree/bkhaagjahfmjljalopjnoealnfndnagc?hl=en-US) can help your workflow.

That's about it; don't be afraid to explore and try things out!


*Disclaimer*: Note the January 2014 date mentioned in the intro. That was the first time I had worked with Git. I am certainly not the most qualified person to be discussing this, just wanted to share my experience!

### References

There are pages upon pages of references on Git, GitHub, and version control, not to mention [books](https://progit.org/).  Here are a few references:

* [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/)
* [Good Resources for Learning Git and GitHub](https://help.github.com/articles/good-resources-for-learning-git-and-github/)
* [GitHub For Beginners: Don't Get Scared, Get Started](http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1)
* [How To Win Friends And Make Pull Requests On GitHub](http://readwrite.com/2014/07/02/github-pull-request-etiquette)
* [Bitbucket](https://bitbucket.org/) - Bitbucket is a fantastic alternative to GitHub that plays well with both Git and Mercurial.
* [Hg Init: A Mercurial tutorial](http://hginit.com/) - Git isn't the only DVCS out there, Mercurial is a solid alternative, and IMHO is a bit easier to use in Windows.