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
Describe 'Invoke-EasitWebRequest' {
    It 'should demand a Uri' {
        Get-Command "$commandName" | Should -HaveParameter Uri -Mandatory
    }
    It 'should demand a Apikey' {
        Get-Command "$commandName" | Should -HaveParameter Apikey -Mandatory
    }
    It 'should demand a Body and it to be of type XML' {
        Get-Command "$commandName" | Should -HaveParameter Body -Mandatory
        Get-Command "$commandName" | Should -HaveParameter Body -Type XML
    }
    It 'should have a switch for UseDefaultCredentials' {
        Get-Command "$commandName" | Should -HaveParameter UseDefaultCredentials -Type switch
    }
    It 'should have a switch for UseBasicParsing' {
        Get-Command "$commandName" | Should -HaveParameter UseBasicParsing -Type switch
    }
    It 'should have a parameter named Method with a default value' {
        Get-Command "$commandName" | Should -HaveParameter Method -DefaultValue 'POST'
    }
    It 'should have a parameter named ContentType with a default value' {
        Get-Command "$commandName" | Should -HaveParameter ContentType -DefaultValue 'text/xml'
    }
}