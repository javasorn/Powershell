<#
    .SYNOPSIS
        Get Computer Stats as AverageCpu, MemoryUsage and PercentFreeSpace foreach computers
    .EXAMPLE
    First step need to put computer name in to a file is "Get-CommputerStats-servers.txt"
    .\Get-CommputerStats.ps1
    Expected result:
    ComputerName AverageCpu MemoryUsage PercentFreeSpace
    ------------ ---------- ----------- ----------------
    localhost            68 82.24       8.82
#>
function Get-ComputerStats {
  param(
    [Parameter(Mandatory=$true, Position=0,
               ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [string[]]$ComputerName
  )

  process {
    foreach ($c in $ComputerName) {
        $avg = Get-WmiObject win32_processor -computername $c |
                   Measure-Object -property LoadPercentage -Average |
                   ForEach-Object {$_.Average}
        $mem = Get-WmiObject win32_operatingsystem -ComputerName $c |
                   ForEach-Object {"{0:N2}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize)}
        $free = Get-WmiObject Win32_Volume -ComputerName $c -Filter "DriveLetter = 'C:'" |
                    ForEach-Object {"{0:N2}" -f (($_.FreeSpace / $_.Capacity)*100)}
        [pscustomobject]@{
            ComputerName = $c
            AverageCpu = $avg
            MemoryUsage = $mem
            PercentFreeSpace = $free
        }
    }
  }
}
Get-Content '.\Get-CommputerStats-servers.txt' | Get-ComputerStats | Format-Table