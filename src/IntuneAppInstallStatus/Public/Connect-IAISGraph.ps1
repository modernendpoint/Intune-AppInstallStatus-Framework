function Connect-IAISGraph {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$TenantId,
    [string[]]$Scopes = @(
      'DeviceManagementApps.Read.All',
      'DeviceManagementManagedDevices.Read.All',
      'Reports.Read.All'
    ),
    [switch]$UseBeta
  )

  if (-not (Get-Module Microsoft.Graph -ListAvailable)) {
    throw "Microsoft.Graph is required. Install-Module Microsoft.Graph -Scope CurrentUser"
  }

  Import-Module Microsoft.Graph -ErrorAction Stop

  if ($UseBeta) {
    Select-MgProfile -Name "beta" | Out-Null
  } else {
    Select-MgProfile -Name "v1.0" | Out-Null
  }

  Connect-MgGraph -TenantId $TenantId -Scopes $Scopes | Out-Null
  $ctx = Get-MgContext
  if (-not $ctx -or -not $ctx.Account) { throw "Graph connection failed." }

  return $ctx
}
