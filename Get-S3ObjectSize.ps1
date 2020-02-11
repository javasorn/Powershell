<#
    .SYNOPSIS
        list all all AWS S3 bucket and size
        This script using S3 API
    .EXAMPLE

#>
$buckets = Get-S3Bucket
$buckets | ForEach-Object {
    $bucketName = $_.BucketName 
    $location = $(Get-S3BucketLocation -BucketName $bucketName).Value
    "Query Bucket Name : $bucketName, location : $location"
    $bucket = Get-S3Object -BucketName $bucketName -Region $location
    $bucket | % { $size += $_.Size; $keys++}
    "Bucket Name : $bucketName, $($size/(1024*1024*1024)), $keys"
}