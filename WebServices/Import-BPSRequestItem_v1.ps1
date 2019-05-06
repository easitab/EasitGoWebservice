function Import-BPSRequestItem {
      <#
      .SYNOPSIS
            Send data to BPS with web services.
      .DESCRIPTION
            Update and create requests in Easit BPS. Returns ID for item in Easit BPS.
            Specify 'ID' to update an existing item.

            Copyright 2018 Easit AB
      .EXAMPLE
            Import-BPSRequestItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateRequest_v1 -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSRequestItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateRequest_v1 -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad
      .EXAMPLE
            Import-BPSRequestItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateRequest_v1 -ID "156" -Description "Testing2. Nytt test!"
      .EXAMPLE
            Import-BPSRequestItem -url $url -apikey $api -ihi $identifier -ID "156" -Description "Updating description for request 156"
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateRequest_v1
      .PARAMETER ID
            ID for request in BPS. Existing item will be updated if provided.
      .PARAMETER ContactID
            ID of contact in BPS. Can be found on the contact in BPS.
      .PARAMETER OrganizationID
            ID for organization to which the contact belongs to. Can be found on the organization in BPS.
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
            ID of reference contact. Can be found on the contact in BPS.
      .PARAMETER ReferenceOrganizationID
            ID of reference organization. Can be found on the organization in BPS.
      .PARAMETER ServiceID
            ID of article to connect with request. Can be found on the article in BPS.
      .PARAMETER SLAID
            ID of contract to connect with request. Can be found on the contract in BPS.
      .PARAMETER Urgency
            Urgency of request.
      .PARAMETER ClassificationID
            ID of classification to connect with request. Can be found on the classification in BPS.
      .PARAMETER KnowledgebaseArticleID
            ID of knowledgebase article to connect with request. Can be found on the knowledgebase article in BPS.
      .PARAMETER ShowDetails
            If specified, the response, including ID, will be displayed to host.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('uri')]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter API key for web service")]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('ihi')]
            [string] $ImportHandlerIdentifier = 'CreateRequest_v1',

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Item','ItemID')]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Contact')]
            [int] $ContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Organization')]
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
            [Alias("Parent")]
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