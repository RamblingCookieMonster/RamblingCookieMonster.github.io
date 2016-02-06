---
layout: post
title: PSExcel&#58; Excel automation without Excel
excerpt: "Who wants Excel on a server?"
tags: [PowerShell, Module, Tools, Excel, EPPlus]
modified: 2015-03-29 22:00:00
date: 2015-03-29 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /psexcel-intro/excel.png
---
{% include _toc.html %}

#### Rambling

When I first started using PowerShell, I preferred sending data to Excel, where I could comfortably filter, sort, and work with data. One of my first functions was a modification of Export-XLSX found on the Internet. That same code sits in a few places in production today; looking at old code is scary.

Nowadays, I prefer working with objects in PowerShell itself, and learning to do this has been [incredibly valuable](http://ramblingcookiemonster.github.io/Why-PowerShell/). If I need to export data, chances are I will use MSSQL through [Invoke-Sqlcmd2](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-Sqlcmd2.ps1) and [Invoke-SQLBulkCopy](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-SQLBulkCopy.ps1), or perhaps [SQLite](http://ramblingcookiemonster.github.io/SQLite-and-PowerShell).

On Friday, Doug Finke tweeted about an Excel module:

![Doug's tweet](/images/psexcel-intro/dfinketweet.png)

Intriguing! I hadn't heard of [EPPlus](https://epplus.codeplex.com/). Turns out there's a .NET library for reading and writing Excel files, without Excel. I'm easily distracted, and Doug only gave us [a taste](https://github.com/dfinke/ImportExcel), so time to write a module! [Edit: Doug has expanded [his solution](https://github.com/dfinke/ImportExcel) to a full module with a number of bells and whistles]

I looked around, saw a few snippets, and one big, [comprehensive module](https://excelpslib.codeplex.com/) from Philip Thompson, but I was looking for something in between.

### Why not COM?

Chances are you have worked with Excel through COM. Why wouldn't we just write a module using this?

Ignoring the dependency on an installed copy of Microsoft Excel, it turns out this isn't supported if you want to use it in an automated solution. You might even run into situations where it won't run, even with a variety of tweaks.

[Straight from Microsoft](https://support.microsoft.com/en-us/kb/257757):

> All current versions of Microsoft Office were designed, tested, and configured to run as end-user products on a client workstation. They assume an interactive desktop and user profile. They do not provide the level of reentrancy or security that is necessary to meet the needs of server-side components that are designed to run unattended.

> **Microsoft does not currently recommend, and does not support, Automation of Microsoft Office applications from any unattended, non-interactive client application or component (including ASP, ASP.NET, DCOM, and NT Services), because Office may exhibit unstable behavior and/or deadlock when Office is run in this environment.**

### PSExcel

I spent a short while flipping through Doug and Philip's work, and ended up with [the PSExcel module](https://github.com/RamblingCookieMonster/PSExcel), a rudimentary module for working with Excel, without the dependency of Excel or it's troublesome COM interface.

What can we do with this? Let's walk through a quick demo.

#### Export data to Excel

We'll create some dummy data to use:

```powershell
#Create some demo data
    $DemoData = 1..10 | Foreach-Object{

        $EID = Get-Random -Minimum 1 -Maximum 1000
        $Date = (Get-Date).adddays(-$EID)

        New-Object -TypeName PSObject -Property @{
            Name = "jsmith$_"
            EmployeeID = $EID
            Date = $Date
        } | Select Name, EmployeeID, Date
    }
```

![Dummy data](/images/psexcel-intro/dummydata.png)

Now, let's export it!

```powershell
$DemoData | Export-XLSX -Path C:\temp\Demo.xlsx
```

Let's verify in Excel:

![Dummy data](/images/psexcel-intro/export.png)

#### Import data from Excel

Importing data is just as easy. In this example, let's switch out the headers:

```powershell
$Imported = Import-XLSX -Path C:\Temp\Demo.xlsx -Header samaccountname, EID, Date
```

![Dummy data](/images/psexcel-intro/imported.png)

It worked! Keep in mind that Excel might not store your data as expected. If you run into any odd cases, be sure to let me know, there might be a quick fix.

#### Generate an Excel object to work with

You might want to open an existing xlsx file to work with:

```powershell
$Excel = New-Excel -Path C:\temp\Demo.xlsx
```

This is a very basic function, it just creates a OfficeOpenXml.ExcelPackage object. I like abstraction though; I don't want to remember that I have to call ```New-Object OfficeOpenXml.ExcelPackage $Path```, I just want to say ```New-Excel```.

#### Get a workbook

We have an ExcelPackage to work with, now we can get the workbook from this. More abstraction; this case it's literally just calling the Workbook property.

```powershell
$Workbook = $Excel | Get-Workbook
```

#### Get a worksheet

We can pipe an ExcelPackage or a Workbook to ```Get-Worksheet```, and can optionally filter on name:

```powershell
$Worksheet = $Excel | Get-Worksheet
$Worksheet = $Workbook | Get-Worksheet -Name Worksheet1
```

Let's take a peak at a worksheet object:

![Worksheet](/images/psexcel-intro/worksheet.png)

We can see some details, including the dimension of this worksheet.

#### Freeze some panes

Why bother getting an ExcelPackage, Workbook, or Worksheet? We can use these to manipulate the data and metadata behind the scenes. Maybe we want to freeze the first row:

```powershell
$WorkSheet | Set-FreezePane -Row 2
```

The row and column parameters might seem confusing - they indicate the first cell that should *not* be frozen. So freezing the top row would be row 2, column 1. Freezing the top row and first two columns would be row 2, column 3.

We'll have to save before we can verify this.

#### Save and close

Saving and closing uses the ExcelPackage object we first created:

```powershell
$Excel | Close-Excel -Save
```

Let's take a look at our spreadsheet, did it freeze the top row?

![Frozen pane](/images/psexcel-intro/frozenpane.png)

The row is frozen as expected!

#### Format cells

Management likes pretty colors and formatting. Let's add some emphasis on the header:

```powershell
# Re-open the file
    $Excel = New-Excel -Path C:\temp\Demo.xlsx

# Add bold, size 15 formatting to the header
    $Excel |
        Get-WorkSheet |
        Format-Cell -Header -Bold $True -Size 14

# Save and re-open the saved changes
    $Excel = $Excel | Save-Excel -Passthru
```

![Header change](/images/psexcel-intro/header.png)

They're nitpicky. That header is way too big! And the first column should be dark red, and autofit with a maximum width of 7:

```powershell
#  Text was too large!  Set it to 11
    $Excel |
        Get-WorkSheet |
        Format-Cell -Header -Size 11

    $Excel |
        Get-WorkSheet |
        Format-Cell -StartColumn 1 -EndColumn 1 -Autofit -AutofitMaxWidth 7 -Color DarkRed

# Save and close
    $Excel | Save-Excel -Close
```

![Format change](/images/psexcel-intro/format2.png)

#### Search cells

```powershell
# Search a spreadsheet
    Search-CellValue -Path C:\test\Demo.xlsx { $_ -like 'jsmith10' -or $_ -eq 280 }
```

![Search](/images/psexcel-intro/search.png)

This can return the location (default), the raw value, or an ExcelRange that you can manipulate with more flexibility than Format-Cell provides.

#### Create tables

Thanks to AWiddersheim for adding table support!

```powershell
# Add a table, autofit the data. We use force to overwrite our previous demo.
    $DemoData | Export-XLSX -Path C:\Temp\Demo.xlsx -Table -Autofit -Force
```

[![Pivot](/images/psexcel-intro/table.png)](/images/psexcel-intro/table.png)

#### Create pivot tables and charts

This is straight from Doug Finke's fantastic [ImportExcel module](https://github.com/dfinke/ImportExcel).

```powershell
# Fun with pivot tables and charts! Props to Doug Finke
    Get-ChildItem $env:USERPROFILE -Recurse -File |
        Export-XLSX -Path C:\Temp\Files.xlsx -PivotRows Extension -PivotValues Length -ChartType Pie
```

[![Pivot](/images/psexcel-intro/pivot.png)](/images/psexcel-intro/pivot.png)

### Demo Gist

Here's the full demo code we just walked through:

{% gist 7f49beeaebb570204581 %}

### Fun with GitHub, Pester, and Appveyor

In case it isn't evident, I haven't succumbed to test-driven development, as beneficial as it seems. I did add a few Pester tests to PSExcel, and have enabled continuous integration for this project through AppVeyor, so you'll know whether the build is passing, and [you can view the pester tests](https://ci.appveyor.com/project/RamblingCookieMonster/psexcel) to see what specifically broke the build.

![Build passing](/images/appveyor-1/build-passing-large.png)

If you want a simple way to enable version control, testing, and continuous integration for your projects, definitely check this out!

* [Fun with Github, Pester, and AppVeyor](http://ramblingcookiemonster.github.io/GitHub-Pester-AppVeyor/)
* [Github, Pester, and AppVeyor: Part Two](http://ramblingcookiemonster.github.io/Github-Pester-AppVeyor-Part-2/)
* [Testing DSC Configurations with Pester and AppVeyor](http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/)

### Next steps

I plan to continue with a few more tweaks to meet my specific needs, but probably won't go as deep as Philip has.

That's it! This should get you up and running with an Excel-free solution for creating and reading Excel files. Feel free to poke around, let me know if you run into any issues, have any suggestions, or would like to contribute!

[PSExcel project on Github](https://github.com/RamblingCookieMonster/PSExcel)

Time to update some servers:

![Frozen pane](/images/psexcel-intro/updates.png)
