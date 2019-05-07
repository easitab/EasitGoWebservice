function Ping-BPSWebService {
      <#
      .SYNOPSIS
            Ping BPS web services.
      .DESCRIPTION
            Can be used to check if service is available and correct credentials have been provided.

            Copyright 2019 Easit AB
      .NOTES
            Version 2.0
      .EXAMPLE
            Ping-BPSWebService -url http://localhost:8180/test/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375
      .PARAMETER url
            Address to BPS webservice. Default = http://localhost:8080/webservice/
      .PARAMETER apikey
            API-key for BPS.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false)]
            [string] $url = "http://localhost:8080/webservice/",

            [parameter(Mandatory=$true)]
            [Alias("api")]
            [string] $apikey
      )

      Write-Verbose "Defining xmlns:soapenv and xmlns:sch"
      $xmlnsSoapEnv = "http://schemas.xmlsoap.org/soap/envelope/"
      $xmlnsSch = "http://www.easit.com/bps/schemas"

      try {
            Write-Verbose "Creating xml object for payload"
            $payload = New-Object xml
            [System.Xml.XmlDeclaration] $xmlDeclaration = $payload.CreateXmlDeclaration("1.0", "UTF-8", $null)
            $payload.AppendChild($xmlDeclaration)
      } catch {
            Write-Error "Failed to create xml object for payload"
            Write-Error "$_"
            break
      }

      try {
            Write-Verbose "Creating xml element for Envelope"
            $soapEnvEnvelope = $payload.CreateElement("soapenv:Envelope","$xmlnsSoapEnv")
            $soapEnvEnvelope.SetAttribute("xmlns:sch","$xmlnsSch")
            $payload.AppendChild($soapEnvEnvelope)
      } catch {
            Write-Error "Failed to create xml element for Envelope"
            Write-Error "$_"
            break
      }

      try {
            Write-Verbose "Creating xml element for Header"
            $soapEnvHeader = $payload.CreateElement('soapenv:Header',"$xmlnsSoapEnv")
            $soapEnvEnvelope.AppendChild($soapEnvHeader)
      } catch {
            Write-Error "Failed to create xml element for Header"
            Write-Error "$_"
            break
      }

      try {
            Write-Verbose "Creating xml element for Body"
            $soapEnvBody = $payload.CreateElement("soapenv:Body","$xmlnsSoapEnv")
            $soapEnvEnvelope.AppendChild($soapEnvBody)
      } catch {
            Write-Error "Failed to create xml element for Body"
            Write-Error "$_"
            break
      }

      try {
            Write-Verbose "Creating xml element for PingRequest"
            $envelopePingRequest = $payload.CreateElement('sch:PingRequest',"$xmlnsSch")
            $envelopePingRequest.InnerText  = '?'
            $soapEnvBody.AppendChild($envelopePingRequest)
      } catch {
            Write-Error "Failed to create xml element for PingRequest"
            Write-Error "$_"
            break
      }

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
      Write-Verbose "Calling web service"
      try {
            $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
            Write-Verbose "Successfully connected to web service"
      } catch {
            Write-Error "Failed to connect to BPS!"
            Write-Error "$_"
            return $payload
      }
      Write-Verbose 'Successfully connected to and recieved data from web service'
      [xml]$functionout = $r.Content
      Write-Verbose 'Casted content of reponse as [xml]$functionout'
      Write-Verbose 'Returning $functionout.Envelope.Body.PingResponse.Message (Pong!)'
      return $functionout.Envelope.Body.PingResponse.Message
}