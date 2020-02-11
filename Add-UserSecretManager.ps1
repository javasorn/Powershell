function Get-KmsKeyArn {
    <#
        .SYNOPSIS
        Get an encryption key for that environment

        .DESCRIPTION
        Get a kms key to use as decryption and encryption for that environment.

        .PARAMETER Environment
        An environment, only live environment will get different return.

        .PARAMETER Region
        An AWS region to get kms key
    #>
    Param(
        [Parameter(Mandatory = $true)] [string] $Environment,
        [Parameter(Mandatory = $true)] [string] $Region
    )

    $kmsAlias = "KMS_SCRIPT_KEY"
    $targetKeyId = (Get-KMSAliasList -Region $Region | Where-Object { "alias/$kmsAlias" -contains $_.AliasName }).TargetKeyId
    $keyArn = (Get-KMSKeyList -Region $Region | Where-Object { $targetKeyId -contains $_.KeyId}).KeyArn
    $keyArn
}

function New-CredentialSecretManager {
    <#
        .SYNOPSIS
        Create a secret manager to store the credentials

        .DESCRIPTION
        Create a secret manager to store the credentials.
        It will contains username and password key in the secret manager.

        .PARAMETER Environment
        An environment that credentials belong to

        .PARAMETER Name
        Name of the credentials without 'AD\' prefix

        .PARAMETER Credential
        An credentials to keep in secret manager

        .PARAMETER Region
        An AWS region to keep in secret manager

        .PARAMETER KmsKeyArn
        KMS Encryption key
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)] [string] $Environment,
        [Parameter(Mandatory = $true)] [string] $Name,
        [Parameter(Mandatory = $true)] [pscredential] $Credential,
        [Parameter(Mandatory = $true)] [string] $Region,
        [string] $KmsKeyArn = (Get-KmsKeyArn -Environment $Environment -Region $Region)
    )
    $tag = New-Object Amazon.SecretsManager.Model.Tag -Property @{
        Key = 'Env'
        Value = $Environment
    }
    $currentSecret = try { Get-SECSecret -SecretId $Name -Region $Region } catch {$null}
    if ($currentSecret) {
        Log "Remove $Name secret manager"
        Remove-SECSecret -SecretId $Name -Region $Region -DeleteWithNoRecovery $true -Force
    }

    Log "Create $Name secret manager"
    if ($PSCmdlet.shouldprocess("New-SECSecret $Name with $($Credential.Username) for $($tag.Key) with $KmsKeyArn")) {
        New-SECSecret -Region $Region -Name $Name -SecretString (ConvertTo-Json @{
            "username" = $Credential.Username
            "password" = $Credential.GetNetworkCredential().Password
        }) -Tag $tag -KmsKeyId $KmsKeyArn
    }
}

$samAccountName = "ENTER_USER_HERE"
$Password = "ENTER_PASSWORD_HERE"
$securePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$userCredential = New-Object -TypeName PSCredential -ArgumentList "AD\$samAccountName", $securePassword
$Environment = "test"

New-CredentialSecretManager -Environment $Environment -Name $samAccountName -Credential $userCredential -Region ap-southeast-2