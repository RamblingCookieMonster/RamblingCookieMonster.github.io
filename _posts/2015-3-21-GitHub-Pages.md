---
layout: post
title: Moving to GitHub Pages!
excerpt: "Nothing to see here"
tags: [rambling]
modified: 2015-03-21
comments: true
image:
  feature: banner.png
  thumb: 2015-03-21/octojekyll-opt.jpg
---

When I first started blogging, WordPress.com seemed like the quickest and simplest option.

After using GitHub and a variety of other sites that use markdown, it became quite convenient to be able to copy and paste markdown between mediums. The Wordpress.com and Windows Live Writer WYSIWYG editting, and the HTML it generates, became tedious to work with.

I wanted something even simpler; [GitHub pages](https://pages.github.com/) seemed to fit the bill! [This article](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/) from Barry Clark offers a simple way to get started with GitHub Pages.

![Jekyll’s Octocat mascot. (Image credit: GitHub, Barry Clark)]({{ site.url }}/images/2015-03-21/octojekyll-opt.jpg)
*Jekyll’s Octocat mascot. (Image credit: [GitHub](http://jekyllrb.com/), [Barry Clark](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/))*

I played around with this, Julian Thilo's [Run Jekyll on Windows Guide](http://jekyll-windows.juthilo.com/), stumbled around for a bit, and landed on Michael Rose' [Minimal Mistakes theme](http://mmistakes.github.io/minimal-mistakes/theme-setup/).



There was a bit of a learning curve, and I still don't know what I'm doing, but this will simplify posting going forward. It will also let me use existing tools like GitHub and $TextEditorOfTheDay.

Cheers!



### Testing:

{% highlight powershell %}
# What will PowerShell syntax highlighting look like?
    
    Get-Help about_*  |
        Get-Random

    "This is $("ASubExpressionOperator" + ${With odd quoting}) $WithAVariable that might need to wrap"
    
    $Var = [pscustomobject]@{
        What = 1
        WillThis = "Look Like?"
    }

{% endhighlight %}

What will Gists look like?

{% gist bc4f2e1bcf1c4a44b03e %}

What will an animated gif look like?

[![What will an animated gif look like?]({{ site.baseurl }}/images/2015-03-21/appveyordsc1.gif)](https://ramblingcookiemonster.wordpress.com/2015/03/01/testing-dsc-configurations-with-pester-and-appveyor/)

EDIT:  I like it, apart from the fact that my excessive post-publication nitpicking and tweaking will be caught in commits!
