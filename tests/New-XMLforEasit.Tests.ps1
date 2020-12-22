Describe "New-XMLforEasit" {
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
            Write-Host "Unable to locate code file to test against!" -ForegroundColor Red
        }
    }
    Context 'Mandatory parameters' {
        foreach ($set in $paramSets) {
            if ($set -eq 'get') {
                It 'should demand an ItemViewIdentifier if request is GET' {
                    Get-Command "$commandName" | Should -HaveParameter ItemViewIdentifier -Mandatory
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'ItemViewIdentifier'}).IsMandatory | Should Be $true
                }
                It 'Should demand an SortField if request is GET' {
                    Get-Command "$commandName" | Should -HaveParameter SortField -Mandatory
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'SortField'}).IsMandatory | Should Be $true
                }
                It 'Should demand an SortOrder if request is GET' {
                    Get-Command "$commandName" | Should -HaveParameter SortOrder -Mandatory
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'SortOrder'}).IsMandatory | Should Be $true
                }
            }

            if ($set -eq 'import') {
                It 'Should demand an Params if request is POST' {
                    Get-Command "$commandName" | Should -HaveParameter Params -Mandatory
                }
                It 'Should demand an ImportHandlerIdentifier if request is POST' {
                    Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -Mandatory
                }
            }
            

        }
    }
    
    Context 'Building XML' {
        It 'Should define schemas' {
            $scriptContent -match '\$xmlnsSch = "http://www.easit.com/bps/schemas"' | Should -Be $true
            $scriptContent -match '\$xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"' | Should -Be $true
        }
        
        It 'Should have a declaration' {
            $scriptContent -match '\[System\.Xml\.XmlDeclaration\] \$xmlDeclaration' | Should -Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$xmlDeclaration\)' | Should -Be $true
        }
    
        It 'Should create a envelope element' {
            $scriptContent -match '\$soapEnvEnvelope = \$payload\.CreateElement\("soapenv\:Envelope"\,\"\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.SetAttribute\("xmlns\:sch","\$xmlnsSch"\)' | Should -Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$soapEnvEnvelope\)' | Should -Be $true
        }
    
        It 'Should create a header element' {
            $scriptContent -match '\$soapEnvHeader = \$payload\.CreateElement\(.{1}soapenv\:Header.{1},"\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvHeader\)' | Should -Be $true
        }
    
        It 'Should create a body element' {
            $scriptContent -match '\$soapEnvBody = \$payload\.CreateElement\("soapenv\:Body","\$xmlnsSoapEnv"\)' | Should -Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvBody\)' | Should -Be $true
        }
    }
}