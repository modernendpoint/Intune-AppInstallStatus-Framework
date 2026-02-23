function Get-IAISApps {
  [CmdletBinding()]
  param(
    [Parameter()][string]$Search,
    [ValidateSet('mobile','win32','store','all')][string]$Type = 'all',
    [int]$Top = 999
  )

  $uri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?`$top=$Top"
  $apps = (Invoke-IAISGraph -Method GET -Uri $uri).value

  if ($Type -ne 'all') {
    $apps = switch ($Type) {
      'mobile' { $apps | Where-Object { $_.'@odata.type' -match 'android|ios' } }
      'win32'  { $apps | Where-Object { $_.'@odata.type' -match 'win32LobApp' } }
      'store'  { $apps | Where-Object { $_.'@odata.type' -match 'windowsStoreApp|winGetApp' } }
    }
  }

  if ($Search) { $apps = $apps | Where-Object { $_.displayName -like "*$Search*" } }

  $apps | Select-Object id, displayName, publisher, '@odata.type'
}
