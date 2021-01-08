function Get-GOItems {
      [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Get-GOItems.md")]
      <#
      .EXTERNALHELP EasitGoWebservice-help.xml
      #>
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
