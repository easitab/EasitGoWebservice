function Convert-EasitXMLToPsObject {
    <#
    .SYNOPSIS
    Converts XML response from easitGO to PSCustomObjects

    .DESCRIPTION
    The **Convert-EasitXMLToPsObject** converts an XML response from easitGO and Easit BPS to PSCustomObjects.
    
    This function uses Convert-GetItemsResponse, Convert-ImportItemsResponse and Convert-PingResponse to convert each response in the correct way.

    .INPUTS
    XML

    .OUTPUTS
    PSCustomObject

    .PARAMETER Response
    XML response from easitGO to convert.

    .PARAMETER ThrottleLimit
    Specifies the number of items to process in parallel.

    .EXAMPLE
    Convert-EasitXMLToPsObject -Response $response

    .EXAMPLE
    Convert-EasitXMLToPsObject -Response $response -ThrottleLimit 10
    #>
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Convert-EasitXMLToPsObject.md")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$Response,
        [Parameter()]
        [int]$ThrottleLimit
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }

    process {
        if ($Response.Envelope.Body.Fault) {
            Write-Warning "$($Response.Envelope.Body.Fault.faultstring.innerText)"
            return
        }
        $unknownResponseType = $true
        if ($Response.Envelope.Body.GetItemsResponse) {
            Write-Verbose "XML contains GetItemsResponse"
            $unknownResponseType = $false
            if ($Response.Envelope.Body.GetItemsResponse.Items) {
                try {
                    Convert-GetItemsResponse -Response $Response -ThrottleLimit $ThrottleLimit
                } catch {
                    throw $_
                }
            } else {
                Write-Warning "View did not return any items or objects"
            }
        } 
        if ($Response.Envelope.Body.ImportItemsResponse) {
            Write-Verbose "XML contains ImportItemsResponse"
            $unknownResponseType = $false
            try {
                Convert-ImportItemsResponse -Response $Response
            } catch {
                throw $_
            }
        } 
        if ($Response.Envelope.Body.PingResponse) {
            Write-Verbose "XML contains PingResponse"
            $unknownResponseType = $false
            try {
                Convert-PingResponse -Response $Response
            } catch {
                throw $_
            }
        } 
        if ($unknownResponseType) {
            Write-Warning "Unknown response type as response does not contain GetItemsResponse, ImportItemsResponse or PingResponse element"
            return
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}