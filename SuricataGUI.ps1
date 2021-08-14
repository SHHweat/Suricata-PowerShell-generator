
[System.Reflection.Assembly]::LoadWithPartialName("System.Win.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = "Suricata Alert Generator"


#$image = [System.Drawing.Image]::FromFile("$PSScriptRoot\suricata_icon.png")
$form.BackgroundImage = $image
$form.BackgroundImageLayout = 'Stretch'
$form.Size = New-Object System.Drawing.Size(450,400)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.MinimizeBox = $true
$form.MaximizeBox = $true

#----------------------------------------------------------------------------------------------------

# IMPORT .TXT FILE/ LIST

$IMPORT_Label = New-Object System.Windows.Forms.Label
$IMPORT_Label.Text = "Import [.txt] File: "
$IMPORT_Label.Location = New-Object Drawing.Point(10,102)
$IMPORT_Label.AutoSize = $true
$form.Controls.Add($IMPORT_Label)

$IMPORT_Textbox = New-object System.Windows.Forms.Textbox
$IMPORT_Textbox.Location = New-Object Drawing.Size(115,100)
$IMPORT_Textbox.Size = New-Object Drawing.Size(180,15)
$IMPORT_Textbox.Multiline =$false
$form.Controls.Add($IMPORT_Textbox)

$IMPORT_Button = New-Object System.Windows.Forms.Button
$IMPORT_Button.Text = "Browse"
$IMPORT_Button.Location = New-Object Drawing.Size(300,100)
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
    }   $Global:SelectedFile = $OpenFileDialog.FileName
    
}

$IMPORT_Button.Add_Click({IMPORT_File
$IMPORT_Textbox.Text = $Global:SelectedFile
})

#----------------------------------------------------------------------------------------------------

# DROPDOWN ALERT LIST

$alertDropDown_Label = New-Object System.Windows.Forms.Label
$alertDropDown_Label.Location = New-Object System.Drawing.Point(10,65)
$alertDropDown_Label.AutoSize = $true
$alertDropDown_Label.Text = "Choose alert type: "

[array]$ScriptList = "IP", "DOMAIN","HASH", "FILENAMES-SMB", "FILENAMES-SMTP", "FILENAMES-HTTP", "CUSTOM"
$alertDropDown = New-Object System.Windows.Forms.ComboBox
$alertDropDown.Location = New-Object Drawing.Point(115,65)
$alertDropDown.AutoSize = $true

foreach ($Script in $ScriptList) {
$alertDropDown.Items.Add($Script) | Out-Null }
$form.Controls.AddRange(@($alertDropDown,$alertDropDown_Label))

<#----------------------------------------------------------------------------------------------------#

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
#$Radio_TextBox.Text = $ALERT_GroupBox.AutoChecked
$form.Controls.Add($Radio_TextBox)

#$ALERT_GroupBox.Controls (Where-Object $_.chec

#>
#----------------------------------------------------------------------------------------------------

# SID INPUT

$SID_Label = New-Object System.Windows.Forms.Label
$SID_Label.Location = New-Object System.Drawing.Point(10,135)
$SID_Label.AutoSize = $true
$SID_Label.Text = "Enter starting SID #: "

$SID_Input = New-Object System.Windows.Forms.TextBox
$SID_Input.Location = New-Object System.Drawing.Point(115,135)
$SID_Input.AutoSize = $true
$SID_Input.Text = ""

$form.Controls.AddRange(@($SID_Input,$SID_Label))

#----------------------------------------------------------------------------------------------------

# OUTPUT DESTINATION

$OUTPUT_Label = New-Object System.Windows.Forms.Label
$OUTPUT_Label.Text = "Output Destination: "
$OUTPUT_Label.Location = New-Object System.Drawing.Point(10,170)
$OUTPUT_Label.AutoSize = $true

$OUTPUT_TextBox = New-Object System.Windows.Forms.TextBox
$OUTPUT_TextBox.Text = ""
$OUTPUT_TextBox.Location = New-Object System.Drawing.Point(115,170)
$OUTPUT_TextBox.Size = New-Object System.Drawing.Size(180,15)
$OUTPUT_TextBox.Multiline = $false

