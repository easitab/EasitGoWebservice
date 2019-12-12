$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptFolder = Split-Path -Parent $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$scriptFolder\$sut"
$scriptContent = Get-Content -Path "$scriptFolder\$sut" -Raw

Describe "New-XMLforEasit" {
    
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