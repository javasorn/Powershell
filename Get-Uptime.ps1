<#
    .SYNOPSIS
        Get computer uptime
    .EXAMPLE
     .\Get-Uptime.ps1 -Computer localhost
    Sample result:
    ComputerName UptimeDays UptimeHours UptimeMinutes UptimeSeconds
    ------------ ---------- ----------- ------------- -------------
    localhost             7           5            31            36
#>
Param (
    [parameter(Mandatory=$true)] $Computer
)
$info = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
$diff = ($info.ConvertToDateTime($info.LocalDateTime) - $info.ConvertToDateTime($info.LastBootUpTime))
$properties=[ordered]@{
 'ComputerName'=$Computer;
 'UptimeDays'=$diff.Days;
 'UptimeHours'=$diff.Hours;
 'UptimeMinutes'=$diff.Minutes
 'UptimeSeconds'=$diff.Seconds
 }
New-Object -TypeName PSObject -Property $properties | Format-Table