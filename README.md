# PowerShell functions for Easit BPS and Easit GO

## Install

- ExecutionPolicy: Scripts/Functions/Module is not signed so you need to set execution policy to either Bypass or Unrestricted.
- Scope: Set to either Process (Affects only the current PowerShell session) or CurrentUser (Affects only the current user).
- [More information: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy)

1. Open Windows PowerShell as Administrator
2. Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
3. Install-Module EasitGoWebservice
4. Import-Module EasitGoWebservice

## Functions with "Complete/Done/Ready for use" status

* Get-GOItems
* Ping-GOWebService
* Import-GORequestItem
* Import-GOContactItem
* Import-GOAssetItem
* Import-GOOrganizationItem

## Functions with "work in progress" status

* None at the moment