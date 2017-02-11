---
layout: post
title: Moving to GitHub Pages!
excerpt: "Nothing to see here. What will happen if the excerpt is pretty lengthy? Will it wrap around nicely, or do something evil? Let's find out."
tags: [Rambling]
modified: 2015-03-21 00:00:00
date: 2015-03-21 00:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /2015-03-21/octojekyll-opt.jpg
---
{% include _toc.html %}

When I first started blogging, WordPress.com seemed like the quickest and simplest option. Simple is good; the fewer barriers to writing, the more writing you can do!

After using GitHub and a variety of other sites that use markdown, it became quite convenient to be able to copy and paste markdown between mediums. On top of this, the Wordpress.com and Windows Live Writer WYSIWYG editting, and the HTML it generates, became tedious to work with.

I wanted something even simpler; [GitHub pages](https://pages.github.com/) seemed to fit the bill! [This article](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/) from Barry Clark offers a simple way to get started with GitHub Pages.

<img src="/images/2015-03-21/octojekyll-opt.jpg" width="256">

*Jekyll’s Octocat mascot. (Image credit: [GitHub](http://jekyllrb.com/), [Barry Clark](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/)*

I played around with [Jekyll-Now](https://github.com/barryclark/jekyll-now), Julian Thilo's [Run Jekyll on Windows Guide](http://jekyll-windows.juthilo.com/), stumbled around for a bit, and landed on Michael Rose' [Minimal Mistakes theme](http://mmistakes.github.io/minimal-mistakes/theme-setup/).

There was certainly a bit of a learning curve, and I still don't know what I'm doing, but this will simplify posting going forward. It will also let me use existing tools like GitHub and $TextEditorOfTheDay.

Cheers!



### Testing:

#### Pygments syntax highlighting test

```powershell
# What will PowerShell syntax highlighting look like?

    Get-Help about_*  |
        Get-Random

    "This is $("ASubExpressionOperator" + ${With odd quoting}) $WithAVariable that might need to wrap"

    $Var = [pscustomobject]@{
        What = 1
        WillThis = "Look Like?"
    }

```

#### Embedded Gist test

{% gist bc4f2e1bcf1c4a44b03e %}

#### Anlimated gif test

[![What will an animated gif look like?]({{ site.baseurl }}/images/2015-03-21/appveyordsc1.gif)](https://ramblingcookiemonster.wordpress.com/2015/03/01/testing-dsc-configurations-with-pester-and-appveyor/)

One caveat... my excessive post-publication nitpicking and tweaking will be caught in commits! Okay, two caveats. I forgot how tedious HTML and CSS can be when you aren't familiar with them and take the trial and error approach.  Thankfully that piece is site specific and not needed for each post!
