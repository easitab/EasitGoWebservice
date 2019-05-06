function Ping-BPSWebService {
      <#
      .SYNOPSIS
            Ping BPS web services.
      .DESCRIPTION
            Can be used to check if service is available and correct credentials have been provided.

            Copyright 2018 Easit AB
      .EXAMPLE
            Ping-BPSWebService -url http://localhost/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API-key for BPS.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Enter API key for web service")]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey
      )

      Write-Verbose 'Setting authentication header'
      # basic authentucation
      $pair = "$($apikey): "
      $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
      $basicAuthValue = "Basic $encodedCreds"
      Write-Verbose 'Authentication header set'

      Write-Verbose 'Creating payload'
[xml]$payload=@'
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sch="http://www.easit.com/bps/schemas">
   <soapenv:Header/>
   <soapenv:Body>
      <sch:PingRequest>?</sch:PingRequest>
   </soapenv:Body>
</soapenv:Envelope>
'@
      Write-Verbose 'Payload created'

      Write-Verbose 'Setting headers'
      # HTTP headers
      $headers = @{SOAPAction = ""; Authorization = $basicAuthValue}
      Write-Verbose 'Headers set'

      # Calling web service
      Write-Verbose 'Calling web service and using $SOAP as input for Body parameter'
      try {
            $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
      } catch {
            Write-Error "Failed to connect to BPS!"
            Write-Error "$_"
            return
      }
      Write-Verbose 'Successfully connected to and recieved data from web service'
      [xml]$functionout = $r.Content
      Write-Verbose 'Casted content of reponse as [xml]$functionout'
      Write-Verbose 'Returning $functionout.Envelope.Body.PingResponse.Message (Pong!)'
      return $functionout.Envelope.Body.PingResponse.Message
}