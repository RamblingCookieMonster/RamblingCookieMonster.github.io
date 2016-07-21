---
layout: post
title: "Invoke PowerShell on Azure VMs"
excerpt: "Doing it wrong"
tags: [PowerShell, Tools]
modified: 2016-07-21 07:00:00
date: 2016-07-21 07:00:00
comments: true
image:
 feature: banner.jpg
 thumb: /vmscript/browncloud.png
---
{% include _toc.html %}

## Rambling

I cut my teeth in a conservative enterprise environment.  Few, if any services were hosted.  I'm now in an organization that's very open to hosted services where they make sense.

Need to spin up a bunch of temporary compute?  Use something like Azure or AWS, rather than going through the time and effort to provision physical resources that won't necessarily have a purpose in a few weeks, assuming our processes for physical equipment are even efficient enough to get these up and running in time for the customer's deadline.

So!  I had my first go at this the other week.  There's a deadline coming up, and a team is a bit behind on generating some data.  We have plenty of *nix compute, but they have this wonderful single threaded, Windows-specific workload to run.

If only we had a service where we could spin up a bunch of VMs.  Oh!  We have an Azure account.  If only we had the budget.  Oh!  We might have credits, or maybe this actually made the budget.

If only we had experience spinning up legacy Windows systems in the cloud, with no connectivity to our configuration management platform.  Time to improvise and make a few mistakes!

This is a quick hit on my experience with a similar scenario, that will likely expose my inexperience with Azure, and hosted services in general.

## Clones

First things first!  We spin up a single Azure VM using the legacy Server 2008 R2 OS.  Requirements dictate this, sadly.  Testing goes well.  *We'll take 50 of them!* our customer enthusiastically exclaims.  After validating that yes, they actually do need 50, selecting an optimal VM size, and configuring the image, we're off to the races.

