#Set up some logging. You might consider writing or finding a standard logging module.
    $Date        = Get-Date
    $LogPath     = "C:\temp"
    $LogGeneral  = Join-Path $LogPath 'Gen.log'
    $LogEnvStart = Join-Path $LogPath 'EnvStart.xml'
    $LogErrors   = Join-Path $LogPath 'Errors.log'

#Log initial details
    $Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
    $Whoami = whoami # Simple, could use $env as well
    "Running script $($MyInvocation.MyCommand.Path) at $Date"
    "Admin: $Admin" | Out-File $LogGeneral -Append
    "User: $Whoami" | Out-File $LogGeneral -Append
    "Bound parameters: $($PSBoundParameters | Out-String)" | Out-File $LogGeneral -Append

    #Only track two layers.  If you need deeper properties, expand this or track them independently
    Get-Variable | Export-Clixml -Depth 2 -Path $LogEnvStart

#Write to the root of C, requires admin
    Try
    {
        #The -ErrorAction Stop brings us to the catch block, if we get an error...
        $FailingFile = 'C:\ThisWorked.txt'
        New-Item -ItemType File -Path C:\ThisWorked.txt -Force -ErrorAction Stop
    }
    Catch
    {
        "I can log a friendly description of the error here, or log the error:" | Out-File $LogErrors -Append
        $_ | Out-File $LogErrors -Append

        # Google around, there is much more detail in an error than meets the eye.
        # PowerShell in Action has a great 'Show-ErrorDetails' function...
   
        # Note that unless I explicitly stop here, PowerShell keeps going
        # Throw "You will never see this terminating error!"
    }

# If you depend on changes you made, verify them.  Let's check if that file exists.
    If( -not (Test-Path $FailingFile -ErrorAction SilentlyContinue))
    {
        "'$FailingFile' didn't exist, failing gracefully" | Out-File $LogErrors -Append
        Throw "This error won't show up in any logs, we already logged the important bit"
    }

# Do something silly. Typo, but no error because I'm using *
    Add-PSSnapin VMwre*

    Try
    {
        #This will fail, because we didn't verify that the VMware snapin loaded...
        Get-PowerCLIConfiguration -ErrorAction Stop
    }
    Catch
    {
        $_ | Out-File $LogErrors -Append
    }