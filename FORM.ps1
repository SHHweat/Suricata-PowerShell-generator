
[System.Reflection.Assembly]::LoadWithPartialName("System.Win.Forms")
$form = New-Object System.Windows.Forms.Form
$form.Text = "Suricata Alert Generator"


$image = [System.Drawing.Image]::FromFile("$PSScriptRoot\suricata_icon.png")
$form.BackgroundImage = $image
$form.BackgroundImageLayout = 'Stretch'
$form.Size = New-Object System.Drawing.Size(500,600)

#--------------------

$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Alert File: "
$Label1.Location = New-Object Drawing.Point(10,62)
$Label1.AutoSize = $true
$form.Controls.Add($Label1)

$selectTextbox = New-object System.Windows.Forms.Textbox
$selectTextbox.Location = New-Object Drawing.Size(90,60)
$selectTextbox.Size = New-Object Drawing.Size(180,25)
$selectTextbox.AutoSize = $true
$selectTextbox.Multiline =$false
$selectTextbox.ScrollBars = "Vertical"
$form.Controls.Add($selectTextbox)


$selectButton = New-Object System.Windows.Forms.Button
$selectButton.Text = "Browse"
$selectButton.Location = New-Object Drawing.Size(350,60)
$selectButton.AutoSize = $true
$form.Controls.Add($selectButton)


Function Sel_File($InitialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = “All files (*.*)| *.*”
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") 
    {
    [System.Windows.Forms.MessageBox]::Show("No File Selected. Please select a file !", "Error", 0, 
    [System.Windows.Forms.MessageBoxIcon]::Exclamation)
    }   $Global:SelectedFile = $OpenFileDialog.SafeFileName
    
}
$selectButton.Add_Click({Sel_File
$FileChosen = $selectTextbox.Text = $Global:SelectedFile
})

#--------------------






# add controls.add..buttons/radios/etc. here
#$form.Controls.AddRange(@())

$form.ShowDialog()

