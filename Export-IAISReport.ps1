function Export-IAISReport {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]$Data,
    [Parameter(Mandatory)][string]$PathBase
  )

  $dir = Split-Path $PathBase -Parent
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  $csv  = "$PathBase.csv"
  $json = "$PathBase.json"

  $Data | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8
  ($Data | ConvertTo-Json -Depth 15) | Set-Content -Path $json -Encoding UTF8

  [pscustomobject]@{ Csv=$csv; Json=$json }
}
