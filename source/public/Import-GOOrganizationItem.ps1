function Import-GOOrganizationItem {
      <#
      .SYNOPSIS
            Send data to BPS/GO with web services.
      .DESCRIPTION
            Update and create organization in Easit BPS/GO. Returns ID for item in Easit BPS/GO.
            Specify 'ID' to update an existing organization.

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
            https://github.com/easitab/EasitGoWebservice/blob/master/EasitGoWebservice/Import-BPSContactItem.ps1

      .EXAMPLE
            Import-GOOrganizationItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateOrganization_Internal -Name "IT and things" -ParentItemID "124" -CustomerNumber "1648752" -BusinessDebit "4687" -Country "Sverige" -Status "Active" -Verbose -ShowDetails
      .EXAMPLE
            Import-GOOrganizationItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ihi CreateOrganization_External -Name "Stuff and IT" -CustomerNumber "4678524" -BusinessDebit "1684" -AccountManager "account.manager@company.com" -MainContractID "85" -ServiceManager "username123"
      .EXAMPLE
            Import-GOOrganizationItem -url http://localhost/webservice/ -api a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateOrganization_Supplier -ID "467" -Category "Food" -Status "Active"
      .EXAMPLE
            Import-GOOrganizationItem -url $url -apikey $api -ihi $identifier -ID "156" -Status "Inactive"
      .PARAMETER url
            Address to BPS/GO webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS/GO.
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
            ID of organization in BPS/GO.
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
      .PARAMETER SSO
            Used if system is using SSO with IWA (Active Directory). Not need when using SAML2
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

            [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateOrganization_Internal",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Country,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Parent")]
            [int] $ParentItemID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Contract")]
            [string] $MainContractID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OrganizationID")]
            [string] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("UserName")]
            [string] $AnvNamn,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Verksamhetdebet")]
            [string] $BusinessDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Counterpart,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $CustomerNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Fax,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Password")]
            [string] $Losen,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Namn")]
            [string] $Name,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Anteckningar")]
            [string] $Notes,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("City")]
            [string] $Ort,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Telefon")]
            [string] $Phone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PostNummer,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Ansvardebet")]
            [string] $ResponsibilityDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $UtdelningsAdress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besoksadress")]
            [string] $VisitingAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besoksort")]
            [string] $VisitingCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besokspostnummer")]
            [string] $VisitingZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Webshop,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Webb","homepage")]
            [string] $Website,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Kundansvarig")]
            [string] $AccountManager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Serviceansvarig")]
            [string] $ServiceManager,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [int] $uid = "1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory=$false)]
            [switch] $SSO,

            [parameter(Mandatory=$false)]
            [switch] $dryRun,

            [parameter(Mandatory=$false)]
            [switch] $ShowDetails
      )

      try {
            Write-Verbose "Collecting list of used parameters.."
            $CommandName = $PSCmdlet.MyInvocation.InvocationName
            $ParameterList = (Get-Command -Name $commandName).Parameters.Values
            Write-Verbose "Successfully collected list of used parameters."
      } catch {
            Write-Error 'Failed to get list of used parameters!'
            Write-Error "$_"
            break
      }

      Write-Verbose "Starting loop for creating hashtable of parameter..."
      $params = [ordered]@{}
      foreach ($parameter in $parameterList) {
            Write-Verbose "Starting loop for $($parameter.Name)"
            $ParameterSetToMatch = 'BPSAttribute'
            $parameterSets = $parameter.ParameterSets.Keys
            if ($parameterSets -contains $ParameterSetToMatch) {
                  Write-Verbose "$($parameter.Name) is part of BPS parameter set!"
                  $parDetails = Get-Variable -Name $parameter.Name
                  if ($parDetails.Value) {
                        Write-Verbose "$($parameter.Name) have a value"
                        $parName = $parDetails.Name
                        $parValue = $parDetails.Value
                        $params.Add("$parName", "$parValue")
                  } else {
                        Write-Verbose "$($parameter.Name) does not have a value!"
                  }
            } else {
                  Write-Verbose "$($parameter.Name) is not part of BPS parameter set!"
            } Write-Verbose "Loop for $($parameter.Name) reached end!"
      }
      Write-Verbose "Successfully created hashtable of parameter!"
      $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $Params

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
      if ($SSO) {
            try {
                  Write-Verbose 'Using switch SSO. De facto UseDefaultCredentials for Invoke-WebRequest'
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers -UseDefaultCredentials
                  Write-Verbose "Successfully connected to and imported data to BPS"
            } catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      } else {
            try {
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
                  Write-Verbose "Successfully connected to and imported data to BPS"
            } catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      }
      
      New-Variable -Name functionout
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