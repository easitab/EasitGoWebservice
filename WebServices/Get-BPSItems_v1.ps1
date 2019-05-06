function Get-BPSItems {
      <#
      .SYNOPSIS
            Get data from BPS with web services.
      .DESCRIPTION
            Connects to BPS Web service with url, apikey and view and returns response as xml.
            If used with variable as in examples below, the following properties can be found as follows:

            Current page: $bpsdata.Envelope.Body.GetItemsResponse.page
            Total number of pages in response: $bpsdata.Envelope.Body.GetItemsResponse.totalNumberOfPages
            Total number of items in response: $bpsdata.Envelope.Body.GetItemsResponse.totalNumberOfItems
            Items: $bpsdata.Envelope.Body.GetItemsResponse.Items
            Details about fields used in view: $bpsdata.Envelope.Body.GetItemsResponse.Columns.Column

            Copyright 2018 Easit AB

      .EXAMPLE
            $bpsdata = Get-BPSItems -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375 -view Incidents_v1
      .EXAMPLE
            $bpsdata = Get-BPSItems -url $url -apikey $api -view Incidents_v1 -page 1
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      .PARAMETER importViewIdentifier
            View to get data from. Default = Incidents_v1
      .PARAMETER sortOrder
            Order in which to sort data, DESCENDING or ASCENDING. Default = DESCENDING
      .PARAMETER sortField
            Field to sort data with. Default = Id
      .PARAMETER viewPageNumber
            Used to get data from specific page in view. Each page contains 100 items. Default = 1.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("view")]
            [string] $importViewIdentifier = "Incidents_v1",

            [parameter(Mandatory=$false)]
            [Alias("so")]
            [string] $sortOrder = "DESCENDING",

            [parameter(Mandatory=$false)]
            [Alias("sf")]
            [string] $sortField = "Id",

            [parameter(Mandatory=$false)]
            [Alias("page")]
            [int] $viewPageNumber = 1
      )

      $ivi = $importViewIdentifier
      $so = $sortOrder
      $sf = $sortField
      $pc = $viewPageNumber

      Write-Verbose 'Setting authentication header'
      # basic authentucation
      $pair = "$($apikey): "
      $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
      $basicAuthValue = "Basic $encodedCreds"
      Write-Verbose 'Authentication header set'

      Write-Verbose 'Creating payload'
#message payload from template
$payload=@'
<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.easit.com/bps/schemas">
    <soapenv:Header/>
        <soapenv:Body>
            <sch:GetItemsRequest>
                <sch:ItemViewIdentifier>$ivi</sch:ItemViewIdentifier>
                <sch:Page>$pc</sch:Page>
                <sch:SortColumn order="$so">$sf</sch:SortColumn>
            </sch:GetItemsRequest>
        </soapenv:Body>
</soapenv:Envelope>
'@
      Write-Verbose 'Payload created'

      Write-Verbose 'Replacing content in $payload with parameter input'
      try {
            $payload = $payload.Replace('$ivi', $ivi)
            $payload = $payload.Replace('$pc', $pc)
            $payload = $payload.Replace('$so', $so)
            $payload = $payload.Replace('$sf', $sf)
      } catch {
            Write-Error 'Failed to update payload'
            Write-Error "$_"
            return
      }
      Write-Verbose 'Done replacing content in $payload with parameter input'

      Write-Verbose 'Casting $payload as [xml]$SOAP'
      [xml]$SOAP = $payload

      Write-Verbose 'Setting headers'
      $headers = @{SOAPAction = ""; Authorization = $basicAuthValue}
      Write-Verbose 'Headers set'

      Write-Verbose 'Calling web service and using $SOAP as input for Body parameter'
      try {
            $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $SOAP -Headers $headers
      } catch {
            Write-Error "Failed to connect to BPS!"
            Write-Error "$_"
            return
      }
      Write-Verbose 'Successfully connected to and recieved data from web service'
      [xml]$functionout = $r.Content
      Write-Verbose 'Casted content of reponse as [xml]$functionout'

      return $functionout
}