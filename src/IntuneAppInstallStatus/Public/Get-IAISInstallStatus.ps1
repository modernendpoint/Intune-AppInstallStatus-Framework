function Get-IAISInstallStatus {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$AppId,
    [ValidateSet('ByDevice','ByUser')][string]$View = 'ByDevice'
  )

  $report = if ($View -eq 'ByDevice') { 'DeviceInstallStatus' } else { 'UserInstallStatus' }

  $rows = Invoke-IAISReport -ReportName $report -AppId $AppId

  foreach ($r in $rows) {

    $deviceName = $r.DeviceName  ?? $r.'Device Name' ?? $r.ManagedDeviceName
    $deviceId   = $r.DeviceId    ?? $r.'Device Id'   ?? $r.ManagedDeviceId
    $upn        = $r.UserPrincipalName ?? $r.UPN ?? $r.User ?? $r.'User Principal Name'
    $status     = $r.InstallState ?? $r.InstallStatus ?? $r.Status ?? $r.'Install State'
    $error      = $r.ErrorCode ?? $r.Error ?? $r.'Error Code'
    $updated    = $r.LastModifiedDateTime ?? $r.LastUpdated ?? $r.'Last Modified Date Time'

    [pscustomobject]@{
      AppId       = $AppId
      DeviceName  = $deviceName
      DeviceId    = $deviceId
      UPN         = $upn
      Status      = $status
      ErrorCode   = $error
      LastUpdated = $updated
    }
  }
}
