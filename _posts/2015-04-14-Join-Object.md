---
layout: post
title: Merging data in PowerShell
excerpt: "How many Join-Objects do we need?"
tags: [PowerShell, Tools, Practical, Function, Quick Hit]
modified: 2015-04-17 22:00:00
date: 2015-04-17 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /join-object/venn.png
---
{% include _toc.html %}

### Rambling

We occasionally get requests we can't refuse. Do I have any interest in working with spreadsheets? Not particularly. But if my boss, or my bosses boss asks me to merge two spreadsheets based on a common column, I don't want to say "sorry, no can do."

I also don't want to get stuck being the spreadsheet guy. So I wrote a quick PowerShell function that merges two sets of data, found a more flexible but slow [alternative from Lucio Silveira](http://blogs.msdn.com/b/powershell/archive/2012/07/13/join-object.aspx), and settled on extending [a nice modification from Dave Wyatt](http://powershell.org/wp/forums/topic/merging-very-large-collections/).

The result is yet another [Join-Object](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Join-Object.ps1).

### Overview

Let's look at a silly concocted example. I have a spreadsheet of managers, and a spreadsheet of departments. For some inexplicable reason, I need to match up departments to their manager's birthday.

![Managers](/images/join-object/managers.png)

![Departments](/images/join-object/departments.png)

