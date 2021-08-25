
Add-Type -AssemblyName System.Windows.Forms
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

$IMPORT_Textbox = New-object System.Windows.Forms.Textbox
$IMPORT_Textbox.Location = New-Object Drawing.Size(115,100)
$IMPORT_Textbox.Size = New-Object Drawing.Size(180,15)
$IMPORT_Textbox.Multiline =$false

$IMPORT_Button = New-Object System.Windows.Forms.Button
$IMPORT_Button.Text = "Browse"
$IMPORT_Button.Location = New-Object Drawing.Size(300,100)
$IMPORT_Button.AutoSize = $true

$form.Controls.AddRange(@($IMPORT_Label, $IMPORT_Textbox, $IMPORT_Button))

Function IMPORT_File($InitialDirectory)
{
    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = “All files (*.*)| *.*”
    
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") 
    {
    [System.Windows.Forms.MessageBox]::Show("No File Selected. Please select a file !", "Error", 0) 
    #[System.Windows.Forms.MessageBoxIcon]::Exclamation)
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

[array]$ScriptList = "IP", "DOMAIN","HASH", "FILENAMES"#, "CUSTOM"
$alertDropDown = New-Object System.Windows.Forms.ComboBox
$alertDropDown.Location = New-Object Drawing.Point(115,65)
$alertDropDown.AutoSize = $true

foreach ($Script in $ScriptList) {
    $alertDropDown.Items.Add($Script) | Out-Null 
}

$form.Controls.AddRange(@($alertDropDown,$alertDropDown_Label))

#----------------------------------------------------------------------------------------------------

# SID INPUT

$SID_Label = New-Object System.Windows.Forms.Label
$SID_Label.Location = New-Object System.Drawing.Point(10,180)
$SID_Label.AutoSize = $true
$SID_Label.Text = "Enter starting SID #: "

$SID_Input = New-Object System.Windows.Forms.TextBox
$SID_Input.Location = New-Object System.Drawing.Point(115,177)
$SID_Input.AutoSize = $true
$SID_Input.Text = ""

$form.Controls.AddRange(@($SID_Input,$SID_Label))

#----------------------------------------------------------------------------------------------------

# OUTPUT DESTINATION

$OUTPUT_Label = New-Object System.Windows.Forms.Label
$OUTPUT_Label.Text = "Output Destination: "
$OUTPUT_Label.Location = New-Object System.Drawing.Point(10,215)
$OUTPUT_Label.AutoSize = $true

$OUTPUT_TextBox = New-Object System.Windows.Forms.TextBox
$OUTPUT_TextBox.Text = ""
$OUTPUT_TextBox.Location = New-Object System.Drawing.Point(115,210)
$OUTPUT_TextBox.Size = New-Object System.Drawing.Size(180,15)
$OUTPUT_TextBox.Multiline = $false

$OUTPUT_Button = New-Object System.Windows.Forms.Button
$OUTPUT_Button.Text = ".."
$OUTPUT_Button.Location = New-Object System.Drawing.Point(300,210)
$OUTPUT_Button.AutoSize = $true

$form.Controls.AddRange(@($OUTPUT_Label,$OUTPUT_TextBox,$OUTPUT_Button))

Function OUTPUT_File($OutputFolder)
{
    Add-Type -AssemblyName System.Windows.Forms
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $OutputFolder = $FolderBrowserDialog.RootFolder 
    
    If ($FolderBrowserDialog.ShowDialog() -eq "Cancel") 
    {
    [System.Windows.Forms.MessageBox]::Show("No Path Selected. Please select a Destination !", "Error", 0) 
    #[System.Windows.Forms.MessageBoxIcon]::Exclamation)
    }   $Global:SelectedPath = $FolderBrowserDialog.SelectedPath
    
}

$OUTPUT_Button.Add_Click({OUTPUT_File
    $OUTPUT_TextBox.Text = $Global:SelectedPath 
})

#----------------------------------------------------------------------------------------------------

# MESSAGE TEXTBOX

$MESSAGE_Label = New-Object System.Windows.Forms.Label
$MESSAGE_Label.Location = New-Object System.Drawing.Point(10,142)
$MESSAGE_Label.AutoSize = $true
$MESSAGE_Label.Text = "Type msg text: "

$MESSAGE_Textbox = New-Object System.Windows.Forms.Textbox
$MESSAGE_Textbox.Location = New-Object System.Drawing.Point(115,140)
$MESSAGE_Textbox.Size = New-Object System.Drawing.Size(310,150)

$form.Controls.AddRange(@($MESSAGE_Label, $MESSAGE_Textbox))

#----------------------------------------------------------------------------------------------------

# CREATE ALERT BUTTON

$CREATE_Button = New-Object System.Windows.Forms.Button
$CREATE_Button.Text = "Create Alert"
$CREATE_Button.Location = New-Object System.Drawing.Point(115,270)
$CREATE_Button.AutoSize = $true

$form.Controls.Add($CREATE_Button)

#----------------------------------------------------------------------------------------------------

# ALERT FUNCTIONS 

Function IP_TEMPLATE {

    $IP_Get = Get-Content ($IMPORT_Textbox.Text)
    $IP_Dst = ($OUTPUT_TextBox.Text) + "\PS-IP-alerts.txt"
    $IP_Join = [string]::Join(",",$IP_Get)
    $SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($IP in $IP_Join) { 
        Add-Content $IP_Dst ("["+$IP_Join+"]") 
    }

    foreach ($IP in $IP_Get.Count) {
        $SID_txt = ($OUTPUT_Textbox.Text) + "\sid.txt"
        [int]$SID_Count = ($SID_Input.Text)
        $IP_Get.ForEach( {$SID_Count++ | Add-Content $SID_txt} )
    }

    $IP_sid_msg = Get-Content $SID_txt
    $IP_Alert = Get-Content $IP_Dst
    $IP_String1 = ('alert ip'+" "+$IP_Alert+" "+'any <> $HOME_NET any (msg: '+'"'+($MESSAGE_Textbox.Text)+'"'+'; sid: '+($SID_Input.Text)+";)") > $IP_Dst

    If ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt}
    
    Write-Host "Check $Global:SelectedPath for created alert!"
    #[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}


Function DOMAIN_TEMPLATE {

    $DOMAIN_Get = Get-Content ($IMPORT_Textbox.Text)
    $DOMAIN_String1 = 'alert http any any -> any any (msg: '
    $DOMAIN_String2 = '; content: '
    $DOMAIN_String3 = '; http_host; nocase; sid: '
    $DOMAIN_Dst = ($OUTPUT_TextBox.Text) + "\PS-DOMAIN-alerts.txt"
    $SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($DOMAIN in $DOMAIN_Get.Count) {
        [int]$SID_Count = ($SID_Input.Text)
        $DOMAIN_Get.ForEach( {$SID_Count++ | Add-Content $SID_txt} ) 
    }

    $DOMAIN_sid_msg = Get-Content $SID_txt

    for ($a =0; $a -lt $DOMAIN_Get.Count; $a++) {
    ( ($DOMAIN_String1) + ('"') + ($MESSAGE_Textbox.Text)+ ('"') + ($DOMAIN_String2) + (('"'), '{0}',('"'),($DOMAIN_String3),'{1}',(';)') -f $DOMAIN_Get[$a],$DOMAIN_sid_msg[$a]) ) | Add-Content $DOMAIN_Dst
    }
    
    If ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
    
    Write-Host "Check $Global:SelectedPath for created alert!"
    [System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

Function FILENAMES_TEMPLATE {

    $FILES_Get = Get-Content ($IMPORT_Textbox.Text)
    $FILES_String1 = 'alert ip any any -> any any (msg: '
    $FILES_String2 = '; content: '
    $FILES_String3 = '; fileext: "*"; nocase; sid '
    $FILES_Dst = ($OUTPUT_TextBox.Text) + "\PS-FILENAME-alerts.txt"
    $SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($FILE in $FILES_Get.Count) {
        [int]$SID_Count = ($SID_Input.Text)
        $FILES_Get.ForEach( {$SID_Count++ | Add-Content $SID_txt} ) 
    }

    $FILES_sid_msg = Get-Content $SID_txt

    for ($a =0; $a -lt $FILES_Get.Count; $a++) {
    ( ($FILES_String1) + ('"') + ($MESSAGE_Textbox.Text)+ ('"') + ($FILES_String2) + (('"'), '{0}',('"'),($FILES_String3),'{1}',(';)') -f $FILES_Get[$a],$FILES_sid_msg[$a]) ) | Add-Content $FILES_Dst
    }
    
    If ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
    
    Write-Host "Check $Global:SelectedPath for created alert!"
    #[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

Function HASH_TEMPLATE {

    $HASH_Get = Get-Content ($IMPORT_Textbox.Text)
    $HASH_String1 = 'alert ip $HOME_NET any <> $EXTERNAL_NET any (msg: '
    $HASH_String2 = '; content: '
    $HASH_String3 = '; nocase; sid: '
    $HASH_Dst = ($OUTPUT_TextBox.Text) + "\PS-HASH-alerts.txt"
    $SID_txt = "$PSScriptRoot\sid.txt"

    foreach ($HASH in $HASH_Get.Count) {
        [int]$SID_Count = ($SID_Input.Text)
        $HASH_Get.ForEach( {$SID_Count++ | Add-Content $SID_txt} )
    }

    $HASH_sid_msg = Get-Content $SID_txt

    for ($a =0; $a -lt $HASH_Get.Count; $a++) {
    ( ($HASH_String1) + ('"') + ($MESSAGE_Textbox.Text)+ ('"') + ($HASH_String2) + (('"'), '{0}',('"'),($HASH_String3),'{1}',(';)') -f $HASH_Get[$a],$HASH_sid_msg[$a]) ) | Add-Content $HASH_Dst
    }
    
    If ((Test-Path -Path $SID_txt -PathType Leaf)) {rm -Path $SID_txt }
    
    Write-Host "Check $Global:SelectedPath for created alert!"
    #[System.Windows.MessageBox]::Show("Check $Global:SelectedPath for created alert!")
}

#----------------------------------------------------------------------------------------------------

# EVENT HANDLER 

$Events = {
    if ($alertDropDown.Text -like "ip") { IP_TEMPLATE }    
    elseif ($alertDropDown.Text -like "domain") { DOMAIN_TEMPLATE }
    elseif ($alertDropDown.Text -like "hash") { HASH_TEMPLATE }
    elseif ($alertDropDown.Text -like "filenames") { FILENAMES_TEMPLATE }
    elseif ($alertDropDown.Text -like "custom") {[System.Windows.MessageBox]::Show("Not available - WIP","Error") }
    else { [System.Windows.MessageBox]::Show("You didn't select an alert type", "Error") }
}

$CREATE_Button.add_Click($Events)

#----------------------------------------------------------------------------------------------------

# MAIN FORM CALL

$form.ShowDialog() | Out-Null




