function Invoke-EasitWebRequest {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Invoke-EasitWebRequest.md")]
    <#
    .EXTERNALHELP EasitGoWebservice-help.xml
    #>
    param (
        [Parameter(Mandatory)]
        [String] $Uri,
        [Parameter(Mandatory)]
        [String] $Apikey,
        [Parameter()]
        [String] $Method = 'POST',
        [Parameter()]
        [String] $ContentType = 'text/xml',
        [Parameter(Mandatory)]
        [xml] $Body,
        [Parameter()]
        [Switch] $UseDefaultCredentials,
        [Parameter()]
        [Switch] $UseBasicParsing
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $ProgressPreference = 'SilentlyContinue'
    }

    process {
        Write-Verbose "Creating header for web request"
        try {
            $pair = "$($Apikey): "
            $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
            $basicAuthValue = "Basic $encodedCreds"
            $headers = @{SOAPAction = ""; Authorization = $basicAuthValue }
            Write-Verbose "Header created for web request"
        }
        catch {
            Write-Error "Failed to create header"
            Write-Error "$_"
            break
        }
        $webRequestParams = @{
            Uri = $Uri
            Method = $Method
            ContentType = $ContentType
            Body = $Body
            Headers = $Headers
        }
        if ($UseBasicParsing) {
            Write-Verbose "Adding UseBasicParsing to webRequestParams"
            $webRequestParams.Add('UseBasicParsing', $true)
        }
        if ($UseDefaultCredentials) {
            Write-Verbose "Adding UseDefaultCredentials to webRequestParams"
            $webRequestParams.Add('UseDefaultCredentials', $true)
        }
        Write-Verbose "Calling web service.."
        $httpResponse = try {
            ($requestResponse = Invoke-WebRequest @webRequestParams -ErrorAction Stop).BaseResponse
            Write-Verbose "Successfully connected to and imported data"
        } catch [System.Net.WebException] {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Verbose "StatusCode = $statusCode"
            $erMessStart = 'An exception was caught:'
            if (!($statusCode) -or $statusCode -ne 500) {
                throw "$($_.Exception.Message)"
            }
            if ($statusCode -and $statusCode -eq 500) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $reader.BaseStream.Position = 0
                $reader.DiscardBufferedData()
                [xml]$xmlResponse = $reader.ReadToEnd()
                $dets = "$($xmlResponse.Envelope.Body.Fault.faultstring.innerText)"
                throw "$erMessStart $dets"
            }
        }
        [xml]$returnObject = $requestResponse.Content
        return $returnObject
    }
    end {
        $ProgressPreference = 'Continue'
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}