---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v1/New-XMLforEasit.md
schema: 2.0.0
---

# New-XMLforEasit

## SYNOPSIS
Helper function to create XML payload to send to Easit webservice.

## SYNTAX

### ping
```
New-XMLforEasit [-Ping] [<CommonParameters>]
```

### get
```
New-XMLforEasit [-Get] -ItemViewIdentifier <String> [-Page <Int32>] -SortField <String> -SortOrder <String>
 [-ColumnFilter <String[]>] [<CommonParameters>]
```

### import
```
New-XMLforEasit [-Import] -ImportHandlerIdentifier <String> -Params <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ColumnFilter
{{ Fill ColumnFilter Description }}

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
{{ Fill Get Description }}

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

### -Import
{{ Fill Import Description }}

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
{{ Fill ImportHandlerIdentifier Description }}

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
{{ Fill ItemViewIdentifier Description }}

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
{{ Fill Page Description }}

```yaml
Type: Int32
Parameter Sets: get
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Params
{{ Fill Params Description }}

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
{{ Fill Ping Description }}

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
{{ Fill SortField Description }}

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

### -SortOrder
{{ Fill SortOrder Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
