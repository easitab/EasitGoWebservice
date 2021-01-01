function Ping-GOWebService {
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false)]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true)]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      try {
            $payload = New-XMLforEasit -Ping
      } catch {
            throw $_
      }
      if ($dryRun) {
            Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS"
            $i = 1
            $currentUserProfile = [Environment]::GetEnvironmentVariable("USERPROFILE")
            $userProfileDesktop = Join-Path -Path $currentUserProfile -ChildPath 'Desktop'
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
                        $payload.Save("$payloadFile")
                        Write-Verbose "Saved payload to file, will now end!"
                        break
                  }
                  catch {
                        throw $_
                  }
            }
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