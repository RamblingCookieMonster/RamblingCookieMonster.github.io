---
layout: post
title: Troubleshooting PowerShell Based Scheduled Tasks
excerpt: "You're doing it wrong"
tags: [PowerShell]
modified: 2015-03-23 22:00:00
date: 2015-03-23 22:00:00
comments: true
image:
  feature: banner.png
  thumb: /invoke-ping/lego.png
---
{% include _toc.html %}

I often see questions about PowerShell based scheduled tasks that aren't working.  The inquiring party tells us that they run perfectly fine outside of the task scheduler. This is a quick hit to cover some of the more common points of failure, and how to troubleshoot these.

Let's look at a well constructed scheduled task, and start listing out where things can go wrong.

### A Working Scheduled Task

We'll stick to configurations that cause the most headaches, found in the general and actions tabs.

#### General

![General tab](/images/scheduled-tasks/OverviewGeneral.png)

* If UAC is enabled and your code requires administrative privileges, be sure to check the 'Run with highest privileges' box (2). Without this box checked, your code executes without the administrator access token.
* Verify that the account the task runs as has the appropriate privileges on the local computer. Do they have 'Log on as a batch job'? Are NTFS and registry ACEs in place to allow access?
* Verify that the account the task runs as has the appropriate privileges for any systems that you query.  Are there application specific or domain specific privileges that you might have missed?  If you're running New-ADUser as SYSTEM, (hopefully) things won't work out.

When simulating a scheduled task, you must mimic these settings.  For example:

* If UAC is enabled and 'Run with highest privileges' is specified, you must ensure you are running with administrative privileges. Don't leave this to chance, if you are troubleshooting, log the output of something like Test-ForAdmin, and verify that you truly are running with the administrator access token.
* Ensure that you are running as the user configured in the scheduled task. This should be straightforward, but if in doubt, log it. If you need to run as SYSTEM, [psexec](https://technet.microsoft.com/en-us/sysinternals/bb897553.aspx) comes in handy: {% highlight bat %} psexec -i -s Powershell.exe {% endhighlight %}

#### Actions

![Actions tab](/images/scheduled-tasks/OverviewGeneral.png)

{% highlight bat %} c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe {% endhighlight %}

{% highlight bat %} -NoProfile -Executionpolicy bypass -file "\\path\to\Generate-SQLDatabaseGrowth.ps1" -Parameter 'Value' {% endhighlight %}

* Verify that you are running PowerShell at the correct bitness - are you running PowerShell from syswow64 (32-bit) and trying to load a module under system32 (64-bit)? That won't work. Fully spell out the path to the PowerShell executable that you need.
* Don't bother typing inside the Add arguments text box. Type out your arguments in your favorite text editor and paste it in. Verify that you don't have any odd trailing spaces or other remnants from pasting.
* Did you forget -NoProfile? Always, *always* specify -NoProfile. If you need to load code in your script, do it in your script. Allowing profiles adds complexity and opens you up to malicious code injection, and unintentional mistakes. What if a profile drops you in an unintended PSDrive that your script doesn't account for? What if a profile sets variables that you naively assumed (never assume!) would be null? I can't emphasize this enough, -NoProfile is required.
* Is your execution policy configured correctly? Sign your scripts, or add {% highlight bat %} -ExecutionPolicy Bypass {% endhighlight %} in the arguments to avoid this altogether.
* If you're specifying -File, anything that comes after the file is seen as a parameter or parameter value for that script.  Your PowerShell.exe switches need to be specified before -File.  Run {% highlight bat %}powershell.exe /?{% endhighlight %} for more information.
* If you're specifying -File, does the account running the task have access to that path?
* Are you making the assumption that you can use PowerShell syntax in the Add Arguments text box? That's not the case, you need to provide syntax that cmd.exe can handle.

This is simple to mimic:

* Open cmd.exe, taking into account our previous example (UAC, account principal).
* Paste the action and the arguments.  Voila! {% highlight bat %} c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -Executionpolicy bypass -file "\\path\to\Generate-SQLDatabaseGrowth.ps1" -Parameter 'Value' {% endhighlight %}

#### Other considerations

There are other considerations that may come into play in. For example, some [code may require an interactive login](https://social.technet.microsoft.com/Forums/windowsserver/en-US/aede572b-4c1f-4729-bc9d-899fed5fad02/run-powershell-script-as-scheduled-task-that-uses-excel-com-object?forum=winserverpowershell).

If you tried the above steps and everything worked properly when properly mimicking a scheduled task, but continues to fail when run as a scheduled task, you will need more information to diagnose the root cause.

### Trust, but Verify

Assumptions can be dangerous. They may lead you on a wild goose chase, or prompt you to give up when a perfectly viable solution is a click away. How can you troubleshoot a scheduled task that you can't see? Log it!

Get familiar with commands to write output to disk. Add-Content, Set-Content, Out-File, Export-CLIXML (mind the depth!), etc. I like Export-Clixml, as you can use Import-Clixml later on to pull the objects into another PowerShell session to troubleshoot.

What should you log? There's a lot to consider:

* Use appropriate [error handling](https://www.penflip.com/powershellorg/the-big-book-of-powershell-error-handling) to catch any errors and log them. Try/Catch is a tried and true method (be sure to force a terminating error in the Try block). The ErrorVariable common parameter may come in handy as well.
* Are there warnings that may lead to a root cause? The WarningVariable common parameter can find these.
* Does your logic depend on the current environment? The output of Get-Variable is quite juicy, you may spot an unexpected value or notice that the variable you were depending on doesn't exist. If you rely on a module or function, log whether they exist (Get-Module and Get-Command can help you here).
* Are you making changes in the script, and assuming that they took place? Add logic to verify to changes as you make them. This is part of scripting 101. You should be verifying those changes and gracefully failing out if they don't get made. Log these.
