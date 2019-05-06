function Import-BPSAssetItem {
      <#
      .SYNOPSIS
            Send data to BPS with web services.
      .DESCRIPTION
            Update and create assets in Easit BPS. Returns ID for asset in Easit BPS.
            Specify 'ID' to update an existing asset.

            Copyright 2018 Easit AB
      .EXAMPLE
            Import-BPSAssetItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateAssetGeneral_v1 -AssetName "Test" -SerialNumber "SN-467952" -Description "One general asset." -Status "Active" -Verbose -ShowDetails
      .EXAMPLE
            Import-BPSAssetItem -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ihi CreateAssetServer_v1 -AssetStartDate "2018-06-26" -InternalMemory "32" -HardriveSize "500" -Status "Active"
      .EXAMPLE
            Import-BPSAssetItem -url http://localhost/webservice/ -api 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -ImportHandlerIdentifier CreateAssetPC_v1 -ID "45" -OperatingSystem "Windows 10" -Status "Inactive"
      .EXAMPLE
            Import-BPSAssetItem -url $url -apikey $api -ihi $identifier -ID "156" -Status "Inactive"
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER ImportHandlerIdentifier
            ImportHandler to import data with. Default = CreateAssetGeneral_v1
      .PARAMETER ID
            ID for asset in BPS.
      .PARAMETER AssetType
            Type of asset.
      .PARAMETER AssetInvoicingPeriod
            Invoicing period for asset.
      .PARAMETER AssetSupplierOrganizationID
            ID of organization to be set as supplier of asset.
      .PARAMETER Impact
            Impact of asset.
      .PARAMETER Manufacturer
            Manufacturer of asset.
      .PARAMETER OwnerContactID
            ID of contact to be set as owner of asset.
      .PARAMETER OwnerOrganizationID
            ID of organization to be set as owner of asset.
      .PARAMETER PriceListConnectionID
            ID of price list to connect with asset.
      .PARAMETER Status
            Status for asset.
      .PARAMETER CityLocation
            Location (City) of asset.
      .PARAMETER HouseLocation
            Location (House) of asset.
      .PARAMETER FinLifteTime
            Financial lifte time of asset.
      .PARAMETER LifeCycle
            Life cycle of asset.
      .PARAMETER ActivityDebit
            Activity debit for asset.
      .PARAMETER AssetName
            Name of asset.
      .PARAMETER AssetStartDate
            Contract start date for asset. Format = yyyy-MM-dd
      .PARAMETER BarCode
            Bar code for asset.
      .PARAMETER CIReference
            Reference ID for asset.
      .PARAMETER Description
            Description of asset.
      .PARAMETER FinancialNotes
            Financial notes for asset.
      .PARAMETER LastInventoryDate
            Last inventory date of asset. Format = yyyy-MM-dd
      .PARAMETER ObjectDebit
            Object debit for asset.
      .PARAMETER ProjectDebit
            Project debit for asset.
      .PARAMETER PurchaseDate
            Date of purchase of asset. Format = yyyy-MM-dd
      .PARAMETER PurchaseOrderNumber
            Purchase order number of asset.
      .PARAMETER PurchaseValueCurrency
            Purchase value of asset.
      .PARAMETER RoomLocation
            Location (Room) of asset.
      .PARAMETER SerialNumber
            Serial number for asset.
      .PARAMETER SupplierInvoiceId
            ID of invoice from supplier.
      .PARAMETER TheftId
            Theft ID for asset.
      .PARAMETER WarrantyExpireDate
            Date for when warranty of asset expires. Format = yyyy-MM-dd
      .PARAMETER ModelMonitor
            Model of monitor.
      .PARAMETER MonitorType
            Type of monitor.
      .PARAMETER MonitorSize
            Size of monitor.
      .PARAMETER MonitorResolution
            Resolution of monitor.
      .PARAMETER ConectionType_Monitor
            Conection type of monitor.
      .PARAMETER OperatingSystem
            Operating system for asset.
      .PARAMETER Equipment
            Equipment of asset.
      .PARAMETER ModelPC
            Model of PC/Computer.
      .PARAMETER ComputerType
            Type of PC/Computer.
      .PARAMETER HardriveSize
            Hardrive size of asset.
      .PARAMETER InternalMemory
            Internal memory of asset.
      .PARAMETER ProcessorSpeed
            Processor speed of asset.
      .PARAMETER SLA
            Service level agreement of asset. Valid values = true / false.
      .PARAMETER SLAExpiredate
            Expire date for SLA of asset. Format: yyyy-MM-dd
      .PARAMETER UserLogin
            Username of person using asset.
      .PARAMETER UserPassword
            Password for person using asset.
      .PARAMETER AssetPhoneModel
            Model of phone.
      .PARAMETER AssetPhoneType
            Type of phone.
      .PARAMETER Operator
            Operator for phone.
      .PARAMETER IMEINumber
            IMEI number of phone.
      .PARAMETER MobilePhoneNumber
            Mobile phone number.
      .PARAMETER PhoneNumber
            Phone number.
      .PARAMETER PukCode
            PUK code for phone.
      .PARAMETER ModelPrinter
            Model of printer.
      .PARAMETER IPAdress
            IP address to printer.
      .PARAMETER MacAddress
            Printer mac address.
      .PARAMETER NetworkName
            Printer network name.
      .PARAMETER ModelServer
            Model of server.
      .PARAMETER DNSName
            Server DNS name.
      .PARAMETER ServiceBlackout
            Notes about when service is undergoing maintenance.
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
            [string] $ImportHandlerIdentifier = "CreateAssetGeneral_v1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Type")]
            [string] $AssetType,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("InvoicingPeriod")]
            [string] $AssetInvoicingPeriod,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("SupplierOrganizationID")]
            [int] $AssetSupplierOrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Impact,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Manufacturer,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OwnerContact")]
            [int] $OwnerContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OwnerOrganization")]
            [int] $OwnerOrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("PriceListConnection","PriceList")]
            [int] $PriceListConnectionID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("City")]
            [string] $CityLocation,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("House")]
            [string] $HouseLocation,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $FinLifteTime,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $LifeCycle,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ActivityDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Name")]
            [string] $AssetName,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("StartDate")]
            [string] $AssetStartDate,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $BarCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("CI")]
            [string] $CIReference,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Description,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $FinancialNotes,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $LastInventoryDate,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ObjectDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ProjectDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PurchaseDate,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PurchaseOrderNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PurchaseValueCurrency,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $RoomLocation,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $SerialNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $SupplierInvoiceId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $TheftId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $WarrantyExpireDate,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ModelMonitor,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $MonitorType,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $MonitorSize,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $MonitorResolution,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("ConectionTypeMonitor")]
            [string] $ConectionType_Monitor,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $OperatingSystem,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Equipment,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ModelPC,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ComputerType,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $HardriveSize,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $InternalMemory,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ProcessorSpeed,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $SLA,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $SLAExpiredate,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $UserLogin,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [SecureString] $UserPassword,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $AssetPhoneModel,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $AssetPhoneType,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Operator,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("IMEI")]
            [string] $IMEINumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $MobilePhoneNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PhoneNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("puk")]
            [string] $PukCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ModelPrinter,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("IP")]
            [string] $IPAdress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("MAC")]
            [string] $MacAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $NetworkName,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ModelServer,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DNSName,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ServiceBlackout,

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
            Write-Error 'Failed to get list of used parameters!'
            Write-Error "$_"
            Write-Verbose ""
            break
      }
      Write-Verbose 'Successfully collected list of used parameters'

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