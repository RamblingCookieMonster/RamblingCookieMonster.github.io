---
layout: post
title: Quick Hit&#58; How Can I Verify Column Types?
excerpt: "Conversion Failed"
tags: [PowerShell, Rambling, Tool, Function, SQL]
modified: 2015-05-30 22:00:00
date: 2015-05-30 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /Column-Types/ducktype.png
---
{% include _toc.html %}

### Rambling

Many languages out there force you to declare types; for example, ```int x;``` or ```string y = "hello world";```.

PowerShell is easy going. It's dynamically typed - If you run ```$x = 5```, the parser will see that $x should be an integer. If you run ```$y = 'Hello world'```, the parser would see that $y should be a string.

To make things even easier for you, PowerShell will try to finagle types into whatever it thinks they should be - it's type-promiscuous. If I run ```Get-Date -Date "1/1/2000"```, the parser sees that the Date parameter expects a DateTime, and even though we provided a string, it will attempt to convert "1/1/2000" to a fully fledged DateTime.

Why am I rambling on about types? It turns out other languages and technologies might not be as forgiving as PowerShell. You might end up in a situtation where your data needs to be a specific type in PowerShell, before sending it off to another system. SQL is a great example.

How can we verify what types we are working with?

### Exploring Types

PowerShell gives us plenty of tools for introspection. Let's take a quick peak at a few of these.

#### Exploring with Cmdlets

The most common way to explore an object is the Get-Member command. You can use this to explore below the surface of your output. Take a look at a DateTime object:

```powershell
# Look at the methods and properties on a DateTime object from Get-Date:
Get-Date | Get-Member
```

If you run this, you will find a wealth of information; there's are DayOfWeek, Millisecond, Month and many other properties, along with methods like AddDays and ToUniversalTime.

Hopefully you already knew this! Get-Command, Get-Help, and Get-Member are three major pillars of discovery and exploration in PowerShell.

These commands are fantastic, but what if you want to dive in deeper? You'll need to start working with .NET Reflection.

#### Exploring with .NET Reflection

We'll only poke the surface of .NET Reflection, but this is a powerful tool to explore underneath the covers:

{% gist abedae07e7daed270f79 %}

Google around, and you will find a trove of interesting and esoteric examples using .NET Reflection in PowerShell. You might find a post on [exploring types and enums](http://ramblingcookiemonster.github.io/Types-And-Enums/).

Let's look at a more practical example, and see if we can verify what types we have on some data we want to send to SQL.

### Get-PropertyType

A while back, I kept running into scenarios where I would have a collection of data to send to SQL... Everything seemed in order, but there would occasionally be a handful of rows to insert that had the wrong property type. SQL might bark at you when this happens.

Rather than dealing with these on a case by case basis, I wrote a quick tool to validate the property types of every object in an array - [Get-PropertyType](https://gallery.technet.microsoft.com/scriptcenter/Get-PropertyType-546b9eeb).

Let's take a look at it in action:

{% gist e9745b18a34e4b8dedd1 %}

![Get-PropertyTypes](/images/Column-Types/Get-PropertyTypes.png)

That's not too exciting; let's toss a wrench in there:

{% gist 55f6b33a30a5c1910d8f %}

Now what happens?

![Gremlins](/images/Column-Types/Gremlins.png)

No good! We have both strings and booleans now. Let's pretend there were actual gremlins and we have no idea which row has a column with the wrong type. How do we find the offending object?

{% gist 8838561a159a67a4ce8f %}

![Offender](/images/Column-Types/Offender.png)

That's it! You can use [Get-PropertyType](https://gallery.technet.microsoft.com/scriptcenter/Get-PropertyType-546b9eeb) to quickly validate that all the objects in your collection have consistent or expected property types.

### Behind the Scenes

What's going on behind the scenes? It's fairly straight forward. We get a list of property names, and we keep track of what types we see for each of these properties.

If you haven't seen it, there's a nifty trick we use to get the properties. Every PowerShell object has a magical hidden [*PSObject* property](http://blogs.msdn.com/b/besidethepoint/archive/2011/11/22/psobject-and-the-adapted-and-extended-type-systems-ats-and-ets.aspx). Rather than parse output from Get-Member, we use this PSObject property.

For example, you could look at the properties of the $Date object we created earlier: ```$Date.PSObject.Properties```

One major benefit to using PSObject.Properties is that it returns the property names in the order you would typically see them. Get-Member only gives you alphabetized output.

If you poke around, you might find other helpful members of PSObject, like the PSObject.Copy() method.

That's about it! If .NET Reflection and the strange PSObject property intrigue you, be sure to check out Bruce Payette's [PowerShell in Action](http://www.manning.com/payette2/). It targets PowerShell 2, but it contains a trove of information still applicable today. Thankfully, we might see a sequel!

[![Action](/images/Column-Types/Action.png)](https://twitter.com/brucepayette/status/476491667185213440)



*Disclaimer*: Nothing here can be classified as [duck typing](http://en.wikipedia.org/wiki/Duck_typing). All this talk of types just reminded me of [this](https://twitter.com/mmastrac/status/536332443398057984).