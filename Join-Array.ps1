<#
    .SYNOPSIS
        Sample way to join data from two sets of array
    .DESCRIPTION
    We have 2 array desn't have any relation between them.But need to merge that 2 array
    Let say we have a first array is :
        ["A","B","C","D","E","F"]
    And second array is :
        ["1","2","3"]
    Expected result like this :
        ["A,1","B,2","C,3","D,1","E,2","F,3"]
    .NOTES
    More advanced and complex join object see this https://github.com/RamblingCookieMonster/PowerShell/blob/master/Join-Object.ps1
#>
$leftArray = @("A","B","C","D","E","F")
$rightArray = @("1","2","3")
$resultArray = @()
$leftArray | ForEach-Object {
    $resultArray += [pscustomobject]@{
        col1 = $_
        col2 = $rightArray[ [array]::IndexOf($leftArray,$_) % ($rightArray).Count ]
    }
}
$resultArray