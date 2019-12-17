$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptFolder = Split-Path -Parent $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$commandName = $sut -replace '.ps1',''
. "$scriptFolder\$sut"
$scriptContent = Get-Content -Path "$scriptFolder\$sut" -Raw
$paramSets = (Get-Command -Name "$commandName").ParameterSets.Name

Describe "New-XMLforEasit" {

    Context 'Mandatory parameters' {
        foreach ($set in $paramSets) {
            if ($set -eq 'get') {
                It 'should demand an ItemViewIdentifier if request is GET' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'ItemViewIdentifier'}).IsMandatory | Should Be $true
                }
                It 'Should demand an SortField if request is GET' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'SortField'}).IsMandatory | Should Be $true
                }
                It 'Should demand an SortOrder if request is GET' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'SortOrder'}).IsMandatory | Should Be $true
                }
                It 'Should demand an ColumnFilter if request is GET' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'ColumnFilter'}).IsMandatory | Should Be $true
                }
            }

            if ($set -eq 'import') {
                It 'Should demand an Params if request is POST' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'Params'}).IsMandatory | Should Be $true
                }
                It 'Should demand an ImportHandlerIdentifier if request is POST' {
                    (((Get-Command -Name "$commandName").ParameterSets).Parameters | Where-Object -FilterScript {$_.IsMandatory -eq 1 -and $_.Name -eq 'ImportHandlerIdentifier'}).IsMandatory | Should Be $true
                }
            }
            

        }
    }
    
    Context 'Building XML' {
        It 'Should define schemas' {
            $scriptContent -match '\$xmlnsSch = "http://www.easit.com/bps/schemas"' | Should Be $true
            $scriptContent -match '\$xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"' | Should Be $true
        }
        
        It 'Should have a declaration' {
            $scriptContent -match '\[System\.Xml\.XmlDeclaration\] \$xmlDeclaration' | Should Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$xmlDeclaration\)' | Should Be $true
        }
    
        It 'Should create a envelope element' {
            $scriptContent -match '\$soapEnvEnvelope = \$payload\.CreateElement\("soapenv\:Envelope"\,\"\$xmlnsSoapEnv"\)' | Should Be $true
            $scriptContent -match '\$soapEnvEnvelope\.SetAttribute\("xmlns\:sch","\$xmlnsSch"\)' | Should Be $true
            $scriptContent -match '\$payload\.AppendChild\(\$soapEnvEnvelope\)' | Should Be $true
        }
    
        It 'Should create a header element' {
            $scriptContent -match '\$soapEnvHeader = \$payload\.CreateElement\(.{1}soapenv\:Header.{1},"\$xmlnsSoapEnv"\)' | Should Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvHeader\)' | Should Be $true
        }
    
        It 'Should create a body element' {
            $scriptContent -match '\$soapEnvBody = \$payload\.CreateElement\("soapenv\:Body","\$xmlnsSoapEnv"\)' | Should Be $true
            $scriptContent -match '\$soapEnvEnvelope\.AppendChild\(\$soapEnvBody\)' | Should Be $true
        }
    }
}