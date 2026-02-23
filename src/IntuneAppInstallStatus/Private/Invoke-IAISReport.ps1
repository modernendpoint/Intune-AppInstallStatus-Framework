function Invoke-IAISReport {
  <#
    NOTE:
    This is a scaffold. The report route name may vary by tenant.
    Finalize the endpoint here once, and the rest of the framework becomes stable.

    Common pattern:
      POST https://graph.microsoft.com/beta/deviceManagement/reports/<reportName>
      Body: { filter, select, top, skip, orderBy }
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][ValidateSet('DeviceAppInstallStatus','UserAppInstallStatus','AppInstallSummary')]
    [string]$ReportName,
    [Parameter(Mandatory)][string]$AppId,
    [int]$Top = 500
  )

  $uri = "https://graph.microsoft.com/beta/deviceManagement/reports/$ReportName"

  $body = @{
    top    = $Top
    filter = "AppId eq '$AppId'"
  }

  Invoke-IAISGraph -Method POST -Uri $uri -Body $body
}
