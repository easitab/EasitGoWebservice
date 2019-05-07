function Import-BPSContactItem {
      <#
      .SYNOPSIS
            Send data to BPS with web services.
      .DESCRIPTION
            Update and create contacts in Easit BPS. Returns ID for item in Easit BPS.
            Specify 'ID' to update an existing contact.

            Copyright 2018 Easit AB
      .NOTES
            Version 1.0
      .EXAMPLE
            Import-BPSContactItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateContact_v1 -OrganizationID "12" -Position "Manager" -Deparment "Support" -FirstName "Test" -Surname "Testsson" -Username "te12te" -SecId "97584621" -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSContactItem -url http://localhost:8080/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ihi CreateContact_v1 -ID "649" -Inactive "true"
      .EXAMPLE
            Import-BPSContactItem -url http://localhost/webservice/ -api 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateContact_v1 -ID "649" -Surname "Andersson" -Email "test.anders@company.com" -FQDN "$FQDN"
      .EXAMPLE
            Import-BPSContactItem -url $url -apikey $api -ihi $identifier -ID "156" -Inactive "false" -Responsible_Manager "true"
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateContact_v1
      .PARAMETER ID
            ID for contact in BPS.
      .PARAMETER FirstName
            First name of contact in BPS.
      .PARAMETER Surname
            Last name of contact in BPS.
      .PARAMETER OrganizationID
            ID for organization to which the contact belongs to. Can be found on the organization in BPS.
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
            [string] $ImportHandlerIdentifier = "CreateContact_v1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $FirstName,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Lastname")]
            [string] $Surname,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("mail")]
            [string] $Email,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $SecId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Organization","org")]
            [string] $OrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Position,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Manager")]
            [string] $ManagerID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Impact,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PreferredMethodForNotification,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Building,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Checkbox_Authorized_Purchaser,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Checkbox_Responsible_Manager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Deparment,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("External")]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $FQDN,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Inactive,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Mobile")]
            [string] $MobilePhone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Note,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Phone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Room,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Title,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Username,

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
      Write-Verbose "Successfully created xml element for importhandler"

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