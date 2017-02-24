---
layout: post
title: "Quick Hit&#58; Fun with Sorting"
excerpt: "@{ e = Get-UglyCode }"
tags: [PowerShell, Quick, Snippet]
modified: 2017-02-24 07:00:00
date: 2017-02-24 07:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /sort/sorting.gif
---
{% include _toc.html %}

## Rambling

So!  I'm updating a squid file to remove some duplicate URLs that break things, when my mild OCD gets the better of me.  These damn URLs are not in order!

Rather than resorting to a few GNU tools, I realized I could use [PowerShell from my Mac](https://github.com/powershell/powershell).

## Sorting URLs

We'll use the following URLs in our examples:

```powershell
$URLs = 'dept55.host.tld',
        'dept1.host.tld',
        'some-other-host.net',
        'a.dept55.host.tld',
        'first.com'
```

We'll try the obvious `Sort-Object` first:

```powershell
$urls | Sort-Object

# a.dept55.host.tld
# dept1.host.tld
# dept55.host.tld
# first.com
# some-other-host.net
```

Nope nope nope.  I want my dept55 subdomains grouped together.  Also, first.com should come before anything host.tld.

It looks like we need to sort by pieces of this string.  How do we do that?

### Custom Sorting

#### Calculated Properties

You might be familiar with calculated properties.  The syntax is ugly, but they're incredibly helpful, and we can always use snippets!

```powershell
New-IseSnippet -Title "Calculated Property" -description "Create a calculated property" -text '@{ label = ""; expression = {} }' -Author Blah -CaretOffset 12 -ErrorAction SilentlyContinue -force
```

Shorthand, we can just use `@{ l=@{}; e=@{} }`.

That's a bit ugly, but let's show what this can do:

```powershell
$Example = [pscustomobject]@{
    One = 1
    Two = 2
}

$Example

# One Two
# --- ---
#   1   2

$Example | Select-Object *, @{l='Five';e={5}}, @{l='Multiple';e={$_.Two * 2}}

# One Two Five Multiple
# --- --- ---- --------
#  1   2    5        4
```

Pretty cool!  We can add properties to an object - they can be static (`Five`), or can use logic along with other properties of the object (`Multiple`).

Do keep in mind this kills the fidelity of the object.  You get the properties, but none of the methods on the resulting selected object.  If you need to keep your object pristine, you can use `Add-Member`:

```powershell
Add-Member -InputObject $Example -Type NoteProperty -Name Five -Value 5
Add-Member -InputObject $Example -Type NoteProperty -Name Multiple -Value ($Example.Two * 2)

$Example

# One Two Five Multiple
# --- --- ---- --------
#  1   2    5        4
```

Wait... weren't we talking about sorting?

#### Custom sorting

So!  With a calculated property, we provided a name and expression.  When sorting, all we need is the expression scriptblock:

```powershell
$Urls | Sort-Object @{ e={ ($_ -split '\.')[-2] } }

# first.com
# a.dept55.host.tld
# dept55.host.tld
# dept1.host.tld
# some-other-host.net
```

That's a start!  What happened?  We basically said to sort by...

* Splitting the items on `.`.  Split uses regex, so we escape the `.`, hence `\.`
* Picking the second to last item in the array (`[-2]`): we don't want to sort on TLDs.

Hmm.  You might have noticed that even though host.tld is sorted behind first.com, dept55 is in front of dept1.  That doesn't look right!

So, we need to sort on several components, not just the host name:

```powershell
$Urls | Sort-Object @{e={ ($_ -split '\.')[-2] }}, @{e={ ($_ -split '\.')[-3] }}

# first.com
# dept1.host.tld
# dept55.host.tld
# a.dept55.host.tld
# some-other-host.net
```

We're on the way!  We sort by the second to last item, and then third to last item.

#### Refactoring

Normally, I would use the code above.  It's more readable, even if it repeats code.  That said, let's illustrate a re-usable means to handle some sorting scenarios:

```powershell
# Go a few layers deep
$URLs | Foreach-Object {
    $Array = $_ -split '\.'
    [pscustomobject]@{
        Item = $_
        2 = $Array[-2]
        3 = $Array[-3]
        4 = $Array[-4]
        5 = $Array[-5]
    }
} | Sort-Object {$_.2}, {$_.3}, {$_.4}, {$_.5} |
    Select -ExpandProperty Item

# first.com
# dept1.host.tld
# dept55.host.tld
# a.dept55.host.tld
# some-other-host.net
```

Notice we didn't use the `@{e={}}` syntax here. Turns out this is unnecessary, all we need is a scriptblock!

What happened here?

* We break the URL into an array of strings
* We create a new object that has the original item to sort, along with pieces of the array to sort on
* We sort on the pieces of the array
* We extract the item we wanted to sort

So!  Even if this isn't the best code to use for this particular situation, do keep the gist of this in mind, it can come in handy:

* Create an object with the item to sort, and properties to sort on.  Those properties might involve further logic and query results.
* Sort on the properties in question
* Extract the item you're sorting

#### Other sorting options

As with any language, there are many ways to accomplish a task.  Some folks will assemble a string that helps them sort.  Others will use type coercion and native sorting for those types ([cool example from Tim Curwick](http://www.madwithpowershell.com/2016/03/sorting-ip-addresses-in-powershell-part.html)).

While all this may seem complicated, be happy that we don't need to write our own [sorting algorithms](https://www.toptal.com/developers/sorting-algorithms)!  Unless you're a masochist that is.
