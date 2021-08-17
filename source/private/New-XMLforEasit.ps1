function New-XMLforEasit {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/New-XMLforEasit.md")]
    <#
    .EXTERNALHELP EasitGoWebservice-help.xml
    #>
    param (
        [parameter(Mandatory=$false, Position=0, ParameterSetName="ping")]
        [switch] $Ping,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="get")]
        [switch] $Get,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $ItemViewIdentifier,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [int] $Page = 1,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string] $SortField,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string] $SortOrder,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string[]] $ColumnFilter,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string] $IdFilter,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="import")]
        [switch] $Import,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [string] $ImportHandlerIdentifier,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [hashtable] $Params
    )
    begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        Write-Verbose "Defining xmlns:soapenv and xmlns:sch"
        $xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"
        $xmlnsSch = "http://www.easit.com/bps/schemas"

        try {
            Write-Verbose "Creating xml object for payload"
            $payload = New-Object xml
            [System.Xml.XmlDeclaration] $xmlDeclaration = $payload.CreateXmlDeclaration("1.0", "UTF-8", $null)
            $payload.AppendChild($xmlDeclaration) | Out-Null
        } catch {
            Write-Error "Failed to create xml object for payload.."
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
            } elseif ($parameter.Value.Count -gt 1) {
                
                foreach($p in $parameter.Value){
                    $parName = $parameter.Name
                    $parValue = $p
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
            if (!([string]::IsNullOrWhiteSpace($sortOrder))) {
                if ([string]::IsNullOrWhiteSpace($sortField)) {
                    Write-Warning "Please provide a sortField when using sortOrder"
                    break
                }
                if (!([string]::IsNullOrWhiteSpace($sortField))) {
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
                }
            }
            if ($ColumnFilter) {
                Write-Verbose "Creating xml element for Column filter"
                Write-Verbose "ColumnFilter = $ColumnFilter"
                $Filters = $ColumnFilter -replace '; ', ';' -split ';'
                Write-Verbose "Filters = $Filters"
                Write-Verbose "Number of filters = $($Filters.Count)"
                foreach ($filter in $Filters) {
                    try {
                        Write-Verbose "filter = $filter"
                        $ColumnFilterValues = $filter -split ','
                        $envelopeColumnFilter = $payload.CreateElement('sch:ColumnFilter',"$xmlnsSch")
                        Write-Verbose "columnName = $($ColumnFilterValues[0])"
                        $envelopeColumnFilter.SetAttribute("columnName","$($ColumnFilterValues[0])")
                        $columnFilterInnerText = "$($ColumnFilterValues[-1])"
                        Write-Verbose "columnFilterInnerText = $($ColumnFilterValues[-1])"
                        if ($ColumnFilterValues.Count -eq 4) {
                            $envelopeColumnFilter.SetAttribute("rawValue","$($ColumnFilterValues[1])")
                            Write-Verbose "rawValue = $($ColumnFilterValues[1])"
                            $envelopeColumnFilter.SetAttribute("comparator","$($ColumnFilterValues[2])")
                            Write-Verbose "comparator = $($ColumnFilterValues[2])"
                            
                            if ([string]::IsNullOrWhiteSpace($columnFilterInnerText)) {
                                $columnFilterInnerText = $false
                            }
                        } else {
                            $envelopeColumnFilter.SetAttribute("comparator","$($ColumnFilterValues[1])")
                            Write-Verbose "comparator = $($ColumnFilterValues[1])"
                        }
                        if (!($columnFilterInnerText)) {
                            $envelopeColumnFilter.InnerText = ""
                            Write-Verbose "InnerText = blank"
                        } else {
                            $envelopeColumnFilter.InnerText = "$($ColumnFilterValues[-1])"
                            Write-Verbose "InnerText = $($ColumnFilterValues[-1])"
                        }
                        
                        $schGetItemsRequest.AppendChild($envelopeColumnFilter) | Out-Null
                    } catch {
                        Write-Error "Failed to create xml element for ColumnFilter"
                        Write-Error "$_"
                        break
                    }
                }
            } else {
                Write-Verbose "Skipping ColumnFilter as it is null!"
            }
            ## End issue 6
            if (!([string]::IsNullOrWhiteSpace($IdFilter))) {
                try {
                    Write-Verbose "Creating xml element for Page"
                    $envelopePage = $payload.CreateElement('sch:IdFilter',"$xmlnsSch")
                    $envelopePage.InnerText  = "$IdFilter"
                    $schGetItemsRequest.AppendChild($envelopePage) | Out-Null
                } catch {
                    Write-Error "Failed to create xml element for Page"
                    Write-Error "$_"
                    break
                }
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
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
    Write-Verbose "Successfully updated property values in SOAP envelope for all parameters with input provided!"
    return $payload
}