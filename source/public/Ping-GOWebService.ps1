function Ping-GOWebService {
      <#
      .SYNOPSIS
            Ping BPS/GO web services.
      .DESCRIPTION
            Can be used to check if service is available and correct credentials have been provided..

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
            https://github.com/easitab/EasitGoWebservice/blob/master/EasitGoWebservice/Ping-GOWebService.ps1

      .EXAMPLE
            Ping-GOWebService -url http://localhost/test/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375
      .PARAMETER url
            Address to BPS/GO webservice. Default = http://localhost/webservice/
      .PARAMETER apikey
            API key for BPS/GO.
      #>
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false)]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true)]
            [Alias("api")]
            [string] $apikey
      )

      $payload = New-XMLforEasit -Ping

      Write-Verbose "Creating header for web request.."
      try {
            $pair = "$($apikey): "
            $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
            $basicAuthValue = "Basic $encodedCreds"
            $headers = @{SOAPAction = ""; Authorization = $basicAuthValue}
            Write-Verbose "Header created for web request."
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