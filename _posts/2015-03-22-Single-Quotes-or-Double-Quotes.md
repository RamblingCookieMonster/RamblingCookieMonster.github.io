---
layout: post
title: Quick Hit&#58; Single or Double Quotes?
excerpt: "Is differentiating these truly a best practice?"
tags: [Quick hit, PowerShell, Best Practice, Rambling]
modified: 2015-03-22 10:00:00
date: 2015-03-22 10:00:00
comments: true
image:
  feature: banner.jpg
  thumb: /2015-03-22/DutyCalls.png
---
{% include _toc.html %}

A few weeks back, Adam Bertram posted a blasphemous, code formatting declaration of war, along with a tip to use single quotes over double quotes if expansion is not needed.  We'll ignore the blasphemy here.

![Blasphemy!](/images/2015-03-22/InciteorInsight.png)

### Duty calls

[![Duty Calls](/images/2015-03-22/DutyCalls.png)](http://xkcd.com/386/)

I had previously tried the otherwise excellent [ISESteroids](http://www.powertheshell.com/isesteroids/) and was a bit perturbed when I was told my tendency to use double quotes for everything failed best practices!

I dutifully posted a friendly reply to Adam, ignoring the blasphemous formatting comment.

![Duty](/images/2015-03-22/Duty.png)

### Time and mistakes

My viewpoint: I make changes. A lot. If I start out without needing to expand a variable and use single quotes, chances are I might revisit and realize I want a variable expanded.

Now I need to spend time converting single quotes to double quotes. Here's the thing: I'm a lot slower and more likely to make mistakes than a computer. So I generally start with double quotes and don't worry about it.

It turns out there are other viewpoints.

### Readability

Kirk Munro brought up the importance of readability.

![ReadReason](/images/2015-03-22/ReadReason.png)

There are too many scenarios to cover, but let's look at a few:

Using the PowerShell ISE:

![ISE Readability](/images/2015-03-22/ReadableTestISE.png)

Using Sublime Text 3 with [PowerShell syntax highlighting](https://github.com/SublimeText/PowerShell):

![ST3 Readability](/images/2015-03-22/ReadableTestST3.png)

Okay! I use the ISE, and have no trouble whatsoever differentiating strings that have something in them from strings that do not. That being said, not everyone uses the ISE. Even solid alternatives like Sublime Text leave a bit to be desired here (perhaps it's just my setup?). Point for Kirk.

Also, while most regular PowerShell users have a firm grasp on the difference between single and double quotes, beginners may not. No points for this. If you take visual cues, and I'll assume everyone writing PowerShell meets this criteria, you clearly see the $$ is a different color. We'll leave this in the 'Readability' column.

### Performance

There's another factor. Mike Robbins replied to let us know that PowerShell needs to take action to parse the double quoted content, leading to a slight performance hit.

![PerfReason](/images/2015-03-22/PerfReason.png)

This one makes sense to me. But Measure-Command is fun, so let's test it out! We'll perform 3 iterations for each scenario; loop through ten thousand and loop through a million, using single and double quotes in each.

{% gist 615032fe1bbbeb9a835e %}

The result was surprising, an almost imperceptible difference:

![PerformanceTest](/images/2015-03-22/PerformanceTest.png)

When the original discussion was taking place, I also ran a single test for ten million and another for one billion, leading to .05 second and 22 second (of 650 total) differences, respectively.

So this does impact performance, but from my perspective, the cases where this would make an impact, and that impact would be important, are few and far between.  Anyone coding in those scenarios will likely be fully aware of the performance implications of using quotes (and PowerShell itself).

No points here, from my perspective, but definitely good to know for those corner cases!

### Best Practice?

Is using single quotes when no expansion is needed truly a best practice?

I do see the other view points, both were certainly valid. I'm not sure if they warrant awarding a 'best practice' though. I agree with Adam that this is a good tip. Maybe a 'good practice', as code readability is important.

 I'll try to move towards following this good practice, but it will take time. I will likely continue to use double quotes without expansion, to the chagrin of my Sublime-Text-using-peers.

### Aside

If ISESteroids squiggles out double quotes without expansion, Tobias should consider squiggling out the wretched code formatting practices like this:

```powershell

# What is this?  Why would you force this upon my eyes!
    if($Something) {
        "Arrrgh"
    } else {
        "My eyes!"
    }

# This would be preferred
    if ($Something) {
        "grumble"
    }
    else {
        "grumble!"
    }

# Or even better
    if ($Something)
    {
        "Ahh, this is"
    }
    else
    {
        "more readable!"
    }

```

Cheers!