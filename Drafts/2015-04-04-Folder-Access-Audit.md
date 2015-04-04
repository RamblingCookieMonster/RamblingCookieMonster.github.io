---
layout: page
title: Mapping NTFS and Share Permissions
excerpt: "Can't you just tell me what they have access to?"
tags: [PowerShell, Tools, SQL, SQLite, Practical]
modified: 2015-04-04 22:00:00
date: 2015-04-04 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /psexcel-intro/excel.png
---
{% include _toc.html %}

A short while back, I got an IM from someone on the security team.  'Warren, do you have a PowerShell script to tell me what access so-and-so has?'

This is something I've had on my task list for a while. It's not a small task, and there hasn't been a major driver for it, so I kept putting it off.

When we can break it down into components, it starts to become more approachable. Breaking down these seemingly complex goals into digestible chunks is an important part of the scripting process (mine, at least):

* Pull all of our computers from Active Directory or an inventory database.
* [Identify](http://ramblingcookiemonster.github.io/Invoke-Ping/) which systems are up and running and accessible over SMB.
* List all folders very quickly with a robocopy wrapper, [Get-FolderEntry](https://gallery.technet.microsoft.com/scriptcenter/Get-FolderEntry-List-all-bce0ff43)
* Use tools like Get-ACL or the fantastic [NTFSSecurity module](https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85) to list ACEs on the targets.
* Collect the results on a regular basis and store them in a SQL database, perhaps using [SQLite](http://ramblingcookiemonster.github.io/SQLite-and-PowerShell/) or [MSSQL](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1)

We'll skip over the first two, see the final demo gist for an example that includes these.

### Design the Database

This isn't a complicated solution, but we'll need to plan out our design for the database. See the references section for some articles on the topic. I would highly recommend spending a little time becoming vaguely familiar with databases - a little knowledge and experience with these goes a long way towards improving your solutions!





### References

Database design and development isn't a small topic. This is a career path. That being said, here are a few short references that might get you started.

* [11 important database designing rules which I follow](http://www.codeproject.com/Articles/359654/important-database-designing-rules-which-I-fo)
* [Stairway to Database Design](http://www.sqlservercentral.com/stairway/72400/)
* [Designing Databases - A few Microsoft references](https://technet.microsoft.com/en-us/library/ms187099%28v=sql.105%29.aspx)
* [Too many ads, but looks decent](http://en.tekstenuitleg.net/articles/software/database-design-tutorial/intro.html)
* [Ten common database design mistakes, and how to avoid them](https://www.simple-talk.com/sql/database-administration/ten-common-database-design-mistakes/)
* [Some great StackOverflow replies on common mistakes](http://stackoverflow.com/questions/621884/database-development-mistakes-made-by-application-developers?rq=1)

To be honest, I didn't find one reference that summed everything up. When I was learning, I bounced around between various references. Also, I still have no idea what I'm doing, but I enjoy (the illusion that I'm) learning.

When looking for references, some DBA's scoffed when asked for a quick reference. "Quit taking shortcuts and read a book!"  If only we had the time.