<#
    .SYNOPSIS
        Get Disk Space
    .EXAMPLE
    .\Get-DiskSpace.ps1 -Computer localhost
    Expected result:
    SystemName DeviceID VolumeName Total Size (GB) Free Space (GB) Free Space %
    ---------- -------- ---------- --------------- --------------- ------------
    localhost  C:                  223.1           19.7            8.8
    localhost  D:       Local Disk 931.2           834.7           89.6
#>
Param (
    [parameter(Mandatory=$true)] $Computer
)
Get-WMIObject Win32_LogicalDisk -Filter "DriveType=3" -Computer $Computer `
    | Select-Object SystemName, DeviceID, VolumeName, @{Name="Total Size (GB)"; Expression={"{0:N1}" -F ($_.Size/1GB)}}, @{Name="Free Space (GB)"; Expression={"{0:N1}" -F ($_.Freespace/1GB)}}, @{Name="Free Space %"; Expression={"{0:N1}" -F (($_.Freespace/$_.Size)*100)}} | Format-Table -AutoSize