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
            Write-Verbose "StatusCode = $($_.Exception.Response.StatusDescription)"
            if ($_.Exception.Response.StatusDescription -eq 404) {
                $dets = "url"
            }
            if ($_.Exception.Response.StatusDescription -eq 500) {
                $dets = "apikey, ImportHandlerIdentifier/importViewIdentifier and properties for the items/object in payload"
                $addHelp = "You can try running $((Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name) with -dryRun to save payload to your desktop (${HOME}\Desktop\payload_x.xml)."
            }
            throw "An exception was caught: $($_.Exception.Message). Please check so that $dets are correct. $addHelp"
        }
        [xml]$returnObject = $requestResponse.Content
        return $returnObject
    }
    end {
        $ProgressPreference = 'Continue'
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}