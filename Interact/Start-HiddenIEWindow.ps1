function Start-HiddenIEWindow()
{
<#
.SYNOPSIS
Starts a new IE window and navigates to a URL

.DESCRIPTION
Author: Aelon Porat (@whereIsBiggles) except for the CC validation function
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
Important: This function needs to be extended to provide interaction with the IE COM object
           Otherwise, the object is local to the function and should not be accessed globally.

.EXAMPLE
Start-HiddenIEWindow

.LINK
http://www.twitter.com/whereIsBiggles

#>
    [CmdletBinding()] Param (
        [Parameter(Mandatory = $false)]
        [string]$url
    )
    $ieObj = New-Object -com InternetExplorer.Application
    Write-Verbose "Created IE COM object `$ieObj"
    
    # Sleeping until URL has been loaded
    Start-Sleep 3

    Write-Verbose "Navigating to '$url'"
    $ieObj.navigate($url)
    while ($ieObj.Busy -eq $true)
    {
        Start-Sleep -Seconds 1
    }

    Write-Verbose "Page Loaded."
}
