function Get-GOItems {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false)]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory = $true)]
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
            [switch] $SSO
      )

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
      }
      else {
            Write-Verbose "Skipping ColumnFilter as it is null!"
      }
      ## End issue 6
      Write-Verbose 'Setting authentication header'
      # basic authentucation
      $pair = "$($apikey): "
      $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
      $basicAuthValue = "Basic $encodedCreds"
      Write-Verbose 'Authentication header set'

      Write-Verbose 'Creating payload'

      $payload = New-XMLforEasit -Get -ItemViewIdentifier "$importViewIdentifier" -SortOrder "$sortOrder" -SortField "$sortField" -Page "$viewPageNumber" -ColumnFilter "$ColumnFilter"

      if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
            Write-Verbose "Saving payload to ${Home}\Documents\payload.xml"
            $payload.Save("$Home\Documents\payload.xml")
      }
      Write-Verbose 'Setting headers'
      # HTTP headers
      $headers = @{SOAPAction = ""; Authorization = $basicAuthValue }
      Write-Verbose 'Headers set'

      # Calling web service
      Write-Verbose 'Calling web service and using $SOAP as input for Body parameter'
      if ($SSO) {
            try {
                  Write-Verbose 'Using switch SSO. De facto UseDefaultCredentials for Invoke-WebRequest'
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers -UseDefaultCredentials
                  Write-Verbose "Successfully connected to and got data from BPS"
            }
            catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      }
      else {
            try {
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
                  Write-Verbose "Successfully connected to and got data from BPS"
            }
            catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      }

      New-Variable -Name functionout
      [xml]$functionout = $r.Content
      try {
            $returnObjects = Convert-EasitXMLToPsObject -Response $functionout
      }
      catch {
            throw $_
      }
      $returnObjects
}