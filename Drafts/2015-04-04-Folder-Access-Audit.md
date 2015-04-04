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

* We can pull all of our computers from Active Directory or an inventory database.
* We can [quickly identify](http://ramblingcookiemonster.github.io/Invoke-Ping/) which systems are up and running and accessible over SMB.
* We can list all folders very quickly with a robocopy wrapper, Get-FolderEntry
* We can use various tools, from Get-ACL to the fantastic [NTFSSecurity module](https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85) to list ACEs on the targets.
* 