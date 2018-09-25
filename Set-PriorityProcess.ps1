
$start = New-Object System.Diagnostics.ProcessStartInfo
$start.Arguments = "a -tzip -mx9 c:\temp\filezip.zip c:\temp\filetest.txt"
$start.FileName = "C:\Program Files\7-Zip\7z.exe"
$proc = New-Object System.Diagnostics.Process
$proc.StartInfo = $start
$proc.Start()
$proc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal