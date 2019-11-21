param(
    $execDir,
    $easitObjects
)
$now = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"
$logDir = Join-Path -Path "$execDir" -ChildPath 'logs'
$scriptName = $MyInvocation.MyCommand.Name.Trim('.ps1')
$outputFile = "$logDir\$scriptName.log"
"$now - Script start!" | Out-File -FilePath "$outputFile" -Encoding UTF8 -Append

[int]$requestID =  $easitObjects.requestID

$urlWS = ""
$apikey = ""
$importHandlerContact = "activateADUser"
$importHandlerRequest = "updateRequest"

try {
    $adUpdate = Disable-ADAccount -Identity "$($easitObjects.userName)"
} catch {
    "$_" | Out-File -Path "$outputFile" -Encoding UTF8 -Append
    break
}

if ($adUpdate) {
    try {
        $easitContactUpdate = Import-GOContactItem -url "$urlWS" -apikey "$apikey" -ImportHandlerIdentifier "$importHandlerContact" -Inactive $true
    } catch {
        "$_" | Out-File -Path "$outputFile" -Encoding UTF8 -Append
        break
    }
    if ($easitContactUpdate) {
        try {
            $easitRequestUpdate = Import-GORequestItem -url "$urlWS" -apikey "$apikey" -ImportHandlerIdentifier "$importHandlerRequest" -ID $requestID
        } catch {
            "$_" | Out-File -Path "$outputFile" -Encoding UTF8 -Append
            break
        }
        if ($easitRequestUpdate) {
            # Log success and continue
        } else {
            # Log failure
        }
    } else {
        break
    }

}
"$now - Script end!" | Out-File -FilePath "$outputFile" -Encoding UTF8 -Append