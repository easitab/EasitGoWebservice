function Import-GOAssetItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = 'CreateAssetGeneral',

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [int] $ID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("Type")]
            [string] $AssetType,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("InvoicingPeriod")]
            [string] $AssetInvoicingPeriod,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("SupplierOrganizationID")]
            [int] $AssetSupplierOrganizationID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Impact,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Manufacturer,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("OwnerContact")]
            [int] $OwnerContactID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("OwnerOrganization")]
            [int] $OwnerOrganizationID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("PriceListConnection", "PriceList")]
            [int] $PriceListConnectionID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Status,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("City")]
            [string] $CityLocation,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("House")]
            [string] $HouseLocation,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FinLifteTime,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $LifeCycle,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ActivityDebit,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("Name")]
            [string] $AssetName,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("StartDate")]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $AssetStartDate,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $BarCode,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("CI")]
            [string] $CIReference,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Description,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FinancialNotes,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $LastInventoryDate,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ObjectDebit,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ProjectDebit,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $PurchaseDate,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $PurchaseOrderNumber,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $PurchaseValueCurrency,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $RoomLocation,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $SerialNumber,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $SupplierInvoiceId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $TheftId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $WarrantyExpireDate,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ModelMonitor,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MonitorType,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MonitorSize,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MonitorResolution,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("ConectionTypeMonitor")]
            [string] $ConectionType_Monitor,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $OperatingSystem,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Equipment,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ModelPC,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ComputerType,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [int] $HardriveSize,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [int] $InternalMemory,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ProcessorSpeed,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $SLA,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $SLAExpiredate,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $UserLogin,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [SecureString] $UserPassword,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $AssetPhoneModel,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $AssetPhoneType,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Operator,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("IMEI")]
            [string] $IMEINumber,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MobilePhoneNumber,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $PhoneNumber,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("puk")]
            [string] $PukCode,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ModelPrinter,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("IP")]
            [string] $IPAdress,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("MAC")]
            [string] $MacAddress,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $NetworkName,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ModelServer,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $DNSName,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ServiceBlackout,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [int] $uid = "1",

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory = $false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory = $false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
            try {
                  Write-Verbose "Collecting list of used parameters"
                  $CommandName = $PSCmdlet.MyInvocation.InvocationName
                  $ParameterList = (Get-Command -Name $commandName).Parameters.Values
                  Write-Verbose "Successfully collected list of used parameters"
            }
            catch {
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
                        Write-Verbose "$($parameter.Name) is part of BPS parameter set"
                        $parDetails = Get-Variable -Name $parameter.Name
                        if ($parDetails.Value) {
                              Write-Verbose "$($parameter.Name) have a value"
                              $parName = $parDetails.Name
                              $parValue = $parDetails.Value
                              $params.Add("$parName", "$parValue")
                        }
                        else {
                              Write-Verbose "$($parameter.Name) does not have a value!"
                        }
                  }
                  else {
                        Write-Verbose "$($parameter.Name) is not part of BPS parameter set!"
                  } Write-Verbose "Loop for $($parameter.Name) reached end!"
            }
            Write-Verbose "Successfully created hashtable of parameter!"
            try {
                  $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $Params
            } catch {
                  throw $_
            }
            if ($dryRun) {
                  Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS"
                  try {
                        Export-PayloadToFile -Payload $payload
                  } catch {
                        throw $_
                  }
                  break
            }
            $easitWebRequestParams = @{
                  Uri = "$url"
                  Apikey = "$apikey"
                  Body = $payload
            }
            if ($SSO) {
                  Write-Verbose "Adding UseDefaultCredentials to param hash"
                  $easitWebRequestParams.Add('UseDefaultCredentials',$true)
            }
            if ($UseBasicParsing) {
                  Write-Verbose "Adding UseBasicParsing to param hash"
                  $easitWebRequestParams.Add('UseBasicParsing',$true)
            }
            try {
                  Write-Verbose "Calling Invoke-EasitWebRequest"
                  $r = Invoke-EasitWebRequest @easitWebRequestParams
            }
            catch {
                  throw $_
            }
            try {
                  Write-Verbose "Converting response"
                  $returnObject = Convert-EasitXMLToPsObject -Response $r
            }
            catch {
                  throw $_
            }
            Write-Verbose "Returning converted response"
            return $returnObject
      }

      end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}