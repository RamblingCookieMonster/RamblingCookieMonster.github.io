---
layout: post
title: Cross Platform PowerShell Remoting
excerpt: "Still baking"
tags: [PowerShell, Tools, DevOps]
modified: 2016-02-06 22:00:00
date: 2016-02-06 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /ssh/here-are-my-creds.png
---
{% include _toc.html %}

# Rambling

Wow! Four months since my last post.  New city, new home, new job, new tiny human in less than a month, and thankfully, same Wegmans.

I lucked out on the job front.  Found a fun team full of talented folks using modern tools, with a role focusing on Microsoft and related tech, in a predominantly *nix / OSS oriented environment.  Plenty of room to learn and explore!

Of course, with everyone being well-versed in languages like bash and Python, and with most infrastructure residing on *nix systems using tools like Puppet for configuration, learning PowerShell hasn't made it to their to-do list.  Yet.  Hopefully that changes - from my perspective, nothing comes close to PowerShell as an approachable, task-oriented glue language - imagine if it were open sourced and ported to other systems?

Until then, rather than miss out on the goodness PowerShell enables, we need to figure out an approach to invoke PowerShell from cross platform systems!

## The Options

There are a number of approaches, each with benefits and drawbacks.  At a high level, we could use...

* Remoting solutions like SSH or WinRM
* API oriented solutions like [flancy](https://github.com/toenuff/flancy), or something heavier like ASP.NET Web API
* Web based solutions, from tools like rundeck, to shoe-horning [Jenkins](https://hodgkins.io/automating-with-jenkins-and-powershell-on-windows-part-1), to [WebCommander](https://github.com/vmware/webcommander), to building your own ASP.NET / C# page

The other options are absolutely worth exploring, but a remoting solution would be very flexible with minimal overhead.  So, how can we use WinRM or SSH to call PowerShell from non-Windows systems?

## SSH

Wait, an SSH server on Windows? Do you really want to rely on some third party or outdated open source option?

Turns out Microsoft is [planning](https://blogs.msdn.microsoft.com/powershell/2015/06/03/looking-forward-microsoft-support-for-secure-shell-ssh/) to deliver an SSH client *and server* for Windows systems, and that there is already a usable (ish) [early preview](https://github.com/PowerShell/Win32-OpenSSH).

Given that it's so early, you should definitely consider testing this out and [contributing feedback](https://github.com/PowerShell/Win32-OpenSSH/issues).  You might help shape design decisions and improve the solution for you, and everyone else using it.

### Getting Started with SSH on Windows

This is the easy part! Just follow [the instructions here](https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH).  At some point, this will hopefully receive CI/CD treatment to deliver stable and dev releases, perhaps to a package manager we can hit from [OneGet](https://github.com/OneGet/oneget).

If you're reading this in early 2016, be sure to [grab the right architecture](https://github.com/PowerShell/Win32-OpenSSH/releases); the link in the instructions will point you to the 32-bit release.

### Running PowerShell from SSH

I ran into no issues getting up and running *with non-interactive commands*.  Let's look at a few examples:

```bash
# Run ipconfig
ssh -l wframe@my.domain ts1 ipconfig
```

[![SSH ipconfig](/images/ssh/ipconfig.png)](/images/ssh/ipconfig.png)

```bash
# PowerShell isn't the default shell. Let's try it out.
ssh -l wframe@my.domain ts1 powershell.exe -command "get-service sshd"
```

[![SSH service](/images/ssh/ssh-get-service.png)](/images/ssh/ssh-get-service.png)

```bash
# Double hop issue? Nope!
ssh -l wframe@my.domain ts1 powershell.exe -command "get-aduser wframe"
```

[![SSH aduser](/images/ssh/ssh-aduser.png)](/images/ssh/ssh-aduser.png)

Nice! So, SSHD is working, we can run PowerShell.exe, and we don't have to worry about the double-hop issue that you might be familiar with on the PowerShell remoting / Kerberos side!

How about something a little longer, with variables?

```bash
ssh -l wframe@rc.domain ts1 powershell.exe -noprofile -command "

    $Service = 'SSHD'
    Get-Service $Service
"
```

[![SSH escape char fail](/images/ssh/ssh-escape-char-fail.png)](/images/ssh/ssh-escape-char-fail.png)

Here's where we run into our first issue.  When calling PowerShell from bash or another interpreter, you need to be mindful of all the interpreters.  In our case, bash helpfully replaced $service for us.  After bash, presumably cmd.exe needs to be accounted for (i.e. we're not dropped right into PowerShell), and then PowerShell itself.  Maybe you have a snippet that needs double quotes: have fun!

Ideally, you manage Windows systems from Windows systems that are already running PowerShell, and avoid the mess, but you can't always make that call.

In this example, we can simply escape the $:

```bash
ssh -l wframe@rc.domain ts1 powershell.exe -noprofile -command "

    \$Service = 'SSHD'
    Get-Service \$Service
"
```

[![SSH escape char](/images/ssh/ssh-escape-char.png)](/images/ssh/ssh-escape-char.png)

Now, you could always abstract this into a shell script, perhaps using expect to handle the password, but ideally we could wrap this in Python or Ruby.  I had no luck getting this to work in [Paramiko](https://github.com/paramiko/paramiko) or it's abstraction, [spur](https://pypi.python.org/pypi/spur), but feel free to give it a try, and be sure to let others know if you have any luck!

That's about it - let's move on and look at using WinRM.

## WinRb / WinRM

There are a number of ways to invoke PowerShell over WinRM from other languages.  For many, the Python and Ruby modules will likely be your first stop.

We're going to skip the Python pywinrm module, given that it requires either plaintext auth, Kerberos, or fun with SSL.  If you already use Kerberos or have a PKI infrastructure in place, you could safely use this.  Otherwise, you'll find a number of guides for [pywinrm](https://github.com/diyan/pywinrm), [WinRb](https://github.com/WinRb/WinRM), and more, instructing you to configure WinRM to enable basic auth and AllowUnencrypted. *Don't*.

We'll use the Ruby module for WinRM.  Install Ruby on your system, `gem install -r winrm`, and away we go!

### Using WinRM From Ruby

We'll assume you already have have PowerShell remoting enabled and accessible from another Windows system.  Thanks to Dan Wanek and Matt Wrock, we can now use [NTLM authentication](http://www.hurryupandwait.io/blog/sane-authenticationencryption-arrives-to-ruby-based-cross-platform-winrm-remote-execution), which doesn't come with the dependencies or complexities of Kerberos or a PKI.

Security note: Do consider using SSL and/or a more modern authentication mechanism like Kerberos, but for quick and dirty testing, NTLM is a far safer bet than basic auth with AllowUnencrypted.  Would love to hear some real security folks weigh in on the current method...

Let's get started!

Here's the gist of what I might run.  More examples abound, just keep in mind we're using create_executor's run_powershell_script method, not the [deprecated alternatives](https://github.com/WinRb/WinRM#deprecated-methods).

```ruby
#!/usr/local/bin/ruby
require 'winrm'
winrm = WinRM::WinRMWebService.new('http://ts1:5985/wsman',
                                   :negotiate,
                                   :user => 'wframe',
                                   :pass => 'my password')

winrm.create_executor do |executor|
  executor.run_powershell_script("get-service 'sshd'") do |stdout, stderr|
    STDOUT.print stdout
    STDERR.print stderr
  end
end
```

[![WinRM service](/images/ssh/winrm-simple.png)](/images/ssh/winrm-simple.png)

This is my first time touching Ruby outside of some sparing use with the GitHub pages setup behind this blog, but I figured it would be worth trying to abstract this into a simple, re-usable function.  Cobbled [this](https://gist.github.com/RamblingCookieMonster/a1645b534fed02b4b368) together from various stackoverflow queries;  feedback or tips welcome.

Let's kick the tires a bit:

```bash
# Double hop issue? Yep!
ps-winrm.rb -u wframe -c "get-aduser wframe"
```

[![WinRM aduser fail](/images/ssh/winrm-aduser-fail.png)](/images/ssh/winrm-aduser-fail.png)

The error message is a bit garbled, but you can get the gist of it.  While the underlying cause differs, we run into the double hop issue PowerShell remoting typically gives us.

Given that NTLM support was just implemented, and that a cursory search doesn't turn up anything on CredSSP, it looks like the usual CredSSP workaround won't help.

Security note: CredSSP will make a red team happy. Do consider [the security implications](http://www.powershellmagazine.com/2014/03/06/accidental-sabotage-beware-of-credssp/), as well as the fact that if you're using RDP, you're already using CredSSP.

Another workaround that works here would be to live dangerously and hit a domain controller directly:

[![WinRM aduser](/images/ssh/winrm-aduser-dc.png)](/images/ssh/winrm-aduser.png)

That's about it! I have seen some odd issues with commands that use runspaces, but most every-day use cases seem to work.

## Which Should I Use?

Both options have their strengths and weaknesses, this is really up to you.  I personally prefer to use languages like Ruby or Python over bash, and SSHD is quite new, so I'll likely lean towards WinRM in the interim. Once I can get Paramiko or spur working against Microsoft's SSHD, I'll likely switch over to that.

Looking ahead, SSH on Windows seems very promising, and should enable simpler integration with cross platform solutions.

The WinRM implementations are worth exploring and will continue improving, but will come with some limitations, and don't seem to be receiving contributions from Microsoft (yet).

## What's on the Horizon?

A nice side-effect of Microsoft using GitHub is that we get a glimpse of what's coming down the road.

Check out the Win32-OpenSSH [issues](https://github.com/PowerShell/Win32-OpenSSH/issues/) - you'll see some notes on current limitations and bugs, along with some interesting ideas and plans.  Curious to see how they'll implement key based authentication for domain accounts ([issue 39](https://github.com/PowerShell/Win32-OpenSSH/issues/39)).

Be sure to kick the wheels of Microsoft's SSHD implementation.  You can actually contribute, whether you submit a pull request, a thoughtful bug report, or an idea for a feature.  It's still quite early, so if you get in your ideas now, who knows, you might help improve this for everyone!

Cheers!