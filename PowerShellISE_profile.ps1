#sample profile \\lpnlfs0003\userdata$\fijmp\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1

$addPath = 'c:\GitHub\PowerShell\Modules\'
 
if($addPath -notin [Environment]::GetEnvironmentVariable("PSModulePath", "Machine").split([System.IO.Path]::PathSeparator) ){ 
  [Environment]::SetEnvironmentVariable("PSModulePath", [Environment]::GetEnvironmentVariable("PSModulePath", "Machine") + [System.IO.Path]::PathSeparator + $addPath, "Machine")
}else{
  [Environment]::GetEnvironmentVariable("PSModulePath", "Machine").split([System.IO.Path]::PathSeparator)
}

start-steroids


import-module lpnl.timops
# get-command -module lpnl.timops

import-module lpnl.assets
# get-command -module lpnl.assets

#DPAPI Secured strings
$userUsr = 'pfijma'
$credsUsr = New-Object System.Management.Automation.PSCredential -ArgumentList $userUsr,((Get-Content c:\scripts\~sec\\PCNAME1_$userUsr.sec) | ConvertTo-SecureString )
$credsUsr | write-verbose

$userAdm = 'pfijma_adm'
$CredsAdm = New-Object System.Management.Automation.PSCredential -ArgumentList $userAdm,((Get-Content c:\scripts\~sec\\PCNAME1_$userAdm.sec) | ConvertTo-SecureString )
$credsAdm  | write-verbose

function test-online{
  [CmdletBinding()]
  Param (
    [string]$PC
  )
  $online = $false
  if(Test-Connection -ComputerName $pc -BufferSize 16 -Count 1 -ErrorAction 0 -Quiet){
    $online = $true
  }
  return $online
}
   
function Get-PC{
  [CmdletBinding()]
  Param (
    [string]$PC,
    [object]$sredentials
  )
  
  if(test-online $pc){
    $args = "\\$PC -u $userAdm -p {0} -e -h -i -s  powershell" -f [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credsAdm.password))
    start-process c:\scripts\psexec $args
  }else{
    "$(get-date -format u)`t$pc" | write-host -NoNewline
    "`tOFFLINE"| write-host -ForegroundColor DarkRed
  }
}


if (-not (test-path c:\temp\startup.txt)){
  & "C:\Program Files\ShareX\ShareX.exe" 
  & "C:\Users\fijmp\AppData\Local\Microsoft\Teams\current\Teams.exe"
  & "C:\Program Files (x86)\Microsoft Office\root\Office16\outlook.exe"
  'this file prevents starting up' | out-file c:\temp\startup.txt
}

# if needed: 
# import-module ActiveDirectory

Get-ADUser lpnladmfijmp -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword | select Name,PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
Get-ADUser fijmp -Properties msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword | select Name,PasswordLastSet, @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
#Get-date -Format u
get-date -format 'dd-MM-yyyy HH:mm:ss'
set-location c:\GitHub\ 


