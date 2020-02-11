$listInstances = (Get-EC2Instance -Filter @(
        @{name = "platform"; values = "windows"};
        @{name = "instance-state-name"; values = "running"}
    )).Instances

($listInstances.tag | Where-Object { $_.key -eq "Name" }).value