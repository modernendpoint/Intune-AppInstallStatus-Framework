function Compare-IAISSnapShot {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$OldSnapshot,
    [Parameter(Mandatory)][string]$NewSnapshot,
    [string[]]$KeyFields = @('AppId','DeviceId','UPN')
  )

  $old = Get-Content $OldSnapshot -Raw | ConvertFrom-Json
  $new = Get-Content $NewSnapshot -Raw | ConvertFrom-Json

  $makeKey = {
    param($x)
    ($KeyFields | ForEach-Object { $x.$_ }) -join '|'
  }

  $oldMap = @{}
  foreach ($o in $old) { $oldMap[(& $makeKey $o)] = $o }

  $newMap = @{}
  foreach ($n in $new) { $newMap[(& $makeKey $n)] = $n }

  $changes = @()

  foreach ($k in $newMap.Keys) {
    if (-not $oldMap.ContainsKey($k)) {
      $changes += [pscustomobject]@{ Change='Added'; Key=$k; NewStatus=$newMap[$k].Status; OldStatus=$null }
      continue
    }
    $o = $oldMap[$k]; $n = $newMap[$k]
    if ($o.Status -ne $n.Status -or $o.ErrorCode -ne $n.ErrorCode) {
      $changes += [pscustomobject]@{
        Change='Updated'; Key=$k;
        OldStatus=$o.Status; NewStatus=$n.Status;
        OldError=$o.ErrorCode; NewError=$n.ErrorCode
      }
    }
  }

  foreach ($k in $oldMap.Keys) {
    if (-not $newMap.ContainsKey($k)) {
      $changes += [pscustomobject]@{ Change='Removed'; Key=$k; NewStatus=$null; OldStatus=$oldMap[$k].Status }
    }
  }

  $changes
}