$OUTPUT_Button = New-Object System.Windows.Forms.Button
$OUTPUT_Button.Text = ".."
$OUTPUT_Button.Location = New-Object System.Drawing.Point(300,170)
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
$CREATE_Button.Location = New-Object System.Drawing.Point(115,200)
$CREATE_Button.AutoSize = $true

$form.Controls.Add($CREATE_Button)

#----------------------------------------------------------------------------------------------------

# ALERT FUNCTIONS 

Function IP_TEMPLATE {

$IP_Get = Get-Content ($IMPORT_Textbox.Text)

$IP_Dst = ($OUTPUT_TextBox.Text) + "\PS-IP-alerts.txt"

$IP_Join = [string]::Join(",",$IP_Get)

    foreach ($IP in $IP_Join) { Add-Content $IP_Dst (" "+"["+$IP_Join+"]") }


$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($IP in $IP_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $IP_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} )
    }

$IP_sid_msg = Get-Content $SID_txt


$IP_Alert = Get-Content $IP_Dst

$IP_String1 = ('alert ip'+" "+$IP_Alert+" "+'any <> $HOME_NET any (msg: "Test"; '+ "sid: "+($SID_Input.Text)+";)") > $IP_Dst

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt | Write-host "Done"}
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}


Function DOMAIN_TEMPLATE {

$DOMAIN_Get = Get-Content ($IMPORT_Textbox.Text)

$DOMAIN_String1 = 'alert http any any -> any any (msg: "TEST"; content: '

$DOMAIN_String2 = '; http_host; nocase; sid: '

$DOMAIN_Dst = ($OUTPUT_TextBox.Text) + "\PS-DOMAIN-alerts.txt"

$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($DOMAIN in $DOMAIN_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $DOMAIN_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} ) 
    }

$DOMAIN_sid_msg = Get-Content $SID_txt


    for ($a =0; $a -lt $DOMAIN_Get.Count; $a++) {
    ( ($DOMAIN_String1) + (('"'),'{0}',('"'),($DOMAIN_String2),'{1}',(';)') -f $DOMAIN_Get[$a],$DOMAIN_sid_msg[$a]) ) | Add-Content $DOMAIN_Dst
    }
    

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

Function FILES_SMB_TEMPLATE {

$FILES_Get = Get-Content ($IMPORT_Textbox.Text)

$FILES_String1 = 'alert smb any any -> any any (msg: "TEST"; filename: '
$FILES_String2 = '; fileext: "*"; nocase; sid: '

#$FILES_String3 = 'alert smtp any any -> any any (msg: "TEST"; filename: '
#$FILES_String4 = '; fileext: "*"; nocase; sid: '


$FILES_Dst = ($OUTPUT_TextBox.Text) + "\PS-FILENAME-alerts.txt"

$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($FILE in $FILES_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $FILES_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} ) 
    }

