# Intune App Install Status Framework (IAIS)

$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

foreach ($f in @($Private + $Public)) {
    try { . $f.FullName } catch { throw "Failed loading $($f.FullName): $($_.Exception.Message)" }
}

Export-ModuleMember -Function @(
  'Connect-IAISGraph',
  'Get-IAISApps',
  'Get-IAISInstallStatus',
  'Export-IAISReport',
  'Save-IAISSnapShot',
  'Compare-IAISSnapShot'
)
