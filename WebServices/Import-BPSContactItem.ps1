function Import-BPSContactItem {
      <#
      .SYNOPSIS
            Send data to BPS/GO with web services.
      .DESCRIPTION
            Update and create contacts in Easit BPS/GO. Returns ID for item in Easit BPS/GO.
            Specify 'ID' to update an existing contact.

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
            https://github.com/easitab/powershell/blob/master/WebServices/Import-BPSContactItem.ps1

      .EXAMPLE
            Import-BPSContactItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateContact -OrganizationID "12" -Position "Manager" -Deparment "Support" -FirstName "Test" -Surname "Testsson" -Username "te12te" -SecId "97584621" -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSContactItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ihi CreateContact -ID "649" -Inactive "true"
      .EXAMPLE
            Import-BPSContactItem -url http://localhost/webservice/ -api a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateContact -ID "649" -Surname "Andersson" -Email "test.anders@company.com" -FQDN "$FQDN"
      .EXAMPLE
            Import-BPSContactItem -url $url -apikey $api -ihi $identifier -ID "156" -Inactive "false" -Responsible_Manager "true"
      .PARAMETER url
            Address to BPS/GO webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS/GO.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateContact
      .PARAMETER ID
            ID for contact in BPS/GO.
      .PARAMETER FirstName
            First name of contact in BPS/GO.
      .PARAMETER Surname
            Last name of contact in BPS/GO.
      .PARAMETER OrganizationID
            ID for organization to which the contact belongs to. Can be found on the organization in BPS/GO.
      .PARAMETER Category
            Contacts category.
      .PARAMETER Position
            Contacts position.
      .PARAMETER ManagerID
            ID of contact that should be used as Manager.
      .PARAMETER Impact
            Contacts impact level. 1. Minor, 2. Medium or 3. Major.
      .PARAMETER PreferredMethodForNotification
            Contacts preferred method for notification. Mail or Telephone.
      .PARAMETER Building
            Buildning that the contact is located in.
      .PARAMETER Checkbox_Authorized_Purchaser
            Can be set to true or false.
      .PARAMETER Checkbox_Responsible_Manager
            Can be set to true or false.
      .PARAMETER Deparment
            Department to which the contact belongs.
      .PARAMETER Email
            Contacts email.
      .PARAMETER ExternalId
            Contacts external id.
      .PARAMETER FQDN
            Contacts fully qualified domain name.
      .PARAMETER Inactive
            Used to set contact as inactive. Can be set to true or false.
      .PARAMETER MobilePhone
            Contacts mobilephone.
      .PARAMETER Note
            Notes regarding contact.
      .PARAMETER Phone
            Contacts phone.
      .PARAMETER Room
            Room in which contact is located.
      .PARAMETER SecId
            Contacts security id.
      .PARAMETER Title
            Contact title, eg CEO.
      .PARAMETER Username
            Contacts username.
      .PARAMETER Attachment
            Full path to file to be included in payload.
      .PARAMETER ShowDetails
            If specified, the response, including ID, will be displayed to host.
      .PARAMETER dryRun
            If specified, payload will be save as payload.xml to your desktop instead of sent to BPS.
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
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateContact",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("FirstName")]
            [string] $FirstName,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Surname")]
            [string] $Surname,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Email")]
            [string] $Email,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ID")]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("SecId")]
            [string] $SecId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OrganizationID")]
            [string] $OrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Category")]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Position")]
            [string] $Position,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ManagerID")]
            [string] $ManagerID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Impact")]
            [string] $Impact,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("PreferredMethodForNotification")]
            [string] $PreferredMethodForNotification,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Building")]
            [string] $Building,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Checkbox_Authorized_Purchaser")]
            [string] $Checkbox_Authorized_Purchaser,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Checkbox_Responsible_Manager")]
            [string] $Checkbox_Responsible_Manager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Deparment")]
            [string] $Deparment,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ExternalId")]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("FQDN")]
            [string] $FQDN,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Inactive")]
            [string] $Inactive,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("MobilePhone")]
            [string] $MobilePhone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Note")]
            [string] $Note,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Phone")]
            [string] $Phone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Room")]
            [string] $Room,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Title")]
            [string] $Title,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Username")]
            [string] $Username,

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
            $schItemToImport.SetAttribute("id","$uid") | Out-Null
            $schItemToImport.SetAttribute("uid","$uid") | Out-Null
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
                        if ($parDetails.Name -ne "FileAttachement") {
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
                                    $base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FileAttachement))
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