$FILES_sid_msg = Get-Content $SID_txt


    for ($a =0; $a -lt $FILES_Get.Count; $a++) {
    ( ($FILES_String1) + (('"'),'{0}',('"'),($FILES_String2),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    #( ($FILES_String3) + (('"'),'{0}',('"'),($FILES_String4),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    }
    

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

Function FILES_SMTP_TEMPLATE {

$FILES_Get = Get-Content ($IMPORT_Textbox.Text)

$FILES_String1 = 'alert smtp any any -> any any (msg: "TEST"; filename: '
$FILES_String2 = '; fileext: "*"; nocase; sid: '

#$FILES_String3 = 'alert smtp any any -> any any (msg: "TEST"; filename: '
#$FILES_String4 = '; fileext: "*"; nocase; sid: '


$FILES_Dst = ($OUTPUT_TextBox.Text) + "\PS-FILENAME-alerts.txt"

$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($FILE in $FILES_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $FILES_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} ) 
    }

$FILES_sid_msg = Get-Content $SID_txt


    for ($a =0; $a -lt $FILES_Get.Count; $a++) {
    ( ($FILES_String1) + (('"'),'{0}',('"'),($FILES_String2),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    #( ($FILES_String3) + (('"'),'{0}',('"'),($FILES_String4),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    }
    

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

Function FILES_HTTP_TEMPLATE {

$FILES_Get = Get-Content ($IMPORT_Textbox.Text)

$FILES_String1 = 'alert http any any -> any any (msg: "TEST"; filename: '
$FILES_String2 = '; fileext: "*"; nocase; sid: '

#$FILES_String3 = 'alert smtp any any -> any any (msg: "TEST"; filename: '
#$FILES_String4 = '; fileext: "*"; nocase; sid: '


$FILES_Dst = ($OUTPUT_TextBox.Text) + "\PS-FILENAME-alerts.txt"

$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($FILE in $FILES_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $FILES_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} ) 
    }

$FILES_sid_msg = Get-Content $SID_txt


    for ($a =0; $a -lt $FILES_Get.Count; $a++) {
    ( ($FILES_String1) + (('"'),'{0}',('"'),($FILES_String2),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    #( ($FILES_String3) + (('"'),'{0}',('"'),($FILES_String4),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    }
    

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}


Function HASH_TEMPLATE {

$HASH_Get = Get-Content ($IMPORT_Textbox.Text)

$HASH_String1 = 'alert tcp $HOME_NET any -> $EXTERNAL_NET any (msg: "TEST"; content: '

$HASH_String2 = '; nocase; sid: '

$HASH_Dst = ($OUTPUT_TextBox.Text) + "\PS-HASH-alerts.txt"

$SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($HASH in $HASH_Get.Count) {
    [int]$SIDCOUNT = ($SID_Input.Text)
    $HASH_Get.ForEach( {$SIDCOUNT++ | Add-Content $SID_txt} )
    }

$HASH_sid_msg = Get-Content $SID_txt


    for ($a =0; $a -lt $HASH_Get.Count; $a++) {
    ( ($HASH_String1) + (('"'),'{0}',('"'),($HASH_String2),'{1}',(';)') -f $HASH_Get[$a],$HASH_sid_msg[$a]) ) | Add-Content $HASH_Dst
    }
    

    if ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt | Write-host "Done"}
[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

#----------------------------------------------------------------------------------------------------

# EVENT HANDLER 

$Events = {
    if ($alertDropDown.Text -like "hash") { HASH_TEMPLATE }    
    elseif ($alertDropDown.Text -like "ip") { IP_TEMPLATE }
    elseif ($alertDropDown.Text -like "domain") { DOMAIN_TEMPLATE }
    elseif ($alertDropDown.Text -like "filenames-smb") { FILES_SMB_TEMPLATE }
    elseif ($alertDropDown.Text -like "filenames-smtp") { FILES_SMTP_TEMPLATE }
    elseif ($alertDropDown.Text -like "filenames-http") { FILES_HTTP_TEMPLATE }
    elseif ($alertDropDown.Text -like "custom") {[System.Windows.MessageBox]::Show("Not available - WIP","Error") }
    #elseif ($IP_Radio.Checked) { [System.Windows.Forms.MessageBox]::Show("You chose IP") }
    else { [System.Windows.MessageBox]::Show("You didn't select an alert type", "Error") }
    }


$CREATE_Button.add_Click($Events)

<#----------------------------------------------------------------------------------------------------

# EXAMPLE OUPUT
# Text field showing alert example as user makes inputs to GUI

$Example_Textbox = New-object System.Windows.Forms.TextBox
$Example_Textbox.Location = New-Object Drawing.point(20,270)
$Example_Textbox.Text = " WORDS  GO  HERE "
$Example_Textbox.Font = New-Object System.Drawing.Font("Lucida Console",50)
$Example_Textbox.Size = New-Object System.Drawing.Size(395,100)
#$Example_Textbox.AutoSize = $true
$form.Controls.Add($Example_Textbox)

#----------------------------------------------------------------------------------------------------#>

#$form.ShowDialog()
$form.ShowDialog() | Out-Null




