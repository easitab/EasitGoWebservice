---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Get-GOItems.md
schema: 2.0.0
---

# Get-GOItems

## SYNOPSIS

Get data from BPS/GO with web services.

## SYNTAX

```powershell
Get-GOItems [[-url] <String>] [-apikey] <String> [-importViewIdentifier] <String> [[-sortOrder] <String>]
 [[-sortField] <String>] [[-viewPageNumber] <Int32>] [[-ColumnFilter] <String[]>] [-SSO] [<CommonParameters>]
```

## DESCRIPTION

Connects to BPS/GO Web service with url, apikey and view and returns each item as an objects.<br>
If the view specified to get items from contains two or more fields with the same name, the value from the latest field will be used.<br>
All returning objects will have these properties requestedPage, totalNumberOfPages and totalNumberOfItems beyond the once provided by the importViewIdentifier.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-GOItems -url 'http://localhost/test/webservice/' -apikey '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375' -view 'Request'
```

### EXAMPLE 2

```powershell
$url = 'http://localhost/test/webservice/'
$api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
Get-GOItems -url "$url" -apikey "$api" -view 'RequestsProblems' -page 2
```

### EXAMPLE 3

```powershell
$getGoItemsParams = @{
      url = 'http://localhost/test/webservice/'
      api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
      view = 'RequestServiceRequests'
      ColumnFilter = 'Name,EQUALS,Extern organisation'
}
Get-GOItems @getGoItemsParams
```

### EXAMPLE 4

```powershell
$getGoItemsParams = @{
      url = 'http://localhost/test/webservice/'
      api = '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
      view = 'RequestIncidents'
      sortOrder = 'Ascending'
}
Get-GOItems @getGoItemsParams -ColumnFilter "Status,IN,Registrerad", "Prioritet,IN,5"
```

## PARAMETERS

### -apikey

API-key for BPS/GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnFilter

Used to filter data.<br>
Example: ColumnName,comparator,value<br>
Valid comparator: EQUALS, NOT_EQUALS, IN, NOT_IN, GREATER_THAN, GREATER_THAN_OR_EQUALS, LESS_THAN, LESS_THAN_OR_EQUALS, LIKE, NOT_LIKE

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -importViewIdentifier

View to get data from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: view

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sortField

Field to sort data with.
Default = Id

```yaml
Type: String
Parameter Sets: (All)
Aliases: sf

Required: False
Position: 5
Default value: Id
Accept pipeline input: False
Accept wildcard characters: False
```

### -sortOrder

Order in which to sort data, Descending or Ascending.
Default = Descending

```yaml
Type: String
Parameter Sets: (All)
Aliases: so

Required: False
Position: 4
Default value: Descending
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSO

Used if system is using SSO with IWA (Active Directory). Not needed when using SAML2.<br>
Cmdlet will use the credentials of the current user to send the web request.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -url

Address to BPS/GO webservice.
Default = http://localhost/webservice/

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Http://localhost/webservice/
Accept pipeline input: False
Accept wildcard characters: False
```

### -viewPageNumber

Used to get data from specific page in view.
Each page contains 25 items.
Default = 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: page

Required: False
Position: 6
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

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

## RELATED LINKS

[https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Get-GOItems.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Get-GOItems.ps1)

