function Get-GOItems {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false)]
            [string] $url,

            [parameter(Mandatory = $false)]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $true)]
            [Alias("view")]
            [string] $importViewIdentifier,

            [parameter(Mandatory = $false)]
            [Alias("so")]
            [string] $sortOrder = "Descending",

            [parameter(Mandatory = $false)]
            [Alias("sf")]
            [string] $sortField = "Id",

            [parameter(Mandatory = $false)]
            [Alias("page")]
            [int] $viewPageNumber = 1,

            [parameter(Mandatory = $false)]
            [string[]] $ColumnFilter,

            [parameter(Mandatory = $false)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

            [parameter(Mandatory = $false)]
            [switch] $dryRun,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory = $false)]
            [switch] $SSO
      )
      if (!($url) -or !($apikey)) {
            Write-Verbose "url or apikey NOT provided, checking for local configuration file"
            if ($ConfigurationFile) {
                  $localConfigPath = $ConfigurationFile
            } else {
                  $localConfigPath = $Home
            }
            try {
                  $wsConfig = Get-ConfigurationFile -Path $localConfigPath
            } catch {
                  throw $_
            }
            if ($wsConfig) {
                  if (!($url)) {
                        $url = $wsConfig.url
                  } else {
                        Write-Verbose "url provided via cmdlet parameter, using that"
                  }
                  if (!($apikey)) {
                        if ($wsConfig.apikey.Length -gt 0) {
                              $apikey = $wsConfig.apikey
                              Write-Verbose "Using apikey from local configuration file"
                        } else {
                              Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                              break
                        }
                  } else {
                        Write-Verbose "apikey provided via cmdlet parameter, using that"
                  }
            } else {
                  Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                  break
            }
      }
      $validComparators = 'EQUALS', 'NOT_EQUALS', 'IN', 'NOT_IN', 'GREATER_THAN', 'GREATER_THAN_OR_EQUALS', 'LESS_THAN', 'LESS_THAN_OR_EQUALS', 'LIKE', 'NOT_LIKE'
      ## Solution provided by Dennis Zakariasson <dennis.zakariasson@regionuppsala.se> thru issue 6
      function Test-ColumnFilter {
            [CmdletBinding()]
            param (
                  [parameter()]
                  [String]$Filter,
                  [parameter()]
                  [string[]]$FilterValues)

            if (!$filterValues[0] -or !$filterValues[1]) {
                  throw "Column or comparator has not been set in filter $filter!"
            }
            if ($FilterValues[1] -notin $validComparators) {
                  throw "Invalid comparator '$($FilterValues[1])' in filter $filter! For a list of valid comparators, run command 'Get-Help Get-GoItems -Parameter ColumnFilter'"
            }
      }
      $xmlParams = @{
            Get = $true
            ItemViewIdentifier = "$importViewIdentifier"
            SortOrder = "$sortOrder"
            SortField = "$sortField"
            Page = "$viewPageNumber"
      }
      if ($ColumnFilter) {
            Write-Verbose "Validating column filter.."
            Write-Verbose "ColumnFilter = $ColumnFilter"
            Write-Verbose "ColumnFilters = $($ColumnFilter.Count)"
            foreach ($filter in $ColumnFilter) {
                  try {
                        Write-Verbose $filter
                        $FilterValues = $filter -replace ', ', ',' -split ','
                        Test-ColumnFilter -Filter $filter -FilterValues $FilterValues
                  }
                  catch {
                        Write-Error "Failed to create xml element for Page"
                        Write-Error "$_"
                        return
                  }
            }
            $xmlParams.Add('ColumnFilter',"$ColumnFilter")
      }
      else {
            Write-Verbose "Skipping ColumnFilter as it is null!"
      }
      ## End issue 6
      Write-Verbose 'Creating payload'

      try {
            $payload = New-XMLforEasit @xmlParams
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
      $returnObject
}

