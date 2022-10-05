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
Describe 'Import-GOCustomItem' {
    It 'should have a parameter named apikey' {
        Get-Command "$commandName" | Should -HaveParameter apikey
    }
    It 'should have a parameter named url' {
        Get-Command "$commandName" | Should -HaveParameter url
    }
    It 'should have a parameter named ConfigurationDirectory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationDirectory
    }
    It 'should have a parameter named ImportHandlerIdentifier' {
        Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier
    }
    It 'should demand a value for ImportHandlerIdentifier' {
        Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -Mandatory
    }
    It 'should have a parameter named CustomProperties' {
        Get-Command "$commandName" | Should -HaveParameter CustomProperties
    }
    It 'should demand a value for CustomProperties' {
        Get-Command "$commandName" | Should -HaveParameter CustomProperties -Mandatory
    }
    It 'input type for CustomProperties should be hashtable' {
        Get-Command "$commandName" | Should -HaveParameter CustomProperties -Type 'hashtable'
    }
}