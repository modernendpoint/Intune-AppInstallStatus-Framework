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
    $status = Invoke-IAISGraph -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/re
