# Use PowerShell with Easit GO Rest API

## Generic variables used in code

```powershell
$ApiKey = "6dc3f11fa7054bajf9347856j9f8j74jf6h98746fh4ca88d3d514155089f27"
$baseUri = "baseUrlToEasitGO"

$pair = "$($ApiKey): "
$asciiPair = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [System.Convert]::ToBase64String($asciiPair)
$basicAuthValue = "Basic $encodedCreds"
$headers = @{ Authorization = $basicAuthValue }
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

$webRequestParams = @{
    Uri = "$baseUri/integration-api/items"
    Body = $getBody
    Method = 'Get'
    Headers = $Headers
    ContentType = "application/json;charset=utf-8"
} 
try {
    $items = Invoke-RestMethod @webRequestParams -Verbose
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
$webImportRequestParams = @{
    Uri = "$baseUri/integration-api/items"
    Body = $importBody
    Method = 'Post'
    Headers = $Headers
    ContentType = "application/json;charset=utf-8"
}
try {
    Invoke-RestMethod @webImportRequestParams -Verbose
} catch {
    throw $_
}
```
