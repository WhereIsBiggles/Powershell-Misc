function Get-Antivirus()
{
<#
.SYNOPSIS
Retrieves registered antivirus information from the computer
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
 
.EXAMPLE
Get-Antivirus

.LINK
http://www.twitter.com/whereIsBiggles
#>

    $AntivirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Query "SELECT * FROM AntiVirusProduct"
    return $AntivirusProduct
}
