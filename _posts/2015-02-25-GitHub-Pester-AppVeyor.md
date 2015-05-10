---
layout: post
title: Fun with Github, Pester, and AppVeyor
excerpt: "Better Together"
tags: [PowerShell, GitHub, Pester, AppVeyor, Tools]
modified: 2015-03-25
date: 2015-02-25
comments: true
image:
  feature: banner.jpg
  thumb: /appveyor-1/build-passing-large.png
---
{% include _toc.html %}

This is a quick hit to cover a practical example of some very important processes; version control, unit testing, and continuous integration. We’re going to make a number of assumptions, and quickly run through GitHub (version control), Pester (unit testing for PowerShell), and AppVeyor (continuous integration).

Yesterday evening I added some basic Pester tests to a [PowerShell module for DiskPart](https://github.com/RamblingCookieMonster/PSDiskPart). I thought it might be fun to test out AppVeyor, but assumed running DiskPart or some other process requiring administrative privileges might not work. I assumed wrong, the build passed!

We’ll make the assumption that if you’re using PowerShell and Pester, you’re using Windows. We’ll also assume you have a PowerShell script or module already written. Finally, we’ll assume that for all the GUI fun below, you might dive into the CLI.

### GitHub

I’m not going to ramble on about Git or GitHub [edit: [Just kidding!](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/)]. There are heavy duty books, hundreds of blog posts, and various youtube examples to get you up and running. Sign up. Download the Windows client. Read one of the thousands of articles on using GitHub ([Example](http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1), others may be better).

You’re signed up. Let’s create a repository and upload our code.  Here’s yet another quick-start, using the website and Windows client, documented with [GifCam](http://blog.bahraniapps.com/gifcam/), a handy tool I found through [Doug Finke](http://www.dougfinke.com/blog/).

Create a repository:

[![Create a repository](/images/appveyor-1/createrepository_thumb.gif)](/images/appveyor-1/createrepository.gif)

Clone the repository on your computer, copy the files you want in there, commit:

[![Create a repository](/images/appveyor-1/clonerepository_thumb.gif)](/images/appveyor-1/clonerepository.gif)

There’s way more to see and do, so do spend a little time experimenting and reading up on it if you haven’t already. There are too many benefits of version control to list, and GitHub adds a simple interface and a nice layer enabling collaboration and sharing. Or go with [Mercurial](http://hginit.com/) and [BitBucket](https://bitbucket.org/), among the many other combinations.

### Pester

Pester is a unit testing framework for PowerShell. Companies like Microsoft and VMware are starting to use it, you should probably check it out (**edit**: Pester will be included with Windows...):

![Pester tweet](/images/appveyor-1/pester-twitter.png)

Jakub Jareš has a great set of articles on [PowerShellMagazine.com](http://www.powershellmagazine.com/) ([One](http://www.powershellmagazine.com/2014/03/12/get-started-with-pester-powershell-unit-testing-framework/), [Two](http://www.powershellmagazine.com/2014/03/27/testing-your-powershell-scripts-with-pester-assertions-and-more/), [Three](http://www.powershellmagazine.com/2014/09/30/pester-mock-and-testdrive/)), and you should find plenty of other examples out there.  Dave Wyatt gave [a great talk on Pester](https://www.youtube.com/watch?v=SftZCXG0KPA) at the PowerShell 2015 NA Summit.

I took an existing Invoke-Parallel test file, used the relative path to Wait-Path.ps1, and [added a few tests](https://github.com/RamblingCookieMonster/Wait-Path/blob/master/Tests/Wait-Path.Tests.ps1). Follow Jakub’s first article or two and you will realize how simple this is. Start using it, and you will realize how valuable it is.

It’s quite comforting knowing that I have a set of tests and don’t need to worry about whether I remembered to test each scenario manually. Even more comforting if you have other people collaborating on a project and can identify when one of them (certainly not you!) does something wrong.

### AppVeyor

Continuous integration. You’ve probably heard it before, perhaps around the [Jenkins](http://jenkins-ci.org/) application. Personally, I never got around to checking it out. A short while back, Sergei from Microsoft suggested using AppVeyor for [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel) (thank you for the motivation!). He added a mysterious appveyor.yml file and Pester tests, I signed up for AppVeyor, added the Invoke-Parallel project, and all of a sudden [Pester tests appeared on the web](https://ci.appveyor.com/project/RamblingCookieMonster/invoke-parallel/branch/master):

[![Pester in the cloud](/images/appveyor-1/pester-test_thumb.png)](/images/appveyor-1/pester-test.png)

I assumed this required much wizardry. It probably did, but now I can borrow what Sergei did! Sign up with your GitHub creds, login, and here’s a quick rundown:

[![Add a project](/images/appveyor-1/addproject_thumb.gif)](/images/appveyor-1/addproject.gif)

Simple so far! AppVeyor is waiting for a commit. In the background, I added a readme.md and a line in Wait-Path. Let’s commit:

[![Commit](/images/appveyor-1/commit_thumb.gif)](/images/appveyor-1/commit.gif)

Behind the scenes, gears are turning at AppVeyor. After a short wait in the queue, your tests will start to run:

![Build pending](/images/appveyor-1/build-pending.png)

[![Pester Wait-Path](/images/appveyor-1/pester-wait-path_thumb.png)](/images/appveyor-1/pester-wait-path.png)

![Build Passing](/images/appveyor-1/build-passing.png)

[Build Passing!](https://ci.appveyor.com/project/RamblingCookieMonster/wait-path)

Take a peak at the [appveyor.yml](https://github.com/RamblingCookieMonster/Wait-Path/blob/master/appveyor.yml). There’s [a whole lot more](http://www.appveyor.com/docs/appveyor-yml) you can do with AppVeyor, but this is a nice framework for simple PowerShell Pester tests. In the yaml, you can see we use domain specific language to...

* Install Pester
* Invoke Pester, pass the results through, and generate output XML
* Upload the Pester XML output (Why? The [Tests](https://ci.appveyor.com/project/RamblingCookieMonster/wait-path/build/tests) tab)
* If Pester output FailedCount is greater than 0, fail the build

### Better together

Version control, unit testing, and continuous integration, and the products we looked at for each of these are fantastic in their own right. If you experiment and try these out together, I think you will find they are even better together. And this particular combination of GitHub + Pester + AppVeyor (for PowerShell) is particularly smooth.

In fact, writing this post, listening to the tail end of the DSC MVA, enjoying some pasta and wine, and recording the various gifs took all of about two hours. Don’t be intimidated, just dive in!

**Edit**:  A few related posts:

* [GitHub for PowerShell Projects](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) - The basics
* [Fun with GitHub, Pester, and AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/) - You are here
* [Github, Pester, and AppVeyor: Part 2](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/) - Mostly rambling
* [Testing DSC Configurations with Pester and AppVeyor](http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/) - Quick integration testing for DSC resources and configurations