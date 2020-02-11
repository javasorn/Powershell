<#
    .SYNOPSIS
        list all all AWS S3 bucket and size
        This script using S3 API
    .EXAMPLE

#>
$buckets = Get-S3Bucket
$buckets | ForEach-Object {
    $bucketName = $_.BucketName 
    $daysAgo = (Get-Date ([datetime](Get-Date).AddDays(-3)) -Format s) # Date formats for Get-CWMetricStatistics MUST be in ISO format
    $today = Get-Date -Format s # Date formats for Get-CWMetricStatistics MUST be in ISO format
    $Statistic = 'Average'
    $maxSize = 0
   
    $stgclasses = @("GlacierStorage", "GlacierObjectOverhead", "GlacierS3ObjectOverhead", "StandardStorage", "ReducedRedundancyStorage", "OneZoneIASizeOverhead", "OneZoneIAStorage")
    $stgclasses | ForEach-Object {
        $stgclass = $_        
        $metricSize = Get-CWMetricStatistics -Namespace 'AWS/S3' -MetricName 'BucketSizeBytes' `
        -Dimension @(@{ Name = 'BucketName'; Value = "$bucketName" }; @{ Name = 'StorageType'; Value = "$stgclass" }) `
        -Statistic $Statistic -Period 86400 -UtcStartTime $daysAgo -UtcEndTime $today
        $maxSize += '{0:N2}' -f (($metricSize.Datapoints | Measure-Object -Property $Statistic -Maximum).Maximum / 1GB)
    }
    
    "Bucket Name : $bucketName, $maxSize"
}

