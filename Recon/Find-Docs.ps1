function Find-Docs
{
<#
.SYNOPSIS
Searches inside a folder for documents based on predefined extensions. Adds a "Category" field to indicate document type.  Type is text, spreadsheet, data, or media.
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
 
.PARAMETER Folder
Specifies the path to search files. By default, searches $env:USERPROFILE

.EXAMPLE
Find-Docs c:\users\ | select Name, Category

.LINK
http://www.twitter.com/whereIsBiggles

#>
    [CmdletBinding()] Param (
        $folder = $env:USERPROFILE
    )
    
    if (-not (Test-Path $folder))
    {
        Write-Error "Cannot find folder '$folder'" -Category ReadError
    }

    $fileTypes = 
    @{
        "Text" = @(".WPS",".WPD",".TXT",".TEX",".RTF",".PAGES",".ODT",".MSG",".LOG",".DOCX",".DOC",".PPTX",".PPT")
        "Data" = @(".XML",".VCF",".TAX2017",".TAX2016",".TAR",".SDF",".PPS",".KEYCHAIN",".KEY",".GED",".DAT", ".ZIP")
        "Media" = @(".WMV",".VOB",".SWF",".SRT",".RM",".MPG",".MP4",".MOV",".M4V",".FLV",".AVI",".ASF",".3GP",".3G2",".WMA",".WAV",".MPA",".MP3",".MID",".M4A",".M3U",".IFF",".AIF")
        "Spreadsheets" = @(".XLSX",".XLS",".XLR",".CSV")
    }

    $fileTypesExtensions = @()
    $fileTypes.Values | % {
        foreach ($extension in ($_))
        {
            $fileTypesExtensions += $extension
        }
    }

    $fileList = Get-ChildItem -Recurse $folder | Where-Object {$fileTypesExtensions -contains $_.Extension}
    
    foreach ($file in $fileList)
    {
        $extension = $file.Extension
        $fileTypes.Keys | % {
            if($fileTypes[$_] -contains $extension)
            {
                $category =  $_
            }
        }
        Add-Member -InputObject $file -MemberType NoteProperty -Name "Category" -Value $category
    }

    return $fileList
}

