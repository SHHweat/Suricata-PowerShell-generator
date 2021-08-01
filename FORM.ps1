
[System.Reflection.Assembly]::LoadWithPartialName("System.Win.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Suricata Alert Generator"


$image = [System.Drawing.Image]::FromFile("$PSScriptRoot\suricata_icon.png")
$form.BackgroundImage = $image
$form.BackgroundImageLayout = 'Stretch'
$form.Size = New-Object System.Drawing.Size(500,600)
$form.MinimizeBox = $true
$form.MaximizeBox = $true

#----------------------------------------------------------------------------------------------------

# IMPORT .TXT FILE/ LIST

$IMPORT_Label = New-Object System.Windows.Forms.Label
$IMPORT_Label.Text = "Import [.txt] File: "
$IMPORT_Label.Location = New-Object Drawing.Point(10,142)
$IMPORT_Label.AutoSize = $true
$form.Controls.Add($IMPORT_Label)

$IMPORT_Textbox = New-object System.Windows.Forms.Textbox
$IMPORT_Textbox.Location = New-Object Drawing.Size(115,140)
$IMPORT_Textbox.Size = New-Object Drawing.Size(180,25)
$IMPORT_Textbox.Multiline =$false
$form.Controls.Add($IMPORT_Textbox)


$IMPORT_Button = New-Object System.Windows.Forms.Button
$IMPORT_Button.Text = "Browse"
$IMPORT_Button.Location = New-Object Drawing.Size(300,140)
$IMPORT_Button.AutoSize = $true
$form.Controls.Add($IMPORT_Button)


Function IMPORT_File($InitialDirectory)
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

$IMPORT_Button.Add_Click({IMPORT_File
$FileChosen = $IMPORT_Textbox.Text = $Global:SelectedFile
})

#----------------------------------------------------------------------------------------------------

<#----------------------------------------------------------------------------------------------------

# DROPDOWN ALERT LIST

[array]$ScriptList = "IP", "DOMAIN", "FILES", "HASH", "CUSTOM"
$alertDropDown = New-Object System.Windows.Forms.ComboBox
$alertDropDown.Location = New-Object Drawing.Size(90,90)
$alertDropDown.AutoSize = $true
foreach ($Script in $ScriptList) {
$alertDropDown.Items.Add($Script) }
$form.Controls.Add($alertDropDown)

#----------------------------------------------------------------------------------------------------#>

# ALERT RADIO BUTTONS
# (x,y)

$ALERT_GroupBox = New-Object System.Windows.Forms.GroupBox
$ALERT_GroupBox.Location = New-Object System.Drawing.Point(90,15)
$ALERT_GroupBox.Size = New-Object System.Drawing.Size(165,85)
$ALERT_GroupBox.Text = "Alert Type"
$form.Controls.Add($ALERT_GroupBox)
$ALERT_GroupBox.Controls.AddRange(@($IP_Radio,$HASH_Radio,$DOMAIN_Radio,$FILES_Radio))

$IP_Radio = New-Object System.Windows.Forms.RadioButton
$IP_Radio.Location = New-Object Drawing.Point(5,15)
$IP_Radio.AutoSize = $true
$IP_Radio.Text = "IP"

$DOMAIN_Radio = New-Object System.Windows.Forms.RadioButton
$DOMAIN_Radio.Location = New-Object Drawing.Point(70,15)
$DOMAIN_Radio.AutoSize = $true
$DOMAIN_Radio.Text = "DOMAINS"

$HASH_Radio = New-Object System.Windows.Forms.RadioButton
$HASH_Radio.Location = New-Object Drawing.Point(5,38)
$HASH_Radio.AutoSize = $true
$HASH_Radio.Text = "MD5, SHA1, SHA256"

$FILES_Radio = New-Object System.Windows.Forms.RadioButton
$FILES_Radio.Location = New-Object Drawing.Point(5,61)
$FILES_Radio.AutoSize = $true
$FILES_Radio.Text = "FILENAMES (.exe,.ps1,etc.)"

$Radio_TextBox = New-Object System.Windows.Forms.TextBox
$Radio_TextBox.Location = New-Object System.Drawing.Point(90,100)
$Radio_TextBox.AutoSize = $true
$Radio_TextBox.Text = $ALERT_GroupBox.Controls
$form.Controls.Add($Radio_TextBox)

#$form.Controls.AddRange(@($IP_Radio, $HASH_Radio, $DOMAIN_Radio, $FILES_Radio))

#----------------------------------------------------------------------------------------------------

# SID INPUT

$SID_Label = New-Object System.Windows.Forms.Label
$SID_Label.Location = New-Object System.Drawing.Point(10,195)
$SID_Label.AutoSize = $true
$SID_Label.Text = "Enter starting SID #: "

$SID_Input = New-Object System.Windows.Forms.TextBox
$SID_Input.Location = New-Object System.Drawing.Point(115,195)
$SID_Input.AutoSize = $true
$SID_Input.Text = ""

$form.Controls.AddRange(@($SID_Input,$SID_Label))

#----------------------------------------------------------------------------------------------------

# OUTPUT DESTINATION

$OUTPUT_Label = New-Object System.Windows.Forms.Label
$OUTPUT_Label.Text = "Output Destination: "
$OUTPUT_Label.Location = New-Object System.Drawing.Point(10,250)
$OUTPUT_Label.AutoSize = $true

$OUTPUT_TextBox = New-Object System.Windows.Forms.TextBox
$OUTPUT_TextBox.Text = ""
$OUTPUT_TextBox.Location = New-Object System.Drawing.Point(115,250)
$OUTPUT_TextBox.Size = New-Object System.Drawing.Size(180,25)
$OUTPUT_TextBox.Multiline = $false

$OUTPUT_Button = New-Object System.Windows.Forms.Button
$OUTPUT_Button.Text = ".."
$OUTPUT_Button.Location = New-Object System.Drawing.Point(300,250)
$OUTPUT_Button.AutoSize = $true

$form.Controls.AddRange(@($OUTPUT_Label,$OUTPUT_TextBox,$OUTPUT_Button))

Function OUTPUT_File($OutputFolder)
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $OutputFolder = $FolderBrowserDialog.RootFolder 
    If ($FolderBrowserDialog.ShowDialog() -eq "Cancel") 
    {
    [System.Windows.Forms.MessageBox]::Show("No Path Selected. Please select a Destination !", "Error", 0, 
    [System.Windows.Forms.MessageBoxIcon]::Exclamation)
    }   $Global:SelectedPath = $FolderBrowserDialog.SelectedPath
    
}

$OUTPUT_Button.Add_Click({OUTPUT_File
$PathChosen = $OUTPUT_TextBox.Text = $Global:SelectedPath
})

#----------------------------------------------------------------------------------------------------

# CREATE ALERT BUTTON

$CREATE_Button = New-Object System.Windows.Forms.Button
$CREATE_Button.Text = "Create Alert"
$CREATE_Button.Location = New-Object System.Drawing.Point(115,290)
$CREATE_Button.AutoSize = $true
#$CREATE_Button.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.Controls.Add($CREATE_Button)
$CREATE_Button.Add_Click({$Events})

#----------------------------------------------------------------------------------------------------



$Events = {
if ($DOMAIN_Radio.Checked) { Write-Host("You chose domainnnns") }
    
    elseif ($HASH_Radio.Checked) { [System.Windows.Forms.MessageBox]::Show("You chose hashes") }
    elseif ($IP_Radio.Checked) { [System.Windows.Forms.MessageBox]::Show("You chose IP") }
    }





#----------------------------------------------------------------------------------------------------

$form.ShowDialog()
#$form.ShowDialog() | Out-Null




