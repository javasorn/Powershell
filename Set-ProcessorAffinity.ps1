<#
Core # = Value = BitMask
Core 1 = 1 = 00000001
Core 2 = 2 = 00000010
Core 3 = 4 = 00000100
Core 4 = 8 = 00001000
Core 5 = 16 = 00010000
Core 6 = 32 = 00100000
Core 7 = 64 = 01000000
Core 8 = 128 = 10000000

add the decimal values together for which core you want to use. 255 = All 8 cores.
#>

$process = Get-Process | where { $_.ProcessName -like "7z*" }
$process.ProcessorAffinity=7

Get-Process | where { $_.ProcessName -like "7z*" } | Select-Object ProcessorAffinity