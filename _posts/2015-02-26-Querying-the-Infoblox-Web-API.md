---
layout: post
title: Querying the Infoblox Web API with PowerShell
excerpt: "A rant"
tags: [PowerShell, Tools, Integration, Infoblox, Module, Practical]
modified: 2015-02-26 22:00:00
date: 2015-02-26 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /legacy/infoblox.png
---
{% include _toc.html %}

My apologies ahead of time. This post is half rant, half discussion on the basics of using the InfoBlox Web API. A rudimentary PowerShell module abstracting this out is [available here](https://github.com/RamblingCookieMonster/Infoblox).

This is a follow-up to [my thoughts on REST APIs](http://ramblingcookiemonster.github.io/REST-PowerShell-and-Infoblox/). Today we’re going to focus more on working with the Infoblox Web API, while highlighting some of the reasons vendors should really step in and provide PowerShell modules that sit on top of their APIs.

## Getting Started: Reading

First things first; get ready to read. For every API you work with, chances are you’re going to spend more time reading than writing code. Sign into Infoblox’ support site and download the Web API documentation. *Vendors: How much time do you think your customers will spend writing functions or modules that work across API versions? Or that cover more functions than are absolutely necessary?*

Now skim through that documentation. As you spend more time working with REST APIs, you’ll pick out the important bits. Sadly, there is little consistency between the various REST implementations; chances are you can borrow snippets of PowerShell code between solutions, or that you might find examples online, but the conventions and syntax for accessing and interpreting output from each REST API will vary wildly.

Thankfully, the basics are summed up in the first twelve pages. The remaining 800+ are relegated to describing some examples, and the various objects we can work with, which you can selectively review later.

## Key ingredients

We need a few ingredients to start:

* SSL. Ideally you have this set up. For a quick, less secure start, [consider this solution](http://stackoverflow.com/a/15841856/3067642)
* The Web API version, which Infoblox uses in the base URL
* A base URL. In general it looks like this: https://FQDN/wapi/v1.6/
* A credential with access to the Infoblox
* The ability and motivation to read lengthy, verbose documentation

## Authentication

We need to figure out how to authenticate. Most APIs provide a method to create a token, session, or some other persistent state. Others force you to authenticate with each request.

Some APIs require you do obfuscate the password in some way, and construct a header per their specifications. I’ve even seen specs requiring you to generate a header, generate a hash for that header, and use that hash in the real header.

Reminder: use SSL, obfuscation is not secure. Be wary of the misuse of the word ‘encryption’. Base64 encoding is neither encryption nor secure. Thankfully, with the Infoblox we can pass in a standard PSCredential object and leverage HTTPS.

Let’s try to hit the Uri without specifying a resource:

![bad request](/images/legacy/ibAuth.png)

No luck. The documentation explains that a 400 error is essentially your fault. Let’s try with an object. Something basic, like the grid itself:

![ref](/images/legacy/ib_ref.png)

Voila! We’re all done, right? What if we have to make a large number of calls. Would a session be more efficient?

Let’s open up the API documentation. Ctrl+f ‘Session’. Nothing relevant. Ctrl+f ‘Token’. Nothing relevant. Ctrl+f ‘Cookie’ – got it! There’s a brief mention in the authentication section. I’m hoping we can use the SessionVariable parameter from our Invoke-RESTMethod or Invoke-WebRequest call.

If you’re lucky, you can google around and find a working example. In this case, I was able to look at Don Smith’s [REST-PowerShell wrapper](https://github.com/Infoblox-API/REST-PowerShell/blob/master/wrapper/Infoblox.ps1). It’s not very PowerShell-y, but it has some examples which come in handy. Borrowing from this, we wrote an ugly [New-IBSession](https://github.com/RamblingCookieMonster/Infoblox/blob/master/Infoblox/New-IBSession.ps1).

Relatively painless so far; we already know how to authenticate and pull data! But we’re looking at a single API among many, each of which has its own peculiarities and implementation details. Let’s see if there’s more to pulling data than meets the eye.

## GETting data

Time to start looking at the data which we actually care about. Each web API will expose different objects to you. In this case, we have 720 pages describing the objects and their various properties. Somewhat painful, but verbose documentation beats no documentation. Wouldn’t it be nice if we had the discoverability and reflection you get with PowerShell?

Let’s pretend we want a DHCP lease address and binding state. We look through the objects, and we see “lease: DHCP Lease object”. Submit a GET request for this:

![Bad request](/images/legacy/ibBadRequest.png)

I have a bad feeling about this. I just want a lease, what’s going on? Let’s try another obvious object, a network:

![Network](/images/legacy/ibNetwork_ref.png)

Bizarre – I got data back! I dive back into the documentation. The 400 error is generic, but let’s search for it anyways. Ah ha! In the GET method section, we see specific error handling notes. A 400 error means there were too many results.

To whittle down the results, we need to dive into some domain specific CGI that will help provide no value to you outside of these Infoblox API calls. With PowerShell, if I spend some time learning the ins-and-outs of the language, it helps me whether I’m working with AD, VMware, or SQL. *Vendors: if your competition offers a decent PowerShell module, it might swing my vote.*

Time for more reading. Long story short, you need to implement paging. In this case, I say _paging=1, and I specify an appropriate _max_results; I chose 1000. The first page of results includes a next_page_id. I use this to quantify my next call to the Infoblox, rinse and repeat until the Infoblox doesn’t provide me a next_page_id. My implementation is crude, but you can see this in the logic of [Get-IBLease](https://github.com/RamblingCookieMonster/Infoblox/blob/master/Infoblox/Get-IBLease.ps1).

Reading the documentation, we see we can call _max_results=[positive number] and it will truncate results, rather than error out:

![Max results](/images/legacy/ibMaxResults.png)

Woohoo! I got a _ref, an address, and a network_view. That’s not what I’m after. At the very least, I want the binding state for that lease, and I want a way to filter the results.

## Filtering

Time for more reading, and more CGI on the end of that Uri. It’s up to you again to invest time learning Infoblox’ specific method of picking out properties to return, and filtering results in an API call.

For each object, the documentation will describe a property, including whether and how you can filter for it:

![Address filter](/images/legacy/ibAddress.png)

Hopefully the property you want to filter is searchable! We wanted to look at binding_state, perhaps to see if we have free leases. No luck:

![Not searchable](/images/legacy/ibNotSearchable.png)

Let’s find another example for filtering. There are plenty more; in this case, I’m searching for leases that were discovered in the past two days (Epoch time is used):

![Get](/images/legacy/ibGet.png)

Again, crudely implemented, but you can see the construction of these CGI queries and the resulting Uri in the [Get-IB* commands](https://github.com/RamblingCookieMonster/Infoblox), and using verbose output, respectively.

## Picking and choosing data

You guessed it, time for more reading! At this point, it should be clear that if you want to work with a vendor’s API, you’re probably going to spend a great deal of time reading. *Vendors: at this point, your customers may be tired. They struggled through figuring out your authentication mechanism, your object model, your unique query syntax, your unique interpretations of error codes. They might not spend much time on important details like error handling, testing, or covering functionality that they don’t have immediate plans for. What if this causes an outage and leaves your brand with a black eye? What if your customers realize they are spending valuable time designing and implementing functions that you could be creating for us?*

Back to the task at hand; we want to pull different properties. Reading the documentation, we see that you simply specify _return_fields=comma,separated,list:

![Return fields](/images/legacy/ibReturnFields.png)

Here’s an example call to Get-IBLease with verbose output. It specifies a few default properties I find helpful, and allows filtering on properties like address (~= operator) and discovered_data.last_discovered. Yes, this might be too verbose:

[![Get-IBLease](/images/legacy/ibGet-IBLease.png)](https://ramblingcookiemonster.files.wordpress.com/2015/02/clip_image009.png)

There are a few other commands in the module, including a generic Get-IBObject. Perhaps you want to search for IPAM entries (IPv4Address) between two addresses:

![Get-IBLease filter](/images/legacy/ibFilters.png)

## POSTs, PUTs, and DELETEs

Just kidding. Hopefully you’ve learned enough to go back and learn how to work with the Infoblox beyond GET requests.

## How do we fix this?

I want to emphasize that this post is not targeting Infoblox specifically: as far as REST APIs go, theirs has been solid. If you’re working with a modern product, chances are it has a web API of some sort. Some vendors do provide a PowerShell module to abstract out the painful process we went through above, but many do not.

I submitted a few potential suggestions in my closing section of [the previous REST API post](http://ramblingcookiemonster.github.io/REST-PowerShell-and-Infoblox/). What do you think? Is this even an issue? Any suggestions on fixing it? What can we do to encourage vendors to provide more than a few simplified examples of hitting their API through PowerShell?

On a side note, if your answer involves a specific vendor’s specific version of an orchestration product, and the specific third party extensions for this, please do not reply : )

Thanks to Don Smith and Anders Wahlqvist for their [helpful examples](https://community.infoblox.com/forum/ddi/started-working-powershell-module).

Cheers!