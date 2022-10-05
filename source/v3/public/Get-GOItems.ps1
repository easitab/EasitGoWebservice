function Get-GOItems {
      <#
      .SYNOPSIS
      Get data from Easit BPS / Easit GO with web services.

      .DESCRIPTION
      Connects to Easit BPS / Easit GO web service with url, apikey and view and returns each item as an objects.<br>
      If the view specified to get items from contains two or more fields with the same name, the value from the latest field will be used.<br>
      All returning objects will have these properties requestedPage, totalNumberOfPages and totalNumberOfItems beyond the once provided by the importViewIdentifier.<br>

      .INPUTS
      None. You cannot pipe input to this cmdlet.

      .OUTPUTS
      PSCustomObject

      .PARAMETER apikey
      API-key for Easit BPS / Easit GO.

      .PARAMETER ColumnFilter
      Used to filter data.<br>
      Example: ColumnName,comparator,value<br>
      Valid comparator: EQUALS, NOT_EQUALS, IN, NOT_IN, GREATER_THAN, GREATER_THAN_OR_EQUALS, LESS_THAN, LESS_THAN_OR_EQUALS, LIKE, NOT_LIKE<br>

      .PARAMETER ConfigurationDirectory
      Path to directory where the configuration file for the web service is.

      .PARAMETER dryRun
      If specified, payload will be save as payload_1.xml (or next available number) to your desktop instead of sent to Easit BPS / Easit GO. This parameter does not append, rewrite or remove any files from your desktop.

      .PARAMETER IdFilter
      Database id for item to get.

      .PARAMETER importViewIdentifier
      View to get data from.

      .PARAMETER sortField
      Field to sort data with.

      .PARAMETER sortOrder
      Order in which to sort data, Descending or Ascending.

      .PARAMETER SSO
      Used if system is using SSO with IWA (Active Directory). Not needed when using SSO with SAML2.
      Function will use the credentials of the current user to send the web request.

      .PARAMETER ThrottleLimit
      Specifies the number of items to process in parallel.

      .PARAMETER url
      URL to Easit BPS / Easit GO web service.

      .PARAMETER UseBasicParsing
      This parameter is required when Internet Explorer is not installed on the computers, such as on a Server Core installation of a Windows Server operating system.

      .PARAMETER viewPageNumber
      Used to get data from specific page in view. Each page contains 25 items.

      .EXAMPLE
      Get-GOItems -url 'http://localhost/test/webservice/' -apikey '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375' -view 'Request'

      In this example we are requesting items from a webservice view named 'Request'.

      .EXAMPLE
      $url = 'http://localhost/test/webservice/'
      $api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
      Get-GOItems -url "$url" -apikey "$api" -view 'RequestsProblems' -page 2

      In this example we are requesting items from page 2 in the webservice view named 'RequestsProblems'.<br>
      Url and apikey are supplied with variables.

      .EXAMPLE
      $getGoItemsParams = @{
            url = 'http://localhost/test/webservice/'
            api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
            view = 'RequestServiceRequests'
            ColumnFilter = 'Name,EQUALS,Extern organisation'
      }
      Get-GOItems @getGoItemsParams

      In this example we use a technique called splatting and are requesting items from a webservice view named 'RequestServiceRequests' where 'Name' is 'Extern organisation'.

      .EXAMPLE
      $getGoItemsParams = @{
            url = 'http://localhost/test/webservice/'
            api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
            view = 'RequestIncidents'
            sortOrder = 'Ascending'
      }
      Get-GOItems @getGoItemsParams -ColumnFilter "Status,IN,Registrerad", "Prioritet,IN,5"

      In this example we are are requesting items from a webservice view named 'RequestIncidents'. We only ask for items where 'Status' is 'Registrerad' and 'Prioritet' is '5'. We also specify that the items should be sorted in 'Ascending' order.

      .EXAMPLE
      $getGoItemsParams = @{
            view = 'RequestIncidents'
            sortOrder = 'Ascending'
      }
      Get-GOItems @getGoItemsParams -ColumnFilter "Status,IN,Registrerad", "Prioritet,IN,5"

      In this example we have a configuration file located in our users home directory with the url and apikey.

      .EXAMPLE
      $getGoItemsParams = @{
            view = 'RequestIncidents'
            sortOrder = 'Ascending'
      }
      Get-GOItems @getGoItemsParams -ColumnFilter "Status,159:5,IN,", "Prioritet,753:1,IN,"

      In this example we use the databaseId for 'Status' and 'Prioritet' to filter the items returned.
      #>
      [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Get-GOItems.md")]
      param (
            [parameter()]
            [string] $url,

            [parameter()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory)]
            [Alias("view")]
            [string] $importViewIdentifier,

            [parameter()]
            [Alias("so")]
            [string] $sortOrder,

            [parameter()]
            [Alias("sf")]
            [string] $sortField,

            [parameter()]
            [Alias("page")]
            [int] $viewPageNumber = 1,

            [parameter()]
            [string[]] $ColumnFilter,

            [parameter()]
            [string] $IdFilter,

            [parameter()]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

            [parameter()]
            [switch] $dryRun,

            [parameter()]
            [switch] $UseBasicParsing,

            [parameter()]
            [switch] $SSO,
            
            [Parameter()]
            [int]$ThrottleLimit = 5
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
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
            $xmlParams = @{
                  Get = $true
                  ItemViewIdentifier = "$importViewIdentifier"
                  Page = "$viewPageNumber"
            }
            if (!([string]::IsNullOrWhiteSpace($sortOrder))) {
                  $xmlParams.Add('SortOrder',"$sortOrder")
                  if ([string]::IsNullOrWhiteSpace($sortField)) {
                        Write-Warning "Please provide a sortField when using sortOrder"
                        break
                  }
            }
            if (!([string]::IsNullOrWhiteSpace($sortField))) {
                  $xmlParams.Add('SortField',"$sortField")
            }
            if ($ColumnFilter) {
                  Write-Verbose "Validating column filter.."
                  Write-Verbose "ColumnFilter = $ColumnFilter"
                  Write-Verbose "ColumnFilters = $($ColumnFilter.Count)"
                  $filterCounter = 1
                  $numberOfFilters = $ColumnFilter.Count
                  $checkedColumnFilter = @()
                  foreach ($filter in $ColumnFilter) {
                        try {
                              Write-Verbose "Testing filter: $filter"
                              $FilterValues = $filter -replace ', ', ',' -split ','
                              Test-ColumnFilter -Filter $filter -FilterValues $FilterValues
                        }
                        catch {
                              Write-Error "$_"
                              return
                        }
                        if ($filterCounter -lt $numberOfFilters) {
                              $checkedColumnFilter += "$filter;"
                        } else {
                              $checkedColumnFilter += "$filter"
                        }
                        $filterCounter++
                  }
                  $xmlParams.Add('ColumnFilter',"$checkedColumnFilter")
            }
            else {
                  Write-Verbose "Skipping ColumnFilter as it is null!"
            }
            if ($IdFilter) {
                  $xmlParams.Add('IdFilter',"$IdFilter")
            } else {
                  Write-Verbose "Skipping IdFilter as it is null!"
            }
            Write-Verbose 'Creating payload'

            try {
                  $payload = New-XMLforEasit @xmlParams
            } catch {
                  throw $_
            }
            if ($dryRun) {
                  Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it"
                  try {
                        Export-PayloadToFile -Payload $payload
                  } catch {
                        throw $_
                  }
            } else {
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
                  } catch {
                        throw $_
                  }
                  try {
                        Write-Verbose "Converting response"
                        $returnObject = Convert-EasitXMLToPsObject -Response $r -ThrottleLimit $ThrottleLimit
                  } catch {
                        throw $_
                  }
                  Write-Verbose "Returning converted response"
                  $returnObject
            }
      }
      end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}
