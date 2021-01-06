---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Get-ConfigurationFile.md
schema: 2.0.0
---

# Get-ConfigurationFile

## SYNOPSIS

"Private" cmdlet that act as helper function.

## SYNTAX

```powershell
Get-ConfigurationFile [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

This cmdlet *Get-ConfigurationFile* checks if a configuration file ('easitWS.properties') is present and returns its content as a result of Get-Content piped to ConvertFrom-Json.
This cmdlet *Get-ConfigurationFile* is invoked if -url or -apikey is omitted when running any of the "public" cmdlets in the EasitGoWebservice module.

If *Get-ConfigurationFile* do not find a configuration file it will return $false.<br>
If the length of the  value for url in the configuration file is 0 or less it will return 'http://localhost/webservice/' as the value of url.<br>
No check or default value is set for the key apikey.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ConfigurationFile
```

Looks for configuration file ('easitWS.properties').

## PARAMETERS

### -Path

Path to directory where configuration file exists.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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

[https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Get-ConfigurationFile.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Get-ConfigurationFile.ps1)

[https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/easitWS.properties](https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/easitWS.properties)