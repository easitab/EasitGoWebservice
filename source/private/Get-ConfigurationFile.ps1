function Get-ConfigurationFile {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Get-ConfigurationFile.md")]
    <#
    .EXTERNALHELP EasitGoWebservice-help.xml
    #>
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }

    process {
        $configFilePath = Join-Path "$Path" -ChildPath 'easitWS.properties'
        if (Test-Path $configFilePath) {
            Write-Verbose "Found local configuration file"
            try {
                $easitWSConfig = Get-Content -Raw -Path $configFilePath -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
            } catch {
                throw $_
            }
            Write-Verbose "Retrieved local configuration file"
            if ($easitWSConfig.url.Length -gt 0) {
                Write-Verbose "Using url from local configuration file, $($easitWSConfig.url)"
            } else {
                Write-Verbose "Using url default, http://localhost/webservice/"
                $easitWSConfig.url = 'http://localhost/webservice/'
            }
        } else {
            Write-Warning "Unable to locate configuration file"
            $easitWSConfig = $false
        }
        return $easitWSConfig
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}