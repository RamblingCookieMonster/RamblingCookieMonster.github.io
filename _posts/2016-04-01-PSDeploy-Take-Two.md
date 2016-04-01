---
layout: post
title: "PSDeploy&#58; Take Two"
excerpt: "Yet Another DSL"
tags: [PowerShell]
modified: 2016-04-01 09:00:00
date: 2016-04-01 09:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /psdeploy/workflow.png
---
{% include _toc.html %}

## Rambling

So!  I'm a dad now.  Everything went smoothly, Hannah arrived mid-March, at 8lbs 9oz.  I'm a light sleeper, so I now have a few hours every night to hack away at things in a sleep-deprived state, lending an occasional hand with our trouble-making daughter.

Right before all the fun, I got a fun message from Michael Greene:

> wanted to ask where you want to go with that PSDeploy project.  could we get it to a DSL along the lines of "Deploy &#60;type&#62; &#60;path&#62; To &#60;Target&#62;" and then from any project just invoke-deployment.

It sounded interesting, but complicated.  I was happy with the simple YAML implementation, but gave the change some thought.  A DSL would mean deployment configurations could call PowerShell inline with the deployment.  It wouldn't add much complexity for a user, but it would add some serious flexibility.

This post will be a quick and dirty overview of the revamped PSDeploy.

## Why Would I Use PSDeploy?

Maybe you're an IT professional, and you're starting to use important tools like version control.  This can be a pain:

* Do you commit to version control and manually copy things out to where they live in the real world?
* Do you edit things where they sit in the real world, and then commit that to version control?
* Do you ever let these get out of sync?

A simple answer to this is to borrow an idea that developers have been using for a while:  continuous deployment.