function Import-GOAssetItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = 'CreateAssetGeneral',

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [Alias("configdir")]
            [string] $ConfigurationDirectory = $Home,

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
            if (!($url) -or !($apikey)) {
                  Write-Verbose "url or apikey NOT provided, checking for local configuration file"
                  if ($ConfigurationDirectory) {
                        $localConfigPath = $ConfigurationDirectory
                  } else {
                        $localConfigPath = $Home
                  }
                  try {
                        $wsConfig = Get-ConfigurationFile -Path $localConfigPath
                  } catch {
                        throw $_
                  }
                  if ($wsConfig) {
                        if (!($url)) {
                              $url = $wsConfig.url
                        } else {
                              Write-Verbose "url provided via cmdlet parameter, using that"
                        }
                        if (!($apikey)) {
                              if ($wsConfig.apikey.Length -gt 0) {
                                    $apikey = $wsConfig.apikey
                                    Write-Verbose "Using apikey from local configuration file"
                              } else {
                                    Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                                    break
                              }
                        } else {
                              Write-Verbose "apikey provided via cmdlet parameter, using that"
                        }
                  } else {
                        Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                        break
                  }
            }
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

function Import-GOContactItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateContact",

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FirstName,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Surname,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Email,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [int] $ID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $SecId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $OrganizationID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Category,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Position,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ManagerID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Impact,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $PreferredMethodForNotification,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Building,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Checkbox_Authorized_Purchaser,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Checkbox_Responsible_Manager,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Deparment,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ExternalId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FQDN,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Inactive,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MobilePhone,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Note,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Phone,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Room,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Title,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Username,

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
            if (!($url) -or !($apikey)) {
                  Write-Verbose "url or apikey NOT provided, checking for local configuration file"
                  if ($ConfigurationDirectory) {
                        $localConfigPath = $ConfigurationDirectory
                  } else {
                        $localConfigPath = $Home
                  }
                  try {
                        $wsConfig = Get-ConfigurationFile -Path $localConfigPath
                  } catch {
                        throw $_
                  }
                  if ($wsConfig) {
                        if (!($url)) {
                              $url = $wsConfig.url
                        } else {
                              Write-Verbose "url provided via cmdlet parameter, using that"
                        }
                        if (!($apikey)) {
                              if ($wsConfig.apikey.Length -gt 0) {
                                    $apikey = $wsConfig.apikey
                                    Write-Verbose "Using apikey from local configuration file"
                              } else {
                                    Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                                    break
                              }
                        } else {
                              Write-Verbose "apikey provided via cmdlet parameter, using that"
                        }
                  } else {
                        Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                        break
                  }
            }
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

