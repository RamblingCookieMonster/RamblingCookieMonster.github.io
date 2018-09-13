---
layout: post
title: "Quick hit&#58; PoshBot Useability"
excerpt: "Forget those PowerShell best practices"
tags: [PowerShell, ChatOps, DevOps, PoshBot, Quick]
modified: 2018-09-13 07:00:00
date: 2018-09-13 07:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /poshbot/NoMonad.png
---
{% include _toc.html %}

## Rambling

So!  First post in a year.  Guess setting up the _Quick Hits_ section was totally worth it : )

It's been a great year!  On top of various fun with PowerShell, keeping up with a two-year-old destroyer-of-all-the-things, and having a new destroyer-of-all-the-things in training, I've spent a good bit of time exposing handy tools in Slack via [PoshBot](https://github.com/poshbotio/PoshBot), an awesome bot framework by [Brandon Olin](https://twitter.com/devblackops)

We've been using PoshBot for over a year (see: [last post](http://ramblingcookiemonster.github.io/PoshBot/)), and we finally have Microsoft Teams support in PoshBot - figured I'd try to lay out some practices and tooling I've found helpful in case it would help anyone!

## Isn't PoshBot Just PowerShell?

Nope.  Not.  At.  All.  Let's start out with what we don't have:

* **No tab completion**.  Quick discovery and command/parameter validation simply isn't a thing
* **No pipeline**.  Yet
* **Output needs more consideration**.  Unless you want to make your rooms unreadable

So!  What does this mean?  How can we make this more usable?

## No Tab Completion

Get ready for co-workers who can't remember, or mistype commands and parameters all the time.  Heck, I write most of our plugins, and do this all the time.  What can we do about it?

### Use aliases

How do I force AD replication?  `!syncad`?  `!adsync`?  Something else?  Here's the thing:  aliases are free.  If you see a very common mistyped variant, and if it makes sense and won't be confusing now or when you add more commands, go ahead and add it!

### Keep it short

Verbosity is king in PowerShell.  With no tab completion to help discovery and spelling?  Keep it short!  Reserve single character aliases for your most popular commands and parameters.  Expand as needed.  Again, you can always leave the actual command name in a PowerShell `Verb-Noun` format, but do use short aliases for chat.

Don't forget parameters!  Want to specify properties?  `-p` is a nice shorthand for `-property`, for example.

### Keep it consistent

This goes for PowerShell as well.  If you have a parameter that offers the same functionality in many commands, be sure you also give it the same name and aliases in every command.  With no tab completion, this simplifies memorization, and lets us extrapolate syntax and naming from other commands.

### Make it easy

A busy command definition is much nicer than forcing a user to run a busy command.  Abstract things out.  For example...

You want to query users from Active Directory.  What are some common criteria?  Not everyone will want to type raw ldap queries in chat.  Can you inspect parameter values and make assumptions (clarifying in the help for each parameter)?  For example:

* `!u wframe`: Get users with identity wframe
* `!u wframe@g.something.edu`:  Get users with mail wframe@g.something.edu
* `!u 12345`:  Get users by UID
* `!u 'warren frame'`:  There's a space!  Use [ambiguous name resolution](https://social.technet.microsoft.com/wiki/contents/articles/22653.active-directory-ambiguous-name-resolution.aspx)

Positional parameters are also quite helpful, for your most commonly used parameters.

### Give good examples

Comment based help examples should already be the norm, but be sure to do a solid job showcasing these - I tend to use full command/parameter names in the first example, and the easiest shorthand thereafter.  Reading help is a bit more painful in chat.  Examples give you a quick way to say _ah, this is exactly what I need to do!_

## No Pipeline

### Do everything in your command

So!  Forget the Monad Manifesto and PowerShell best practices for now.  You can't pipe.  Want specific properties back?  Include a `-Property` (`-p`) parameter.  Want to format data as a table, list, csv, or something else?  Include a `-Format` (`-f`) parameter.  Think about other common needs.

Once you gather up a common group of parameters, strongly consider adding them to every PohBot command they apply to - no output on a command?  Yeah, probably don't need `-Format` (`-f`) on that one.

### Format things for the user

So!  We just mentioned this.  We can't just pipe to `Format-Table` or `Export-Csv` in chat.  You probably want some common format options via `-Format` (`-f`).  Tables.  Lists.  CSVs.  Pretty spreadsheets with tables.  No one wants a command that spams a room with unnecessary lines of text or whitespace - give folks only what they need.

Be opinionated!  For example...

* Did they use wildcards or some other fuzzy search and get a bunch of results?  Bundle it into a CSV, or into a table with only the properties they would need to get the details to query further (e.g. `userprincipalname`, `displayname`, `mail` for an AD user)
* Is the text-based representation of the output longer than you want in the channel (e.g. > 8000 characters)?  Switch `Format` over to something like a CSV, which Slack does not truncate
* Is the output a single item with a single property on it?  Expand it!  Do include the property name to help tie the output back to the command
* Is there something abnormal in the output that should be highlighted?  Consider doing so!  Are there disabled users in your output?  Consider listing them out (alphabetically of course) in a warning, ahead of the command output
* Is there output that generally isn't needed?  Consider excluding it by default, and adding a switch to override - (e.g. AD group membership data might exclude disabled users by default)

## Output needs more consideration

### Pick sane defaults

`Get-ADUser` gives me back DistinguishedName, Enabled, GivenName, Name, ObjectClass, ObjectGUID, SamAccountName, SID, Surname, and UserPrincipalName.  Different folks have different needs, but I'm guessing most of us don't care about _most_ of those properties.  Including them in chat, with it's limited character width and ugly wrapping behavior, would be painful.

Pick sane properties to return by default, and allow the user to specify more properties (ideally, support `-Property *` to allow discovery).  Pick a sane property to sort on by default, if that makes sense.  Pick a default format (e.g. table, csv, list) based on the most common use of a command.

Be sure to consider your chat system's line wrapping.  Using Slack message attachments (common)?  You get ~78 characters.  Can you get away with a table?  Will some data make your output unreadable?  You can always adjust things as you see issues pop up in chat.

### Don't spam

Just don't.  Already mentioned this, but be sure to inspect your output.  Recent PSSlack changes added support to handle rate limiting, but still, you don't want to destroy the usability of whatever channel you're chatting in!

There are many ways to do this.  I tend to globally say _if the string output is longer than 8000 characters, you get a CSV or whatever file type is appropriate_.  Slack truncates messages.  Larger items fit much more nicely in a file

Also, be careful with errors.  PoshBot will pick up errors and send them to chat.  Any intentional manipulation of output you do is completely ignored at that point.  Let me get this big list of group members!  Oops.  Formatting error on each of the 100 members that came back.  Slightly embarrassing : )

