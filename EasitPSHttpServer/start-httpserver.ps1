<#
.DESCRIPTION
	A simple http server written in Powershell.

	With this http server you can recieve exported objects from Easit GO and take action upon that object.
	In its current configuration the server will use the cmdlet 'Start-Job' to run the powershell script
	specified as identifier and if present in subfolder 'resources'.

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

#>
[CmdletBinding()]
Param(
	[string]$BindingUrl = 'http://+',
	[string]$Port = '9080',
	[string]$Basedir = 'resources',
	[string]$ErrorHandling = 'SilentlyContinue'
)

	# Settings for logger
function Write-CustomLog {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true,
				ValueFromPipelineByPropertyName=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$Message,
	
		[Parameter(Mandatory=$false)]
		[Alias('LogPath')]
		[string]$Path = (Join-Path -Path "$($MyInvocation.PSScriptRoot)" -ChildPath "PShttpServer.log"),
		
		[Parameter(Mandatory=$false)]
		[ValidateSet('ERROR','WARN','INFO','DEBUG','VERBOSE')]
		[string]$Level = 'INFO',
	
		[Parameter(Mandatory=$false)]
		[switch]$writeToHost,

		[Parameter(Mandatory=$false)]
		[string]$ErrorHandling = 'SilentlyContinue'
	)
	$ErrorActionPreference = "$ErrorHandling"
	# Format Date for our Log File
	$FormattedDate = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

	if (Test-Path $Path) {
		$currentLogFile = Get-Item -Path $Path
		$currentLogs = Get-ChildItem -Path "$($MyInvocation.PSScriptRoot)" -Include "*.log*"
		[int]$currentLogsCount = $currentLogs.Count
		if ($($currentLogFile.Length) -ge 10mb) {
			$logNumber = $currentLogsCount + 1
			if ($logNumber -ge 10) {
				Remove-Item -Path "$($currentLogFile.BaseName).10"
				$newLogNumber = 1
				foreach ($file in $currentLogs) {
					Rename-Item -Path $file -NewName "$($currentLogFile.BaseName).$logNumber"
					$newLogNumber + 1
				}
			}
			Rename-Item -Path $Path -NewName "$($currentLogFile.BaseName).$logNumber"
		}
	}
	if (!(Test-Path $Path)) {
		$NewLogFile = New-Item "$Path" -Force -ItemType File
		Write-Information "$FormattedDate - INFO - Created $NewLogFile"
	}
	
	# Write message to error, warning, or verbose pipeline
	switch ($Level) { 
		'ERROR' { 
			Write-Error $Message 
		}
		'WARN' { 
			Write-Warning $Message 
		}
		'INFO' {
			Write-Information $Message
		}
		'VERBOSE' { 
			Write-Verbose $Message 
		}
		'DEBUG' { 
			Write-Debug $Message
		}
	}
	
	# Write log entry to $Path
	"$FormattedDate - $Level - $Message" | Out-File -FilePath "$Path" -Encoding UTF8 -Append -NoClobber
	if ($writeToHost) {
		Write-Host "$FormattedDate - $Level - $Message"
	}
}
# End of settings for logger

if (-not [System.Net.HttpListener]::IsSupported) {
	Write-CustomLog -Message "HttpListener is not supported for this OS!" -Level ERROR
	exit
}

$Binding = "$BindingUrl"+':'+"$Port/"

