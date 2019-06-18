function Import-GORequestItem {
      <#
      .SYNOPSIS
            Send data to BPS/GO with web services.
      .DESCRIPTION
            Update and create requests in Easit BPS/GO. Returns ID for item in Easit BPS/GO.
            Specify 'ID' to update an existing item.

      .NOTES
            Copyright 2019 Easit AB

            Licensed under the Apache License, Version 2.0 (the "License");
            you may not use this file except in compliance with the License.
            You may obtain a copy of the License at

                http://www.apache.org/licenses/LICENSE-2.0

            Unless required by applicable law or agreed to in writing, software
            distributed under the License is distributed on an "AS IS" BASIS,
            WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
            See the License for the specific language governing permissions and
            limitations under the License.

      .LINK
            https://github.com/easitab/powershell/blob/master/WebServices/Import-GORequestItem.ps1

      .EXAMPLE
            Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad -Verbose -ShowDetails
      .EXAMPLE
            Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad
      .EXAMPLE
            Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -ID "156" -Description "Testing2. Nytt test!"
      .EXAMPLE
            Import-GORequestItem -url $url -apikey $api -ihi $identifier -ID "156" -Description "Updating description for request 156"
      .PARAMETER url
            Address to BPS/GO webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS/GO.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateRequest
      .PARAMETER ID
            ID for request in BPS/GO. Existing item will be updated if provided.
      .PARAMETER ContactID
            ID of contact in BPS/GO. Can be found on the contact in BPS/GO.
      .PARAMETER OrganizationID
            ID for organization to which the contact belongs to. Can be found on the organization in BPS/GO.
      .PARAMETER Category
            Contacts category.
      .PARAMETER ManagerGroup
            Name of manager group
      .PARAMETER Manager
            Username or email of user that should be used as manager.
      .PARAMETER Type
            Name of type. Matches agains existing types.
      .PARAMETER Status
            Name of status. Matches agains existing statuses.
      .PARAMETER ParentItemID
            ID of parent item. Matches agains existing items.
      .PARAMETER Priority
            Priority for item. Matches agains existing priorities.
      .PARAMETER Description
            Description of request.
      .PARAMETER FaqKnowledgeResolutionText
            Solution for the request.
      .PARAMETER Subject
            Subject of request.
      .PARAMETER AssetsCollectionID
            ID of asset to connect to the request. Adds item to collection.
      .PARAMETER CausalField
            Closure cause.
      .PARAMETER ClosingCategory
            Closure category.
      .PARAMETER Impact
            Impact of request.
      .PARAMETER Owner
            Owner of request.
      .PARAMETER ReferenceContactID
            ID of reference contact. Can be found on the contact in BPS/GO.
      .PARAMETER ReferenceOrganizationID
            ID of reference organization. Can be found on the organization in BPS/GO.
      .PARAMETER ServiceID
            ID of article to connect with request. Can be found on the article in BPS/GO.
      .PARAMETER SLAID
            ID of contract to connect with request. Can be found on the contract in BPS/GO.
      .PARAMETER Urgency
            Urgency of request.
      .PARAMETER ClassificationID
            ID of classification to connect with request. Can be found on the classification in BPS/GO.
      .PARAMETER KnowledgebaseArticleID
            ID of knowledgebase article to connect with request. Can be found on the knowledgebase article in BPS/GO.
      .PARAMETER Attachment
            Full path to file to be included in payload.
      .PARAMETER ShowDetails
            If specified, the response, including ID, will be displayed to host.
      .PARAMETER dryRun
            If specified, payload will be save as payload.xml to your desktop instead of sent to BPS/GO.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('ihi')]
            [string] $ImportHandlerIdentifier = 'CreateRequest',

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Item','ItemID')]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $OrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ManagerGroup,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Manager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Type,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Parent')]
            [int] $ParentItemID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Priority,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Description,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Resolution','FAQ')]
            [string] $FaqKnowledgeResolutionText,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Subject,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Asset')]
            [int] $AssetsCollectionID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('ClosureCause')]
            [string] $CausalField,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ClosingCategory,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Impact,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Owner,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ReferenceContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ReferenceOrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Article')]
            [int] $ServiceID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('SLA')]
            [string] $SLAID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $Urgency,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Classification')]
            [int] $ClassificationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('KnowledgebaseArticle','KB')]
            [int] $KnowledgebaseArticleID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('CI')]
            [int] $CIID,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [int] $uid = "1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory=$false)]
            [switch] $dryRun,

            [parameter(Mandatory=$false)]
            [switch] $ShowDetails
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

      try {
            Write-Verbose "Collecting list of used parameters"
            $CommandName = $PSCmdlet.MyInvocation.InvocationName
            $ParameterList = (Get-Command -Name $commandName).Parameters.Values
            Write-Verbose "Successfully collected list of used parameters"
      } catch {
            Write-Error 'Failed to get list of used parameters!'
            Write-Error "$_"
            break
      }

      Write-Verbose "Starting loop for creating xml element for each parameter"
      foreach ($parameter in $parameterList) {
            Write-Verbose "Starting loop for $($parameter.Name)"
            $ParameterSetToMatch = 'BPSAttribute'
            $parameterSets = $parameter.ParameterSets.Keys
            if ($parameterSets -contains $ParameterSetToMatch) {
                  Write-Verbose "$($parameter.Name) is part of BPS parameter set"
                  $parDetails = Get-Variable -Name $parameter.Name
                  if ($parDetails.Value) {
                        Write-Verbose "$($parameter.Name) have a value"
                        Write-Verbose "Creating xml element for $($parameter.Name) and will try to append it to payload!"
                        if ($parDetails.Name -ne "Attachement") {
                              try {
                                    $parName = $parDetails.Name
                                    $parValue = $parDetails.Value
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
                        if ($parDetails.Name -eq "Attachment") {
                              try {
                                    $parName = $parDetails.Name
                                    $fileHeader = ""
                                    $separator = "\"
                                    $fileNametoHeader = $Attachment.Split($separator)
                                    $fileHeader = $fileNametoHeader[-1]
                                    $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$Attachment"))
                                    $envelopeItemAttachment = $payload.CreateElement("sch:Attachment","$xmlnsSch")
                                    $envelopeItemAttachment.SetAttribute('name',"$fileHeader")
                                    $envelopeItemAttachment.InnerText = $base64string
                                    $schItemToImport.AppendChild($envelopeItemAttachment) | Out-Null
                                    Write-Verbose "Added property $parName to payload!"
                              } catch {
                                    Write-Error "Failed to add property $parName in SOAP envelope!"
                                    Write-Error "$_"
                              }
                        }
                  } else {
                        Write-Verbose "$($parameter.Name) does not have a value!"
                  }
            } else {
                  Write-Verbose "$($parameter.Name) is not part of BPS parameter set!"
            } Write-Verbose "Loop for $($parameter.Name) reached end!"
      }
      Write-Verbose "Successfully updated property values in SOAP envelope for all parameters with input provided!"

      if ($dryRun) {
            Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS"
            $i = 1
            $currentUserProfile = [Environment]::GetEnvironmentVariable("USERPROFILE")
            $userProfileDesktop = "$currentUserProfile\Desktop"
            do {
                  $outputFileName = "payload_$i.xml"
                  if (Test-Path $userProfileDesktop\$outputFileName) {
                        $i++
                        Write-Host "$i"
                  }
            } until (!(Test-Path $userProfileDesktop\$outputFileName))
            if (!(Test-Path $userProfileDesktop\$outputFileName)) {
                  try {
                        $outputFileName = "payload_$i.xml"
                        $payload.Save("$userProfileDesktop\$outputFileName")
                        Write-Verbose "Saved payload to file, will now end!"
                        break
                  } catch {
                        Write-Error "Unable to save payload to file!"
                        Write-Error "$_"
                        break
                  }
            }
      }

      Write-Verbose "Creating header for web request!"
      try {
            $pair = "$($apikey): "
            $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
            $basicAuthValue = "Basic $encodedCreds"
            $headers = @{SOAPAction = ""; Authorization = $basicAuthValue}
            Write-Verbose "Header created for web request!"
      } catch {
            Write-Error "Failed to create header!"
            Write-Error "$_"
            break
      }
      Write-Verbose "Calling web service and using payload as input for Body parameter"
      try {
            $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
            Write-Verbose "Successfully connected to and imported data to BPS"
      } catch {
            Write-Error "Failed to connect to BPS!"
            Write-Error "$_"
            return $payload
      }
      New-Variable -Name functionout -
      [xml]$functionout = $r.Content
      Write-Verbose 'Casted content of reponse as [xml]$functionout'

      if ($ShowDetails) {
            $responseResult = $functionout.Envelope.Body.ImportItemsResponse.ImportItemResult.result
            $responseID = $functionout.Envelope.Body.ImportItemsResponse.ImportItemResult.ReturnValues.ReturnValue.InnerXml
            Write-Host "Result: $responseResult"
            Write-Host "ID for created item: $responseID"
      }
      Write-Verbose "Function complete!"
}