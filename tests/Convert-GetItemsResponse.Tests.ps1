BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testRoot = Split-Path -Path $PSCommandPath -Parent
    $testDataRoot = Join-Path -Path "$testRoot" -ChildPath "data"
    $projectRoot = Split-Path -Path $testRoot -Parent
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath "source"
    $codeFile = Get-ChildItem -Path "$sourceRoot" -Include "$codeFileName" -Recurse
    [xml]$testResponse = Get-Content "$testDataRoot\getResponse.xml" -Raw
    if (Test-Path $codeFile) {
        . $codeFile
    } else {
        Write-Output "Unable to locate code file to test against!" -ForegroundColor Red
    }
}
Describe "$commandName" -Tag 'function' {
    It 'should demand and only accept XML' {
        Get-Command "$commandName" | Should -HaveParameter Response -Type xml
        Get-Command "$commandName" | Should -HaveParameter Response -Mandatory
    }
    It 'should return exactly 99 items' {
        (Convert-GetItemsResponse -Response $testResponse).Count | Should -BeExactly 99
    }
}