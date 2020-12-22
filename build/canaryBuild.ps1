# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$moduleName = Split-Path -Path $projectRoot -Leaf
$sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
$moduleRoot = Join-Path -Path "$projectRoot" -ChildPath "module"
$canaryModuleRoot = Join-Path -Path "$moduleRoot" -ChildPath "canaryBuild"
$modulePath = Join-Path -Path "$canaryModuleRoot" -ChildPath "${moduleName}.psm1"
# Runtime variables
Set-Location -Path $projectRoot
if (Test-Path -Path $modulePath) {
    Remove-Item -Path "$modulePath" -Force
}
if (Test-Path -Path "$canaryModuleRoot/${moduleName}.psd1") {
    Remove-Item -Path "$canaryModuleRoot/${moduleName}.psd1" -Force
}
Write-Output "New module start"
New-Module -Name "$moduleName" -ScriptBlock {
    $projectRoot = Split-Path -Path $PSScriptRoot -Parent
    $moduleName = Split-Path -Path $projectRoot -Leaf
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
    $moduleRoot = Join-Path -Path "$projectRoot" -ChildPath "module"
    $canaryModuleRoot = Join-Path -Path "$moduleRoot" -ChildPath "canaryBuild"
    $modulePath = Join-Path -Path "$canaryModuleRoot" -ChildPath "${moduleName}.psm1"
    $allScripts = Get-ChildItem -Path "$sourceRoot" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        $nightlyModuleFile = New-Item -Path "$canaryModuleRoot" -Name "${moduleName}.psm1" -ItemType "file"
        Write-Output "Created $nightlyModuleFile"
    }
    foreach ($script in $allScripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptContent = Get-Content -Path "$($script.FullName)" -Raw
        if (Test-Path -Path $modulePath) {    
            try {
                Add-Content -Path $modulePath -Value $scriptContent -ErrorAction Stop
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
    Path              = "$canaryModuleRoot/${moduleName}.psd1" 
    RootModule        = "${moduleName}.psm1" 
    CompanyName       = "Easit AB"
    Author            = "Anders Thyrsson"
    ModuleVersion     = "0.0.1"
    HelpInfoUri       = "$projectUriRoot/tree/development/docs/v1"
    LicenseUri        = "$projectUriRoot/blob/development/LICENSE"
    ProjectUri        = "$projectUriRoot"
    Description       = 'Module to be used with Easit BPS & Easit GO webservice API'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 Easit AB. All rights reserved."
}
New-ModuleManifest @manifest