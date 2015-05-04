---
layout: post
title: Dealing with the Click&ndash;Next&ndash;Admin
excerpt: "It won't be easy"
tags: [PowerShell, Rambling, Automation, Devops]
modified: 2015-05-03 22:00:00
date: 2015-05-03 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /click-next/next.png
---
{% include _toc.html %}

### Rambling

I have a good deal of yard work to do; this means it's time to write. ***Disclaimer**: I'm an industry and life novice, and may be completely off base. I would love to hear your thoughts on this topic [in the comments](http://powershell.org/wp/2015/05/04/dealing-with-the-click-next-admin/)!*

These are exciting times in the Microsoft world. [More](http://blogs.msdn.com/b/dotnet/archive/2015/02/03/coreclr-is-now-open-source.aspx) and [more](http://blogs.msdn.com/b/powershell/archive/2015/04/27/dsc-resource-kit-moved-to-github.aspx) components of the Microsoft ecosystem are going open source, PowerShell v5 is nearing release, and [a server](http://channel9.msdn.com/events/build/2015/2-755) without local logon capability is coming. Microsoft seems more energized and agile with Satya at the helm.

With these changes, we're seeing a wealth of sentiment in line with this quip from Jeffrey:

![Demise of the click next admins](/images/click-next/snovertweet.png)

I fully support this message, but I suspect Jeffrey is preaching to the choir: if you're reading tweets about PowerShell from Jeffrey Snover, chances are you aren't trying to hold this vision back. Here are a few among many posts on the topic:

* [You'll Pry the GUI From My Cold Dead Hands](http://stevenmurawski.com/powershell/2015/4/youll-pry-the-gui-from-my-cold-dead-hands-1)
* [I'm Over You](http://stevenmurawski.com/powershell/2015/5/im-over-you)
* [Don’t like PowerShell? Get Over It And Get On With It](https://www.petri.com/dont-like-powershell-get-over-it-and-get-on-with-it)
* [Sysadmins that can't script have a choice](http://everythingsysadmin.com/2014/02/do-system-administrators-need-.html)

This isn't a new idea; the need for scripting, and the consistent, scalable solutions it can enable was established long ago, well before I joined the field.

Jeffrey started a nice discussion with his [TechDays Online](https://channel9.msdn.com/Events/Future-Decoded-Tech-Day-2014/TechDays-Online-2015/Microsoft-Corporate-Keynote-and-Interview-Jeffrey-Snover) session, but this was more about rewarding the right people than dealing with the click-next-admins:

![Reward the right people](/images/click-next/lastday.png)

I'm going to describe some of the challenges we face in moving to a world without click-next-admins, and lightly touch on some ideas for addressing these. This isn't my area of expertise, so I'm really hoping to generate some discussion on this topic. I don't think this is something that will change quickly, but we need to start considering how to make and hasten this transition.

### Challenges

I see three major challenges:

* How do you convince management that this is the correct and necessary direction?
* How do you adjust hiring processes to filter out the click-next laggards?
* How do you purge, move, or otherwise deal with the existing laggards?

I may be missing other major challenges, but these stand out to me. They are somewhat intertwined, and will all likely involve working with and influencing management.

### Convincing management

This won't be easy. You could have an oblivious pointy-haired boss, a former click-next-admin-turned-manager, a manager who doesn't want to face the other challenges we'll be covering shortly, or any number of other difficulties.

I've seen some of this first hand.

* *My team doesn't have time to learn how to script*
* *Isn't that what your team does?*
* *They aren't developers*
* *We have strict manual processes defined in these fancy word documents! I don't trust a script.* - Yes. Trust in manual processes over a script.

How can you help convince management? A few ideas, and would love to hear more [in the comments](http://powershell.org/wp/2015/05/04/dealing-with-the-click-next-admin/):

* **Lead by example**
  * Illustrate and highlight the consistency and scalability of a scripted or fully automated solution.
* **Lend a hand**
  * Don't do their work for them, but partner with their teams to build a solution that will illustrate how beneficial scripting and automation can be.
  * See Dealing with existing laggards section, convince them bullet.
* **Let them fail**
  * Sometimes they won't accept a helping hand.
  * Don't gloat when they fail, or when they deliver results behind schedule; lend a hand again.
  * Oh, that carefully documented process wasn't followed to the T? I'm so surprised! Want to learn how we can audit the outcome to identify mistakes, and learn how we can automate or build tooling to avoid these mistakes going forward?
* **Highlight situations where scalability and consistency are critical**
  * There are many situations where you literally have no choice but to script something out. These are growing more common where I work, and I suspect I'm not alone.
* **Band together**
  * Even if your automation and scripting cohorts are in different teams or departments, discuss this challenge with them and make sure you are working towards a common goal.
* **Use pretty charts and statistics**
  * Seriously. Management eats this stuff up. I do to - who doesn't like a pretty chart?
  * Show them that the number of servers / clients / printers / users / services / whatever-you-manage is growing.
  * Highlight the [benefits of scripting](https://www.penflip.com/powershellorg/why-powershell/blob/master/chapter2.txt). Point out recent situations where the benefits at that link were particularly helpful.
  * Highlight situations where a scripted solution was not used, and point out the room for improvement.
  * Try to use real numbers. Don't bore them to death or put them on the defensive.

There are likely more ways to convince management, and different methods might be needed depending on the manager in question, but this should get you started.

### Adjusting hiring processes

This is intertwined with convincing management. If management doesn't buy in to the idea that they need to avoid hiring click-next admins, they might hire more. Even if you do convince them, how will you adjust the hiring process to execute on this?

This one will be tough, and depends on the position you have open. I don't have any answers, but here are a few considerations:

* **Beware of precise requirements**
  * Try to balance the desire to have someone hit the ground running, with the reality that you might miss the perfect candidate who happens to be motivated, curious, willing and able to learn your stack, but who might have a different background.
  * If you say "I need X years of experience with PowerShell" you might miss out on a candidate who has years of experience with Perl, bash, SQL, and other comparable skills, who would be a perfect fit. You might miss out on someone like Dave Wyatt, because you focused on a specific requirement like SQL Server experience.
* **Beware of impostors**
  * Have an interview process that can weed out impostors.
  * I've heard some of the worst laggards claim that they could script.
  * I've seen folks who get confused by the verb-noun convention claim that they are proficient with PowerShell.
* **Beware of gotchas**
  * Be careful not to weed out folks who have trouble with interviews.
  * Don't ask specific, trivial questions that might freeze them up.
  * Ask open-ended questions that will tell you enough about their skillset and thought processes.
  * Some example questions I might ask on PowerShell [here](https://www.linkedin.com/grp/post/140856-5854635872405712900) (ctrl+f Warren), keeping in mind I would lean towards even more general concepts if there wasn't a specific requirement to have someone with existing proficiency in PowerShell.
* **Beware of ambush**
  * Click-next-admins, and management that has not been convinced of the need to avoid hiring them, might push for more click-next-admins.
  * Try to avoid letting these laggard-enablers participate in the hiring process.
  * I've seen a case where someone who seemed like a great fit, who was curious, had spent time with automation, and seemed to do well, be written off as "not technical enough," by a click-next-admin.

I'll stop there. You can likely find better references on interviewing capable IT professionals who aren't click-next-admins.

So! Let's pretend you're successful thus far. You've convinced management that click-next-admins are a detriment to the business, and you've adjusted the hiring process to try to weed them out.

There's a good chance you still have a major problem: What will you do with the existing click-next-admins?

### Dealing with existing laggards

From my perspective, this is the most challenging problem. Sure, they are inefficient curmudgeons that are a detriment to the business on a whole, but they are often your friends. Maybe you've shared beers or met their families.

You want them out of the way of any team that could benefit from scripting and automation, but you might be averse to purging them all. What can you do?

* **Convince them to join the dark side**
  * If they can be motivated, and are capable of learning, try to motivate them and encourage them to join the movement.
  * Can you lend a hand? Lead them through the pseudocode and thought process that goes on as you design a solution. Slowly put together that solution while trying to impart some knowledge around the language and technologies you are working with. Encourage them to do this on their own.
  * Keep in mind that not everyone is made for scripting and automation.
* **Find a better fit for them**
  * Would they be a better fit for a team or role that would not benefit from scripting or automation? From my perspective, there aren't many teams out there that meet this criteria, but it's worth considering (aside: I hope scripting and automation play a role in non-IT positions down the road).
  * We still need folks to physically deliver and hook up equipment, this might be a better fit for you if [you aren't comfortable with learning how to script](http://everythingsysadmin.com/2014/02/do-system-administrators-need-.html).
* **Let them leave**
  * Is it worth the trouble? If they have significant value and institutional knowledge, and are nearing retirement, things might play out on their own.
* **Throw out bad apples**
  * Do they resist encouragement and motivation, provide little value to the organization, and constantly build road blocks? You might need to make some tough decisions and open the door for someone who is curious and motivated, open to learning, and that can provide more value.
  * I wouldn't want to make this call, but it needs to be made.

Here's an excerpt from Tom Limoncelli's [masterpiece](http://www.amazon.com/dp/0321492668/tomontime-20) that might help:

> **A.3.5 Doers of Repetitive Tasks**

> Some personality types lend themselves to doing repetitive tasks. These people should be valued because they solve immediate problems. This book can’t stress enough the importance of automation, but some tasks can’t be automated, such as physically delivering new machines, or are not repeated enough to make it cost-effective to be automated. This role is an important one for the team. This person can take on the load of repetitive tasks from higher-skilled people. These smaller tasks are often excellent training for higher-level tasks.

### Avoiding the Challenges

It goes without saying that you might consider substituting these challenges with the challenge of finding an employer who has already dealt with them. This is a common refrain in the IT community: "just find a better job!"

Unfortunately, not everyone has this flexibility; some of us may really enjoy our current positions, we might want to help transform our current organizations, or we might have external pressures that would make this quite difficult.

### Further Discussion

I would love to hear other ideas on how to get to a place where we don't have click-next-admins getting in the way of delivering scalable, consistent services. If you have any experience or ideas around this, please sound off in the [PowerShell.org comments](http://powershell.org/wp/2015/05/04/dealing-with-the-click-next-admin/)!

If you have any fun, short anecdotes illustrating the challenges we face from click-next-admins, consider tweeting them with the #ClickNextAdmin tag.

[![Too Busy](/images/click-next/toobusy.png)](https://twitter.com/search?q=%23clicknextadmin&src=typd)

Cheers!