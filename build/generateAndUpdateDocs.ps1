# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
$tempModuleFileName = 'EasitGoWebservice'
$docsRoot = Join-Path -Path "$projectRoot" -ChildPath 'docs'
$docsVersionRoot = Join-Path -Path "$docsRoot" -ChildPath 'v1'
$tempModuleRoot = Join-Path -Path "$projectRoot" -ChildPath "$tempModuleFileName"
Set-Location -Path $projectRoot
# Runtime variables

$allScripts = Get-ChildItem -Path "$sourceRoot" -Filter "*.ps1" -Recurse
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
foreach ($script in $allScripts) {
    $commandName = $script.BaseName
    if (Test-Path -Path "$docsVersionRoot/${commandName}.md") {
        Write-Output "Found $docsVersionRoot/${commandName}.md"
        try {
            Update-MarkdownHelp -Path "$docsVersionRoot/${commandName}.md" -AlphabeticParamsOrder -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    } else {
        Write-Output "Unable to find $docsVersionRoot/${commandName}.md"
        try {
            New-MarkdownHelp -Command $commandName -OutputFolder "$docsVersionRoot" -AlphabeticParamsOrder -OnlineVersionUrl "https://github.com/easitab/EasitGoWebservice/blob/development/docs/v1/${commandName}.md" -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    }
}
Write-Verbose "Done updating MarkdownHelp"
Write-Verbose "Generating new external help"
try {
    New-ExternalHelp -Path "$docsVersionRoot" -OutputPath "$docsVersionRoot/en-US" -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
Write-Output "New-ExternalHelp done!"