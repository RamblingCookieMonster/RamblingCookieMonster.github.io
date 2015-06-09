---
layout: page
title: Trust&#44; but Verify
excerpt: "What could go wrong?"
tags: [PowerShell, Rambling, Automation, Best Practices]
modified: 2015-06-08 22:00:00
date: 2015-06-08 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /error-handling/warning.png
---
{% include _toc.html %}

### Rambling

A short while back, Adam Bertram was looking for suggestions on a theme for a PowerShell blog week. I suggested validation and error handling - these may seem dry, and are often overlooked, despite being absolutely critical for reliability and consistency. June corrected my phrasing:

![Not dry](/images/error-handling/june.png)

June is right. The problem is, we often don't realize how important these tasks are. In real life, we tend to take these for granted as well. We look both ways before crossing the road. We check our wallet before heading to a cash-only spot. A chef taste-tests his craft. We don't stop looking at the traffic light just because it was green 15 seconds ago. Many of these cases become second nature, and you may not realize you're doing it.

Yet often enough, someone writing code might forget to double check they have the expected results before proceeding, might let their code run after an error occurs that could lead to disastrous results, or might use un-sanitized user input directly in a SQL query. All of these are solved problems, yet we might overlook them as 'boring' or 'dry'.

Let's take a look at how we can bring these issues to light before they cause major problems.

### What Could Go Wrong?

This is a good question to ask yourself as you write code, PowerShell or otherwise. What could intentionally or unintentionally go wrong? Ask this question often, and you will generally end up with a more reliable, consistent, and secure solution.

Some variations to consider:

* What could go wrong... with the provided input?
* What could go wrong... with the data being processed?
* What could go wrong... with my expectations?
* What could go wrong... with the operating environment?
* What could go wrong... with my code?

When you first start considering these questions, you might wonder if they are worth the extra time and thought. "What are the chances!" you might ask. If you find yourself taking shortcuts, be sure to consider the implications when something invariably goes wrong.

