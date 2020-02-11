$webinstances = Get-EC2Instance -Filter @(
            @{name = "tag:Env"; values = "test" }
            @{name = "instance-state-name"; values = "running"}
        )

$computerName = ($webinstances.instances.Tag | Where-Object { $_.Key -eq "Name" }).value
$after = Get-Date 26/11/2018 -Hour 23 -Minute 40
$before = Get-Date 27/11/2018 -Hour 0 -Minute 20
$computerName | ForEach-Object {
    Get-EventLog -LogName Application -EntryType Error -ComputerName $_ -After $after -Before $before #| Format-Table
}