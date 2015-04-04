---
layout: post
title: SQLite and PowerShell
excerpt: "A simple module for SQLite queries via PowerShell"
tags: [PowerShell, SQL, Module, Tools, SQLite]
modified: 2015-04-04 13:00:00
date: 2015-03-22 13:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /2015-03-22-2/sqlite.gif
---
{% include _toc.html %}

I’ve been planning on sharing some fun projects that involve SQL. Every time I start writing about these, I end up spending a good deal of time writing about MSSQL, and thinking of all the potential caveats that might scare off the uninitiated. Will they have an existing SQL instance they can work with? Will they have access to it? Will they run into a grumpy DBA? Will they be scared off by the idea of standing up their own SQL instance for testing and learning?

Wouldn’t it be great if we could illustrate how to use SQL, and get an idea of how helpful it can be, without the prerequisite of an existing instance with appropriate configurations and access in place?

### SQLite

> [SQLite](https://www.sqlite.org/about.html) is an in-process library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.

What do you know, sounds pretty close to what we are looking for!  We want to use this in PowerShell, so where do we start?

Looking around, you’ll stumble upon Jim Christopher’s [SQLite PowerShell Provider](https://psqlite.codeplex.com/). If you like working with providers and PSDrives, this is probably as far as you need to go. There are other examples abound, including interesting solutions like Chrissy LeMaire’s [Invoke-Locate](https://gallery.technet.microsoft.com/scriptcenter/Invoke-Locate-PowerShell-0aa2673a), which leverage SQLite behind the scenes.

I generally prefer standalone functions and cmdlets over providers. I’m also a fan of abstraction, and building re-usable, simple to use tools. The task-based nature of PowerShell makes it a great language for getting things done. We can concentrate on doing what we want to do, not the underlying implementation.

I was looking for something similar to [Invoke-Sqlcmd2](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1), which abstracts out the underlying .NET logic to provide simplified SQL queries, the ability to handle SQL parameters, [PowerShell-esque behavior for DBNull](https://connect.microsoft.com/PowerShell/feedback/details/830412/provide-expected-comparison-handling-for-dbnull), and other conveniences.

### PSSQLite

I spent a few minutes with the SQLite binaries and examples from Jim and Chrissy, and simply duct-taped SQLite functionality onto Invoke-Sqlcmd2. Let’s take a look at what we can do

#### Getting Started

Download and unblock [PSSQLite](https://github.com/RamblingCookieMonster/PSSQLite), and you'll be up and running, ready to work with SQLite. Let's create a data source and a table:

{% gist bc4f2e1bcf1c4a44b03e %}

![Create a table](/images/2015-03-22-2/init.png)

That was pretty easy! We used a [SQLite PRAGMA statement](http://www.sqlite.org/pragma.html) to see basic details on the table I created. Now let's insert some data and pull it back out:

{% gist 4b86f958c41b50f74e66 %}

![Insert and Select](/images/2015-03-22-2/insertselect.png)

In this example we parameterized the query - notice that @full and @BD were replaced with the full and BD values from SQLParameters, respectively.

#### Example functionality

Let's take a quick look at using SQLite in memory

{% gist bba2ed9a7f542378d19a %}

![Memory](/images/2015-03-22-2/memory.png)

Typically, we might use Datarow output from MSSQL and SQLite queries. As you can see above, using Datarow output leads to unexpected filtering behavior - if I filter on Where {$_.Fullname}, I don't expect any results to come back with no fullname. Thankfully, we have [code from Dave Wyatt](http://powershell.org/wp/forums/topic/dealing-with-dbnull/) that can quickly and efficiently convert output to PSObjects that behave as expected in PowerShell.

We did the querying above in memory. Let's run PRAGMA STATS to see details on the in-memory data source. If we close the connection and run this again, we see the data is gone:

![Memory Gone](/images/2015-03-22-2/memorygone.png)

#### Bulk inserts

On the MSSQL side of the house, we have a .NET BulkCopy class that can speed up inserts.  [Invoke-SQLBulkCopy](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-SQLBulkCopy.ps1) is a handy abstraction of this. On the SQLite side, there is no bulk copy class.

How can we speed up inserts? Searching around, all signs point to transactions. Due to [the way SQLite handles insert statements](https://www.sqlite.org/faq.html#q19), you can see some incredibly slow performance. By completing all inserts in a single transaction, we can speed this up.

There are [C#](http://procbits.com/2009/09/08/sqlite-bulk-insert) [examples](http://www.jokecamp.com/blog/make-your-sqlite-bulk-inserts-very-fast-in-c/) [abound](http://www.schiffhauer.com/bulk-operations-in-sqlite-and-c-with-transaction/), so we need to translate these to PowerShell.

The result is [Invoke-SQLiteBulkCopy](https://github.com/RamblingCookieMonster/PSSQLite/blob/master/PSSQLite/Invoke-SqliteBulkCopy.ps1), a misnomer perhaps, but it does the trick and improves performance:

{% gist 708928ba9a4b3bae41ea %}

![Transaction](/images/2015-03-22-2/Transaction.png)

Not terrible; with 10,000 items to insert, we see a ten fold performance improvement. I suspect we could squeeze more performance out of this if someone dove into the ugly code behind the scenes and submitted a pull request!

### Next steps

That's about it! If you want simplified SQLite queries in PowerShell, check out [PSSQLite](https://github.com/RamblingCookieMonster/PSSQLite). If you delve into the MSSQL side of the house, check out [Invoke-Sqlcmd2](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1) from Chad Miller et al. It was used as the basis for PSSQLite and behaves very similarly.

Now I just have to find more time to write...

*Disclaimer*: The initial functions were written the first day I had worked with SQLite. If I'm missing any major functionality, or you see unexpected behavior, contributions or suggestions would be quite welcome!