If you've spent any time with T-SQL, you've probably seen the [handy Venn diagrams](http://www.codeproject.com/KB/database/Visual_SQL_Joins/Visual_SQL_JOINS_orig.jpg) ([source](http://www.codeproject.com/Articles/33052/Visual-Representation-of-SQL-Joins)) out there, and the [discussions](http://blog.codinghorror.com/a-visual-explanation-of-sql-joins/) on why Venn diagrams don't match join statements alone.

Let's take a look at how we might join the manager and department data.

#### Left joins

A left join is fairly self explanatory - we include all rows from the left data set (managers), and if anything matched on the right side (departments), we include that data:

![Left Join](/images/join-object/joinleft.png)

#### Inner joins

An inner join is the intersection of both data sets.  We return only data where a row on the left matched up with a row on the right:

![Inner Join](/images/join-object/joininner.png)

#### Full joins

In some cases you want all the data, regardless of whether it is in either set:

![Full Join](/images/join-object/joinfull.png)

Let's use PowerShell to join this data up!

### Join-Object

[Join-Object](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Join-Object.ps1) can be found in my hodge podge repository of PowerShell functions. Here's a quick rundown on the parameters:

* *Left* - a collection of objects for the left side - you can pipe in data for this
* *Right* - a collection of objects for the right side
* *LeftJoinProperty* - The property on the Left collection whose value must match RightJoinProperty in the Right collection
* *RightJoinProperty* - The property on the Right collection whose value must match LeftJoinProperty in the Left collection
* *LeftProperties* (optional) - If specified, limit properties we keep from the left to this set
* *RightProperties* (optional) - If specified, limit properties we keep from the right to this set
* *Prefix* and *Suffix* (optional) - If specified, add a prefix or suffix to all Right collection property names.  Quickly avoid collisions.
* *Type* (optional) - What type of join:
  * AllInLeft - Left join
  * AllInRight - Right join
  * OnlyInBoth - Inner join
  * AllInBoth - Full join

That was painful! Let's look at this in practice, where it's a bit easier to see what's going on.

#### Demo data

I'll use [PSExcel](http://ramblingcookiemonster.github.io/PSExcel-Intro/) to pull in data from a spreadsheet. Keep in mind there are other options, like the fantastic [ImportExcel](https://github.com/dfinke/ImportExcel) module from Doug Finke, which PSExcel borrowed from.

```powershell
$L = Import-XLSX -Path C:\temp\JoinTest.xlsx -Sheet 1
```

![Managers in PS](/images/join-object/managersps.png)

```powershell
$R = Import-XLSX -Path C:\temp\JoinTest.xlsx -Sheet 2
```

![Departments in PS](/images/join-object/departmentsps.png)

We have the data, how do we join it together?

#### Inner join

```powershell
Join-Object -Left $L -Right $R -LeftJoinProperty Name -RightJoinProperty Manager -Type OnlyIfInBoth -RightProperties Department
```

We can tell Join-Object that we only want rows where $L.Name is equal to $R.Manager (inner join), and to only return the Department property from the $R collection

![Inner Join](/images/join-object/innerps.png)

#### Left join

Here's where things get more interesting. Let's run Lucio's code first:

![Missing Department](/images/join-object/leftmissingprop.png)

What happened!  We only got back a name and birthday, where is the department that I wanted?

It turns out that PowerShell will see the first object in the pipeline, which only has a name and birthday property, and display output with only those two properties.

We could manually select Name, Birthday, and Department, or use Format-List to see the other properties, but I like abstraction, so in the extended Join-Object, we select the full set of properties for output.

```powershell
Join-Object -Left $L -Right $R -LeftJoinProperty Name -RightJoinProperty Manager -Type AllInLeft -RightProperties Department
```

This time, we get the expected output, without worrying about missing columns:

![Left Join](/images/join-object/leftps.png)

#### Full join

There's another issue you can run into. What if you have two properties with the same name, with differing values and meaning? In our example, we have a set of managers, where name refers to the manager's name. We also have a name property on the department set, that refers to the department name.

Let's look at the practical implication if we don't account for this:

![Full Join, Overwrite](/images/join-object/fulloverwrite.png)

Interesting, the left values for name were overwritten by the right values. How can we fix this? The simplest solution is to add a prefix or suffix to all properties from the right collection:

```powershell
Join-Object -Left $L -Right $R -LeftJoinProperty Name -RightJoinProperty Manager -Type AllInBoth -Prefix r_
```

Now we get all the properties, and nothing is overwritten:

![Full Join, prefix](/images/join-object/fullprefixps.png)

Maybe you are more familiar with [calculated properties](http://stackoverflow.com/a/22726528/3067642). The RightProperties parameter can take individual properties, calculated properties, or a mix:

```powershell
Join-Object -Left $L -Right $R -LeftJoinProperty Name -RightJoinProperty Manager -Type AllInBoth -RightProperties @{ N = "DeptName"; expression = {$_.Name} }
```

Rather than a generic prefix or suffix, we can use calculated properties to rename these conflicts, or manipulate their values:

![Full Join, calculated property](/images/join-object/fullcalcprop.png)

Let's take a peak at performance!

### Performance

Lucio's script offers some pretty cool flexibility, allowing you to specify a custom 'Where' scriptblock rather than assuming we want data where one value is equal to another. Unfortunately, [Add-Member](http://learn-powershell.net/2014/01/11/custom-powershell-objects-and-performance-revisited/) and invoking those scriptblocks takes a bit more time.

{% gist 2950c10063348cee402a %}

As you can see, this flexibility comes at a pretty steep cost, even when comparing two relatively small data sets:

| Version  | Seconds |
|:---------|:-------:|
| Lucio's  |  145.0  |
| Dave's   |   ~1.0  |
| Warren's |   ~1.2  |

### Practical example: Active Directory Input

**The request**:

"Hey Warren, we need to match up SSNs to Active Directory users, and check if they are enabled or not.  I'll e-mail you an unencrypted CSV with all the SSNs from gmail, what could go wrong?"

**The code**:

```powershell
# Import some SSNs. 
$SSNs = Import-CSV -Path D:\SSNs.csv

#Get AD users, and match up by a common value, samaccountname in this case:
Get-ADUser -Filter "samaccountname -like 'wframe*'" |
    Join-Object -LeftJoinProperty samaccountname -Right $SSNs `
                -RightJoinProperty samaccountname -RightProperties ssn `
                -LeftProperties samaccountname, enabled, objectclass
```

**The result**:

[![Join-Worksheet](/images/join-object/userssn.png)](/images/join-object/userssn.png)

### Join-Worksheet

It's a bit simpler to just use Join-Object, but you can find a crude Join-Worksheet function in PSExcel:

{% gist 2e7fefb816e9ec9fe04f %}

![Join-Worksheet](/images/join-object/xlsxmerged.png)

### Closing

That's about it! If you like this sort of thing and haven't worked with SQL yet, read up on T-SQL. You can use simple PowerShell functions like [Invoke-Sqlcmd2](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1) or the [PSSQLite module](http://ramblingcookiemonster.github.io/SQLite-and-PowerShell/) to work with MSSQL and SQLite, respectively, or use the many other tools out there.

If you have any suggestions or run into any issues, a pull request would be welcome : )

*Disclaimer*: [title image source](http://en.wikipedia.org/wiki/Venn_diagram#/media/File:Symmetrical_5-set_Venn_diagram.svg)