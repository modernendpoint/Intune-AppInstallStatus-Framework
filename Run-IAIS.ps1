param(
  [Parameter(Mandatory)][string]$TenantId,
  [Parameter(Mandatory)][string]$AppSearch,
  [ValidateSet('ByDevice','ByUser','Summary')][string]$View='ByDevice',
  [int]$Top = 500
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $here '..')

Import-Module (Join-Path $root 'src/IntuneAppInstallStatus/IntuneAppInstallStatus.psd1') -Force

Connect-IAISGraph -TenantId $TenantId -UseBeta | Out-Null

$app = Get-IAISApps -Search $AppSearch -Type all | Select-Object -First 1
if (-not $app) { throw "App not found for search: $AppSearch" }

$data = Get-IAISInstallStatus -AppId $app.id -View $View -Top $Top

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$base = Join-Path $root ("runs/exports/{0}-{1}-{2}" -f $app.id, $View, $stamp)
Export-IAISReport -Data $data -PathBase $base | Format-List

# snapshot
$snap = Join-Path $root ("runs/snapshots/{0}-{1}-{2}.json" -f $app.id, $View, $stamp)
Save-IAISSnapShot -Data $data -SnapshotPath $snap | Out-Null

# summary
$data | Group-Object Status | Sort-Object Count -Descending | Format-Table Count, Name
