
function Display-FakeBaloonNotification()
{
<#
.SYNOPSIS
Displays a fake baloon notification

.DESCRIPTION
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None

.EXAMPLE
Display-FakeBaloonNotification -Title "Windows Network Error" -Message "Windows requires your password to continue."

.LINK
http://www.twitter.com/whereIsBiggles

#>
    [CmdletBinding()] Param (
        [Parameter(Mandatory = $true)]
        [string]$Title = $(throw "-Title is required"),
      
        [Parameter(Mandatory = $true)]
        [string]$Message = $(throw "-Message is required")
 
    )

    Add-Type -Assembly System.Windows.Forms

    Write-Verbose "Popping up baloon notification"

    $baloon = New-Object System.Windows.Forms.NotifyIcon
    $baloon.Icon = [System.Drawing.SystemIcons]::Information
    $baloon.BalloonTipTitle = $Title
    $baloon.BalloonTipIcon = "Warning"
    $baloon.BalloonTipText = $Message
    $baloon.Visible = $True
    $baloon.ShowBalloonTip(500)
    
    Start-Sleep 5

    $baloon.Visible = $false
    $baloon.Dispose()
}


