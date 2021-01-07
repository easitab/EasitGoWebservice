# Install

- ExecutionPolicy: Scripts/Functions/Module is not signed so you need to set execution policy to either Bypass or Unrestricted.
- Scope: Set to either Process (Affects only the current PowerShell session) or CurrentUser (Affects only the current user).
- [More information: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy)

1. Open Windows PowerShell as Administrator
2. Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
3. Install-Module -Name EasitGoWebservice
4. Import-Module -Name EasitGoWebservice

Read more about [Install-Module](https://docs.microsoft.com/en-us/powershell/module/powershellget/install-module) and [Import-Module](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/import-module) here.

You do not need to install EasitGoWebservice on the server where Easit GO / BPS is running. All you need to is to be able to connect to Easit GO / BPS in order to use EasitGoWebservice.