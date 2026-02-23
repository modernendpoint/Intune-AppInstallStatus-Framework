function Get-IAISInstallStatus {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$AppId,
    [ValidateSet('ByDevice','ByUser','Summary')][string]$View = 'ByDevice',
    [int]$Top = 500
  )

  $report = switch ($View) {
    'ByDevice' { 'DeviceAppInstallStatus' }
    'ByUser'   { 'UserAppInstallStatus' }
    'Summary'  { 'AppInstallSummary' }
  }

  $raw = Invoke-IAISReport -ReportName $report -AppId $AppId -Top $Top

  $values = @()
  if ($raw.PSObject.Properties.Name -contains 'values') { $values = $raw.values }

  foreach ($v in $values) {
    [pscustomobject]@{
      AppId       = $AppId
      DeviceName  = $v.deviceName
      DeviceId    = $v.deviceId
      UPN         = $v.userPrincipalName
      Status      = $v.installState
      ErrorCode   = $v.errorCode
      LastUpdated = $v.lastModifiedDateTime
    }
  }
}
