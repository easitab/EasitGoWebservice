function New-XMLforEasit {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false, Position=0, ParameterSetName="ping")]
        [switch] $Ping,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="get")]
        [switch] $Get,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $ItemViewIdentifier,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [int] $Page = 1,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $SortField,
        
        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $SortOrder,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string[]] $ColumnFilter,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="import")]
        [switch] $Import,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [string] $ImportHandlerIdentifier,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [hashtable] $Params
    )



    Write-Verbose "Defining xmlns:soapenv and xmlns:sch"
    $xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"
    $xmlnsSch = "http://www.easit.com/bps/schemas"

    try {
        Write-Verbose "Creating xml object for payload"
        $payload = New-Object xml
        [System.Xml.XmlDeclaration] $xmlDeclaration = $payload.CreateXmlDeclaration("1.0", "UTF-8", $null)
        $payload.AppendChild($xmlDeclaration) | Out-Null
    } catch {
        Write-Error "Failed to create xml object for payload"
        Write-Error "$_"
        break
    }

    try {
        Write-Verbose "Creating xml element for Envelope"
        $soapEnvEnvelope = $payload.CreateElement("soapenv:Envelope","$xmlnsSoapEnv")
        $soapEnvEnvelope.SetAttribute("xmlns:sch","$xmlnsSch")
        $payload.AppendChild($soapEnvEnvelope) | Out-Null
    } catch {
        Write-Error "Failed to create xml element for Envelope"
        Write-Error "$_"
        break
    }

    try {
        Write-Verbose "Creating xml element for Header"
        $soapEnvHeader = $payload.CreateElement('soapenv:Header',"$xmlnsSoapEnv")
        $soapEnvEnvelope.AppendChild($soapEnvHeader) | Out-Null
    } catch {
        Write-Error "Failed to create xml element for Header"
        Write-Error "$_"
        break
    }

    try {
        Write-Verbose "Creating xml element for Body"
        $soapEnvBody = $payload.CreateElement("soapenv:Body","$xmlnsSoapEnv")
        $soapEnvEnvelope.AppendChild($soapEnvBody) | Out-Null
    } catch {
        Write-Error "Failed to create xml element for Body"
        Write-Error "$_"
        break
    }


    if ($Import) {
        try {
            Write-Verbose "Creating xml element for ImportItemsRequest"
            $schImportItemsRequest = $payload.CreateElement("sch:ImportItemsRequest","$xmlnsSch")
            $soapEnvBody.AppendChild($schImportItemsRequest) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ImportItemsRequest"
            Write-Error "$_"
            break
        }
        try {
            Write-Verbose "Creating xml element for Importhandler"
            $envelopeImportHandlerIdentifier = $payload.CreateElement('sch:ImportHandlerIdentifier',"$xmlnsSch")
            $envelopeImportHandlerIdentifier.InnerText  = "$ImportHandlerIdentifier"
            $schImportItemsRequest.AppendChild($envelopeImportHandlerIdentifier) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Importhandler"
            Write-Error "$_"
            break
        }
    
        try {
            Write-Verbose "Creating xml element for ItemToImport"
            $schItemToImport = $payload.CreateElement("sch:ItemToImport","$xmlnsSch")
            $schItemToImport.SetAttribute("id","$uid")
            $schItemToImport.SetAttribute("uid","$uid")
            $schImportItemsRequest.AppendChild($schItemToImport) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ItemToImport"
            Write-Error "$_"
            break
        }
        Write-Verbose "Starting loop for creating xml element for each parameter"
        foreach ($parameter in $Params.GetEnumerator()) {
            Write-Verbose "Starting loop for $($parameter.Name) with value $($parameter.Value)"
            if ($parameter.Name -eq "Attachment") {
                try {
                    $parName = $parameter.Name
                    $parValue = $parameter.Value
                    $fileHeader = ""
                    $separator = "\"
                    $fileNametoHeader = $parValue.Split($separator)
                    $fileHeader = $fileNametoHeader[-1]
                    $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$parValue"))
                    $envelopeItemAttachment = $payload.CreateElement("sch:Attachment","$xmlnsSch")
                    $envelopeItemAttachment.SetAttribute('name',"$fileHeader")
                    $envelopeItemAttachment.InnerText = $base64string
                    $schItemToImport.AppendChild($envelopeItemAttachment) | Out-Null
                    Write-Verbose "Added property $parName to payload!"
                } catch {
                    Write-Error "Failed to add property $parName in SOAP envelope!"
                    Write-Error "$_"
                }
            } else {
                $parName = $parameter.Name
                $parValue = $parameter.Value
                try {
                    $envelopeItemProperty = $payload.CreateElement("sch:Property","$xmlnsSch")
                    $envelopeItemProperty.SetAttribute('name',"$parName")
                    $envelopeItemProperty.InnerText = $parValue
                    $schItemToImport.AppendChild($envelopeItemProperty) | Out-Null
                    Write-Verbose "Added property $parName to payload!"
                } catch {
                    Write-Error "Failed to add property $parName in SOAP envelope!"
                    Write-Error "$_"
                }
            }
        } Write-Verbose "Loop for $($parameter.Name) reached end!"
    }

    if ($Get) {
        try {
            Write-Verbose "Creating xml element for GetItemsRequest"
            $schGetItemsRequest = $payload.CreateElement("sch:GetItemsRequest","$xmlnsSch")
            $soapEnvBody.AppendChild($schGetItemsRequest) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for GetItemsRequest"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for ItemViewIdentifier"
            $envelopeItemViewIdentifier = $payload.CreateElement('sch:ItemViewIdentifier',"$xmlnsSch")
            $envelopeItemViewIdentifier.InnerText  = "$ItemViewIdentifier"
            $schGetItemsRequest.AppendChild($envelopeItemViewIdentifier) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ItemViewIdentifier"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for Page"
            $envelopePage = $payload.CreateElement('sch:Page',"$xmlnsSch")
            $envelopePage.InnerText  = "$Page"
            $schGetItemsRequest.AppendChild($envelopePage) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Page"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for SortColumn order"
            $envelopeSortColumnOrder = $payload.CreateElement('sch:SortColumn',"$xmlnsSch")
            $envelopeSortColumnOrder.SetAttribute("order","$SortOrder")
            $envelopeSortColumnOrder.InnerText  = "$SortField"
            $schGetItemsRequest.AppendChild($envelopeSortColumnOrder) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Page"
            Write-Error "$_"
            break
        }
        if ($ColumnFilter) {
            try {
                $ColumnFilterValues = $ColumnFilter -split ','
                [int]$ColumnFilterValuesCount = $ColumnFilterValues.Count
                $i=0
                do {
                    Write-Verbose "Creating xml element for Column filter"
                    $envelopeColumnFilter = $payload.CreateElement('sch:ColumnFilter',"$xmlnsSch")
                    $envelopeColumnFilter.SetAttribute("columnName","$uid")
                    $envelopeColumnFilter.SetAttribute("comparator","$uid")
                    $envelopeColumnFilter.InnerText  = "$ColumnFilter"
                    $schGetItemsRequest.AppendChild($envelopeColumnFilter) | Out-Null
                    $i+3
                } until ($i -le $ColumnFilterValuesCount)
            } catch {
                Write-Error "Failed to create xml element for Page"
                Write-Error "$_"
                break
            }
        } else {
            Write-Verbose "Skipping ColumnFilter as it is null!"
        }
    }

    if ($Ping) {
        try {
            Write-Verbose "Creating xml element for PingRequest"
            $envelopePingRequest = $payload.CreateElement('sch:PingRequest',"$xmlnsSch")
            $envelopePingRequest.InnerText  = '?'
            $soapEnvBody.AppendChild($envelopePingRequest) | Out-Null
      } catch {
            Write-Error "Failed to create xml element for PingRequest"
            Write-Error "$_"
            break
      }
    }
    
    Write-Verbose "Successfully updated property values in SOAP envelope for all parameters with input provided!"
    return $payload
}