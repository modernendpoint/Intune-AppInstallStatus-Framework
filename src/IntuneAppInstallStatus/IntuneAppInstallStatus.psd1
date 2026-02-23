@{
  RootModule        = 'IntuneAppInstallStatus.psm1'
  ModuleVersion     = '0.1.0'
  GUID              = '3c3fb4f7-1a9b-4a6a-8d0c-2b7e6a2fd3a9'
  Author            = 'Menahem'
  CompanyName       = ''
  Copyright         = '(c) 2026'
  Description       = 'Intune App Install Status Framework (IAIS) using Microsoft Graph.'
  PowerShellVersion = '7.0'
  FunctionsToExport = @(
    'Connect-IAISGraph',
    'Get-IAISApps',
    'Get-IAISInstallStatus',
    'Export-IAISReport',
    'Save-IAISSnapShot',
    'Compare-IAISSnapShot'
  )
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      Tags = @('Intune','Graph','Reporting','MDM','Android','Windows')
      LicenseUri = 'LICENSE'
      ProjectUri = ''
    }
  }
}
