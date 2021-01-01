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
        Write-Host "Unable to locate code file to test against!" -ForegroundColor Red
    }
}
Describe 'Get-GOItems' {
    It 'should demand an api key' {
        Get-Command "$commandName" | Should -HaveParameter apikey -Mandatory
    }
    It 'should demand a importViewIdentifier or "view"' {
        Get-Command "$commandName" | Should -HaveParameter importViewIdentifier -Mandatory
    }
    It 'should have a parameter named sortOrder with a default value' {
        Get-Command "$commandName" | Should -HaveParameter sortOrder -DefaultValue 'Descending'
    }
    It 'should have a parameter named sortField with a default value' {
        Get-Command "$commandName" | Should -HaveParameter sortField -DefaultValue 'Id'
    }
    It 'should have a parameter named viewPageNumber with a default value' {
        Get-Command "$commandName" | Should -HaveParameter viewPageNumber -DefaultValue 1
    }
    It 'should have a parameter named url with a default value' {
        Get-Command "$commandName" | Should -HaveParameter url -DefaultValue 'http://localhost/webservice/'
    }
}