function Save-IAISSnapShot {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]$Data,
    [Parameter(Mandatory)][string]$SnapshotPath
  )

  $dir = Split-Path $SnapshotPath -Parent
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  ($Data | ConvertTo-Json -Depth 15) | Set-Content -Path $SnapshotPath -Encoding UTF8
  $SnapshotPath
}
