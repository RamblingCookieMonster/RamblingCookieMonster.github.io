---
layout: post
title: "The 2019 PowerShell and DevOps Global Summit CFP"
excerpt: "It's finally over"
tags: [PowerShell, DevOps, Summit]
modified: 2018-10-16 07:00:00
date: 2018-10-16 07:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /cfp/formulas.png
---
{% include _toc.html %}

## Rambling

Whew!  It's been a fun and busy few weeks.  I've been working with [Missy](https://twitter.com/thedevopsdiva) on reviewing proposals for the [2019 PowerShell + DevOps Global Summit](https://powershell.org/summit/).

I was excited and honored when I was asked to help with the summit.  I've been coming to this summit since I started working on PowerShell, and I owe most of any success I've had to the various attendees and speakers who have helped me along the years.

Working on the CFP has been awesome - you get to preview a ton of interesting ideas, and you get to help pick the content of the summit, which sets the direction of topics and ideas for a decent sized audience...  It's a huge honor, and I would do it again, but I can assure you, turning down ~150 proposals, and reviewing 20 release pipeline bits can wear you out - I'm happy to be done for the year!

Now that [the agenda](https://bit.ly/summit2019agenda) is out and speakers have been notified, I figure it's a good time to talk about the CFP!

## Deciding

Picking topics was tough.  Cutting topics was tougher.  Let's look at some of the factors!

### The Basics

Early in the process Missy pointed to [a solid bit on reviewing proposals for a CFP](https://tisiphone.net/2018/07/16/i-reviewed-600-call-for-paper-submissions-and-youll-probably-guess-what-happened-next/).  This helped serve as a gate of sorts.

A few of these criteria lead to some hard _no_s.  We weren't super strict, but some things scare a reviewer off.  If you put no time into a proposal, don't review it, and have no one else review it, leading to a bunch of spelling and grammar errors among other issues, we might extrapolate and think... what sort of presentation and material will this author put together?

Other criteria simply made it harder for us to say yes.  We had a bunch of *release pipelines*, *Azure*, and *Pester* proposals.  This means you have a lot more competition - not only is your proposal up against everything else, it can be edged out by proposals on similar topics.  It also means your proposal might blend in with the others, and stand out less than an original topic.

Combined with other factors, the _why is this important_ bit stood out.  Proposals are basically marketing.  We read through each proposal _multiple times_.  If you didn't capture our curiosity or interest, it made it much easier for your proposal to land in the _maybe_ pile, which puts it at a little disadvantage.  If it was on a popular topic _and_ it didn't intrigue us?  It might have ended up in the _no_ pile.

There was more, but those are three criteria that stood out to help as an initial filter.

* Did you spend any time creating and reviewing your proposal?
* Was your topic very popular?
* Did you capture our interest?

So... We've talked about some things that lead to a _no_ or a _maybe_.  What made us say yes?

### The Good Things

Some factors helped proposals get to the _accept_ pile, for better or worse.  Keep in mind these are simply factors that could help to some degree, not hard-and-fast rules.

* **Was it unique?**  This makes it much easier to say yes.  Particularly for a popular topic.  Module or infrastructure release pipelines?  Tons of submissions.  SQL release pipelines?  [One](https://app.socio.events/MjQ4Nw/agenda/14445/session/61465)
* **Was it widely applicable?**  If your talk can extrapolate across different products / stacks, it had a better chance.  For example, we might pick a bit on [psake](https://app.socio.events/MjQ4Nw/agenda/14445/session/61482), over a similar bit specific to Azure DevOps
* **Do you have any community presence?**.  This might be a bad one.  There are plenty of situations that lead to someone having no chance to contribute at work and at home.  That said, your work in a community can help us pick some 'known quantity' speakers - whether that means you're an awesome speaker that we've seen, that you're an expert in a particular topic, or that you're quite creative and tend to do awesome things.  This could even mean just networking with folks at the summit
* **Was your topic interesting?**  On top of being unique, having an interesting topic can help.  This really depends on the reviewer, and what they think the audience, or subsets thereof, might find interesting
* **Are you the author?**  This is a pretty specific one, but worth pointing out.  If you're the author or maintainer of a tool or module, chances are if there are more than one proposal on it, you'll be speaking
* **Did you submit late?**  We're human.  We need to review and follow-up throughout this CFP process.  We did our best to avoid any bias based on time, but to a small degree, I think the farther along the CFP, the more compelling a proposal needed to be to land in the _accept_ pile
* **Did you get lucky?**  Again, we're human.  Maybe Missy or I were in a good or bad mood when we saw / re-reviewed your bit.  Maybe you ended up in the _maybe_ pile and we didn't give your proposal as much consideration on re-review as we should have.  There are so many little things that could have added up to what I call... Luck

Okay!  Let's move on to some more potential road blocks.

### Things that didn't help

Some of these will be the inverse of helpful factors, or repeats from the basics...  In general, these didn't help:

* **Hot topics**.  Proposing a popular topic?  Yours needs to stand out that much more
* **Constrained topics**.  Azure is a good example.  Not everyone uses Azure.  If we got 20 world-beating Azure proposals from the brightest leaders in the community, we're still only going to accept a handful or less
* **Lack of context or clarity**.  This came up in a few ways.  If you're talking about PowerShell with _technology xyz_, tell us (and the audience!) what _technology xyz_ is!  If you're giving us a recipe for solving something, give us a light outline of sorts - it can help us if we're not sure you'll go off in an odd direction - particularly important for new folks
* **A single proposal**.  I know.  It takes time to write these.  But here's the thing: What if we happen to get a blockbuster proposal that covers what you cover?  What if you simply get unlucky?  Having two or three proposals gives you a better chance of speaking
* **Repeat topics**.  We don't mandate original content.  We completely understand that coming up with new talks is _hard_, and that iterating on topics works.  That said - if you've given this talk at a recorded conference or even at this summit another year, you _need_ to tell us what will be different, or there's a very high likelihood it's going in the _no_ pile, even if it was originally a hit
* **Poor fit**.  Did you submit a beginner level bit?  Something that isn't PowerShell or DevOps related?  It probably won't get picked.  Even if we let some beginner level material through, chances are it's going to have some serious competition, and we likely won't let anything through that would be covered in the OnRamp material

Whew!  Okay, so we've talked the basics, and factors that made it more or less likely for us to select your topic.  Let's cover a few other factors that you might not think about.

### Logistics and balance

So!  These are some other factors that could help or hurt a proposal:

* **Two accept-worthy proposals**.  We have budget for ~40 non-PowerShell.org speakers.  We have 56 or so speaking slots.  This means that we _need_ several folks to give more than one presentation.  If you submitted two strong proposals, chances are you got in, even if we only accepted one (we might have added your other as a potential backup).  I know this isn't optimal, but we have a cap on attendees, so every speaker means less $$ to support the summit
* **We need a balance of known and unknown speakers**.  Known speakers can help sell tickets, and we know they'll likely give solid sessions.  That said, we want to encourage folks to share and speak, so we want new folks as well!
* **We want to introduce more non-PowerShell-specific material**.  As folks progress in their careers, PowerShell will likely become less of a central focus.  It will still play a large part of this conference, but we'll be including sessions on important topics that a PowerShell-er might run into as they progress in their career, even if those topics don't involve PowerShell itself
* **We want to balance content** We mention it above, but again, we need to balance content.  We can't have 20 Release Pipeline talks, and 10 Azure talks

Let's summarize these

### So you want to speak at the summit

That was too many words.  Let's boil it down to some takeaways that might help you with a successful proposal:

* **Do submit a proposal**.  Seriously.
* **Do give it a small bit of effort**.  Write it.  Review it.  Give it to someone else to review.  Adjust as needed
* **Be wary of over-populated topics**.  These can be hard to judge.  You can always ask!!
* **Do make your proposal stand out**.  It needs to capture our curiosity or interest
* **Consider making it unique**.  Pester?  It's been done.  Pester-for-some-unique-thing?  Much more likely
* **Consider keeping it widely applicable**.  Even if you use a particular stack for your demos, let us know you'll include widely applicable takeaways
* **Consider interesting topics**.  This depends on the reviewer and the target audience, but is worth considering
* **Do submit as early as possible**.  You'll stand out more initially
* **Be wary of constrained topics**.  We're not going to have a conference of all Azure or AWS bits
* **Do include enough information** for us and your audience to know what you'll be talking about, even if it's a very rough outline
* **Do submit more than one proposal**.  Don't throw everything against the wall, but don't risk your single proposal getting unlucky
* **Be wary of repeat topics**.  At the very least, if you've done it before, let us know how it has changed
* **Do keep the topic appropriate** for this conference.  Not sure?  Just ask!
* **Do get involved with the community** if you can.  Blog,  share / open source your work, attend and speak at user groups, do a [PSPowerHour](https://github.com/PSPowerHour/PSPowerHour), etc.
* **Do ask for feedback**.  We created #Conferences in the [PowerShell Slack team](https://bit.ly/psslack).  I suspect this would have helped on a number of bullets above, and for a number of proposals

Okay!  Let's talk about the CFP itself

## Some CFP Stats

We have a bunch of data on the CFP proposals.  Nothing particularly interesting, but if you're curious:

* We had something like **205 proposals**.  We actually had to send back a few ahead of the deadline, to make sure folks weren't locked out by the 200 cap
* We had **56 accepted proposals**.  46 standard (45 min) sessions, 10 double (90 min) sessions
* We have **21 new speakers, and 19 returning speakers**.  This is in relation to this specific summit.  Perhaps 5 to 10 of the new speakers speak at other PowerShell-y conferences
* We have something like **11 Microsoft MVPs**.  This doesn't include folks like me, who aren't speaking unless we get pulled in as a last minute backup, or the folks like Don who are speaking only at the OnRamp track.  Also, the whole MVP thing?  It can be nonsense.  We have folks like Brandon Olin and Mathias Jessen who... aren't... MVPs.  Right
* We have **40 total unique speakers**.  Only one is from PowerShell.org (James Petty).  I'd _much_ rather listen to you all speak, than to share myself, even if you took the _I-get-nervous-before-speaking_ and _it-takes-time-to-prepare-a-talk_ factors our of the equation
* **75 unique speakers didn't make it**.  This was seriously painful.  I know many of them from the community, and have met a good number of them in person.  I encouraged many of them to propose.  This was the hardest part of the CFP for me
* **10 Microsoft MVPs didn't make it**, along with several Microsoft folks, and a number of other awesome folks in the community
* There's some overlap given that proposals can cover more than one topic, but looking at a boiled down _what was the primary topic_, the three most popular topics were:
  * **Release Pipeline - 20 proposals**
  * **Azure proposals - 13 proposals**
  * **Pester proposals - 11 proposals**
* We had some prolific proposers.  I can't imagine coming up with 9 ideas and enough to propose on each.  Two speakers did

## How did you work on the CFP?

So!  This was my first time being responsible (well, co-responsible!) for a CFP.  Some notes for posterity:

### Things that worked

* **Google Sheets**.  PaperCall and other services might not have the best reviewing tools.  Some easy-to-collaborate spreadsheet service works for this
* **Having help**.  Don't go alone.  Seriously.  IMHO no CFP should be handled by a single person.  The stress, items you might miss without a second pair of eyes, and other issues will pile up.  Thanks Missy : D
* **Knowing spreadsheet language basics**.  Using spreadsheets?  Learn the language (functions, formulas, etc.).  There's only so much manual work you can do.  Sheets and Excel both have useful query languages, and you should know enough to pick these up without too much trouble
* **Keeping identifier data** to tie review data to CFP data.  Make sure each review entry has enough data to uniquely tie it back to a talk - for example, the submitter's name or e-mail and the title of a talk.  Watch out for whitespace.  This helps reconcile the data if you need to join it up later on
* **Using PowerShell**!  Once we had review data in sheets, and proposal data in PaperCall, it was easy to [join](http://ramblingcookiemonster.github.io/Join-Object/), filter, etc., generate speaker agreement word documents, and send acceptance, back-up, and not-selected [e-mails via smtp](https://stackoverflow.com/a/51158377/3067642).  I also had a quick way to generate [all the speaker's twitter handles](https://twitter.com/psCookieMonster/lists/pshsummit-2019-speakers), stats for this article, etc.
* **Encouraging people**.  I can't tell you how many folks I pinged, who either hadn't considered proposing, figured they didn't have anything worth proposing, just didn't see that we were running a CFP, etc.  A number of these folks were selected.  I'll remind folks again next year, but seriously, _if something helps you or your teammates, chances are it might help folks at this conference_.  Propose it!
  * Side note:  if I missed pinging you, I'm sorry!  tried to get a bunch of folks, but I missed plenty
* **Remote collaboration tools**.  Already mentioned Google Sheets.  Slack and screen-sharing-tools (e.g. Skype) also came in quite handy when working with other reviewers

### Things that didn't work

* **Manual work**.  Each time a new proposal came in, we manually copied data over to our review sheet.  This was painful
  * Suggestion: have an easy process to add proposal metadata to your review data, without messing with existing review info.  For example, download your review data (e.g. sheets), download your PaperCall data, join it, and publish the data back to Sheets.  Maybe use [existing tools](https://github.com/scrthq/PSGSuite)
* **Not linking review data to CFP data**.  We used google sheets for review.  Each time we needed to review proposal content, we needed to browse to PaperCall, search (its search tool is horrible), select, and scroll to the content
  * Suggestion:  Make it easy to tie your review metadata and notes to the CFP data.  A link to the CFP proposal for each row in your review, for example
* **Too many Maybes**.  We each rated a talk as it came in.  Yes, No, Maybe.  I think we (I did, at least) might have put too many in the _Maybe_ pile.  We revisited the _Maybe_ pile multiple times, but not too many proposals went from _Maybe_ to _Yes_, and I worry that we missed some gems
  * Suggestion:  Be as thorough as possible when you first rate a proposal.  Don't look at a proposal if you don't have time to review it in full.  Try to avoid marking proposals _Maybe_ unless you really mean it.
* **Tags, not buckets**.  We tried to boil down each talk into a bucket (e.g. Release Pipeline, Azure, Serverless).  Here's the thing:  Many talks might have two or more topics involved, and might include a constrained topic.  For example, Release Pipelines overlapped heavily with Infrastructure-As-Code, and the Serverless bucket often included a constrained topic (Azure or AWS)
  * Tag central topics for each session.  Submitters often do this, but they might be overzealous, or use different words - normalize and filter these.  Spreadsheets aren't the best for many-to-many relationships, but you can shoehorn it in

I'm sure there's more, but this is mostly a quick brain dump for next year's CFP

Whew!  That's it!  Tickets go on sale November 1, and you can find a brochure, agenda, and other links [here](https://powershell.org/summit/). [The initial agenda looks fantastic](http://bit.ly/summit2019agenda) (I know, I'm biased).  Hope to see you at the summit!
