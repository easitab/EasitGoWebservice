function Convert-PingResponse {
    <#
    .SYNOPSIS
    Converts PingResponse XML to PSCustomObject

    .DESCRIPTION
    The **Convert-PingResponse** converts an XML PingResponse from easitGO and Easit BPS to a PSCustomObject.
    
    Returned object will have at least these properties: Message and Timestamp.

    - item.Message = Pong!
    - item.Timestamp = Time of ping request

    .INPUTS
    XML

    .OUTPUTS
    PSCustomObject

    .PARAMETER Response
    Returned PingResponse XML from easitGO that should be converted.

    .EXAMPLE
    Convert-PingResponse -Response $Response

    #>
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Convert-PingResponse.md")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$Response
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $returnObject = New-Object PSCustomObject
        foreach ($pingProperty in $Response.Envelope.Body.PingResponse.GetEnumerator()) {
            $returnObject | Add-Member -MemberType Noteproperty -Name "$($pingProperty.name)" -Value "$($pingProperty.InnerText)"
        }
        $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}