function Get-InstalledPrograms()
{
<#
.SYNOPSIS
Retrieves programs installed and registered via MSI from HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall and from HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall.
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
 
.EXAMPLE
Get-InstalledPrograms

.LINK
http://www.twitter.com/whereIsBiggles
#>

    Write-Verbose "Fetching HKLM:\SOFTWARE\Microsoft"
    $installedPrograms = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*
    Write-Verbose "Fetching HKLM:\SOFTWARE\Wow6432Node"
    $installedPrograms += Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
    $installedPrograms = $installedPrograms | Select-Object DisplayName, Publisher | where {$_.DisplayName}

    return $installedPrograms
 
}
