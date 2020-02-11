$samAccountName = "ENTER_USER_HERE"
$Password = "ENTER_PASSWORD_HERE"
$name = "User name"
$userPrincipal = "$samAccountName@abc.com"
$ouPath ="OU=ManagedUsers,DC=ad,DC=ABCcompany,DC=com"
$securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$userCredential = New-Object -TypeName PSCredential -ArgumentList "AD\$samAccountName", $securePassword

$DomainCredential = Get-Credential
if ($DomainCredential){
    New-ADUser -SamAccountName $samAccountName -AccountPassword $userCredential.Password `
        -Name $name -UserPrincipalName $userPrincipal -credential $DomainCredential `
        -Enabled $true -PasswordNeverExpires $true -Path $ouPath
}