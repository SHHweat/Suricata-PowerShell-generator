# Suricata-PowerShell-GUI
Powershell GUI for generating Suricata/Snort based alerts.

Mass produce IDS alerts based on known indicators of compromise (IOC).

# Installation

download **zip**

Right-click SuricataGUI.ps1 >> Properties >> Check [ ] Unblock 

Open SuricataGUI.ps1 w/PoSH ISE >> Run Script (F5)





# Instructions


run **.\SuricataGUI.ps1**

1.) Choose Alert type :

    eg. "DOMAIN"
    
2.) Import file list : 

    eg. Click "[Browse]" > ".\domain-list.txt"
    
3.) Input SID# :

    eg. "10"
    
4.) Click "[..]" for output destination

    eg. Click "[..]" > ".\Desktop"
    
5.) Verify desired alerts.txt file


# Features
  Inputs
  - Import .txt as input.
  - [WIP] import CSV as input.

  Output
  - Uutput .txt to desired path location.
  - [WIP] export to CSV.







# ToDo

  - [ ] Import/Export CSV feature
  
  - [ ] Export CSV for used SID's/Alerts
  
  - [ ] Add "Example.TextBox" showcase during user input



