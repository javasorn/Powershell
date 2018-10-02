AWS Lambda functions for forward AWS Health event to slack.

This script require setting up a PowerShell Development Environment
    1. Install the correct version for PowerShell. AWS Lambda 's support PowerShell Core 6.0. We can find instructions in
       https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell
    2. Install the .NET Core 2.1 SDK. You can download from https://www.microsoft.com/net/download
    3. Install the AWSLambdaPSCore module with command (with admin mode)
        >Install-Module AWSLambdaPSCore
    4. If you don't have AWSPowerShell module also need to Install by PowerShell Gallery
        >Install-Module -Name AWSPowerShell

If not exist AWS Credentials need to setup this first
    >Set-DefaultAWSRegion us-east-1
    >Set-AWSCredentials -AccessKey AXXXXXXXXXXXXX -SecretKey SXXXXXXXXXXXXX -StoreAs your-aws-credentails-name
    >Set-AWSCredentials your-aws-credentails-name

Using AWS Credentials
    >Set-AWSCredentials your-aws-credentails-name

Publish to AWS Lambda.
    >Publish-AWSPowerShellLambda -ScriptPath .\PSAwsEventToSlack -Name  PS6AwsEventToSlack -Region us-east-1