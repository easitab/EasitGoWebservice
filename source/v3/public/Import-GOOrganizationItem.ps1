function Import-GOOrganizationItem {
      [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Import-GOOrganizationItem.md")]
      param (
            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("uri")]
            [string] $url,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("api")]
            [string] $apikey,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [ValidateNotNullOrEmpty()]
            [Alias("ihi")]
            [string] $ImportHandlerIdentifier = "CreateOrganization",

            [parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
            [Alias('configdir')]
            [string] $ConfigurationDirectory = $Home,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Country,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Category,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Status,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Parent")]
            [int] $ParentItemID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Contract")]
            [string] $MainContractID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("OrganizationID")]
            [string] $ID,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("UserName")]
            [string] $AnvNamn,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Verksamhetdebet")]
            [string] $BusinessDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Counterpart,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $CustomerNumber,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $DeliveryZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $ExternalId,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Fax,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Password")]
            [string] $Losen,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Namn")]
            [string] $Name,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Anteckningar")]
            [string] $Notes,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("City")]
            [string] $Ort,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Telefon")]
            [string] $Phone,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $PostNummer,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Ansvardebet")]
            [string] $ResponsibilityDebit,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $UtdelningsAdress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besoksadress")]
            [string] $VisitingAddress,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besoksort")]
            [string] $VisitingCity,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Besokspostnummer")]
            [string] $VisitingZipCode,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [string] $Webshop,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Webb","homepage")]
            [string] $Website,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Kundansvarig")]
            [string] $AccountManager,

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("Serviceansvarig")]
            [string] $ServiceManager,

            [parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
            [int] $uid = "1",

            [parameter(ParameterSetName='BPSAttribute',ValueFromPipelineByPropertyName=$true)]
            [Alias("File")]
            [string[]] $Attachment,

            [parameter(Mandatory=$false)]
            [switch] $dryRun
      )
      begin {
            Write-Verbose "$($MyInvocation.MyCommand) initialized"
            Write-Warning "You are using a command from an older version of the module EasitGoWebservice. This command is considered deprecated as of version 3 of the module EasitGoWebservice."
            Write-Warning "This command will not get any new functionality and is used as a proxy for Import-GOItem. Please use Import-GOItem instead."
      }
      process {
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
                  Write-Verbose "Collecting list of used parameters.."
                  $CommandName = $PSCmdlet.MyInvocation.InvocationName
                  $ParameterList = (Get-Command -Name $commandName).Parameters.Values
                  Write-Verbose "Successfully collected list of used parameters."
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
                        Write-Verbose "$($parameter.Name) is part of BPS parameter set!"
                        $parDetails = Get-Variable -Name $parameter.Name
                        if ($parDetails.Value) {
                              Write-Verbose "$($parameter.Name) have a value, $($parDetails.Value)"
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
            if ($dryRun) {
                  Write-Verbose "dryRun specified! Trying to save payload to file instead of sending it to BPS"
                  try {
                        $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $Params
                  } catch {
                        throw $_
                  }
                  try {
                        Export-PayloadToFile -Payload $payload
                  } catch {
                        throw $_
                  }
            } else {
                  $easitWebRequestParams = @{
                        Uri = "$url"
                        Apikey = "$apikey"
                        Body = $payload
                  }
                  try {
                        Import-GOItem @easitWebRequestParams
                  } catch {
                        throw $_
                  }
            }
      }
      end {
            Write-Verbose "$($MyInvocation.MyCommand) completed"
      }
}