function Import-GOCustomItem {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("uri")]
        [string] $url,

        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("api")]
        [string] $apikey,

        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("ihi")]
        [string] $ImportHandlerIdentifier,

        [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('configdir')]
        [string] $ConfigurationDirectory = $Home,

        [parameter(Mandatory = $true, ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
        [hashtable] $CustomProperties,

        [parameter(Mandatory = $false, ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
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
        if (!($url) -or !($apikey)) {
            Write-Verbose "url or apikey NOT provided, checking for local configuration file"
            if ($ConfigurationDirectory) {
                $localConfigPath = $ConfigurationDirectory
            } else {
                $localConfigPath = $Home
            }
            try {
                $wsConfig = Get-ConfigurationFile -Path $localConfigPath
            } catch {
                throw $_
            }
            if ($wsConfig) {
                if (!($url)) {
                    $url = $wsConfig.url
                } else {
                    Write-Verbose "url provided via cmdlet parameter, using that"
                }
                if (!($apikey)) {
                    if ($wsConfig.apikey.Length -gt 0) {
                        $apikey = $wsConfig.apikey
                        Write-Verbose "Using apikey from local configuration file"
                    } else {
                        Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                        break
                    }
                } else {
                    Write-Verbose "apikey provided via cmdlet parameter, using that"
                }
            } else {
                Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                break
            }
        }
        $params = [ordered]@{}
        foreach ($property in $CustomProperties.GetEnumerator()) {
            try {
                $propertyName = $property.Key
                $propertyValue = $parDetails.Value
                Write-Verbose "Adding $propertyName with the value $propertyValue"
                $params.Add("$propertyName", "$propertyValue")
            } catch {
                throw $_
            }
        }
        Write-Verbose "Generating payload"
        try {
            $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $params
            Write-Verbose "Successfully generated payload"
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
function Import-GOOrganizationItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateOrganization",

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

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

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
            if (!($url) -or !($apikey)) {
                  Write-Verbose "url or apikey NOT provided, checking for local configuration file"
                  if ($ConfigurationDirectory) {
                        $localConfigPath = $ConfigurationDirectory
                  } else {
                        $localConfigPath = $Home
                  }
                  try {
                        $wsConfig = Get-ConfigurationFile -Path $localConfigPath
                  } catch {
                        throw $_
                  }
                  if ($wsConfig) {
                        if (!($url)) {
                              $url = $wsConfig.url
                        } else {
                              Write-Verbose "url provided via cmdlet parameter, using that"
                        }
                        if (!($apikey)) {
                              if ($wsConfig.apikey.Length -gt 0) {
                                    $apikey = $wsConfig.apikey
                                    Write-Verbose "Using apikey from local configuration file"
                              } else {
                                    Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                                    break
                              }
                        } else {
                              Write-Verbose "apikey provided via cmdlet parameter, using that"
                        }
                  } else {
                        Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                        break
                  }
            }
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

function Import-GORequestItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('ihi')]
            [string] $ImportHandlerIdentifier = 'CreateRequest',

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

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
            [string] $Urgency,

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
            [string]$DeliveryInformation,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('ApprovedBy')]
            [int] $ApprovedByID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Approval,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ProductsAndServices,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Message,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $DesiredDelivery,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $PlannedDelivery,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Workaround,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ImpactAssessment,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ResourceRequirement,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Cause,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $LifeCycle,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $TypeOfChange,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $CategoryOfChange,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory=$false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
            if (!($url) -or !($apikey)) {
                  Write-Verbose "url or apikey NOT provided, checking for local configuration file"
                  if ($ConfigurationDirectory) {
                        $localConfigPath = $ConfigurationDirectory
                  } else {
                        $localConfigPath = $Home
                  }
                  try {
                        $wsConfig = Get-ConfigurationFile -Path $localConfigPath
                  } catch {
                        throw $_
                  }
                  if ($wsConfig) {
                        if (!($url)) {
                              $url = $wsConfig.url
                        } else {
                              Write-Verbose "url provided via cmdlet parameter, using that"
                        }
                        if (!($apikey)) {
                              if ($wsConfig.apikey.Length -gt 0) {
                                    $apikey = $wsConfig.apikey
                                    Write-Verbose "Using apikey from local configuration file"
                              } else {
                                    Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                                    break
                              }
                        } else {
                              Write-Verbose "apikey provided via cmdlet parameter, using that"
                        }
                  } else {
                        Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                        break
                  }
            }
            try {
                  Write-Verbose "Collecting list of used parameters."
                  $CommandName = $PSCmdlet.MyInvocation.InvocationName
                  $ParameterList = (Get-Command -Name $commandName).Parameters.Values
                  Write-Verbose "Successfully collected list of used parameters"
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
                        Write-Verbose "$($parameter.Name) is part of BPS parameter set"
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

function Ping-GOWebService {
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false)]
            [string] $url,

            [parameter(Mandatory=$false)]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $false)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

            [parameter(Mandatory=$false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      if (!($url) -or !($apikey)) {
            Write-Verbose "url or apikey NOT provided, checking for local configuration file"
            if ($ConfigurationDirectory) {
                  $localConfigPath = $ConfigurationDirectory
            } else {
                  $localConfigPath = $Home
            }
            try {
                  $wsConfig = Get-ConfigurationFile -Path $localConfigPath
            } catch {
                  throw $_
            }
            if ($wsConfig) {
                  if (!($url)) {
                        $url = $wsConfig.url
                  } else {
                        Write-Verbose "url provided via cmdlet parameter, using that"
                  }
                  if (!($apikey)) {
                        if ($wsConfig.apikey.Length -gt 0) {
                              $apikey = $wsConfig.apikey
                              Write-Verbose "Using apikey from local configuration file"
                        } else {
                              Write-Warning "You need to provide an apikey, either via cmdlet parameters OR local configuration file."
                              break
                        }
                  } else {
                        Write-Verbose "apikey provided via cmdlet parameter, using that"
                  }
            } else {
                  Write-Warning "You need to provide an url and apikey, either via cmdlet parameters OR local configuration file. If url is not provided it defaults to http://localhost/webservice/"
                  break
            }
      }
      try {
            $payload = New-XMLforEasit -Ping
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

function Convert-EasitXMLToPsObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [xml]$Response
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }

    process {
        $returnItem = New-Object PSObject
        if ($Response.Envelope.Body.GetItemsResponse) {
            Write-Verbose "XML contains GetItemsResponse"
            $returnItem | Add-Member -MemberType Noteproperty -Name "requestedPage" -Value "$($Response.Envelope.Body.GetItemsResponse.requestedPage)"
            $returnItem | Add-Member -MemberType Noteproperty -Name "totalNumberOfPages" -Value "$($Response.Envelope.Body.GetItemsResponse.totalNumberOfPages)"
            $returnItem | Add-Member -MemberType Noteproperty -Name "totalNumberOfItems" -Value "$($Response.Envelope.Body.GetItemsResponse.totalNumberOfItems)"
            foreach ($column in $Response.Envelope.Body.GetItemsResponse.Columns.GetEnumerator()) {
                Write-Verbose "Adding property $($column.InnerText) as Noteproperty to object"
                try {
                    $returnItem | Add-Member -MemberType Noteproperty -Name "$($column.InnerText)" -Value $null -ErrorAction 'Stop'
                } catch [System.InvalidOperationException] {
                    Write-Warning "$($column.InnerText) is used two times in the importViewIdentifier specified, this could be due to duplicates of the same field or that two fields have the same name. The value from the latest occurance will be used!"
                }
            }
            foreach ($item in $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator()) {
                foreach ($itemProperty in $item.GetEnumerator()) {
                    $itemPropertyName = "$($itemProperty.Name)"
                    Write-Verbose "itemPropertyName = $itemPropertyName"
                    $itemPropertyValue = "$($itemProperty.InnerText)"
                    Write-Verbose "itemPropertyValue = $itemPropertyValue"
                    Write-Verbose "Setting $itemPropertyName to $itemPropertyValue"
                    $returnItem."$itemPropertyName" = "$itemPropertyValue"
                    if ("$($itemProperty.InnerText)" -match ' \/ ') {
                        Write-Verbose "$($itemProperty.InnerText) -match '/'"
                        $tempPropertyValues = @()
                        $tempPropertyValues = $itemProperty.InnerText -split ' / '
                        Write-Verbose "tempPropertyValue with slashes = $tempPropertyValues"
                        $count = 1
                        foreach ($tempPropertyValue in $tempPropertyValues) {
                            Write-Verbose "${propertyName}_${count} = $tempPropertyValue"
                            if ("$($itemProperty.rawValue)" -notmatch 'null') {
                                Write-Verbose "Adding ${itemPropertyName}_${count} with value $tempPropertyValue"
                                $returnItem | Add-Member -MemberType Noteproperty -Name "${itemPropertyName}_${count}" -Value "$tempPropertyValue"
                            }
                            $count++
                        }
                        $returnItem."$itemPropertyName" = "customArrayList"
                    }
                }
                $returnItem
            }
        } elseif ($Response.Envelope.Body.ImportItemsResponse) {
            Write-Verbose "XML contains ImportItemsResponse"
            $importItemResult = "$($Response.Envelope.Body.ImportItemsResponse.ImportItemResult.result)"
            $returnItem | Add-Member -MemberType Noteproperty -Name "ImportItemResult" -Value "$importItemResult"
            foreach ($returnValue in $Response.Envelope.Body.ImportItemsResponse.ImportItemResult.ReturnValues.GetEnumerator()) {
                Write-Verbose "Name = $($returnValue.name)"
                Write-Verbose "Value = $($returnValue.InnerText)"
                $returnItem | Add-Member -MemberType Noteproperty -Name "$($returnValue.name)" -Value "$($returnValue.InnerText)"
            }
            $returnItem
        } elseif ($Response.Envelope.Body.PingResponse) {
            Write-Verbose "XML contains PingResponse"
            foreach ($pingProperty in $Response.Envelope.Body.PingResponse.GetEnumerator()) {
                $returnItem | Add-Member -MemberType Noteproperty -Name "$($pingProperty.name)" -Value "$($pingProperty.InnerText)"
            }
            $returnItem
        } else {
            throw "Do not know what to do with XML.."
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}

function Export-PayloadToFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [xml]$Payload
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $InformationPreference = 'Continue'
    }

    process {
        $i = 1
        $userProfileDesktop = Join-Path -Path $HOME -ChildPath 'Desktop'
        do {
            $outputFileName = "payload_$i.xml"
            $payloadFile = Join-Path -Path $userProfileDesktop -ChildPath "$outputFileName"
            if (Test-Path $payloadFile) {
                    $i++
                    Write-Verbose "$i"
            }
        } until (!(Test-Path $payloadFile))
        if (!(Test-Path $payloadFile)) {
            try {
                    $Payload.Save("$payloadFile")
                    Write-Information "Saved payload to file ($payloadFile), will now end!"
            }
            catch {
                    throw $_
            }
        }
    }

    end {
        $InformationPreference = 'SilentlyContinue'
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}
function Get-ConfigurationFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }

    process {
        $configFilePath = Join-Path "$Path" -ChildPath 'easitWS.properties'
        if (Test-Path $configFilePath) {
            Write-Verbose "Found local configuration file"
            try {
                $easitWSConfig = Get-Content -Raw -Path $configFilePath -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            } catch {
                throw $_
            }
            Write-Verbose "Retrieved local configuration file"
            if ($easitWSConfig.url.Length -gt 0) {
                Write-Verbose "Using url from local configuration file, $($easitWSConfig.url)"
            } else {
                Write-Verbose "Using url default, http://localhost/webservice/"
                $easitWSConfig.url = 'http://localhost/webservice/'
            }
        } else {
            Write-Warning "Unable to locate configuration file"
            $easitWSConfig = $false
        }
        return $easitWSConfig
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Invoke-EasitWebRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Uri,
        [Parameter(Mandatory)]
        [String] $Apikey,
        [Parameter()]
        [String] $Method = 'POST',
        [Parameter()]
        [String] $ContentType = 'text/xml',
        [Parameter(Mandatory)]
        [xml] $Body,
        [Parameter()]
        [Switch] $UseDefaultCredentials,
        [Parameter()]
        [Switch] $UseBasicParsing
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $ProgressPreference = 'SilentlyContinue'
    }

    process {
        Write-Verbose "Creating header for web request"
        try {
            $pair = "$($Apikey): "
            $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
            $basicAuthValue = "Basic $encodedCreds"
            $headers = @{SOAPAction = ""; Authorization = $basicAuthValue }
            Write-Verbose "Header created for web request"
        }
        catch {
            Write-Error "Failed to create header"
            Write-Error "$_"
            break
        }
        $webRequestParams = @{
            Uri = $Uri
            Method = $Method
            ContentType = $ContentType
            Body = $Body
            Headers = $Headers
        }
        if ($UseBasicParsing) {
            Write-Verbose "Adding UseBasicParsing to webRequestParams"
            $webRequestParams.Add('UseBasicParsing', $true)
        }
        if ($UseDefaultCredentials) {
            Write-Verbose "Adding UseDefaultCredentials to webRequestParams"
            $webRequestParams.Add('UseDefaultCredentials', $true)
        }
        Write-Verbose "Calling web service.."
        $httpResponse = try {
            ($requestResponse = Invoke-WebRequest @webRequestParams -ErrorAction Stop).BaseResponse
            Write-Verbose "Successfully connected to and imported data"
        } catch [System.Net.WebException] {
            Write-Verbose "StatusCode = $($_.Exception.Response.StatusDescription)"
            if ($_.Exception.Response.StatusDescription -eq 404) {
                $dets = "url"
            }
            if ($_.Exception.Response.StatusDescription -eq 500) {
                $dets = "apikey, ImportHandlerIdentifier/importViewIdentifier and properties for the items/object in payload"
                $addHelp = "You can try running $((Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name) with -dryRun to save payload to your desktop (${HOME}\Desktop\payload_x.xml)."
            }
            throw "An exception was caught: $($_.Exception.Message). Please check so that $dets are correct. $addHelp"
        }
        [xml]$returnObject = $requestResponse.Content
        return $returnObject
    }
    end {
        $ProgressPreference = 'Continue'
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-XMLforEasit {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false, Position=0, ParameterSetName="ping")]
        [switch] $Ping,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="get")]
        [switch] $Get,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $ItemViewIdentifier,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [int] $Page = 1,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $SortField,

        [Parameter(Mandatory=$true, ParameterSetName="get")]
        [string] $SortOrder,

        [Parameter(Mandatory=$false, ParameterSetName="get")]
        [string[]] $ColumnFilter,

        [parameter(Mandatory=$false, Position=0, ParameterSetName="import")]
        [switch] $Import,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [string] $ImportHandlerIdentifier,

        [Parameter(Mandatory=$true, ParameterSetName="import")]
        [hashtable] $Params
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
        Write-Error "Failed to create xml object for payload.."
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


    if ($Import) {
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
        Write-Verbose "Starting loop for creating xml element for each parameter"
        foreach ($parameter in $Params.GetEnumerator()) {
            Write-Verbose "Starting loop for $($parameter.Name) with value $($parameter.Value)"
            if ($parameter.Name -eq "Attachment") {
                try {
                    $parName = $parameter.Name
                    $parValue = $parameter.Value
                    $fileHeader = ""
                    $separator = "\"
                    $fileNametoHeader = $parValue.Split($separator)
                    $fileHeader = $fileNametoHeader[-1]
                    $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$parValue"))
                    $envelopeItemAttachment = $payload.CreateElement("sch:Attachment","$xmlnsSch")
                    $envelopeItemAttachment.SetAttribute('name',"$fileHeader")
                    $envelopeItemAttachment.InnerText = $base64string
                    $schItemToImport.AppendChild($envelopeItemAttachment) | Out-Null
                    Write-Verbose "Added property $parName to payload!"
                } catch {
                    Write-Error "Failed to add property $parName in SOAP envelope!"
                    Write-Error "$_"
                }
            } else {
                $parName = $parameter.Name
                $parValue = $parameter.Value
                try {
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
        } Write-Verbose "Loop for $($parameter.Name) reached end!"
    }

    if ($Get) {
        try {
            Write-Verbose "Creating xml element for GetItemsRequest"
            $schGetItemsRequest = $payload.CreateElement("sch:GetItemsRequest","$xmlnsSch")
            $soapEnvBody.AppendChild($schGetItemsRequest) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for GetItemsRequest"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for ItemViewIdentifier"
            $envelopeItemViewIdentifier = $payload.CreateElement('sch:ItemViewIdentifier',"$xmlnsSch")
            $envelopeItemViewIdentifier.InnerText  = "$ItemViewIdentifier"
            $schGetItemsRequest.AppendChild($envelopeItemViewIdentifier) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ItemViewIdentifier"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for Page"
            $envelopePage = $payload.CreateElement('sch:Page',"$xmlnsSch")
            $envelopePage.InnerText  = "$Page"
            $schGetItemsRequest.AppendChild($envelopePage) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Page"
            Write-Error "$_"
            break
        }

        try {
            Write-Verbose "Creating xml element for SortColumn order"
            $envelopeSortColumnOrder = $payload.CreateElement('sch:SortColumn',"$xmlnsSch")
            $envelopeSortColumnOrder.SetAttribute("order","$SortOrder")
            $envelopeSortColumnOrder.InnerText  = "$SortField"
            $schGetItemsRequest.AppendChild($envelopeSortColumnOrder) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Page"
            Write-Error "$_"
            break
        }
        ## Solution provided by Dennis Zakariasson <dennis.zakariasson@regionuppsala.se> thru issue 5
        if ($ColumnFilter) {
            Write-Verbose "Creating xml element for Column filter"
            $Filters = $ColumnFilter -split ' '
            Write-Verbose "Filters = $Filters"
            Write-Verbose "Number of filters = $($Filters.Count)"
            foreach ($filter in $Filters) {
                try {
                    Write-Verbose "filter = $filter"
                    $ColumnFilterValues = $filter -split ','
                    $envelopeColumnFilter = $payload.CreateElement('sch:ColumnFilter',"$xmlnsSch")
                    Write-Verbose "columnName = $($ColumnFilterValues[0])"
                    $envelopeColumnFilter.SetAttribute("columnName","$($ColumnFilterValues[0])")
                    $envelopeColumnFilter.SetAttribute("comparator","$($ColumnFilterValues[1])")
                    Write-Verbose "comparator = $($ColumnFilterValues[1])"
                    $envelopeColumnFilter.InnerText = "$($ColumnFilterValues[2])"
                    Write-Verbose "InnerText = $($ColumnFilterValues[2])"
                    $schGetItemsRequest.AppendChild($envelopeColumnFilter) | Out-Null
                } catch {
                    Write-Error "Failed to create xml element for ColumnFilter"
                    Write-Error "$_"
                    break
                }
            }
        } else {
            Write-Verbose "Skipping ColumnFilter as it is null!"
        }
        ## End issue 6
    }

    if ($Ping) {
        try {
            Write-Verbose "Creating xml element for PingRequest"
            $envelopePingRequest = $payload.CreateElement('sch:PingRequest',"$xmlnsSch")
            $envelopePingRequest.InnerText  = '?'
            $soapEnvBody.AppendChild($envelopePingRequest) | Out-Null
      } catch {
            Write-Error "Failed to create xml element for PingRequest"
            Write-Error "$_"
            break
      }
    }
    Write-Verbose "Successfully updated property values in SOAP envelope for all parameters with input provided!"
    return $payload
}
