BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testRoot = Split-Path -Path $PSCommandPath -Parent
    $projectRoot = Split-Path -Path $testRoot -Parent
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath "source"
    $codeFile = Get-ChildItem -Path "$sourceRoot" -Include "$codeFileName" -Recurse
    if (Test-Path $codeFile) {
        . $codeFile
    } else {
        Write-Output "Unable to locate code file to test against!" -ForegroundColor Red
    }
}
Describe 'Import-GORequestItem' {
    It 'have a parameter named apikey' {
        Get-Command "$commandName" | Should -HaveParameter apikey
    }
    It 'should have a parameter named url' {
        Get-Command "$commandName" | Should -HaveParameter url
    }
    It 'should have a parameter named ConfigurationDirectory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationDirectory
    }
    It 'should have a parameter named ImportHandlerIdentifier with a default value' {
        Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -DefaultValue 'CreateRequest'
    }
}