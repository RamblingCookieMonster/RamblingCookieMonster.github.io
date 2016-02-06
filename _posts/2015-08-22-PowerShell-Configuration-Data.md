---
layout: post
title: PowerShell Configuration Data
excerpt: "&#60;B N=&#34;Readable&#34;&#62;false&#60;&#47;B&#62;"
tags: [PowerShell, Module, Script, Configuration, Data]
modified: 2015-08-16 22:00:00
date: 2015-08-16 22:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /formats/jsonxThumb.png
---
{% include _toc.html %}

### Rambling

I recently wrote [PSDeploy](https://ramblingcookiemonster.github.io/PSDeploy/), a quick-and-dirty module to abstract out PowerShell based deployments. You define what you want deployed in a configuration file, it does the rest.

The most common follow-up questions seemed to be *why yaml?* or *why not &#60;data format of preference&#62;?* This is a quick hit on the many data formats you can use from PowerShell.

***Disclaimer**: I know very little about data formats, their intended uses, or their benefits or caveats. This is from a layman's perspective.*

### The Choices

Let's list off a few common data formats we could use.

* XML
* JSON
* YAML
* PowerShell Data File (PSD1)
* INI
* Registry
* CSV
* Text
* Database

Let's take a peak at these from a high level. Keep in mind these can vary wildly even within a single format. For example, you might have an ad hoc JSON file, or a formal schema describing your JSON.

For each solution you design, consider your needs, priorities, and constraints, and pair them up with one of these formats. Bear in mind the the lessons of the [configuration complexity clock](http://mikehadlow.blogspot.com/2012/05/configuration-complexity-clock.html).

### XML

XML is a tried and true format, but is a bit inefficient and ugly.

![XML example](/images/formats/xml.png)

#### Common tools

* Built in Cmdlets: Import-CliXml, Export-CliXml, ConvertTo-Xml
* Built in .NET framework support

#### The Good

* Avoid external dependencies
* Flexible
* Wide cross-platform support and tooling
* CliXml functions provide simple serialization and deserialization
* Stores data with more than one layer of depth

#### The Bad

* Not human readable
* Syntax is inefficient and verbose
* It's 2015

#### Example

```powershell
# Serialize some data to disk
Get-Item C:\Windows\explorer.exe |
    Export-Clixml -Depth 5 -Path C:\XML.xml

# Deserialize the data
$File = Import-Clixml -Path C:\XML.xml

# Drill down.
$File.VersionInfo.ProductVersion
```

#### Should I use XML?

There are two scenarios where I use XML. In all other cases I pick an alternative.

* Quick and dirty serialization. Import and Export CliXml are simple to use
* Technology lock-in. If it only supports XML, you don't have a choice

#### Further reading

* [Mastering everyday XML tasks in PowerShell](http://www.powershellmagazine.com/2013/08/19/mastering-everyday-xml-tasks-in-powershell/)
* [PowerShell and XML](http://www.codeproject.com/Articles/61900/PowerShell-and-XML)

### JSON

JSON is a lightweight data format common in modern web APIs.

![JSON example](/images/formats/json.png)

#### Common tools

* Built in Cmdlets: ConvertFrom-Json, ConvertTo-Json (PowerShell 3 or later)

#### The Good

* Avoid external dependencies (in PowerShell 3 or later)
* Stores data with more than one layer of depth
* Semi human readable
* Syntax is more efficient and less verbose than XML
* Implemented in libraries across several languages

#### The Bad

* Want to store MSFT paths? Have fun: ```{ "Path":  "C:\\W\\T\\F" }```
* Not as widespread cross-platform support or tooling as XML

#### Example

```powershell
# Convert some data to Json
$JSON = Get-Item C:\Windows\explorer.exe |
    ConvertTo-Json -Depth 2

# Read the Json back into an object
$File = $JSON | ConvertFrom-Json

# Drill down.
$File.VersionInfo.ProductVersion
```

#### Should I use JSON?

JSON is a popular and safe choice nowadays. Depending on your needs, this is often a good fit.

#### Further reading

* [A JSON Primer for Administrators](http://www.powershellmagazine.com/2014/12/01/a-json-primer-for-administrators/)
* [JSON.NET](https://github.com/JamesNK/Newtonsoft.Json)
* [JSON Is the New XML](http://blogs.technet.com/b/heyscriptingguy/archive/2014/04/23/json-is-the-new-xml.aspx)

### YAML

YAML is a human friendly data format.

![yaml example](/images/formats/yaml.png)

#### Common tools

* [PowerYaml](https://github.com/scottmuc/PowerYaml) and various [forks](https://github.com/cdhunt/PowerYaml)
* [Yaml.Net](https://github.com/aaubry/YamlDotNet)

#### The Good

* Very human readable
* Stores data with more than one layer of depth
* Syntax is more efficient and less verbose than XML
* Implemented in libraries across several languages

#### The Bad

* Dependencies on libraries like Yaml.Net
* Haven't seen a reliable serialize and deserialize module for YAML yet
* Whitespace is part of the syntax

#### Example

```powershell
# Define some Yaml
$Yaml = @"
Name: explorer.exe
Length: 4532304
DirectoryName: C:\Windows
VersionInfo:
  ProductVersion: 10.0.10240.16384
"@

#Read the Yaml, using PowerYaml
$File = Get-Yaml -FromString $Yaml

# Drill down.
$File.VersionInfo.ProductVersion
```

#### Should I use YAML?

I would only recommend YAML where human readability is paramount, and your other needs and constraints don't rule it out.

Yaml a great option when you will simply be reading in a config file, and the end users will be manually manipulating this file.

### PowerShell Data File (PSD1)

PowerShell data files are used for PowerShell module manifests, but can be used to store arbitrary data.

![psd1 example](/images/formats/psd1.png)

#### Common tools

* Built in Cmdlet: [Import-LocalizedData](https://technet.microsoft.com/en-us/library/hh849919.aspx)

#### The Good

* Familiar to PowerShell authors
* Avoid external dependencies
* Stores data with more than one layer of depth
* Semi human readable

#### The Bad

* Single platform
* Haven't seen a reliable serialize and deserialize module for PSD1 files yet

#### Example

```powershell
# Create a PSD1 file
@"
@{
    Name = 'explorer.exe'
    Length = 4532304
    DirectoryName = 'C:\Windows'
    VersionInfo = @{
      ProductVersion = '10.0.10240.16384'
    }
}
"@ | Out-File -FilePath C:\PSD1.psd1

# Read the file
$File = Import-LocalizedData -BaseDirectory C:\ -FileName PSD1.psd1

# Drill down.
$File.VersionInfo.ProductVersion
```

#### Should I use PSD1?

This seems like a reasonable choice for PowerShell configuration files that will be edited by hand, by folks familiar with PowerShell.

### Other Data Formats

There are a variety of other choices. Here are a few others you might consider:

* **CSV** has plenty of built in Cmdlets, but is quite limited and might produce [unexpected results](http://learn-powershell.net/2014/01/24/avoiding-system-object-or-similar-output-when-using-export-csv/).
* **Text** is an option, with a variety of tools including the new [ConvertFrom-String](http://www.powershellmagazine.com/2014/09/09/using-the-convertfrom-string-cmdlet-to-parse-structured-text/). Not sure why you would chose this over an existing data format.
* **The registry**. I wouldn't pick it, but it's used by many applications and is familiar to most Windows administrators. Tools like [PSRemoteRegistry](https://psremoteregistry.codeplex.com/releases/view/65928) make this simple to work with remotely, unlike the registry PSProvider.
* **[Ini files](http://lipkau.github.io/PsIni/)** are a bit dated, but are simple to read and use. Given their limitations and the wealth of other options, you should probably leave these in the attic.
* **Databases** are a great option for larger solutions, or where your data model requires a bit more sophistication. [SQLite](http://ramblingcookiemonster.github.io/SQLite-and-PowerShell/) is a handy, cross-platform solution, if SQL Server or other database engines are too heavy-weight.

### What Should I Use?

Like most answers in the world of computing: It depends. Chances are, even with your particular needs and constraints, there isn't one correct choice. Consider your options, and pick a data format that makes sense to you.

Do you enjoy trolling? Consider JSONx:

[![JSONx tweet](/images/formats/jsonx.png)](https://twitter.com/DanHarper7/status/514822464673951744)

Cheers!