function Import-BPSOrganizationItem {
      <#
      .SYNOPSIS
            Send data to BPS with web services.
      .DESCRIPTION
            Update and create organization in Easit BPS. Returns ID for item in Easit BPS.
            Specify 'ID' to update an existing organization.

            Copyright 2019 Easit AB
      .NOTES
            Version 2.0
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateOrganization_Internal -Name "IT and things" -ParentItemID "124" -CustomerNumber "1648752" -BusinessDebit "4687" -Country "Sverige" -Status "Active" -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ihi CreateOrganization_External -Name "Stuff and IT" -CustomerNumber "4678524" -BusinessDebit "1684" -AccountManager "account.manager@company.com" -MainContractID "85" -ServiceManager "username123"
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -api a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateOrganization_Supplier -ID "467" -Category "Food" -Status "Active"
      .EXAMPLE
            Import-BPSOrganizationItem -url $url -apikey $api -ihi $identifier -ID "156" -Status "Inactive"
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateOrganization_Internal
      .PARAMETER Country
            Country that organization is located in or belongs to.
      .PARAMETER Category
            Category of organization.
      .PARAMETER Status
            Status of organization.
      .PARAMETER ParentItemID
            ID of parent organisation to organization.
      .PARAMETER MainContractID
            ID of main contract that organization is connected to.
      .PARAMETER ID
            ID of organization in BPS.
      .PARAMETER AnvNamn
            Username at organization.
      .PARAMETER BusinessDebit
            BusinessDebit for organization.
      .PARAMETER Counterpart
            Counterpart for organization.
      .PARAMETER CustomerNumber
            Organization customer number
      .PARAMETER DeliveryAddress
            Delivery address for organization.
      .PARAMETER DeliveryCity
            Delivery city for organization (Leveransadress).
      .PARAMETER DeliveryZipCode
            Delivery zip code for organization.
      .PARAMETER ExternalId
            External id for organization. Can be used as unique identifier for integrations with other systems.
      .PARAMETER Fax
            Fax number for organization.
      .PARAMETER Losen
            Password at organization website.
      .PARAMETER Name
            Name of organization.
      .PARAMETER Notes
            Notes for organization.
      .PARAMETER Ort
            City for organization.
      .PARAMETER Phone
            Phone number for organization.
      .PARAMETER PostNummer
            Postal number for organization.
      .PARAMETER ResponsibilityDebit
            Responsibility debit for organization.
      .PARAMETER UtdelningsAdress
            Delivery address for organization (Utdelningsadress).
      .PARAMETER VisitingAddress
            Visiting address for organization.
      .PARAMETER VisitingCity
            Visiting city for organization.
      .PARAMETER VisitingZipCode
            Visiting zip code for organization.
      .PARAMETER Webshop
            URL to organizations webshop.
      .PARAMETER Website
            URL to organizations website.
      .PARAMETER AccountManager
            Email or username of user that should be used as AccountManager.
      .PARAMETER ServiceManager
            Email or username of user that should be used as ServiceManager.
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
            [string] $ImportHandlerIdentifier = "CreateOrganization_Internal",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Country")]
            [string] $Country,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Category")]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Status")]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Parent","ParentItemID")]
            [int] $ParentItemID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("MainContractID","Contract")]
            [string] $MainContractID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OrganizationID","ID")]
            [string] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("AnvNamn","UserName")]
            [string] $AnvNamn,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("BusinessDebit","Verksamhetdebet")]
            [string] $BusinessDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Counterpart")]
            [string] $Counterpart,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("CustomerNumber")]
            [string] $CustomerNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("DeliveryAddress")]
            [string] $DeliveryAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("DeliveryCity")]
            [string] $DeliveryCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("DeliveryZipCode")]
            [string] $DeliveryZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ExternalId")]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Fax")]
            [string] $Fax,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Losen","Password")]
            [string] $Losen,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Name","Namn")]
            [string] $Name,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Notes","Anteckningar")]
            [string] $Notes,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Ort","City")]
            [string] $Ort,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Phone","Telefon")]
            [string] $Phone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Postnummer")]
            [string] $PostNummer,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ResponsibilityDebit","Ansvardebet")]
            [string] $ResponsibilityDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("UtdelningsAdress")]
            [string] $UtdelningsAdress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("VisitingAddress","Besoksadress")]
            [string] $VisitingAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("VisitingCity","Besoksort")]
            [string] $VisitingCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("VisitingZipCode","Besokspostnummer")]
            [string] $VisitingZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Webshop")]
            [string] $Webshop,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Website","Webb","homepage")]
            [string] $Website,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("AccountManager","Kundansvarig")]
            [string] $AccountManager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ServiceManager","Serviceansvarig")]
            [string] $ServiceManager,

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