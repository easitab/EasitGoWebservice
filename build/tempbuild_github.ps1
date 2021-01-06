# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
$tempModuleFileName = 'EasitGoWebservice'
$tempModuleRoot = Join-Path -Path "$projectRoot" -ChildPath "$tempModuleFileName"
$tempModulePath = Join-Path -Path "$tempModuleRoot" -ChildPath "${tempModuleFileName}.psm1"
# Runtime variables
Set-Location -Path $projectRoot
Write-Output "New module start"
New-Module -Name "$tempModuleFileName" -ScriptBlock {
    $projectRoot = Split-Path -Path $PSScriptRoot -Parent
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
    $tempModuleFileName = 'EasitGoWebservice'
    $allScripts = Get-ChildItem -Path "$sourceRoot" -Filter "*.ps1" -Recurse
    $tempModuleRoot = Join-Path -Path "$projectRoot" -ChildPath "$tempModuleFileName"
    $tempModulePath = Join-Path -Path "$tempModuleRoot" -ChildPath "${tempModuleFileName}.psm1"
    if (!(Test-Path -Path $tempModuleRoot)) {
        New-Item -Path "$projectRoot" -Name "$tempModuleFileName" -ItemType "directory" | Out-Null
        Write-Output "Created $tempModuleRoot"
    }
    if (!(Test-Path -Path $tempModulePath)) {
        $tempModuleFile = New-Item -Path "$tempModuleRoot" -Name "${tempModuleFileName}.psm1" -ItemType "file"
        Write-Output "Created $newModuleFile"
    }
    foreach ($script in $allScripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptContent = Get-Content -Path "$($script.FullName)" -Raw
        if (Test-Path -Path $tempModulePath) {
            try {
                Add-Content -Path $tempModuleFile -Value $scriptContent -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
            try {
                Add-Content -Path $tempModuleFile -Value $exportFunction -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        }
    }
}
Write-Output "New module end"
$projectUriRoot = 'https://github.com/easitab/EasitGoWebservice'
$manifest = @{
    Path              = "$tempModuleRoot/${tempModuleFileName}.psd1"
    RootModule        = "$tempModuleRoot/${tempModuleFileName}.psm1"
    CompanyName       = "Easit AB"
    Author            = "Anders Thyrsson"
    ModuleVersion     = "0.0.1"
    HelpInfoUri       = "$projectUriRoot/tree/development/docs/v1"
    LicenseUri        = "$projectUriRoot/blob/development/LICENSE"
    ProjectUri        = "$projectUriRoot"
    Description       = 'Module to be used with Easit BPS & Easit GO webservice API'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2021 Easit AB. All rights reserved."
}
New-ModuleManifest @manifest