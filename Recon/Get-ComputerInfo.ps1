function Get-ComputerInfo
{
<#
.SYNOPSIS
Retrieves some computer information to help understanding the environment.
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None

.EXAMPLE
Get-ComputerInfo 

.LINK
http://www.twitter.com/whereIsBiggles

#>
    $WMIClasses =
    @(
        "Win32_ComputerSystem",
        "Win32_LogicalDisk",
        "Win32_Processor",
        "Win32_Bios"
    )

    foreach ($WMIClass in $WMIClasses)
    {
        $computerInfoDetails += $WMIClass
        $computerInfoDetails += ( Get-WmiObject -Class $WMIClass | Out-String )
    }

    $computerInfoDetails += "Network adapters"
    $computerInfoDetails += Get-WmiObject -namespace root\cimv2 -class Win32_NetworkAdapter | select name, adapterType, macaddress | Out-String
    
    Write-Verbose $computerInfoDetails      
}
