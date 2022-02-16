---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/New-XMLforEasit.md
schema: 2.0.0
---

# New-XMLforEasit

## SYNOPSIS

"Private" cmdlet that act as helper function.

## SYNTAX

### ping
```
New-XMLforEasit [-Ping] [<CommonParameters>]
```

### get
```
New-XMLforEasit [-Get] -ItemViewIdentifier <String> [-Page <Int32>] [-SortField <String>] [-SortOrder <String>]
 [-ColumnFilter <String[]>] [-IdFilter <String>] [<CommonParameters>]
```

### import
```
New-XMLforEasit [-Import] -ImportHandlerIdentifier <String> -Params <Hashtable> [<CommonParameters>]
```

## DESCRIPTION

This cmdlet "builds" a XML-object that can be sent to Easit BPS and Easit GO to get or create/update items.

## EXAMPLES

### Example 1

```powershell
PS C:\> $payload = New-XMLforEasit -Get -ItemViewIdentifier "$importViewIdentifier" -SortOrder "$sortOrder" -SortField "$sortField" -Page "$viewPageNumber" -ColumnFilter "$ColumnFilter"
```

### Example 2

```powershell
PS C:\> $payload = New-XMLforEasit -Import -ImportHandlerIdentifier "$ImportHandlerIdentifier" -Params $Params
```

## PARAMETERS

### -ColumnFilter

Used to filter data.<br>
Example: ColumnName,comparator,value<br>

```yaml
Type: String[]
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Get

Tells cmdlet that the XML-object should be built in order to get items from Easit BPS or Easit GO.

```yaml
Type: SwitchParameter
Parameter Sets: get
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdFilter
{{ Fill IdFilter Description }}

```yaml
Type: String
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Import

Tells cmdlet that the XML-object should be built in order to import items to Easit BPS or Easit GO.

```yaml
Type: SwitchParameter
Parameter Sets: import
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportHandlerIdentifier

Tells cmdlet what value that the XML-object should set for the ImportHandlerIdentifier property. As this is an "global" property and not for any specific item it is handled separatly.

```yaml
Type: String
Parameter Sets: import
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemViewIdentifier

Tells cmdlet what value that the XML-object should set for the ItemViewIdentifier property.

```yaml
Type: String
Parameter Sets: get
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page

Tells cmdlet what value that the XML-object should set for the Page property.

```yaml
Type: Int32
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Params

The values provided in this parameter will represent the XML properties for the item sent.

```yaml
Type: Hashtable
Parameter Sets: import
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ping

Tells cmdlet if an XML-object should be built in order to ping a webservice.

```yaml
Type: SwitchParameter
Parameter Sets: ping
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortField

Tells cmdlet what value that the XML-object should set for the SortColumn property.

```yaml
Type: String
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortOrder

Tells cmdlet what value that the XML-object should set as the attribut *order* for the SortColumn property.

```yaml
Type: String
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/easitab/EasitGoWebservice/blob/development/source/private/New-XMLforEasit.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/private/New-XMLforEasit.ps1)
