function Convert-ImportItemsResponse {
    <#
    .SYNOPSIS
    Converts ImportItemsResponse XML to PSCustomObject

    .DESCRIPTION
    The **Convert-ImportItemsResponse** converts an XML ImportItemsResponse from easitGO and Easit BPS to a PSCustomObject.

    Each ReturnValues element in *response.Envelope.Body.ImportItemsResponse.ImportItemResult* will be added as a property to the object.

    If present in the response, the returned object will also have these two properties: result and uid.


    The *result* property hold the value of the attribute *result* from the element *response.Envelope.Body.ImportItemsResponse.ImportItemResult*
    
    The *uid* property hold the value of the attribute *UID* from the element *response.Envelope.Body.ImportItemsResponse.ImportItemResult*

    .INPUTS
    XML

    .OUTPUTS
    PSCustomObject

    .PARAMETER Response
    Returned ImportItemsResponse XML from easitGO that should be converted.

    .EXAMPLE
    Convert-ImportItemsResponse -Response $Response

    #>
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Convert-ImportItemsResponse.md")]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$Response
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if (!($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.result)) {
            Write-Warning "Unable to get result from response"
            return
        }
        $returnObject = New-Object PSCustomObject
        try {
            $returnObject | Add-Member -MemberType Noteproperty -Name "result" -Value "$($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.result)"
        } catch {
            throw $_
        }
        if (!($null = $Response.Envelope.Body.ImportItemsResponse.ImportItemResult.UID)) {
            try {
                $returnObject | Add-Member -MemberType Noteproperty -Name "uid" -Value "$($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.UID)"
            } catch {
                throw $_
            }
        }
        if ($returnObject.result -eq 'Exception') {
            Write-Verbose "An exception was returned from the webservice"
            Write-Warning "$($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.SkippedOrExceptionMessage)"
            return $returnObject
        }
        $returnObject | Add-Member -MemberType Noteproperty -Name "ImportItemResult" -Value "$importItemResult"
        if ($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.ReturnValues) {
            foreach ($returnValue in $Response.Envelope.Body.ImportItemsResponse.ImportItemResult.ReturnValues.GetEnumerator()) {
                Write-Verbose "Name = $($returnValue.name)"
                Write-Verbose "Value = $($returnValue.InnerText)"
                $returnObject | Add-Member -MemberType Noteproperty -Name "$($returnValue.name)" -Value "$($returnValue.InnerText)"
            }
        }
        $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}