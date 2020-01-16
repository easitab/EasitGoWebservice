function Get-GOItems { 
      <# 
      .SYNOPSIS 
            Get data from BPS/GO with web services.
      .DESCRIPTION 
            Connects to BPS/GO Web service with url, apikey and view and returns response as xml.
            If used with variable as in examples below, the following properties can be found as follows:

            Current page: $bpsdata.Envelope.Body.GetItemsResponse.page
            Total number of pages in response: $bpsdata.Envelope.Body.GetItemsResponse.totalNumberOfPages
            Total number of items in response: $bpsdata.Envelope.Body.GetItemsResponse.totalNumberOfItems
            Items: $bpsdata.Envelope.Body.GetItemsResponse.Items
            Details about fields used in view: $bpsdata.Envelope.Body.GetItemsResponse.Columns.Column

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
            https://github.com/easitab/EasitGoWebservice/blob/master/EasitGoWebservice/Get-GOItems.ps1
      
      .EXAMPLE 
            $bpsdata = Get-GOItems -url http://localhost/test/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -view Incidents
      .EXAMPLE
            $bpsdata = Get-GOItems -url $url -apikey $api -view Incidents -page 1
      .EXAMPLE
            $bpsdata = Get-GOItems -url $url -apikey $api -view Incidents -page 1 -ColumnFilter 'Name,EQUALS,Extern organisation'
      .PARAMETER url
            Address to BPS/GO webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS/GO.
      .PARAMETER importViewIdentifier
            View to get data from.
      .PARAMETER sortOrder
            Order in which to sort data, Descending or Ascending. Default = Descending
      .PARAMETER sortField
            Field to sort data with. Default = Id
      .PARAMETER viewPageNumber
            Used to get data from specific page in view. Each page contains 25 items. Default = 1.
      .PARAMETER ColumnFilter
            Used to filter data. Example: ColumnName,comparator,value
            Valid comparator: EQUALS, NOT_EQUALS, IN, NOT_IN, GREATER_THAN, GREATER_THAN_OR_EQUALS, LESS_THAN, LESS_THAN_OR_EQUALS, LIKE, NOT_LIKE
      .PARAMETER SSO
            Used if system is using SSO with IWA (Active Directory). Not need when using SAML2
      #>
      [CmdletBinding()]
      param ( 
            [parameter(Mandatory=$false)]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true)]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$true)]
            [Alias("view")]
            [string] $importViewIdentifier,

            [parameter(Mandatory=$false)]
            [Alias("so")]
            [string] $sortOrder = "Descending",

            [parameter(Mandatory=$false)]
            [Alias("sf")]
            [string] $sortField = "Id",

            [parameter(Mandatory=$false)]
            [Alias("page")]
            [int] $viewPageNumber = 1,

            [parameter(Mandatory=$false)]
            [string[]] $ColumnFilter,

            [parameter(Mandatory=$false)]
            [switch] $SSO
      )
      ## TO DO
      # Remove all comments
      
      #$ivi = $importViewIdentifier
      #$so = $sortOrder
      #$sf = $sortField
      #$pc = $viewPageNumber

      Write-Verbose 'Setting authentication header'
      # basic authentucation
      $pair = "$($apikey): "
      $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
      $basicAuthValue = "Basic $encodedCreds"
      Write-Verbose 'Authentication header set'

      Write-Verbose 'Creating payload'

      $payload = New-XMLforEasit -Get -ItemViewIdentifier "$importViewIdentifier" -SortOrder "$sortOrder" -SortField "$sortField" -Page "$viewPageNumber" -ColumnFilter "$ColumnFilter"

#message payload from template
#$payload=@'
#<?xml version="1.0" encoding="utf-8"?>
#<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.easit.com/bps/schemas">
#    <soapenv:Header/>
#        <soapenv:Body>
#            <sch:GetItemsRequest>
#                <sch:ItemViewIdentifier>$ivi</sch:ItemViewIdentifier>
#                <sch:Page>$pc</sch:Page>
#                <sch:SortColumn order="$so">$sf</sch:SortColumn>
#                <!--<sch:ColumnFilter columnName="$cn" comparator="$comp">$cValue</sch:ColumnFilter>-->
#            </sch:GetItemsRequest>
#        </soapenv:Body>
#</soapenv:Envelope>
#'@
#      Write-Verbose 'Payload created'
#
#      Write-Verbose 'Replacing content in $payload with parameter input'
#      try {
#            $payload = $payload.Replace('$ivi', $ivi)
#            $payload = $payload.Replace('$pc', $pc)
#            $payload = $payload.Replace('$so', $so)
#            $payload = $payload.Replace('$sf', $sf)
#            if ($ColumnFilter) {
#                  $ColumnFilterArray = $ColumnFilter.Split(',')
#                  $ColumnFilterArray = $ColumnFilterArray.TrimStart()
#                  $payload = $payload.Replace('<!--', '')
#                  $payload = $payload.Replace('-->', '')
#                  $payload = $payload.Replace('$cn', $ColumnFilterArray[0])
#                  $payload = $payload.Replace('$comp', $ColumnFilterArray[1])
#                  $payload = $payload.Replace('$cValue', $ColumnFilterArray[2])
#                  Write-Verbose $payload
#            }
#      } catch {
#            Write-Error 'Failed to update payload'
#            Write-Error "$_"
#            return
#      }
#      Write-Verbose 'Done replacing content in $payload with parameter input'

      #Write-Verbose 'Casting $payload as [xml]$SOAP'
      #[xml]$SOAP = $payload

      Write-Verbose 'Setting headers'
      # HTTP headers
      $headers = @{SOAPAction = ""; Authorization = $basicAuthValue}
      Write-Verbose 'Headers set'

      # Calling web service 
      Write-Verbose 'Calling web service and using $SOAP as input for Body parameter'
      if ($SSO) {
            try {
                  Write-Verbose 'Using switch SSO. De facto UseDefaultCredentials for Invoke-WebRequest'
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers -UseDefaultCredentials
                  Write-Verbose "Successfully connected to and got data from BPS"
            } catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      } else {
            try {
                  $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
                  Write-Verbose "Successfully connected to and got data from BPS"
            } catch {
                  Write-Error "Failed to connect to BPS!"
                  Write-Error "$_"
                  return $payload
            }
      }
      
      New-Variable -Name functionout
      [xml]$functionout = $r.Content
      Write-Verbose 'Casted content of reponse as [xml]$functionout'

      return $functionout
}