function Import-GORequestItem {
      [CmdletBinding()]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url = "http://localhost/webservice/",

            [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias('ihi')]
            [string] $ImportHandlerIdentifier = 'CreateRequest',

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Item','ItemID')]
            [int] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $OrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ManagerGroup,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Manager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Type,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Parent')]
            [int] $ParentItemID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Priority,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Description,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Resolution','FAQ')]
            [string] $FaqKnowledgeResolutionText,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Subject,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Asset')]
            [int] $AssetsCollectionID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('ClosureCause')]
            [string] $CausalField,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ClosingCategory,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Impact,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Owner,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ReferenceContactID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [int] $ReferenceOrganizationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Article')]
            [int] $ServiceID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('SLA')]
            [string] $SLAID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Urgency,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('Classification')]
            [int] $ClassificationID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('KnowledgebaseArticle','KB')]
            [int] $KnowledgebaseArticleID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('CI')]
            [int] $CIID,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [int] $uid = "1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string]$DeliveryInformation,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias('ApprovedBy')]
            [int] $ApprovedByID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Approval,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ProductsAndServices,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Message,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $DesiredDelivery,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [ValidateScript({
                  if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        $true
                  } else {
                        throw "$_ does not match the format (yyyy-MM-dd) required for this parameter."
                  }
            })]
            [string] $PlannedDelivery,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Workaround,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ImpactAssessment,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ResourceRequirement,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Cause,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $LifeCycle,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $TypeOfChange,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $CategoryOfChange,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("File")]
            [string] $Attachment,

            [parameter(Mandatory=$false)]
            [switch] $SSO,

            [parameter(Mandatory = $false)]
            [switch] $UseBasicParsing,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
      }
      process {
            try {
                  Write-Verbose "Collecting list of used parameters."
                  $CommandName = $PSCmdlet.MyInvocation.InvocationName
                  $ParameterList = (Get-Command -Name $commandName).Parameters.Values
                  Write-Verbose "Successfully collected list of used parameters"
            } catch {
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
                        } else {
                              Write-Verbose "$($parameter.Name) does not have a value!"
                        }
                  } else {
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