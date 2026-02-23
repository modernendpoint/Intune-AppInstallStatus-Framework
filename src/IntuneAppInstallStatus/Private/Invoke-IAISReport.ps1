function Invoke-IAISReport {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][ValidateSet('DeviceInstallStatus','UserInstallStatus')]
    [string]$ReportName,
    [Parameter(Mandatory)][string]$AppId,
    [int]$TimeoutSeconds = 180
  )

  # NOTE:
  # We use exportJobs which is the stable Intune reporting pattern.
  # The output is a CSV downloadUrl which we fetch and return as objects.

  $jobBody = @{
    reportName = $ReportName
    filter     = "AppId eq '$AppId'"
    format     = "csv"
  }

  $job = Invoke-IAISGraph -Method POST -Uri "https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs" -Body $jobBody

  $jobId = $job.id
  if (-not $jobId) { throw "Failed to create export job." }

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)

  do {
    Start-Sleep -Seconds 3
    $status = Invoke-IAISGraph -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs/$jobId"
    if ($status.status -eq "completed" -and $status.url) { break }
    if ($status.status -eq "failed") { throw "Export job failed: $($status.error | ConvertTo-Json -Depth 5)" }
  } while ((Get-Date) -lt $deadline)

  if (-not $status.url) { throw "Export job did not complete within timeout." }

  # Download CSV
  $csvText = (Invoke-WebRequest -Uri $status.url -UseBasicParsing).Content

  # Convert CSV to objects
  $csvText | ConvertFrom-Csv
}
