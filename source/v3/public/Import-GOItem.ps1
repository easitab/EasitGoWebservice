function Import-GOItem {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Import-GOItem.md")]
    [Alias("Import-GOCustomItem","igi")]
    param (
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("uri")]
        [string] $url,

        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("api")]
        [string] $apikey,

        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("ihi")]
        [string] $ImportHandlerIdentifier,

        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('configdir')]
        [string] $ConfigurationDirectory = $Home,

        [parameter(Mandatory = $true, ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
        [hashtable] $CustomProperties,

        [parameter(Mandatory = $false, ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
        [Alias("File")]
        [string] $Attachment,

        [parameter(Mandatory = $false)]
        [switch] $SSO,

        [parameter(Mandatory = $false)]
        [switch] $UseBasicParsing,

        [parameter(Mandatory = $false)]
        [switch] $dryRun
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
        $params = [ordered]@{}
        foreach ($property in $CustomProperties.GetEnumerator()) {
            try {
                Write-Verbose "Adding $($property.Key) with the value $($property.Value)"
                if($property.Value.Count -gt 1){
                    $params.$($property.Key) = @()
                    foreach($p in $property.Value){
                        $params.$($property.Key) += "$($p)"
                    }
                } else {
                    $params.Add("$($property.Key)", "$($property.Value)")
                }
            } catch {
                throw $_
            }
        }
        Write-Verbose "Generating payload"
        try {
            $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $params
            Write-Verbose "Successfully generated payload"
        } catch {
            throw $_
        }
        if ($dryRun) {
			Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS"
			try {
				Export-PayloadToFile -Payload $payload
			} catch {
				throw $_
			}
		} else {
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
                    throw $_
            }
            try {
                    Write-Verbose "Converting response"
                    $returnObject = Convert-EasitXMLToPsObject -Response $r
            } catch {
                    throw $_
            }
            Write-Verbose "Returning converted response"
            return $returnObject
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}