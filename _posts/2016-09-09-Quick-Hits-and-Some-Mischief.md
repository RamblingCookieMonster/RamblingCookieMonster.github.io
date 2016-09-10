---
layout: post
title: "Quick Hit&#58; Extract Scheduled Task Credentials"
excerpt: "Sticky notes, on a server"
tags: [Tools, Quick]
modified: 2016-09-09 07:00:00
date: 2016-09-09 07:00:00
comments: true
image:
 feature: banner.jpg
 thumb:
---
{% include _toc.html %}

## Rambling

I enjoy writing.  I tend to try to write more than a handful of paragraphs, and often pair things up with a module or guide of sorts.  That takes a bit longer than writing a quick hit on something fun I've learned.

This [*Quick Hits*](http://ramblingcookiemonster.github.io/quick/) section will include bits longer than a tweet, and shorter than a typical post.

Quantity over quality, right? : )

## Get-Secret

So!  At $LastJob, I managed to convince $Boss that password management was somewhat important.

Among other motivators, I think these stuck out:

* **Authentication is a thing**.  With KeePass or a similar solution, *anyone* who knows the master password gets in, and can take the safe when they leave

* **Authorization is a thing**.  With KeePass or a similar solution, you're stuck with multiple archives if you want to share different passwords with different folks.  Which password do you need?  [Every one](https://www.youtube.com/watch?v=MrTsuvykUZk)!

* **APIs are a thing**.  Okay.  KeePass and similar solutions might be able to limp by on this, but an authenticated web API designed for multiple users and the works is a bit nicer.  [Secret Server](https://github.com/RamblingCookieMonster/SecretServer) and [PasswordState](https://github.com/devblackops/PasswordState) already have community PowerShell modules wrapping their APIs.  Sort of important for this last bullet:

* **How fast can you change your passwords?**  John left.  He's angry and has always been a bit rash.  He has all the passwords, because you used KeePass, and you don't know which passwords he's accessed before he left.  Or, maybe Jane hacked through your defenses and made off with your passwords.  Whatever the case:  Can you cycle all your passwords?  How quickly?  Will you cause an outage?  A real password management solution can help with this, by providing a robust API, perhaps natively hooking into certain technologies for automated credential changes, providing audit logs that tell you which passwords John accessed to limit the scope of these changes, etc.

Anyhow!  That was completely tangential, but I miss having a real password management solution, and the automation this enables.

That brings us to todays topic:  *Shoot.  What's that account's password again?  It's running a scheduled task, surely we can find it!*

## Scheduled Task Credentials

Sometimes it can come in handy to extract a password from a scheduled task.  Perhaps you forgot to record or update it, because you're not automating these things yet.  Perhaps someone changed it manually and your monitoring hasn't picked up the mismatch between your password solution's idea of the password, and the actual password.

I ran into one of these cases, and needed to find an account's password, without changing it.  I'm not going to go into the technical details on how or why this works, I'll leave that to you.  Here's a quick walk through on extracting a password from a scheduled task:

* Have privileges on the system
* Download [psexec](https://technet.microsoft.com/en-us/sysinternals/bb897553.aspx)
* Download [nirsoft's netpass](http://www.nirsoft.net/utils/network_password_recovery.html)
* Use psexec to launch netpass in SYSTEM's context

```powershell
# psexec is somewhere in my $ENV:Path
# netpass is in the root of C:\
# adjust as needed
psexec -i -s -d C:\netpass.exe
```

[![Passwords](/images/quick/password.png)](/images/quick/password.png)

Voila!  I have the password for this fake scheduled task.

### Wrapping up

[Tools](https://github.com/gentilkiwi/mimikatz) and [references](https://www.securusglobal.com/community/2013/12/20/dumping-windows-credentials/) [abound](https://adsecurity.org/?p=556) - Do consider consulting your $Boss before taking this route.  Just in case.

Cheers!