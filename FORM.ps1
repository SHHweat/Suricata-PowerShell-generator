
[System.Reflection.Assembly]::LoadWithPartialName("System.Win.Forms")
$form = New-Object System.Windows.Forms.Form
$form.Text = "BIG CHUNGUS APP"

$image = [System.Drawing.Image]::FromFile("$PSScriptRoot\bigchungus.png")
$form.BackgroundImage = $image
$form.BackgroundImageLayout = 'Stretch'
$form.Size = New-Object System.Drawing.Size(500,600)


$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Alert File: "
$Label1.Location = New-Object Drawing.Point(25,62)
$Label1.AutoSize = $true
$form.Controls.Add($Label1)

$selectTextbox = New-object System.Windows.Forms.Textbox
$selectTextbox.Location = New-Object Drawing.Size(80,60)
$selectTextbox.Size = New-Object Drawing.Size(180,25)
$selectTextbox.AutoSize = $true
$selectTextbox.Multiline =$false
$selectTextbox.ScrollBars = "Vertical"
$form.Controls.Add($selectTextbox)


$selectButton = New-Object System.Windows.Forms.Button
$selectButton.Text = "SELECT FILE"
$selectButton.Location = New-Object Drawing.Size(350,60)
$selectButton.AutoSize = $true
#$selectButton.Size = New-Object Drawing.Size(125,25)
$form.Controls.Add($selectButton)

$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog 
$selectfile = $fileBrowser.InitialDirectory 
$selectButton.Add_Click($selectFile)

$form.ShowDialog()