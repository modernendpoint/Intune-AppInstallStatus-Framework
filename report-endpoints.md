# Report endpoints

This repository ships with a scaffold for a report route:
`POST /beta/deviceManagement/reports/<ReportName>`

Different tenants / API profiles may expose different report names or shapes.
Finalize the report endpoint once in:
`src/IntuneAppInstallStatus/Private/Invoke-IAISReport.ps1`

Expected return shape:
- JSON object containing a `values` array

If your endpoint returns different field names, map them in:
`src/IntuneAppInstallStatus/Public/Get-IAISInstallStatus.ps1`
