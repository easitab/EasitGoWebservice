function Test-GOWsEndpoint {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Test-GOWsEndpoint.md")]
    param (
        [parameter(Mandatory=$false)]
        [string] $url,

        [parameter(Mandatory=$false)]
        [Alias("api")]
        [string] $apikey,

        [parameter(Mandatory)]
        [string] $Endpoint,

        [parameter(Mandatory)]
        [ValidateSet("Import","Get")]
        [string] $EndpointType,

        [parameter(Mandatory = $false)]
        [Alias('configdir')]
        [string] $ConfigurationDirectory = $Home,

        [parameter(Mandatory=$false)]
        [switch] $SSO,

        [parameter(Mandatory = $false)]
        [switch] $UseBasicParsing
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!($url) -or !($apikey)) {
            Write-Verbose "url or apikey NOT provided, checking for local configuration file"
            if ($ConfigurationDirectory) {
                    $localConfigPath = $ConfigurationDirectory
            } else {
                    $localConfigPath = $Home
            }
            try {
                    $wsConfig = Get-ConfigurationFile -Path $localConfigPath
            } catch {
                    throw $_
            }
            if ($wsConfig) {
                    if (!($url)) {
                        $url = $wsConfig.url
                    } else {
                        Write-Verbose "url provided via cmdlet parameter, using that"
                    }
                    if (!($apikey)) {
                        if ($wsConfig.apikey.Length -gt 0) {
                                $apikey = $wsConfig.apikey
                                Write-Verbose "Using apikey from local configuration file"
                        } else {
                                Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                                break
                        }
                    } else {
                        Write-Verbose "apikey provided via cmdlet parameter, using that"
                    }
            } else {
                    Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                    break
            }
        }
        $newXmlParams = @{}
        if ($EndpointType -like 'Import') {
            $newXmlParams.Add('Import',$true)
            $newXmlParams.Add('ImportHandlerIdentifier',$Endpoint)
            $xmlImportParams = @{
                dummy1 = 1
                dummy2 = 2
            }
        }
        if ($EndpointType -like 'Get') {
            $newXmlParams.Add('Get',$true)
            $newXmlParams.Add('ItemViewIdentifier',$Endpoint)        
        }
        if ($EndpointType -like 'Import') {
            try {
                $payload = New-XMLforEasit @newXmlParams -Params $xmlImportParams
            } catch {
                throw $_
            }
        } else {
            try {
                $payload = New-XMLforEasit @newXmlParams
            } catch {
                throw $_
            }
        }
        $payload.Save("C:\Users\anth\GitHub\easitanth\EasitGoWebservice\payload.xml")
        $easitWebRequestParams = @{
            Uri = "$url"
            Apikey = "$apikey"
            Body = $payload
        }
        if ($SSO) {
                Write-Verbose "Adding UseDefaultCredentials to param hash"
                $easitWebRequestParams.Add('UseDefaultCredentials',$true)
        }
        if ($UseBasicParsing) {
                Write-Verbose "Adding UseBasicParsing to param hash"
                $easitWebRequestParams.Add('UseBasicParsing',$true)
        }
        try {
                Write-Verbose "Calling Invoke-EasitWebRequest"
                $r = Invoke-EasitWebRequest @easitWebRequestParams
        } catch {
                $fault = $_
        }
        if ($fault) {
            Write-Verbose $fault
            if ($fault -match "No configuration with uid") {
                Write-Warning "No importhandler with identifier $Endpoint found"
            } elseif ($fault -match "No item view with specified identifier found") {
                Write-Warning "No item view with identifier $Endpoint found"
            } else {
                Write-Warning $fault
            }
            return $false
        } else {
            return $true
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}