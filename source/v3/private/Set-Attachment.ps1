function Set-Attachment {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitGoWebservice/blob/main/docs/v2/Set-Attachment.md")]
    param (
        [Parameter(Mandatory)]
        [string]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $attachmentDetails = $InputObject -split ';'
        $attachmentType = $attachmentDetails[0].Trim()
        Write-Verbose "attachmentType = $attachmentType"
        if (!($attachmentType -like 'file') -and !($attachmentType -like 'base64')) {
            throw "Unknown type of attachment"
        }
        $returnObject = New-Object PSObject
        if ($attachmentType -like 'file') {
            $attachment = $attachmentDetails[-1].Trim()
            $returnObject | Add-Member -MemberType Noteproperty -Name "attachmentType" -Value "file"
            $separator = "\"
            $fileNametoHeader = $attachment.Split($separator)
            $attachmentName = $fileNametoHeader[-1]
            try {
                $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$attachment"))
                Write-Verbose "Converted file to base64"
            } catch {
                throw $_
            }
        }
        if ($attachmentType -like 'base64') {
            if ($attachmentDetails.Count -ne 3) {
                throw "Invalid syntax for attachment, please use type;filename;base64string"
            }
            $returnObject | Add-Member -MemberType Noteproperty -Name "attachmentType" -Value "base64"
            $attachmentName = $attachmentDetails[1].Trim()
            $base64string = $attachmentDetails[-1].Trim()
        }
        if ([string]::IsNullOrEmpty($attachmentName)) {
            Write-Verbose "attachmentName IsNullOrEmpty, setting value to 'null'"
            $attachmentName = 'null'
        } else {
            Write-Verbose "attachmentName = $attachmentName"
        }
        $returnObject | Add-Member -MemberType Noteproperty -Name "attachmentName" -Value "$attachmentName"
        if ([string]::IsNullOrEmpty($base64string)) {
            Write-Verbose "base64string IsNullOrEmpty, setting value to 'null'"
            $base64string = 'null'
        } else {
            Write-Verbose "base64string is not NullOrEmpty"
        }
        $returnObject | Add-Member -MemberType Noteproperty -Name "attachment" -Value "$base64string"
        return $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}