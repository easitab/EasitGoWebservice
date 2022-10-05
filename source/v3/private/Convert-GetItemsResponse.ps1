function Convert-GetItemsResponse {
    <#
    .SYNOPSIS
    Converts GetItemsResponse XML to PSCustomObjects

    .DESCRIPTION
    The **Convert-GetItemsResponse** converts an XML GetItemsResponse from easitGO and Easit BPS to PSCustomObjects.

    Each item in *response.Envelope.Body.GetItemsResponse.Items* will be returned as a PSCustomObject with each *Column* from *response.Envelope.Body.GetItemsResponse.Columns* as an property.

    
    Each returned object will have the following additional properties, *requestedPage*, *totalNumberOfPages*, *totalNumberOfPages*.

    These properties are genereric response attributes from the *response.Envelope.Body.GetItemsResponse* element.


    Since each property / field from easitGO holds more data than just its value each property is a hashtable with the following keys: value, rawValue.

    In addition there is a corresponding property called [propertyname]_details that holds additional data such as datatype, collection, connectiontype.

    These *detail properties* are not visible by default but can be accessed via $item.PSObject.Properties property.
    

    Returned object structure:
    - item = PSCustomObject
    - item.property = Hashtable or array of hashtables
    - item.property_details = Hashtable

    .INPUTS
    XML

    .OUTPUTS
    PSCustomObject

    .PARAMETER Response
    Returned GetItemsResponse XML from easitGO that should be converted.

    .PARAMETER ThrottleLimit
    Specifies the number of items to process in parallel.

    .EXAMPLE
    Convert-GetItemsResponse -Response $Response -ThrottleLimit 5

    .EXAMPLE
    Convert-GetItemsResponse -Response $Response -ThrottleLimit 10
    
    #>
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Convert-GetItemsResponse.md")]
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
        $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator() | ForEach-Object -Parallel {
            $returnObject = New-Object PSCustomObject
            $xmlResponse = $using:Response
            try {
                $returnObject | Add-Member -MemberType NoteProperty -Name "requestedPage" -Value "$($xmlResponse.Envelope.Body.GetItemsResponse.requestedPage)"
                $returnObject | Add-Member -MemberType NoteProperty -Name "totalNumberOfPages" -Value "$($xmlResponse.Envelope.Body.GetItemsResponse.totalNumberOfPages)"
                $returnObject | Add-Member -MemberType NoteProperty -Name "totalNumberOfItems" -Value "$($xmlResponse.Envelope.Body.GetItemsResponse.totalNumberOfItems)"
                $returnObject | Add-Member -MemberType NoteProperty -Name "databaseId" -Value "$($_.id)"
            } catch {
                throw $_
            }
            foreach ($column in $xmlResponse.Envelope.Body.GetItemsResponse.Columns.GetEnumerator()) {
                $columnName = $column.InnerText
                $columnDetails = @{
                    Name = $column.InnerText
                    DataType = $column.datatype
                    ConnectionType = $column.connectiontype
                    IsArray = $false
                }
                if ($column.collection -eq 'true') {
                    $columnDetails.Add('IsCollection',$true)
                } else {
                    $columnDetails.Add('IsCollection',$false)
                }
                if (Get-Member -InputObject $returnObject -Name $columnName) {
                    if (!($returnObject."$columnName" -is 'System.Array')) {
                        $tempArray = @()
                        $returnObject."$columnName" = $tempArray
                    }
                } else {
                    if ($columnDetails.IsCollection) {
                        try {
                            $tempArray = @()
                            $returnObject | Add-Member -MemberType NoteProperty -Name $columnName -Value $tempArray
                        } catch {
                            throw $_
                        }
                    } else {
                        try {
                            $returnObject | Add-Member -MemberType NoteProperty -Name $columnName -Value $null
                        } catch {
                            throw $_
                        }
                    }
                    [string[]]$visible += $columnDetails.Name
                }
                if (Get-Member -InputObject $returnObject -Name "${columnName}_details") {
                    if ($returnObject."${columnName}_details" -is 'System.Array') {
                        $columnDetails.IsArray = $true
                        $returnObject."${columnName}_details" += $columnDetails
                    } else {
                        $tempColumnDetails = $returnObject."${columnName}_details"
                        $tempColumnDetails.IsArray = $true
                        $tempArray = @()
                        $returnObject."${columnName}_details" = $tempArray
                        $returnObject."${columnName}_details" += $tempColumnDetails
                        $returnObject."${columnName}_details" += $columnDetails
                    }
                } else {
                    try {
                        $returnObject | Add-Member -MemberType NoteProperty -Name "${columnName}_details" -Value $columnDetails
                    } catch {
                        throw $_
                    }
                }
            }
            foreach ($itemProperty in $_.GetEnumerator()) {
                $itemPropertyName = "$($itemProperty.Name)"
                $propertyDetails = $returnObject."${itemPropertyName}_details"
                $propertyHash = @{
                    value = $itemProperty.InnerText
                    rawValue = $itemProperty.rawValue
                }
                if ($propertyDetails.IsArray -or $propertyDetails.IsCollection) {
                    Write-Debug "Property $itemPropertyName is an array"
                    $returnObject."$itemPropertyName" += $propertyHash
                } else {
                    Write-Debug "Property $itemPropertyName is not an array"
                    $returnObject."$itemPropertyName" = $propertyHash
                }
            }
            try {
                $type = 'DefaultDisplayPropertySet'
                [Management.Automation.PSMemberInfo[]]$info = New-Object System.Management.Automation.PSPropertySet($type,$visible)
                Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $info -InputObject $returnObject
            } catch {
                throw $_
            }
            $returnObject
        } -ThrottleLimit $ThrottleLimit
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}