# Starting the powershell webserver
Write-CustomLog -Message "Starting powershell http server..." -Level INFO
try {
	$listener = New-Object System.Net.HttpListener
	$listener.Prefixes.Add($Binding)
	$listener.Start()
} catch {
	Write-CustomLog -Message "Unable to start server" -Level INFO
	Write-CustomLog -Message "$_" -Level ERROR
	exit
}
$error.Clear()
try {
	$resourceRoot = Join-Path -Path "$PSScriptRoot" -ChildPath "$Basedir"
	if (!(Test-Path $resourceRoot)) {
		Write-CustomLog -Message "No valid resource folder ($resourceRoot) provided!" -Level ERROR
		exit
	} else {
		Write-CustomLog -Message "Looking for resources at $resourceRoot" -Level INFO
	}
	Write-CustomLog -Message "Powershell http server started." -Level INFO
	Write-CustomLog -Message "Listening on $Binding" -Level INFO
	while ($listener.IsListening) {
		# analyze incoming request
		$httpContext = $listener.GetContext()
		$httpRequest = $httpContext.Request
		$httpRequestMethod = $httpRequest.HttpMethod
		$httpRequestURLPath = $httpRequest.Url.LocalPath
		$received = "$httpRequestMethod $httpRequestURLPath"
		$requestUrl = $httpRequest.Url.OriginalString
		Write-CustomLog -Message "requestUrl = $requestUrl" -Level INFO
		$httpContentType = $httpRequest.ContentType
		if ($HttpRequest.HasEntityBody) {
			$Reader = New-Object System.IO.StreamReader($HttpRequest.InputStream)
			$requestContent = $Reader.ReadToEnd()
		}
		$HttpResponse = $HttpContext.Response
		$HttpResponse.Headers.Add("Content-Type","text/plain")
		
		
		# check for known commands
		switch ($received)
		{
			"POST /testfromeasit" {
				$HttpResponse.StatusCode = 200
				$htmlResponse = '<html><body>Sucess!</body></html>'
			}
			
			"POST /fromeasit" { # execute script
				$HttpResponse.StatusCode = 200
				$htmlResponse = '<html><body>Sucess!</body></html>'
				Write-CustomLog -Message "ContentType = $httpContentType" -Level INFO
				if ($httpContentType -eq 'text/xml; charset=UTF-8') {
					$match = $requestContent -match 'identifier">(.*)<\/'
					$identifier = $Matches[1]
					[xml]$requestContentXML = $requestContent
					$items = $requestContentXML.EasitImport.Items.ChildNodes
					$easitObjects = @()
					foreach ($item in $items) {
						$objectUID = $item.Attributes.Value
						$propertiesHash = [ordered]@{
							UID = $objectUID
						}
						$properties = $items.ChildNodes
						foreach ($property in $properties.ChildNodes) {
							$xmlPropertyName = $property.Attributes.Value
							$xmlPropertyValue = $property.innerText
							$keys = @($propertiesHash.keys)
							foreach ($key in $keys) {
								$keyMatch = $false
								if ($key -eq $xmlPropertyName) {
									$keyMatch = $true
									[array]$currentPropertyValueArray = $propertiesHash[$key]
									[array]$propertyValueArray = $currentPropertyValueArray
									[array]$propertyValueArray += $xmlPropertyValue
									$propertiesHash.Set_Item($xmlPropertyName, $propertyValueArray)
								}
							}
							if (!($keyMatch)) {
								$propertiesHash.Set_Item($xmlPropertyName, $xmlPropertyValue)
							}
						}
						$object = New-Object PSObject -Property $propertiesHash
						$easitObjects += $object
					}
					$execDir = Join-Path -Path "$PSScriptRoot" -ChildPath "$Basedir"
					$executable = Join-Path -Path "$execDir" -ChildPath "$identifier.ps1"
					if (Test-Path "$executable") {
						try {
							Write-CustomLog -Message "Creating job, executing $executable" -Level INFO
							$job = Start-Job -Name "$identifier" -FilePath "$executable" -ArgumentList @($execDir,$easitObjects)
							Write-CustomLog -Message "Job successfully created" -Level INFO
						} catch {
							Write-CustomLog -Message "$_" -Level ERROR
							Write-CustomLog -Message "Error executing / running script!" -Level ERROR
						}
					} else {
						Write-CustomLog -Message "Cannot find script ($PSScriptRoot\$Basedir\$identifier.ps1)!" -Level ERROR
					}
					$jobCleanup = Get-Job -State Completed | Remove-Job
				} else {
					Write-CustomLog -Message "Invalid Content-Type!" -INFO
				}
			}

			"POST /toeasit" {
				$HttpResponse.StatusCode = 200
				$htmlResponse = '<html><body>Sucess!</body></html>'
				Write-CustomLog -Message "ContentType = $httpContentType" -Level INFO
				if ($httpContentType -contains 'application/json') {
					$requestObjects = ConvertFrom-Json $requestContent
					if ($requestUrl -match '(\?|\&)identifier=(.*)(\&)?') {
						$keyString = $Matches[2]
						if ($keyString -match '&') {
							$paramKeys = $keyString -split '&'
							$identifierJSON = $paramKeys[0]
						} else {
							$identifierJSON = $Matches[2]
						}
					}
					$execDir = Join-Path -Path "$PSScriptRoot" -ChildPath "$Basedir"
					$executable = Join-Path -Path "$execDir" -ChildPath "$identifierJSON.ps1"
					if (Test-Path "$executable") {
						try {
							Write-CustomLog -Message "Creating job, executable $executable" -Level INFO
							$execDir = Join-Path -Path "$PSScriptRoot" -ChildPath "$Basedir"
							$job = Start-Job -Name "$identifier" -FilePath "$executable" -ArgumentList @($execDir,$requestObjects)
							Write-CustomLog -Message "Job successfully created" -Level INFO
						} catch {
							Write-CustomLog -Message "$_" -Level ERROR
							Write-CustomLog -Message "Error executing / running script!" -Level ERROR
						}
					} else {
						Write-CustomLog -Message "Cannot find script ($executable)!" -Level ERROR
					}
					$jobCleanup = Get-Job -State Completed | Remove-Job
				} else {
					Write-CustomLog -Message "Invalid Content-Type!" -Level INFO
				}
			}

			"GET /quit"	{
				$HttpResponse.StatusCode = 200
				$htmlResponse = 'Stopping powershell http server... Goodbye!'
				Write-CustomLog -Message "Stopping powershell http server..." -Level INFO
				exit
			}

			"GET /exit"	{
				$HttpResponse.StatusCode = 200
				$htmlResponse = 'Stopping powershell http server... Goodbye!'
				Write-CustomLog -Message "Stopping powershell http server..." -Level INFO
				exit
			}

			"GET /status"	{
				$HttpResponse.StatusCode = 200
				Write-CustomLog -Message "Everything is goooooood!!!" -Level INFO
				$htmlResponse = 'Staus: OK!'

			}
			default	{
				$HttpResponse.StatusCode = 404
				$htmlResponse = 'Unknown endpoint or action!'
				Write-CustomLog -Message "Received unknown endpoint or action! $received" -Level INFO
				}
			}
		$buffer = [System.Text.Encoding]::UTF8.GetBytes($htmlResponse)
		$HttpResponse.ContentLength64 = $buffer.Length
		$HttpResponse.OutputStream.Write($buffer, 0, $buffer.Length)
		$HttpResponse.Close()
	}
} catch {
	$fullExceptionMessage = "$($_.Exception.InnerException)"
	$smallExceptionMessage = "$($_.Exception.Message)"
	$exceptionScriptStack = "$($_.Exception.ScriptStackTrace)"
	$exceptionStackTrace = "$($_.Exception.StackTrace)"
	if ($exceptionMessage) {
		Write-CustomLog -Message "Message: $smallExceptionMessage" -Level WARN
	}
	Write-CustomLog -Message "Full exception: `n$fullExceptionMessage" -Level ERROR
	if ($exceptionStackTrace) {
		Write-CustomLog -Message "StackTrace: `n$exceptionStackTrace" -Level ERROR
	}
	if ($exceptionScriptStack) {
		Write-CustomLog -Message "ScriptStackTrace: `n$exceptionScriptStack" -Level ERROR
	}
	Write-CustomLog -Message "$_" -Level ERROR
} finally {
	$jobCleanup = Get-Job -State Completed | Remove-Job
	if ($jobCleanup) {
		Write-CustomLog -Message "Removed completed jobs" -Level INFO
	} else {
		Write-CustomLog -Message "No completed jobs to remove" -Level INFO
	}
	# Stop powershell webserver
	$listener.Stop()
	$listener.Close()
	Write-CustomLog -Message "Powershell http server stopped." -Level INFO
}