I like to hang out in the [PowerShell Slack](http://slack.poshcode.org/) / IRC community; you can ask questions, help others, and pick up ideas to take to your environment. I have seen panicked questions that turned out to be resume-generating-events. Don't be afraid to make mistakes, it happens to everyone, and in a non-toxic environment these are often seen as learning opportunities, but be prudent. Consider the potential impact your code could have.

A few examples:

* You're only reading data... but that data feeds management decisions or processes down the line. You might provide bad data to downstream processes.
* You're changing data... what if you change the wrong data? Will you know it changed? How many business processes or services will it impact?
* You're removing data... you just deleted production data! Hopefully you have backups. Will you notice in time to restore without a significant impact?
* You exposed your service to injection... you suffer unintentional or intentional injection. Could be SQL injection, code injection, you name it. Not good!

Let's dive into some common scenarios. We won't be able to cover every imaginable scenario, so be sure to always ask *what could go wrong?*

### Bad Input

The idea with input validation is that you should control and limit the input that you take, to avoid surprising outcomes. There are a number of options:

* Use built in PowerShell functionality for validation. Boe Prox wrote [a great post](http://learn-powershell.net/2014/02/04/using-powershell-parameter-validation-to-make-your-day-easier/) on this, and [about_Functions_Advanced_Parameters](https://technet.microsoft.com/en-us/library/hh847743.aspx) has a few tips as well.
* [Use an Enum](http://ramblingcookiemonster.github.io/Types-And-Enums/) that restricts you to a few specific choices, or a strong type, such as ```[int]``` or ```[string[]]``` to indicate exactly what type of data to take in.
* Use other built in tools. If you are using this input in a SQL query down the line, use safeguards like [parameterized queries](http://blog.codinghorror.com/give-me-parameterized-sql-or-give-me-death/), perhaps through [Invoke-Sqlcmd2](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1).
* In some cases, you might need to allow arbitrary input, performing validation later in your code.

These revolved around input validation, let's dive into validation in general.

### Validation

Validation can be used across wide swathes of your code. There are too many examples to count, across every imaginable scenario. Let's list a few.

* Does the count of objects you get back meet your expectations? Did you get more than expected? Did nothing come back? Did you plan to feed one Active Directory account in for some changes but accidentally get every single account in the domain back?
* Your SQL server deployment system is ready to install SQL; is the SQL service account it created earlier ready to use and replicated across Active Directory?
* Your vendor shipped shoddy code. You're [hunting for runaway processes](https://gallery.technet.microsoft.com/scriptcenter/Get-EvilProcess-Find-a8601566). Do you verify the executable name, session idle time, and other bits, or do you kill processes willy-nilly?
* You're relying on a file being available. Do you assume that it's there and that it's ready to use immediately, or do you test and [wait](https://gallery.technet.microsoft.com/scriptcenter/Wait-Path-Wait-for-a-path-1393ef86) for it to exist?
* You're supposed to get a string back. Or a date. Or some other specific type. Do you verify you're getting the right type before working with it?
* You're making changes to a set of systems. Would it help to [check connectivity](http://ramblingcookiemonster.github.io/Invoke-Ping/) or make sure the right services are running before starting?

This all depends on your task at hand. You're never going to find a list of everything to watch out for, but you can always ask yourself *what could go wrong?* Occasionally we have to ask this of our own expectations on how our code will behave.

### What Could Go Wrong With My Code?

This is a tough one, and highlights the importance of testing your code. Here are a few mistakes I've seen. All of these boil down to your code not doing what you think it's doing.

* You're writing a loop in code that will run in PowerShell 2, and you don't test the loop variable first. In PowerShell 2 and earlier, a loop will run one time, [even if you feed it $null](http://stackoverflow.com/questions/21755825/why-is-it-possible-to-loop-through-a-null-array).
* You're working in a PowerShell 2 environment again. This time, you're taking action based on the count of items you get back. Hopefully you didn't depend on the count property; [in PowerShell 2](http://powershell.com/cs/blogs/tips/archive/2008/11/18/converting-results-into-arrays.aspx), if only a single object comes back, it very likely will not have a count property on it. This means if you get one item back, and your logic tests ```$item.count -eq 1```, or something along those lines, you are out of luck.
* You're handling errors with Try/Catch - awesome! Unfortunately, you forgot to tell PowerShell to force a 'terminating' error by specifying ErrorAction Stop; this means you might never hit the catch block. Be sure to read up on [error handling](https://www.penflip.com/powershellorg/the-big-book-of-powershell-error-handling).
* You're handling errors with Try/Catch, and you made it to the catch block! You reference ```$Error[0]```. Turns out by some fluke another error squeaked its way in, pushing the error you care about to ```$Error[1]```. Always refer to the current error in the catch block as ```$_```. Do not rely on ```$Error```.

There are a number of handy references on related topics:

* Michael Sorens' [Plethora of PowerShell Pitfalls](https://www.simple-talk.com/sysadmin/powershell/a-plethora-of-powershell-pitfalls-part-2/) series.
* PowerShell.org's [Big Book of PowerShell Gotchas](https://www.penflip.com/powershellorg/the-big-book-of-powershell-gotchas)

So what do you do when you successfully detect something wrong?

### Something Went Wrong

There are a number of ways to handle these scenarios:

* Error handling. [References](https://www.penflip.com/powershellorg/the-big-book-of-powershell-error-handling) [abound](http://learn-powershell.net/2015/04/04/a-look-at-trycatch-in-powershell/). Long story short, get very familiar with [Try/Catch and Try/Catch/Finally](https://technet.microsoft.com/en-us/library/hh847793.aspx). Consider whether you should stop the entire function/script, 'continue' to the next item in a loop, or simply log the error and keep on going.
* Logging. There are [many](https://gallery.technet.microsoft.com/scriptcenter/PSLog-Send-messages-to-a-db389927) ways to [skin a cat](https://gallery.technet.microsoft.com/scriptcenter/Enhanced-Script-Logging-27615f85), including writing your own logging module. Logging unexpected scenarios and details on the operating environment when they occur can come in quite handy.
* Notification. If the process is important enough, or needs immediate attention, consider some sort of notification. I tend to send [HTML based e-mail](https://gallery.technet.microsoft.com/scriptcenter/PowerShell-HTML-Notificatio-e1c5759d). You might have a monitoring system you could feed data into.
* Testing. This is a good way to look for something going wrong with your code. Take a peak at [Pester](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/#pester), it is quite valuable.

### Trust, but Verify

One of the more terrifying lines I hear nowadays is the old "oh, that will just be a couple lines of code!"

You might trust your code. You might trust your environment. Regardless, you should always ask yourself *what could go wrong?* and verify your expectations. You might just save yourself, your employer, and your customers a major downtime, a massive data breach, or the many other potential outcomes that could occur when we make assumptions.