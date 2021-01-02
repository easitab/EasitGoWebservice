function Export-PayloadToFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [xml]$Payload
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $InformationPreference = 'Continue'
    }

    process {
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
                    $Payload.Save("$payloadFile")
                    Write-Information "Saved payload to file ($payloadFile), will now end!"
                    break
            }
            catch {
                    throw $_
            }
        }
    }

    end {
        $InformationPreference = 'SilentlyContinue'
        Write-Verbose "$($MyInvocation.MyCommand) completed."
    }
}