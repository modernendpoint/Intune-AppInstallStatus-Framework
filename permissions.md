# Permissions & RBAC

## Delegated (interactive) scopes
Recommended scopes for Graph Explorer / interactive PowerShell:

- DeviceManagementApps.Read.All
- DeviceManagementManagedDevices.Read.All
- Reports.Read.All

> Intune RBAC still applies. The signed-in user must have sufficient Intune read permissions.

## Application permissions (automation)
For service principals / runbooks, typical minimum set:
- DeviceManagementManagedDevices.Read.All
- DeviceManagementApps.Read.All
- Reports.Read.All (if required by your chosen report endpoint)
