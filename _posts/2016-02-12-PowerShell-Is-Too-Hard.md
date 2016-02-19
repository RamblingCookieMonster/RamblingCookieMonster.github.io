---
layout: post
title: "PowerShell Is Too Hard"
excerpt: "I'm not a developer!"
tags: [PowerShell]
modified: 2016-02-18 22:00:00
date: 2016-02-18 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /hard/toobusytiny.png
---
{% include _toc.html %}

## Rambling

I lucked out and no longer need to convince co-workers or their managers that it's in their best interest to learn how to write simple code.  Unfortunately, in most enterprise environments, a [significant proportion](http://ramblingcookiemonster.github.io/Dealing-With-The-Click-Next-Admin/) of the IT workforce seem to enjoy square wheels.

How many times have you seen this?

[![I don't have time to learn](/images/hard/toobusy.png)](/images/hard/toobusy.png)

Some common excuses include *it's too hard*, *I'm too busy*, or *I'm not a developer!* Often with context around how busy they are working on manual tasks that could be automated, or simplified with a small script.

I won't tell you that going from no experience to a decent scripter is something you learn overnight, but you need to start somewhere.

PowerShell is a tool that most of us can handle learning, and would benefit from greatly, even right out of the gate. Lower level languages are great for developers, but they might require a more significant investment in time, without as much value in return (for an IT professional).

Let's illustrate this difference and highlight how helpful PowerShell is, by looking at a simple task across four popular languages.

## The Task

We're going to learn how to read a file.  Exciting, right?  We'll do this using the following languages:

* **PowerShell**, a task-oriented scripting and shell language. Work in a Microsoft ecosystem? [PowerShell is probably the best way to get things done](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter1.txt)
* **Python**, a high-level general purpose programming language
* **C#**, a feature-full general purpose programming language
* **C**, a low-level language that terrifies me

This is roughly in order of how much hand holding a language will do for you, which many IT professionals don't realize.  Let's start from the ground up.  Keep in mind there are many ways to skin a cat in each of these languages.

### Read a file in C

So! First, we need to get a compiler (Visual Studio is your best bet).  Then, we search around for a simple solution.  Protip: don't write in C if you can help it. You need to do everything on your own, which invariably means whatever you write will be insecure.

Here's a "simple" program to read C:\file.txt:

{% gist 6170da1a25751fe3b111 %}

[![C](/images/hard/c.png)](/images/hard/c.png)

And voila, it worked!

Good luck querying LDAP, pulling info from VMware vCenter, or hitting a web API using C. Also, get ready for fun if you're not very familiar with C and need to read or debug someone else's code.

Let's move up to a higher level language, C#.

### Read a file in C&#35;

Next up, C#.  You might have Visual Studio installed already; if not you can compile a simple C# file with csc.exe: e.g. ```C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe YourFile.cs```

{% gist 6c3ae82a321b792b7cca %}

[![C#](/images/hard/cs.png)](/images/hard/cs.png)

Okay! Now we're getting somewhere. Even if I couldn't write that on my own, I can get a feel for what's going on by reading it. But, it's still a bit heavy on the developer side:

* You need to compile
* You can't forget a semi-colon
* You're not just saying "read-a-file", you have to use .NET classes to tell C# how to read a file. Now do this for every task in your solution. This is why I find comments like *just use C# instead of PowerShell* quite absurd

If you're not a developer, it's important to note how helpful that last bullet is. While C# isn't a task-oriented language, it uses the .NET Framework, which provides a vast and incredibly valuable library of code.

If you're an IT professional trying to automate a technology where the vendor got lazy, there's a good chance you can write a PowerShell function or module that wraps their .NET library (the caveats [here](http://ramblingcookiemonster.github.io/REST-PowerShell-and-Infoblox/) still apply: vendors should really provide a PowerShell module for their customers).

Enough rambling, let's move into the world of scripting, and look at reading a file in Python.

### Read a file in Python

So! Being in the Microsoft ecosystem, PowerShell is often the top choice. If you plan to step outside that ecosystem, or just want the experience (protip: this is very valuable), Python is a solid, approachable choice.

We're going to cut our line count quite a bit:

{% gist bacdf9bd418f5960fe0f %}

[![Python](/images/hard/python.png)](/images/hard/python.png)

Nice! So that was much shorter, and the result is even easier to read than C#. Python is a high level language often used for scripting, but it's not as abstracted out and task-based as PowerShell.

### Read a file in PowerShell

We wrap up with the simplest solution:

```PowerShell
Get-Content C:\file.txt
```

[![PowerShell](/images/hard/powershell.png)](/images/hard/powershell.png)

It all boils down to a single, easy to read command.  If your co-workers complain that they aren't developers, ask them if they find commands like the one above too difficult.  Hopefully they are open to learning, and you can help get them started.  Otherwise, what are they doing in IT?

A developer could hop between any of the languages above and more, for a variety of tasks, often with significant expertise in one or two of their favorites. Learning the basics of a task-based language is not *too hard,* and now that nearly everything has an API, [warnings like this](http://everythingsysadmin.com/2014/02/do-system-administrators-need-.html) will be more than just wishful thinking.

So! What's the moral of this story anyways?

## You Don't Need to be a Developer to use PowerShell

Anyone in a Microsoft ecosystem should pick up the basics (or beyond) of PowerShell.  If you can give another person instructions - maybe read a recipe, or describe how to troubleshoot an iPhone - you already have the basic ingredients of coding.  The rest is just syntax, which is a quick Google search away, or even provided to you with [snippets](https://blogs.technet.microsoft.com/heyscriptingguy/2014/01/25/using-powershell-ise-snippets-to-remember-tricky-syntax/).

In fact, PowerShell is a prime candidate for scripting and automation [outside of the world of IT](http://ramblingcookiemonster.github.io/PowerShell-Beyond-Administration/).  How would we get there?

* An open source and cross-platform implementation of the .NET Framework (check) and PowerShell (still waiting)
* Microsoft pushing their own product groups to provide an interface through PowerShell, for both administration and working with products (SQL is a prime example), and beyond their Server and Tools organization
* Microsoft pushing and assisting third parties in developing PowerShell modules to cover a wider variety of technologies
* Microsoft and the community adopting and pushing the PowerShell Gallery - ~560 modules compared to CPAN, PyPI, or RubyGems is sad, regardless of the head start these have
* Luck : )

### How do I get started?

So!  Until then... Are you focused on desktops / clients, printers, identity and access management, databases, virtualization, servers, security, communications, support, networking, or any other pursuit in a Microsoft ecosystem?  You should probably learn the basics of PowerShell.

References abound, I always recommend [a three pronged approach](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/):

* [Pick up a formal resource](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/#formal-resources). Maybe a book you read over a month of lunches.
* [Join the community](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/#join-the-community). Learn from existing tools and scripts. Ask questions and listen in on [Twitter](https://www.reddit.com/r/PowerShell/comments/2gm75d/what_are_some_of_your_favorite_powershell_blogs/ckkfqel), [Slack](http://slack.poshcode.org/), and [PowerShell.org](http://powershell.org/). Stop by a local PowerShell user group. Contribute to all of these if you can!
* [Use PowerShell every day](http://ramblingcookiemonster.github.io/How-Do-I-Learn-PowerShell/#spend-some-time-with-powershell).  Even if only for a few minutes.  You can't learn this in one shot.  You won't learn this if you don't use it regularly.

Hope to see you around the community!