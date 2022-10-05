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
$newMarkdownHelpParams = @{
    Module = $tempModuleFileName
    OutputFolder = "$docsVersionRoot"
    AlphabeticParamsOrder = $true
    OnlineVersionUrl = "https://github.com/easitab/EasitGoWebservice/blob/development/docs/v3/"
    ErrorAction = Stop
}
try {
    New-MarkdownHelp @newMarkdownHelpParams
} catch {
    Write-Error $_
    break
}
Write-Verbose "Done updating MarkdownHelp"
