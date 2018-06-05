function Find-PII
{
<#
.SYNOPSIS
Searches inside text-based files to patterns matching PII, such as birthdays, credit cards, and social security numbers.
Author: Aelon Porat (@whereIsBiggles) except for the CC validation function
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
 
.PARAMETER Folder
Specifies the path to search files

.PARAMETER Recursive
Specifies wether or not to recurse into $folder

.EXAMPLE
Find-PII -Recursive c:\users\ 

.LINK
http://www.twitter.com/whereIsBiggles

#>
    [CmdletBinding()] Param (
        [Parameter(Mandatory = $true)]
        [string]$Folder = $(throw "-Folder is required"),
      
        [Parameter(Mandatory = $false)]
        [bool]$Recurse
    )

    if (-not (Test-Path $folder))
    {
        Write-Error "Cannot find folder '$folder'" -Category ReadError
    }
    else
    {
        Write-Verbose "Searching for PII data in files under '$folder'"

        $regexPatterns =
        @{
            "SSN" = "[0-9]{3}[-| ][0-9]{2}[-| ][0-9]{4}"
            "DOB" = "[^0-9][0-9]{2}[-| |/][0-9]{2}[-| |/][0-9]{2,4}"
            "Email" = "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
            "Creds" = "password|passwd|cred|username|login"
            "CC_Visa" = "(4\d{3}[.]\d{4}[-| ]\d{4}[-| ]\d{4})|(4\d{15})"
            "CC_MasterCard" = "(5[1-5]\d{14})|(5[1-5]\d{2}[-| ]\d{4}[-| ]\d{4}[-| ]\d{4})"
            "CC_Amex" = "(3[47]\d{13})|(3[47]\d{2}[-| ]\d{6}[-| ]\d{5})"
            "CC_Diners" = "(3(?:0[0-5]|[68]\d)\d{11})|(3(?:0[0-5]|[68]\d)\d[-| ]\d{6}[-| ]\d{4})"
            "CC_Discover" = "(6(?:011|5\d{2})\d{12})|(6(?:011|5\d{2})[-| ]\d{4}[-| ]\d{4}[-| ]\d{4})"
            "CC_JCB" = "((?:2131|1800|35\d{3})\d{11})|((?:2131|1800|35\d{2})[-| ]\d{4}[-| ]\d{4}[-| ]\d{3}[\d| ])"
        }

        $AllPIIFound = @()

        foreach ($PIIRegexPattern in ($regexPatterns.Keys))
        {
            Write-Verbose "Searching for $PIIRegexPattern usign pattern ""$($regexPatterns[$PIIRegexPattern])"""
            if ($Recurse)
            {
                $PIIFound = Get-ChildItem -Path $Folder -Recurse | Select-String $regexPatterns[$PIIRegexPattern]
            }
            else
            {
                $PIIFound = Get-ChildItem -Path $Folder | Select-String $regexPatterns[$PIIRegexPattern]
            }
           
            foreach ($PIIFoundItem in $PIIFound)
            {
                $PIIFoundObj = "" | Select-Object "Pattern", "FilePath", "Line", "LineNumber"
                $PIIFoundObj.Pattern = $PIIRegexPattern 
                $PIIFoundObj.FilePath = $PIIFoundItem.Path
                $PIIFoundObj.Line = $PIIFoundItem.Line
                $PIIFoundObj.LineNumber = $PIIFoundItem.lineNumber
                $AllPIIFound += $PIIFoundObj 
             }
        }

        foreach ($PIIItem in $AllPIIFound)
        {
            if ($PIIItem.Pattern -match "^CC_")
            {
                $PIIItem.Line -match $regexPatterns[$PIIItem.Pattern] | Out-Null
                $CCNumber = $Matches[0]
                if (-not (Test-LuhnNumber $CCNumber))
                {
                    $PIIItem.Line = $Null
                }
            }
        }

        return ( $AllPIIFound | Where-Object {$_.line -ne $Null})
    }
}


# Test-LuhnNumber to validate CC number pattern taken from https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#PowerShell
function Test-LuhnNumber
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]
        $Number
    )
 


    $digits = ([Regex]::Matches($Number,'.','RightToLeft')).Value
 
    $digits |
        ForEach-Object `
               -Begin   {$i = 1} `
               -Process {if ($i++ % 2) {$_}} |
        ForEach-Object `
               -Begin   {$sumOdds = 0} `
               -Process {$sumOdds += [Char]::GetNumericValue($_)}
    $digits |
        ForEach-Object `
               -Begin   {$i = 0} `
               -Process {if ($i++ % 2) {$_}} |
        ForEach-Object `
               -Process {[Char]::GetNumericValue($_) * 2} |
        ForEach-Object `
               -Begin   {$sumEvens = 0} `
               -Process {
                            $_number = $_.ToString()
                            if ($_number.Length -eq 1)
                            {
                                $sumEvens += [Char]::GetNumericValue($_number)
                            }
                            elseif ($_number.Length -eq 2)
                            {
                                $sumEvens += [Char]::GetNumericValue($_number[0]) + [Char]::GetNumericValue($_number[1])
                            }
                        }
 
    ($sumOdds + $sumEvens).ToString()[-1] -eq "0"
}
 
