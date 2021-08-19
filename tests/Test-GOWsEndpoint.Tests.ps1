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
Describe 'Test-GOWsEndpoint' {
    It 'should have a parameter named url' {
        Get-Command "$commandName" | Should -HaveParameter url
    }
    It 'should have a parameter named apikey' {
        Get-Command "$commandName" | Should -HaveParameter apikey
    }
    It 'should demand a parameter named Endpoint' {
        Get-Command "$commandName" | Should -HaveParameter Endpoint -Mandatory
    }
    It 'should demand a parameter named EndpointType' {
        Get-Command "$commandName" | Should -HaveParameter EndpointType -Mandatory
    }
    It 'should have a parameter named ConfigurationDirectory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationDirectory
    }
    It 'should have a parameter named SSO' {
        Get-Command "$commandName" | Should -HaveParameter SSO
    }
    It 'should have a parameter named UseBasicParsing' {
        Get-Command "$commandName" | Should -HaveParameter UseBasicParsing
    }
}