## That's a whole bunch of work!

Perhaps.  Most of this is just thinking about how folks will use the tools you write, and accommodating a platform that doesn't come with the niceties of a CLI.

Just consider:  If you don't spend a little time thinking about this, you might lose out on the benefits of ChatOps - folks might start simply using direct messages instead of actually working in-line with chat.  Some folks might get frustrated if you have inconsistent parameter names, or only a single command name that they forget every time.

Also... I don't know about you, but I love convenience.  Much of this is bad practice in PowerShell, given that we can use everything in the pipeline, but here you can get as opinionated as you'd like, while still doing the right thing and making life easier for you

### Is there an Easy button?

Not really.  Most of this will become apparent as you use PoshBot.  Just start using PoshBot.  See what works.  Ask around to see what you can improve.  Don't turn your nose up at ideas that fly in the face of PowerShell best practices - ChatOps is a different context.

I've written a module that can make things a little easier, but it's ugly, and might not fit your needs.

I tend to write all of my functions with a set of their own _common parameters_ like `-Format` or `-Property`.  I then pass any output from a PoshBot command to `ConvertTo-PoshBotResponse`, a function that knows how to parse these common parameters, checks for lengthy output and switching to CSV, and other niceties.

I'll publish the code and write a short bit on this soon!

### You're Wrong!

What do you think?  Do these practices make sense for bot commands?  Do you have other good practices to follow?  Are any of my suggestions misguided?  I'll try to include a summation in my next post!

That's it for today!  It's been a while so I'll mention a few things I think you should check out:

* [Michael Lombardi](https://twitter.com/barbariankb) and I recently started [PSPowerHour](https://github.com/PSPowerHour/PSPowerHour).  Basically, 8 people do lightning demos on something fun.  It's a great, low-pressure way to show off something fun and get experience speaking.  Do submit a proposal!
* I'm working with [Missy Januszko](https://twitter.com/thedevopsdiva) on content for the 2019 PowerShell + DevOps Global Summit - We have some awesome sessions lined up, but need more - do consider [submitting a proposal](https://powershell.org/2018/09/01/getting-feedback-on-powershell-devops-global-summit-proposals/)!
* [Mike Robbins](https://twitter.com/mikefrobbins) put together an amazing PowerShell book [for a good cause](https://twitter.com/barbariankb/status/1015273736763822080).  It's available on [leanpub](https://leanpub.com/powershell-conference-book) and now [Amazon](https://www.amazon.com/dp/1720169977/) - do check this out!