function Ping-GOWebService {
      [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Ping-GOWebService.md")]
      <#
      .EXTERNALHELP EasitGoWebservice-help.xml
      #>
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
