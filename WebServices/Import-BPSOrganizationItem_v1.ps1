function Import-BPSOrganizationItem {
      <#
      .SYNOPSIS
            Send data to BPS with web services.
      .DESCRIPTION
            Update and create organization in Easit BPS. Returns ID for item in Easit BPS.
            Specify 'ID' to update an existing organization.

            Copyright 2018 Easit AB
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateOrganization_Internal_v1 -Name "IT and things" -ParentItemID "124" -CustomerNumber "1648752" -BusinessDebit "4687" -Country "Sverige" -Status "Active" -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ihi CreateOrganization_External_v1 -Name "Stuff and IT" -CustomerNumber "4678524" -BusinessDebit "1684" -AccountManager "account.manager@company.com" -MainContractID "85" -ServiceManager "username123"
      .EXAMPLE
            Import-BPSOrganizationItem -url http://localhost/webservice/ -api 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateOrganization_Supplier_v1 -ID "467" -Category "Food" -Status "Active"
      .EXAMPLE
            Import-BPSOrganizationItem -url $url -apikey $api -ihi $identifier -ID "156" -Status "Inactive"
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateOrganization_Internal_v1
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
      .PARAMETER ShowDetails
            If specified, the response, including ID, will be displayed to host.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter API key for web service")]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateOrganization_Internal_v1",

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
            [Alias("External")]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Fax,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Password")]
            [string] $Losen,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
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

            [parameter(Mandatory=$false)]
            [switch] $ShowDetails
      )
      [xml]$payload=@'
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.easit.com/bps/schemas">
      <soapenv:Header/>
      <soapenv:Body>
            <sch:ImportItemsRequest>
                  <sch:ItemToImport id="1"></sch:ItemToImport>
            </sch:ImportItemsRequest>
      </soapenv:Body>
</soapenv:Envelope>
'@

      Write-Verbose "Creating xml element for importhandler"
      try {
            $envelopeImportHandlerIdentifier = $payload.CreateElement('sch:ImportHandlerIdentifier',"http://www.easit.com/bps/schemas")
            $envelopeImportHandlerIdentifier.InnerText = $ImportHandlerIdentifier
            $payload.Envelope.Body.ImportItemsRequest.AppendChild($envelopeImportHandlerIdentifier)
      } catch {
            Write-Error "Failed to create xml element for importhandler"
            Write-Error "$_"
            break
      }
      Write-Verbose "Successfully created and appended xml element for importhandler"

      Write-Verbose "Collecting list of used parameters"
      try {
            $CommandName = $PSCmdlet.MyInvocation.InvocationName
            $ParameterList = (Get-Command -Name $commandName).Parameters.Values
      } catch {
            Write-Error "Failed to get list of used parameters!"
            Write-Error "$_"
            break
      }
      Write-Verbose "Successfully collected list of used parameters"

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
                        try {
                              $parName = $parDetails.Name
                              $parValue = $parDetails.Value
                              $envelopeItemProperty = $payload.CreateElement('sch:Property',"http://www.easit.com/bps/schemas")
                              $envelopeItemProperty.SetAttribute('name', $parName)
                              $envelopeItemProperty.InnerText = $parValue
                              $payload.Envelope.Body.ImportItemsRequest.ItemToImport.AppendChild($envelopeItemProperty)
                              Write-Verbose "Added property $parName to payload!"
                        } catch {
                              Write-Error "Failed to add property $parName in SOAP envelope!"
                              Write-Error "$_"
                        }
                  } else {
                        Write-Verbose "$($parameter.Name) does not have a value!"
                  }
            } else {
                  Write-Verbose "$($parameter.Name) is not part of BPS parameter set!"
            } Write-Verbose "Loop for $($parameter.Name) reached end!"
      }
      Write-Verbose 'Successfully updated property values in SOAP envelope for all parameters with input provided!'

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