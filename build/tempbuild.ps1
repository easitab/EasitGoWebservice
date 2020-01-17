New-Module -Name "$env:moduleName" -ScriptBlock {
    $modulePath = "$env:resourceRoot\$env:moduleName\$env:moduleName.psm1"
    $scripts = Get-ChildItem -Path "$env:resourceRoot" -Filter "*.ps1"
    if (!(Test-Path -Path $modulePath)) {
        if (!(Test-Path -Path "$env:resourceRoot\$env:moduleName")) {
            New-Item -Path "$env:resourceRoot" -Name "$env:moduleName" -ItemType "directory" | Out-Null
            Write-Host "Created $env:resourceRoot\$env:moduleName"
        }
        $newModuleFile = New-Item -Path "$env:resourceRoot\$env:moduleName" -Name "$env:moduleName.psm1" -ItemType "file"
        Write-Host "Created $newModuleFile"
    }
    foreach ($script in $scripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptName = "$($script.Name)"
        $scriptContent = Get-Content -Path "$env:resourceRoot\$scriptName" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
            if (!($exportFunction -eq 'New-XMLforEasit')) {
                Add-Content -Path $modulePath -Value $exportFunction
            }
        }
    }
}

$manifest = @{
    Path              = "$env:resourceRoot\$env:moduleName\$env:moduleName.psd1" 
    RootModule        = "$env:moduleName.psm1" 
    CompanyName       = "$env:companyName"
    Author            = "$env:moduleAuthor" 
    ModuleVersion     = "$env:APPVEYOR_BUILD_VERSION"
    HelpInfoUri       = "$env:helpInfoUri"
    Description       = 'Description to be used with Easit BPS & Easit GO webservice API'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2019 $env:companyName. All rights reserved."
}
New-ModuleManifest @manifest | Out-Null

## Test section ##
# Install-Module Pester -Force -Scope CurrentUser
# Invoke-Pester -EnableExit

## On build success script ##
# $newManifestTest = Test-ModuleManifest -Path "$env:resourceRoot\$env:moduleName\$env:moduleName.psd1"

## On build finish script ##
# if ($newManifestTest) {
    #Publish-Module -Path "$env:resourceRoot\$env:moduleName\" -NuGetApiKey "$env:galleryPublishingKey"
#}