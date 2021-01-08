function Export-PayloadToFile {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Export-PayloadToFile.md")]
    <#
    .EXTERNALHELP EasitGoWebservice-help.xml
    #>
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
        $userProfileDesktop = Join-Path -Path $HOME -ChildPath 'Desktop'
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