$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptFolder = Split-Path -Parent $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$scriptFolder\$sut"

#$scriptContent = Get-Content -Path "$scriptFolder\$sut" -Raw

Describe 'Mandatory Params' {
    It 'Should demand an api key' {
        (((Get-Command -Name Import-GOAssetItem).ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'apikey'}).IsMandatory | Should Be $true
    }
}