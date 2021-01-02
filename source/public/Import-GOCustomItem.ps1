function Import-GOCustomItem {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("uri")]
        [string] $url = "http://localhost/webservice/",

        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("api")]
        [string] $apikey,

        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("ihi")]
        [string] $ImportHandlerIdentifier,

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
        $params = [ordered]@{}
        foreach ($property in $CustomProperties.GetEnumerator()) {
            try {
                $propertyName = $property.Key
                $propertyValue = $parDetails.Value
                Write-Verbose "Adding $propertyName with the value $propertyValue"
                $params.Add("$propertyName", "$propertyValue")
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
			break
		}
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
        }
        catch {
                throw $_
        }
        try {
                Write-Verbose "Converting response"
                $returnObject = Convert-EasitXMLToPsObject -Response $r
        }
        catch {
                throw $_
        }
        Write-Verbose "Returning converted response"
        return $returnObject
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}