[Azure quickstart templates](https://github.com/Azure/azure-quickstart-templates) look fantastic, and I've heard great things, but time is tight, so I borrow some code from Stephane Lapointe to [capture a template](http://www.codeisahighway.com/how-to-capture-your-own-custom-virtual-machine-image-under-azure-resource-manager-api/) and [create VMs](http://www.codeisahighway.com/how-to-create-a-virtual-machine-from-a-custom-image-using-arm-and-azure-powershell-v1-0-x/) (similar content from Microsoft: [capture](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-classic-capture-image/), [create](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-classic-createportal/)).

There are a few tweaks to make: we use [network security groups](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-nsg/), and we already have a virtual network to use, but by and large our code is similar, outside of [some sanitation and error handling](http://ramblingcookiemonster.github.io/Trust-but-Verify/) to avoid a mess.  We spin up the first clone.

Oh.  That VM took over five minutes to create.  I'm new to this, so I want to watch things progress to see if any issues come up.  I'm not waiting 50 * 5 minutes.  Runspaces are a thing.  Usually I would go with Boe Prox's fantastic [PoshRsJob](https://github.com/proxb/PoshRSJob), but this is a quick hit, so I go with [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel).  Someone mentioned that they had seen it [used with Azure](https://blog.kloud.com.au/2016/02/10/synchronously-startstop-all-azure-resource-manager-virtual-machines-in-a-resource-group/), so I wrapped my code in Invoke-Parallel, and kicked things off.

Nice!  Fifty VMs up and running.  But... how do I get to them?

## Public IPs

This has to be simple.  There are so many AzureRm Cmdlets, We must be able to pull details on VMs along with their public IPs.

```powershell
Get-AzureRmVm @params | Get-AzureRmPublicIP @otherparams
# Nope

Get-AzureRmVm @params | Get-AzureRmNetworkInterface @otherparams
# Nope
```

Huh.  There's no PowerShell-y way to do this that I can find.  That's sad.  Guess we'll write a function!  [Get-AzureRmVmPublicIp](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Get-AzureRmVmPublicIP.ps1)

```
Get-AzureRmVmPublicIP -ResourceGroupName 'my-resource-group'

# VMName  NICName    PublicIP
# ------  -------    --------
# VM-2    VM-2-NIC   23.96.1.2
# VM-3    VM-3-NIC   23.96.1.3
# VM-4    VM-4-NIC   168.61.2.1
# VM-16   VM-16-NIC  168.61.10.27
# VM-17   VM-17-NIC  23.96.17.56
# VM-18   VM-18-NIC  23.96.19.71
# VM-1    VM-1-NIC   Not Assigned
```

Perfect!  We can now get a list of VMs and public IPs.  Our customer doesn't have access to Azure, that would likely be a better solution here, but what can you do.

## Catastrophe(ish)

Our customer is quite thankful.  Their work is chugging along on day one.  We continue our various other projects and tasks.  Ideally we might have something like [OMS](https://azure.microsoft.com/en-us/documentation/articles/operations-management-suite-overview/) up and running to watch these VMs.  Thankfully, one of our astute customers notices when one of these VMs restart overnight.

We should probably mention here that when you run a workload in the cloud, that workload should be designed appropriately.  If you have a system sensitive to restarts running on Azure, AWS, or any other hosted service, you're going to have a bad time.  Alas, we're talking code written by and for a unique audience; it can't handle multiple cores, let alone the many scenarios that come up in a hosted environment.

What happened?  The sysprep process re-enabled automatic updates.  Lesson: If you don't use configuration management, you need to think carefully about all of the things you previously configured and take for granted.

No problem!  We'll just use PowerShell remoting to fix the config, and to find systems that restarted to give the customer a nice report on systems they'll need to visit.  Oh.  Server 2008 R2.  Remoting isn't enabled out of the box.  And our group policy isn't applied.

So!  A few lessons.  Planning is important.  Had we done this before, and not been under a deadline of a day or so, hopefully we would have addressed these.  Being able to manage your systems is somewhat important.

That's fine, Microsoft learned from VMware's Invoke-VMScript (presumably) and recently gave us [PowerShell Direct](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/vmsession?f=255&MSPPError=-2147217396).  Surely this, or something similar is available in Azure.

Nope nope nope.

## Invoke a Script

That's all I want.  To invoke a script on a VM.  I look around.  I read about [custom script extensions](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-classic-extensions-customscript/).  Interesting: upload a file, add the extension to a VM, not terribly complicated.  Oh.  You can only have one per VM.  Any other options?

I ask around.  I join an [Azure Slack team](azured.io).  Crickets.  Someone finally responds:  Azure Runbooks or Hybrid Runbook Workers might work.  I could be wrong, but I couldn't find anything that would let me run a PowerShell script on an Azure VM, without configuring remoting or registering a hybrid runbook worker on each VM.

Back to custom script extensions.  We can deal with the limitations.  A few minutes later, updates are disabled.  The customer already ran through and checked for restarted systems, so they're good to go, no list needed.

I have this nagging feeling.  I need to be able to run a command and get the output back.  We're not about to RDP into 50 systems manually if something else comes up.  We already have the building blocks from executing the CustomScriptExtension to configure updates, all we need to do is abstract out each step of the process.

I check the Azure Slack team one more time.  I'm a fan of using existing libraries, and contributing to them if they need a bit more functionality.  No luck.

I spend a few minutes and put together [Invoke-AzureRmVmScript](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-AzureRmVmScript.ps1).  I test it on one VM.  It works.  I test it with Invoke-Parallel.  It works.  Yay!

### Invoke-AzureRmVmScript

We boil everything down into a few high level steps:

* [Check the VM for existing CustomScriptExtensions](https://github.com/RamblingCookieMonster/PowerShell/blob/aecea7781ee82141a6990e39594f43dfb46edb67/Invoke-AzureRmVmScript.ps1#L168)
* [Upload our script to an Azure storage account](https://github.com/RamblingCookieMonster/PowerShell/blob/aecea7781ee82141a6990e39594f43dfb46edb67/Invoke-AzureRmVmScript.ps1#L197)
* [Set the CustomScriptExtension on the VM](https://github.com/RamblingCookieMonster/PowerShell/blob/aecea7781ee82141a6990e39594f43dfb46edb67/Invoke-AzureRmVmScript.ps1#L267)
* [Read the output from the script](https://github.com/RamblingCookieMonster/PowerShell/blob/aecea7781ee82141a6990e39594f43dfb46edb67/Invoke-AzureRmVmScript.ps1#L294)

This is a quick-publish, so more work to do, but if you're looking for a simple way to invoke PowerShell on an Azure VM, without using PowerShell remoting or installing a worker on the VM, [Invoke-AzureRmVmScript](https://github.com/RamblingCookieMonster/PowerShell/blob/master/Invoke-AzureRmVmScript.ps1) might do the trick.

Let's look at a few examples!

### Investigating Output

PowerShell lets us send output to [various streams](https://blogs.technet.microsoft.com/heyscriptingguy/2014/03/30/understanding-streams-redirection-and-write-host-in-powershell/).  I wonder which we can get back from Azure?

```powershell
    $params = @{
        ResourceGroupName = 'My-Resource-Group'
        VMName = 'VM-22'
        StorageAccountName = 'storageaccountname'
    }

    Invoke-AzureRmVmScript @params -ScriptBlock {
        "Hello world! Running on $(hostname)"
        Write-Error "This is an error"
        Write-Warning "This is a warning"
        Write-Verbose "This is verbose!" -Verbose
        Write-Host "This is killing a kitten"
    }
```

I wait patiently (this is not fast, Set-AzureRmVmCustomScriptExtension takes some time):

```
ResourceGroupName : My-Resource-Group
VMName            : VM-22
Substatuses       : {Microsoft.Azure.Management.Compute.Models.InstanceViewStatus, Microsoft.Azure.Management.Compute.Models.InstanceViewStatus}
StdOut_succeeded  : Hello world! Running on HF-22\nWARNING: This is a warning\nVERBOSE: This is verbose!\nThis is killing a kitten
StdErr_succeeded  : C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.8\Downloads\0\017\n21f1b_7a06_4a45_8d12_3974b59deaf5.ps1 : This is an error\n    + CategoryInfo 
                             : NotSpecified: (:) [Write-Error], WriteErrorExcep \n   tion\n    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorExceptio \n   
                    n,01721f1b_7a06_4a45_8d12_3974b59deaf5.ps1\n 
```

Yuck!  Unfortunately, we're getting plain text back here, including special characters like \n which would typically be represented by an actual new line.  We might write something to serialize output to JSON if we were so inclined, and were stuck on PowerShell 2 without [ConvertTo-Json](https://technet.microsoft.com/en-us/library/hh849922.aspx).

What did we get?  Pretty much everything went to StdOut - Output, Warning, Verbose, and Information streams were all captured.  As expected, the error stream went to StdErr.

So! That's one VM, and it took a bit over a minute to run.  That's painful.

### Parallelize!

I'm impatient when it comes to running code.  Waiting for AppVeyor to [queue, test, and deploy a module](ramblingcookiemonster.github.io/PSDeploy-Inception/) occasionally induces twitching.

In this case, there's a simple solution: runspaces!  Not writing our own, that can be painful, but borrowing something like [PoshRsJob](https://github.com/proxb/PoshRSJob).  We'll use [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel) for this simple example:

```powershell
# Get all the VMs in our resource group where the agent status is ready
$ResourceGroupName = 'My-Resource-Group'
$StorageAccountName = 'mystorageaccount'
$StorageAccountKey = 'my storage account key in plain text' # you can omit this and we'll pull it for you...
$VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroupName |
    Foreach {
        Get-AzureRmVm -ResourceGroupName $ResourceGroupName -Name $_.Name -Status
    } |
    Where-Object {$_.VMAgent.Statuses[0].DisplayStatus -like 'Ready'} |
    Select -ExpandProperty Name

```

Basically, I want all VMs in my resource group that have a VMAgent that is ready.  I have my VMs, time to play!

```powershell
# Kick off script on VMs in parallel
# 50 at a time, timeout at 5 minutes, pull in variables

$InvokeParallelParams = @{
    RunspaceTimeout = (60*5)
    Throttle = 50
    InputObject = $VMs
    ImportVariables = $true
}

$Output = Invoke-Parallel @InvokeParallelParams -ScriptBlock {

    # Load Invoke-AzureRmVmScript. Alternatively you could hard code it here, or we could fix Invoke-Parallel to pull in functions
    . 'C:\Invoke-AzureRmVmScript.ps1'

    # Parameters to splat
    $params = @{
        ResourceGroupName = $ResourceGroupName
        VMName = $_
        StorageAccountName = $StorageAccountName
        StorageAccountKey = $StorageAccountKey
        Force = $True
    }

    Invoke-AzureRmVmScript @params -ScriptBlock {
        $Processes = Get-Process -Name ExampleProcess
        "'$($Processes.count)' ExampleProcess processes on $(hostname)"
    }
}
```

It will still take some time, but this beats running things serially!  It looks like at least one VM is ready to tear down:

```
$Output

VMName StdOut_succeeded
------ ----------------
VM-12  '' ExampleProcess processes on VM-12
VM-21  '4' ExampleProcess processes on VM-21
VM-18  '5' ExampleProcess processes on VM-18
VM-40  '5' ExampleProcess processes on VM-40
VM-27  '6' ExampleProcess processes on VM-27
VM-3   '6' ExampleProcess processes on VM-3
VM-51  '6' ExampleProcess processes on VM-51
VM-52  '6' ExampleProcess processes on VM-52
VM-6   '6' ExampleProcess processes on VM-6
...
```

That's about it!

Going forward, we'll have more time to plan these out, and connectivity should be available for important things like configuration management and authentication, but if we ever need it, we'll have a quick tool to hit poorly-setup-systems.  Perhaps we could bootstrap remoting or other connectivity with this function, but these VMs are already reaching their end of life.

And thus ends my first experience working with resources in the cloud.  It's been fun, looking forward to more!

Side note: the brown cloud illustrates my ability to work with the cloud, and is not a reflection on Azure. Okay, maybe it's a hyperbolic reflection on the documentation, a few bugs I ran into, and some not-as-PowerShell-y-as-expected behavior.