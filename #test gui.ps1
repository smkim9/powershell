#test gui

Add-Type -AssemblyName System.Windows.Forms
Import-Module ActiveDirectory

$Form = New-Object Windows.Forms.Form
$Form.Text = "Add ADUser"
$Form.Width = 500
$Form.Height = 300

# Create labels for user information
$LabelUsername = New-Object Windows.Forms.Label
$LabelUsername.Text = "Username:"
$LabelUsername.Location = New-Object Drawing.Point(20, 20)
$LabelUsername.AutoSize = $true

$LabelPassword = New-Object Windows.Forms.Label
$LabelPassword.Text ="Password:"
$LabelPassword.Location = New-Object Drawing.Point(20,50)
$LabelPassword.AutoSize = $true

$LabelConfirmPassword = New-Object Windows.Forms.Label
$LabelConfirmPassword.Text ="Confirm Password:"
$LabelConfirmPassword.Location = New-Object Drawing.Point(20,80)
$LabelConfirmPassword.AutoSize = $true

$LabelDepartment = New-Object Windows.Forms.Label
$LabelDepartment.Text = "Department:"
$LabelDepartment.Location = New-Object Drawing.point(20, 110)
$LabelDepartment.AutoSize = $true

$LabelOU = New-Object Windows.Forms.Label
$LabelOU.Text = "Organizational Unit:"
$LabelOU.Location = New-Object Drawing.Point(20, 140)
$LabelOU.AutoSize = $true

$LabelEmail = New-Object Windows.Forms.Label
$LabelEmail.Text = "Email:"
$LabelEmail.Location = New-Object Drawing.Point(20, 170)
$LabelEmail.AutoSize = $true

$LabelAction = New-Object Windows.Forms.Label
$LabelAction.Text = "Action:"
$LabelAction.Location = New-Object Drawing.Point(20, 200)
$LabelAction.AutoSize = $true

# Create a text box for entering the username
$UsernameTextBox = New-Object Windows.Forms.TextBox
$UsernameTextBox.Location = New-Object Drawing.Point(120, 20)
$UsernameTextBox.Width = 250

$PasswordTextBox = New-Object Windows.Forms.TextBox
$PasswordTextBox.Location = New-Object Drawing.Point (160, 50)
$PasswordTextBox.Width = 250
$PasswordTextBox.UseSystemPasswordChar = $true

$ConfirmPasswordTextBox = New-Object Windows.Forms.TextBox
$ConfirmPasswordTextBox.Location = New-Object Drawing.Point (160, 80)
$ConfirmPasswordTextBox.Width = 250
$ConfirmPasswordTextBox.UseSystemPasswordChar = $true

$DepartmentTextBox = New-Object Windows.Forms.TextBox
$DepartmentTextBox.Location = New-Object Drawing.Point(160,110)
$DepartmentTextBox.Width = 250

$OUTextBox = New-Object Windows.Forms.TextBox
$OUTextBox.Location = New-Object Drawing.Point (160,140)
$OUTextBox.width = 250

$EmailTextBox = New-Object Windows.Forms.TextBox
$EmailTextBox.Location = New-Object Drawing.Point(160, 170)
$EmailTextBox.Width = 250 

# Create a combo box for selecting the action
$ActionBox = New-Object Windows.Forms.ComboBox
$ActionBox.Location = New-Object Drawing.Point(160, 200)
$ActionBox.Items.Add("Add User")
$ActionBox.Items.Add("Remove User")
$ActionBox.SelectedIndex = 0

# Create a button to perform the action
$ActionButton = New-Object Windows.Forms.Button
$ActionButton.Text = "Execute"
$ActionButton.Location = New-Object Drawing.Point(20, 230)
$ActionButton.Add_Click({
    $Username = $UsernameTextBox.Text
    $Password = ConvertTo-SecureString $PasswordTextBox.Text -AsPlainText -Force
    $Department = $DepartmentTextBox.Text
    $OU = $OUTextBox.Text
    $Email = $EmailTextBox.Text
    $Action = $ActionBox.SelectedItem

    if ($Action -eq "Add User") {
          try {
         New-ADUser -Name $Username -Enabled $true -AccountPassword $Password -Department $Department -Path "OU=$OU,DC=Adatum,DC=com" -EmailAddress $Email -PasswordNeverExpires $true
            Write-Host "User '$Username' added successfully to Active Directory."
              } catch {
             Write-Host "Error: $_"
          }
           } elseif ($Action -eq "Remove User") {
            try {
           Remove-ADUser -Identity $Username -Confirm:$false
           Write-Host "User '$Username' removed successfully from Active Directory."
           } catch {
           Write-Host "Error: $_"
            }
             }
               })

             # Add controls to the form
    $Form.Controls.Add($LabelUsername)
    $Form.Controls.Add($UsernameTextBox)
    $Form.Controls.Add($LabelPassword)
    $Form.Controls.Add($LabelConfirmPassword)
    $Form.Controls.Add($ConfirmPasswordTextBox)
    $Form.Controls.Add($PasswordTextBox)
    $Form.Controls.Add($LabelDepartment)
    $Form.Controls.Add($DepartmentTextBox)
    $Form.Controls.Add($LabelOU)
    $Form.Controls.Add($OuTextBox)
    $Form.Controls.Add($LabelEmail)
    $Form.Controls.Add($EmailTextBox)
    $Form.Controls.Add($LabelAction)
    $Form.Controls.Add($ActionBox)
    $Form.Controls.Add($ActionButton)
    $Form.ShowDialog()
    $Form.Dispose()