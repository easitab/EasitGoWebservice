# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$tempModuleFileName = 'EasitGoWebservice'
$docsRoot = Join-Path -Path "$projectRoot" -ChildPath 'docs'
$docsVersionRoot = Join-Path -Path "$docsRoot" -ChildPath 'v3'
$tempModuleRoot = Join-Path -Path "$projectRoot" -ChildPath "$tempModuleFileName"
Set-Location -Path $projectRoot
# Runtime variables

try {
    Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
    Import-Module platyPS -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
try {
    Import-Module -Name "$tempModuleRoot" -Force -Verbose -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
Write-Verbose "Generating new external help"
try {
    New-ExternalHelp -Path "$docsVersionRoot" -OutputPath "$docsVersionRoot/en-US" -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
Write-Output "New-ExternalHelp done!"
