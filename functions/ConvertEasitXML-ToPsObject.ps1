function ConvertEasitXML-ToPsObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$Item
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $items = $Item.Envelope.Body.GetItemsResponse.Items.ChildNodes
        foreach ($easitItem in $items) {
            $properties = $easitItem.ChildNodes | Group-Object { $_.Name }
            $values = [ordered]@{}
            foreach ($property in $properties) {
	            $xmlPropertyName = $property.name
                if($property.Count -gt 1){
                    [array]$propertyValueArray = @()
                    foreach($p in $property.Group){
                        [string]$propertyValueArray += $p.'#text'
                    }
                    $xmlPropertyValue = $propertyValueArray
                } else {
                    if($property.Group.rawValue -match "^\d+$"){
                        [int]$xmlPropertyValue = $property.Group.rawValue
                    }
                    elseif($property.Group.rawValue -match "^\d+\.\d+$"){
                        [decimal]$xmlPropertyValue = $property.Group.rawValue
                    }
                    else{
	                    [string]$xmlPropertyValue = $property.Group.'#text'
                    }
                }
                $values.set_item($xmlPropertyName, $xmlPropertyValue)
            }
            $returnObject = New-Object PSObject -Property $values
            #$easitItems += $returnObject
            $returnObject
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}