When you commit to version control, a tool like [Jenkins](http://jenkins-ci.org/), [TeamCity](https://www.jetbrains.com/teamcity/), [AppVeyor](http://www.appveyor.com/), [Octopus Deploy](http://octopusdeploy.com/), or other CI/CD solutions will see this, and can automatically deploy your changes out to production.  Ideally after some tests run successfully.

So!  What does this actually look like for an IT professional?  Here's a simple example:

I make a change to a scheduled task script on my computer.  I push those changes to version control, and the rest is automatic!  In the background, Jenkins sees my change, calls PSDeploy, and the scheduled task script is pushed out to production!

Here's an illustration from the [original PSDeploy post](http://ramblingcookiemonster.github.io/PSDeploy/):

[![psdeployflowsmall](https://cloud.githubusercontent.com/assets/6377597/9177951/7fec1fa0-3f62-11e5-98bc-6a077d1c57f0.png)](https://cloud.githubusercontent.com/assets/6377597/9177949/7c5a0c26-3f62-11e5-9d31-61f74a324383.png)

## How Do I Install PSDeploy?

You can pull down PSDeploy a few ways.

The easy way, [assuming you have PowerShell 5, or install the down-level PowerShellGet module](https://www.powershellgallery.com/):

```powershell
Install-Module PSDeploy

Import-Module PSDeploy
```

The old-fashioned way:

* [Download the repository archive](https://github.com/RamblingCookieMonster/PSDeploy/archive/master.zip)
* Unblock the archive file
* Extract the PSDeploy folder to a module path (e.g. `$env:USERPROFILE\Documents\WindowsPowerShell\Modules\`)
* Import the module: `Import-Module PSDeploy`

Once you've installed PSDeploy, you can check out the various functions and help:

```powershell
# Get commands in the module
    Get-Command -Module PSDeploy

# Get help for the module and a command
    Get-Help about_PSDeploy
    Get-Help Invoke-PSDeploy -full
```

That's about it, you're ready to get started with PowerShell based deployments.

## How Do I Use PSDeploy

So! You've installed PSDeploy.  Now what?

At a high level, you write a *.psdeploy.ps1 deployment script.  PSDeploy reads this and runs the deployments that you defined.

Let's step through a few examples to illustrate the basics.  We'll pretend we have the following files and folders for these examples:

[![Source files](/images/psdeploy2/sourcefiles.png)](/images/psdeploy2/sourcefiles.png)

### A basic deployment

At the very least, we need a Deploy, By, FromSource, and To:

```powershell
Deploy SomeDeploymentName {
    By FileSystem {
        FromSource MyModule
        To C:\PSDeployTo
    }
}
```

You can check what PSDeploy sees by running Get-PSDeployment:

```powershell
Get-PSDeployment -Path C:\PSDeployFrom\my.psdeploy.ps1
```

[![Get-PSDeployment](/images/psdeploy2/getpsdeployment.png)](/images/psdeploy2/getpsdeployment.png)

Let's add some more features!

### A more fun deployment

We're going to use a few new features of PSDeploy:  tags and dependencies.  They're relatively pointless here, but might help you with an actual deployment need:

```powershell
Deploy SomeDeploymentName {
    By FileSystem AllTheThings {
        FromSource MyModule,
                   SomeScripts
        To C:\PSDeployTo
        DependingOn SomeDeploymentName-MyModule  #DeploymentName-ByName
        Tagged Dev
    }

    By FileSystem MyModule {
        FromSource MyModule
        To \\ServerY\c$\SomePSModulePath,
           \\ServerX\SomeShare$\Modules
        Tagged Prod,
               Module
    }
}
```

Let's look at how PSDeploy sees this:

[![Get-PSDeployment](/images/psdeploy2/getpsdeployment2.png)](/images/psdeploy2/getpsdeployment2.png)

Like many PowerShell objects, we can find more properties using Select-Object:

[![Get-PSDeployment](/images/psdeploy2/getpsdeployment2all.png)](/images/psdeploy2/getpsdeployment2all.png)

So! We see that the deployments have tags, and Get-PSDeployment gave us the results back taking the dependency we specified into account.

Finally, maybe we only want to look at deployments tagged prod:

[![Get-PSDeployment](/images/psdeploy2/getpsdeployment2tags.png)](/images/psdeploy2/getpsdeployment2tags.png)

So, how do we actually run these deployments?

### Invoke-PSDeploy

Invoking a deployment is simple:  we call Invoke-PSDeploy.  This borrows a few conventions from Invoke-Pester.

Running Invoke-PSDeploy with no parameters will recursively search for *.psdeploy.ps1 files under your current path, and run everything that it finds.  In this scenario, any relative paths in the deployment use the current path as the deployment root:

```powershell
Invoke-PSDeploy
```

Running Invoke-PSDeploy with a path parameter specifying a folder will recursively search for *.psdeploy.ps1 files under that specific folder.  It will use the specfied folder as the root for any relative paths in the deployment:

```powershell
Invoke-PSDeploy -Path \\Path\Below\PSDeployConfigs\
```

Finally, you can run Invoke-PSDeploy with a path parameter specifying a *.psdeploy.ps1 file.  It will use that deployment script's parent path as the root for any relative paths in the deployment:

```powershell
Invoke-PSDeploy -Path \\Path\To\Some.PSDeploy.ps1
```

## What Can I Deploy?

Now that you know how to use PSDeploy, what can you use it to deploy?  Some of these things might seem simple, but having a layer of abstraction to hide some of your code can be quite helpful:

* **FileSystem**:  Copy files or folders.  Uses copy-item and robocopy behind the scenes, respectively
* **FileSystemRemote**:  Same as FileSystem, but runs in a remote PSSession.  Mind the double hop.
* **MkDocs**:  Build and deploy an [MkDocs](http://www.mkdocs.org/) site - thanks to Michael Lombardi!

It's pretty bare bones for now, but contributions would be more than welcome; [extending PSDeploy](https://github.com/RamblingCookieMonster/PSDeploy/wiki/Extending-PSDeploy) takes two quick steps:  write a script to handle deployments, and a config file that tells PSDeploy what DeploymentType invokes that script.

It might be a fun way to get experience working with GitHub, and perhaps some integration testing, if you're up for it!

As time goes on, you can run Get-PSDeploymentType to list available deployment types, and Get-PSDeploymentType SomeDeploymentType -ShowHelp to view the help for that deployment type:

[![Get-PSDeploymentType](/images/psdeploy2/getpsdeploymenttype.png)](/images/psdeploy2/getpsdeploymenttype.png)

[![Get-PSDeployment](/images/psdeploy2/getpsdeploymenttypehelp.png)](/images/psdeploy2/getpsdeploymenttypehelp.png)

That's about it! Let's recap.

## What Changed in PSDeploy?

* ***.PSDeploy.ps1 deployment configurations**, in addition to yaml
* **Yaml deployment configurations deprecated**.  These still work, but development efforts and new features will focus on *.psdeploy.ps1 scripts
* **Tagged deployments** to help filter or categorize deployments
* **Deployment dependencies** to help ensure deployments perform in the necessary order
* **Noop DeploymentType** to help explore or debug the environment when a deployment runs

## Wrapping Up

This was a fun little project!  I've found the functionality quite helpful for PowerShell based deployments, whether they start in Jenkins, GitLab CI, or from the shell.

If you'd like to contribute or collaborate, [issues and pull requests](https://github.com/RamblingCookieMonster/PSDeploy) would be welcome!  If you want to extend PSDeploy with more deployment types, some brief notes are available [in the wiki](https://github.com/RamblingCookieMonster/PSDeploy/wiki/Extending-PSDeploy), and I would be more than happy to help!

Cheers!