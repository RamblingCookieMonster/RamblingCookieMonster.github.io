---
layout: post
title: Decorating PowerShell Objects
excerpt: "Shiny things"
tags: [PowerShell, Tips, Tools]
modified: 2015-06-22 18:00:00
date: 2015-06-22 18:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /decorating/CookieDecorations.png
---
{% include _toc.html %}

### Rambling

I recently ran a quick survey on source control for IT professionals. While drafting up some notes on the [results](http://ramblingcookiemonster.github.io/Source-Control-Survey/), I was pleasantly surprised to find that Atlassian had a free [community license](https://www.atlassian.com/software/views/community-license-request) for non-profits and charitable organizations.

After an awesome co-worker helped out with the implementation, [Stash](https://www.atlassian.com/software/stash/), a git-based source control solution with a RESTful API, was up and running. Despite [my thoughts on REST APIs](https://ramblingcookiemonster.wordpress.com/2015/02/07/rest-powershell-and-infoblox/), I like to poke around unfamiliar technologies and solutions through PowerShell - time for a [POC Stash PowerShell module](https://github.com/RamblingCookieMonster/PSStash)!

After some quick and dirty code, I had output... but it was quite ugly:

[![Ugly Repo Output](/images/decorating/RepoUgly.png)](/images/decorating/RepoUgly.png)

Let's look at what we can do to tame this output into something more readable, like this:

[![Default Repo Properties](/images/decorating/Get-StashRepo.png)](/images/decorating/Get-StashRepo.png)

Along the way, we'll cover setting default properties, adding your own type names, and a tool to simplify all of this.

### Type Names

One of the most important commands you learn in PowerShell is Get-Member. This can give you a wealth of information on the objects you are working with, including the type of these objects:

![Get-Member](/images/decorating/GetMember.png)

In this case, we see that Get-Date gives us a System.DateTime.

So, why would we want to add a custom type name to our objects? Jason Morgan pointed out two good reasons [here](https://jasonspowershellblog.wordpress.com/2014/04/04/giving-type-names-to-your-custom-objects/):

* Custom Formating: You can write (or borrow) 'format' files to define the default display for your custom types.
* Object filtering and pipeline support: If your objects have a specific type, you can filter them appropriately and better support pipeline input.

The code isn't pretty, but inserting a type name only takes a single line. Here's a quick example:

{% gist f83268daca1ed373f35a %}

![Nonsense type](/images/decorating/NonsenseType.png)

We have a type name in there, let's take a look at what we can do with it.

### Formatting Your Objects

If you use PowerShell, you know that objects don't always show their hand. You might need to explore a bit with Get-Member, Select-Object, or [Show-Object](http://www.powershellcookbook.com/recipe/bpqU/program-interactively-view-and-explore-objects).

When we run Get-ChildItem against C:, we only see a few properties:

![Nonsense type](/images/decorating/DefaultGCIDisplay.png)

We know there are many more - How does PowerShell know how to format these? Jeffrey Snover wrote [a quick bit](http://blogs.msdn.com/b/powershell/archive/2010/02/18/psstandardmembers-the-stealth-property.aspx) on this a while back: PowerShell checks for format files, a DefaultDisplayPropertySet, and then falls back to all properties.

Let's look at the first two.

#### DefaultDisplayPropertySet

Like adding a type name, this is a bit ugly, but it's pretty straightforward to copy, paste, and tweak as needed.

Here's a snippet adapted from [Shay Levy's abstraction](http://blogs.microsoft.co.il/scriptfanatic/2012/04/13/custom-objects-default-display-in-powershell-30/).

{% gist f03aeeae705cbb218a83 %}

Whew! That was ugly, but it worked:

![DefaultDisplayPropertySet](/images/decorating/DefaultDisplayPropertySet.png)

Not only was this ugly, it was inefficient. We added this to a single object, and would need to repeat the Add-Member line for every object we want to format. How can we get around this?

#### Format.ps1xml

Time for some fun with XML! Run Get-Help [about_Format.ps1xml](https://technet.microsoft.com/en-us/library/hh847831.aspx) for more detailed help on this.

Long story short, we can borrow a format.ps1xml file, modify it to meet our needs, and use it to define the default properties (and more) for any object of a certain type. This was a big reason behind why we wanted to add custom type names.

You can dive into [MSDN](https://msdn.microsoft.com/en-us/library/gg580944.aspx), or you can get started quickly by borrowing someone else's work. This snippet will open up the format ps1xml for events:

```powershell
ise $PSHOME\Event.Format.ps1xml
```

I cut out the bits I don't care about - everything but one view node. Let's substitute out the TypeName for our own:

```xml
<TypeName>Some.Nonsense.Typename</TypeName>
```

We don't want any grouping, so we can cut the GroupBy section out.

Now we can just play with the table headers and table rows. [Here's the resulting ps1xml](https://gist.github.com/RamblingCookieMonster/10aeb2d4c41698cc2c86) - it might look scary, but it's literally copy and paste, with a few minor tweaks.

We have a few options to get this format into our session. First, let's just add the TypeData on the fly:

{% gist dc7732c3e958828097e7 %}

![Nonsense Display](/images/decorating/NonsenseDisplay.png)

It worked! We didn't need to mess around with DefaultDisplayPropertySet for every single object, all we did was add a TypeName, and PowerShell took care of the rest.

If you're writing a module, it's even simpler. Just specify the path to the format file(s) in the module manifest. Here's an example from the [PSStash psd1 file](https://github.com/RamblingCookieMonster/PSStash/blob/master/PSStash/PSStash.psd1):

```powershell
# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('PSStash.Format.ps1xml')
```

### Reusable Tools

One of the great benefits to code in general is the ability to abstract out seemingly complex tasks into [reusable tools](http://ramblingcookiemonster.github.io/Invoke-Ping/). PowerShell was explicitly designed as a task-based language; for example, rather than needing to know the code behind how to sort objects, we have the task-based Sort-Object command in our toolbelt. The code to decorate objects above wasn't pretty, let's look at a simple to use tool that abstracts out the boring bits.

#### Add-ObjectDetail

We can boil all the logic and .NET calls down to a single function: [Add-ObjectDetail](https://raw.githubusercontent.com/RamblingCookieMonster/PSStash/master/PSStash/Private/Add-ObjectDetail.ps1). Download the ps1 and dot source it as needed. Here are a few examples:

{% gist 5382417d8d248a24b564 %}

We can add type names, set default properties, and add new properties. The last piece is more for convenience; rather than calling Add-ObjectDetail along with another function to add properties, we can do it all at once.

That's about it! You can use this to make your tools easier to use for end users and yourself. The function could likely use some work; it was written for the POC Stash module, but it seems to do the trick.

Cheers!


*Disclaimer*: Thumbnail credit to [PBS](http://www.pbs.org/parents/kitchenexplorers/2013/06/27/how-to-decorate-cookie-monster-cupcakes/)