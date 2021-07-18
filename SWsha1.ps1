



# SW sha1 




$SWsha1GET = Get-Content -Path 'H:\Desktop\PS Testing\Sandworm\*sha1*.txt'

$SWsha1String1 = 'alert tcp $HOME_NET any -> $EXTERNAL_NET any (msg: "Potential malicious SANDWORM sha1 hash."; content: '
$SWsha1String2 = '; nocase; sid: '
#add a ")" string in the for loop in the $SWmd5MESSAGE

$SWsha1PROD ='H:\Desktop\PS Testing\SANDWORM-sha1-alerts.txt'
$SWsha1SIDtxt =  'H:\Desktop\PS Testing\SWsha1SIDgen.txt'






if (-not(Test-Path -Path $SWsha1PROD -PathType Leaf)) {


do {

    Write-Host "Input a SID starting number: "
    [int]$SIDinput = Read-Host
    $sidDB = 'H:\Desktop\PS Testing\sidDB.txt'
    $sidGETDB = Get-Content $sidDB



 if ($sidGETDB -contains $SIDinput) {
       ""
       Write-Host "SID already exists in [$sidDB]"
       ""
       #recommends a number to start the sid count from (max in the sidDB txt file)
       Write-Host "Try a number greater than:  " ($sidGETDB | Measure-Object -Maximum).Maximum

                   }
else {
    

#for ($a =0; $a -lt $SWhashMSG.Count; $a++) {
#[int]$SWpercent = ($a / $SWsidMSG.Count*100)

foreach ($a in $SWhashMSG.Count) {
[int]$SWpercent = ($a / $SWhashMSG.Count*100)

Write-Progress -Id 0 -Activity 'Generating SIDS. This may take awhile....' -Status "$SWpercent % complete" -PercentComplete $SWpercent -CurrentOperation "--- SIDS created: $a "

$SWsha1COUNT = $SIDinput
$SWsha1GET.ForEach(  { $SWsha1COUNT++ | Add-Content $SWsha1SIDtxt } ) 

# adds $SIDinput into a text file for referencing all sids used
Get-Content $SWsha1SIDtxt >> $sidDB
}

#redundant get-content. for $SWsha1GET
$SWhashMSG = $SWsha1GET
$SWsidMSG = Get-Content $SWsha1SIDtxt 

    for($a =0; $a -lt $SWhashMSG.Count; $a++)
         {
         [int]$SWpercent =  ($a / $SWhashMSG.count*100)
            Write-Progress -Id 1 -ParentId 0 -Activity 'Creating SW Alert: ' -Status "$SWpercent% complete" -PercentComplete $SWpercent -CurrentOperation "--- alerts created: $a "
            ( ($SWsha1String1)  + (('"'),'{0}',('"'),($SWsha1String2),'{1}',(';)') -f $SWhashMSG[$a],$SWsidMSG[$a]) )  | Add-Content $SWsha1PROD  
         }
    if ((Test-Path -Path $SWsha1SIDtxt -PathType Leaf)) { rm -Path $SWsha1SIDtxt }

        
   }  
 } Until ($sidGETDB -inotcontains $SIDinput)
}

else {
    Write-Host "Cannot create [$SWsha1PROD] because a file with that name exists."
    }



