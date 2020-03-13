<# Copyright 2019 Jeremy Zimmerman (stopspazzing.com) - MIT License: https://opensource.org/licenses/MIT #>
import-module activedirectory
$notcomputer = $env:COMPUTERNAME
$cmd = {
         param($a)
         $session = ((& quser /server:$a | ? { $_ -match $env:username }) -split ' +')[2]
         logoff $session /server:$a
}
$computers = (Get-ADComputer -Filter *).Name 
ForEach ($computer in $computers)
{
    if ($computer -ne $notcomputer)
    {
        Start-Job -ScriptBlock $cmd -ArgumentList $computer
    }
}
Start-Sleep -Seconds 30
Get-Job | Stop-Job
Get-Job | Remove-Job
