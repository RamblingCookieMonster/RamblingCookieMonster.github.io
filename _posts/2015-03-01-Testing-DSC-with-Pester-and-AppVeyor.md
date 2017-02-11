---
layout: post
title: Testing DSC Configurations with Pester and AppVeyor
excerpt: "You get a VM! You get a VM! Everyone gets a VM!"
tags: [PowerShell, GitHub, Pester, AppVeyor, Tools, DSC, Desired State Configuration]
modified: 2015-03-25 00:00:00
date: 2015-03-01 00:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /appveyor-3/picard-riker.png
---
{% include _toc.html %}

I spent the last few days tinkering with [AppVeyor](http://www.hanselman.com/blog/AppVeyorAGoodContinuousIntegrationSystemIsAJoyToBehold.aspx). It’s an interesting service to help enable continuous integration and delivery in the Microsoft ecosystem.

Last night I realized it might offer a simple means to test the outcome of your DSC configurations. Here’s the recipe for a simple POC, with plenty of room for you to tweak and integrate with your existing processes:

* Create a DSC configuration you want to test
* Create a short script to apply that configuration
* Create some Pester tests to verify the desired state of your system, post configuration
* Create the AppVeyor yaml to control this process
* Add this to an appropriate AppVeyor source ([Example covering GitHub](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/))
* Test away! Make a change to the DSC code, commit, and AppVeyor spins up a VM, applies the DSC configuration, and your Pester tests verify the outcome

This certainly isn't a perfect method, but it would be a simple way for anyone to get up and running writing and testing DSC configurations and resources.

I’m going to make the assumption that you are familiar with GitHub, Pester, and some of the basics of AppVeyor from [my first overview](https://ramblingcookiemonster.wordpress.com/2015/02/25/fun-with-github-pester-and-appveyor/).

### Wait, what is DSC?

Windows PowerShell Desired State Configuration is a configuration management platform from Microsoft. It's still young, but is [fast tracked](https://twitter.com/jsnover/status/456972326601388032) for the Common Engineering Criteria, receives [a good deal of attention](https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d) from the PowerShell team, and [the guy who brought us PowerShell](https://www.youtube.com/watch?v=ZlivNGCkakY) is quite excited about it. It's probably something you should be paying close attention to.

There is quite a variety of resources to get started with. The [DSC Book](https://www.penflip.com/powershellorg/the-dsc-book) from PowerShell.org is a nice overview, and the MVA series was quite helpful ([Getting Started](http://www.microsoftvirtualacademy.com/training-courses/getting-started-with-powershell-desired-state-configuration-dsc-), [Advanced](http://www.microsoftvirtualacademy.com/training-courses/advanced-powershell-desired-state-configuration-dsc-and-custom-resources)).

Let’s look at some caveats to testing DSC over AppVeyor.

### Yes, but…

* You could do much of this on your own, with tools like Client Hyper-V and [AutomatedLab](http://automatedlab.codeplex.com/). You might even have a similar toolset in place at work.
* No testing of distributed systems. This allows testing on a single VM.
* Limited selection of operating systems to deploy on. There is an OS option in the [yaml](http://www.appveyor.com/docs/appveyor-yml), presumably this means we may see more.
* Your configurations [cannot restart the VM](http://help.appveyor.com/discussions/kb/13-machine-restart-during-build). Hoping this will change, but depending on their architecture and design, this may be tough.
* You’re deploying on a hosted service. If your DSC configurations are integrated with your CMDB and other internal resources, this may be a show stopper.
* A good DSC resource should have a solid ‘test’ function. That being said, a single DSC resource’s test function might not handle the intricate combination of resources applied to a system.

Right. I’m sure I’m missing others as well. Certainly not perfect, but if your goal is to write and test some general DSC resources or configurations, and you don’t have the tools in house, this is a fantastic and simple way to spin up fresh VMs, configure them with DSC, and verify that the resulting system is now in the desired state.

Another caveat - building your own system that would perform a similar functionality would be an incredibly valuable experience. They always say "don't re-invent the wheel," but if your goal is experience and to learn, re-inventing the wheel is a great way to get there!

### Pick a source

I’m going to stick to GitHub for this. Keep in mind that AppVeyor is only free for open source projects. Consider your security posture before uploading any sensitive DSC configurations.

![Select repository](/images/appveyor-3/selectrepository.png)

### Pick a DSC configuration to test

We’re going with an incredibly basic example here:

{% gist 7024b780174a95a3f9db %}

### Write a controller script to apply the configuration

There are plenty of ways to do this. Modify this POC example to meet your needs.

{% gist e1674d10c0729d9093f4 %}

Most of this should be self explanatory. We force application of the ContosoWebsite configuration from WebServer.ps1. The one extra bit is that we save the path to the resulting MOF file in Artifacts.txt. We upload this later on.

### Write your Pester tests

Go crazy. I wrote some very simple, limited tests for this POC:

{% gist 84fe75b5a75542168252 %}

Keep in mind that you aren't limited to one pass. You could theoretically apply your configuration, test, add a ‘mischief’ script that messes with the configuration, and test to verify that your DSC configuration brings things back in line.

### Write the AppVeyor yaml

We’re almost done!  At this point, we’re going to tell AppVeyor what to run. There’s a lot more you can configure in the yaml, so be sure to flip through the options and experiment.

{% gist e8dbc31b2dd1940173ad %}

What does this do?

*We ignore any commits that match 'updated readme', to avoid unnecessary builds.
*We run appveyor.dsc.ps1, which applies the DSC configuration and saves the mof path.
*We run appveyor.pester.ps1, which invokes the pester script, sends test results to AppVeyor, and tells us if the build passed.
*We upload the mof file, which will be available on the artifacts page for your AppVeyor project.

### Tie it all together

We’re good to go! We create a GitHub repository, add this to our AppVeyor projects, and make a commit ([covered here](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/)). Browse around [the project](https://ci.appveyor.com/project/RamblingCookieMonster/appveyor-dsc-test) on AppVeyor to see the results:

[![Select repository](/images/appveyor-3/appveyordsc_thumb.gif)](/images/appveyor-3/appveyordsc.gif)

That’s it – we now have a simple framework for automated DSC resource and configuration testing. There’s a lot more you might want to do, but the simple POC material is in the [AppVeyor-DSC-Test](https://github.com/RamblingCookieMonster/AppVeyor-DSC-Test) repository on GitHub.

**Edit**:  A few related follow-up posts:

* [GitHub for PowerShell Projects](http://ramblingcookiemonster.github.io/GitHub-For-PowerShell-Projects/) - The basics
* [Fun with GitHub, Pester, and AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/) - Intro to the toolset
* [Github, Pester, and AppVeyor: Part 2](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/) - Mostly rambling
* [Testing DSC Configurations with Pester and AppVeyor](http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/) - You are here

Cheers!