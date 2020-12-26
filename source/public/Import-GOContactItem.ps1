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
            [switch] $dryRun,

            [parameter(Mandatory = $false)]
            [switch] $ShowDetails
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
                  Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS.."
                  $i = 1
                  $currentUserProfile = [Environment]::GetEnvironmentVariable("USERPROFILE")
                  $userProfileDesktop = "$currentUserProfile\Desktop"
                  do {
                        $outputFileName = "payload_$i.xml"
                        if (Test-Path $userProfileDesktop\$outputFileName) {
                              $i++
                              Write-Verbose "Filename counter: $i"
                        }
                  } until (!(Test-Path $userProfileDesktop\$outputFileName))
                  if (!(Test-Path $userProfileDesktop\$outputFileName)) {
                        try {
                              $outputFileName = "payload_$i.xml"
                              $payload.Save("$userProfileDesktop\$outputFileName")
                              Write-Verbose "Saved payload to file, will now end!"
                              break
                        }
                        catch {
                              Write-Error "Unable to save payload to file!"
                              Write-Error "$_"
                              break
                        }
                  }
            }

            Write-Verbose "Creating header for web request!"
            try {
                  $pair = "$($apikey): "
                  $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
                  $basicAuthValue = "Basic $encodedCreds"
                  $headers = @{SOAPAction = ""; Authorization = $basicAuthValue }
                  Write-Verbose "Header created for web request!"
            }
            catch {
                  Write-Error "Failed to create header!"
                  Write-Error "$_"
                  break
            }
            Write-Verbose "Calling web service and using payload as input for Body parameter"
            if ($SSO) {
                  try {
                        Write-Verbose 'Using switch SSO. De facto UseDefaultCredentials for Invoke-WebRequest'
                        $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers -UseDefaultCredentials
                        Write-Verbose "Successfully connected to and imported data to BPS"
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
                        Write-Verbose "Successfully connected to and imported data to BPS"
                  }
                  catch {
                        Write-Error "Failed to connect to BPS!"
                        Write-Error "$_"
                        return $payload
                  }
            }

            New-Variable -Name functionout
            [xml]$functionout = $r.Content
            Write-Verbose 'Casted content of reponse as [xml]$functionout'

            if ($ShowDetails) {
                  $responseResult = $functionout.Envelope.Body.ImportItemsResponse.ImportItemResult.result
                  $responseID = $functionout.Envelope.Body.ImportItemsResponse.ImportItemResult.ReturnValues.ReturnValue.InnerXml
                  Write-Information "Result: $responseResult"
                  Write-Information "ID for created item: $responseID"
            }
      }
      end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}
