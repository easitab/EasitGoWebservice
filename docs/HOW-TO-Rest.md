# Use PowerShell with Easit GO Rest API

## Generic variables used in code

```powershell
$ApiKey = "yourApiKey"
$baseUri = "baseUrlToEasitGO"
```

## Authentication

```powershell
# When this is used you change from 'Authentication = 'Basic'' and 'Credential = $credObject' to only 'Headers = $Headers'
$pair = "$($ApiKey): "
$asciiPair = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [System.Convert]::ToBase64String($asciiPair)
$basicAuthValue = "Basic $encodedCreds"
$headers = @{ Authorization = $basicAuthValue }
```

OR

```powershell
# When this is used you change from 'Headers = $Headers' to 'Authentication = 'Basic'' and 'Credential = $credObject'
[securestring]$secString = ConvertTo-SecureString 'null' -AsPlainText -Force
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($ApiKey, $secString)
```

## Example code (GET items)

```powershell
$getBody = @{
    columnFilter = @(
        @{
            columnName = "Id"
            comparator = "EQUALS"
            content = "1"
        }
    )
    itemViewIdentifier = "Incidents_v1"
} | ConvertTo-Json

$getRequestParams = @{
    Uri = "$baseUri/integration-api/items"
    Body = $getBody
    Method = 'Get'
    # Headers = $Headers
    # Authentication = 'Basic'
    # Credential = $credObject
    ContentType = "application/json;charset=utf-8"
} 
try {
    $items = Invoke-RestMethod @getRequestParams -Verbose
} catch {
    throw $_
}

$items.items | ForEach-Object {
    $_.PSObject.Properties | ForEach-Object {
        $_.Value.Property | ForEach-Object {
            "$($_.name) = $($_.content)"
        }
    }
}
```

## Example code (POST items)

```powershell
$importBody = @{
    importHandlerIdentifier = "CreateRequest_v1"
    itemToImport = @(
        @{
            id = 1
            property = @(
                @{
                    name = "Subject"
                    content = "EasitTestar"
                },
                @{
                    name = "Description"
                    content = "Description of request"
                }
            )
        }
    )
} | ConvertTo-Json -Depth 4
$postRequestParams = @{
    Uri = "$baseUri/integration-api/items"
    Body = $importBody
    Method = 'Post'
    # Headers = $Headers
    # Authentication = 'Basic'
    # Credential = $credObject
    ContentType = "application/json;charset=utf-8"
}
try {
    Invoke-RestMethod @postRequestParams -Verbose
} catch {
    throw $_
}
```
