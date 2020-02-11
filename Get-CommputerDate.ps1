
function Get-ComputerStats {
  param(
    [Parameter(Mandatory=$true, Position=0,
               ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [string[]]$ComputerName
  )

  process {
    foreach ($c in $ComputerName) {
        $remoteCompDate =  invoke-command -ComputerName $c -ScriptBlock {get-date}
        [pscustomobject]@{
            ComputerName = $c
            CurrentDate = $remoteCompDate
        }
    }
  }
}
Get-Content '.\Get-CommputerStats-servers.txt' | Get-ComputerStats | Format-Table