function Import-GOContactItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateContact",

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FirstName,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Surname,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Email,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [int] $ID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $SecId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $OrganizationID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Category,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Position,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ManagerID,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Impact,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $PreferredMethodForNotification,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Building,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Checkbox_Authorized_Purchaser,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Checkbox_Responsible_Manager,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Deparment,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $ExternalId,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $FQDN,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Inactive,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $MobilePhone,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Note,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Phone,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Room,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Title,

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [string] $Username,

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [int] $uid = "1",

            [parameter(ParameterSetName = 'BPSAttribute', ValueFromPipelineByPropertyName = $true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory = $false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory = $false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
            try {
                  Write-Verbose "Collecting list of used parameters"
                  $CommandName = $PSCmdlet.MyInvocation.InvocationName
                  $ParameterList = (Get-Command -Name $commandName).Parameters.Values
                  Write-Verbose "Successfully collected list of used parameters"
            }
            catch {
                  Write-Error 'Failed to get list of used parameters!'
                  Write-Error "$_"
                  break
            }

            Write-Verbose "Starting loop for creating hashtable of parameter..."
            $params = [ordered]@{}
            foreach ($parameter in $parameterList) {
                  Write-Verbose "Starting loop for $($parameter.Name)"
                  $ParameterSetToMatch = 'BPSAttribute'
                  $parameterSets = $parameter.ParameterSets.Keys
                  if ($parameterSets -contains $ParameterSetToMatch) {
                        Write-Verbose "$($parameter.Name) is part of BPS parameter set"
                        $parDetails = Get-Variable -Name $parameter.Name
                        if ($parDetails.Value) {
                              Write-Verbose "$($parameter.Name) have a value"
                              $parName = $parDetails.Name
                              $parValue = $parDetails.Value
                              $params.Add("$parName", "$parValue")
                        }
                        else {
                              Write-Verbose "$($parameter.Name) does not have a value!"
                        }
                  }
                  else {
                        Write-Verbose "$($parameter.Name) is not part of BPS parameter set!"
                  } Write-Verbose "Loop for $($parameter.Name) reached end!"
            }
            Write-Verbose "Successfully created hashtable of parameter!"
            $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $Params

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
      end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}
