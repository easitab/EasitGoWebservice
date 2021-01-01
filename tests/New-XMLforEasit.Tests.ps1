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
        $scriptContent = Get-Content $codeFile -Raw
    } else {
        Write-Output "Unable to locate code file to test against!" -ForegroundColor Red
    }
    $paramSets = (Get-Command New-XMLforEasit).ParameterSets
}
Describe "New-XMLforEasit" {
    Context 'should have' {
        It 'a Ping parameter' {
            Get-Command "$commandName" | Should -HaveParameter Ping
        }
        It 'a Get parameter' {
            Get-Command "$commandName" | Should -HaveParameter Get
        }
        It 'a Import parameter' {
            Get-Command "$commandName" | Should -HaveParameter Import
        }
    }
    Context 'should demand' {
        foreach ($set in $paramSets) {
            if ($set.Name -eq 'get') {
                It 'an ItemViewIdentifier if request is Get' {
                    Get-Command "$commandName" | Should -HaveParameter ItemViewIdentifier -Mandatory
                }
                It 'an SortField if request is Get' {
                    Get-Command "$commandName" | Should -HaveParameter SortField -Mandatory
                }
                It 'an SortOrder if request is Get' {
                    Get-Command "$commandName" | Should -HaveParameter SortOrder -Mandatory
                }
            }
            if ($set.Name -eq 'import') {
                It 'an Params if request is Import' {
                    Get-Command "$commandName" | Should -HaveParameter Params -Mandatory
                }
                It 'an ImportHandlerIdentifier if request is Import' {
                    Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -Mandatory
                }
            }
        }
    }
    Context 'when building XML' {
        It 'should define schemas' {
            $scriptContent -match '\$xmlnsSch = "http://www.easit.com/bps/schemas"' | Should -Be $true
            $scriptContent -match '\$xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"' | Should -Be $true
        }
        It 'should have a declaration' {
            $scriptContent -match '\[System\.Xml\.XmlDeclaration\] \$xmlDeclaration' | Should -Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$xmlDeclaration\)' | Should -Be $true
        }
        It 'should create a envelope element' {
            $scriptContent -match '\$soapEnvEnvelope = \$payload\.CreateElement\("soapenv\:Envelope"\,\"\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.SetAttribute\("xmlns\:sch","\$xmlnsSch"\)' | Should -Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$soapEnvEnvelope\)' | Should -Be $true
        }
        It 'should create a header element' {
            $scriptContent -match '\$soapEnvHeader = \$payload\.CreateElement\(.{1}soapenv\:Header.{1},"\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvHeader\)' | Should -Be $true
        }
        It 'should create a body element' {
            $scriptContent -match '\$soapEnvBody = \$payload\.CreateElement\("soapenv\:Body","\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvBody\)' | Should -Be $true
        }
    }
}