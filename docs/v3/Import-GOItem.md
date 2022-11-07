---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Import-GOItem.md
schema: 2.0.0
---

# Import-GOItem

## SYNOPSIS

Send data to Easit BPS / Easit GO with web services.

## SYNTAX

```powershell
Import-GOCustomItem [-url <String>] [-apikey <String>] -ImportHandlerIdentifier <String>
 [-ConfigurationDirectory <String>] -CustomProperties <Hashtable> [-Attachment <String>] [-SSO]
 [-UseBasicParsing] [-dryRun] [<CommonParameters>]
```

## DESCRIPTION

Create and update any item in Easit BPS / Easit GO. This cmdlet can be used with any importhandler, module and item in Easit GO.

## EXAMPLES

### Example 1

In this exampel we use the importhandler *CreateCustomItem* to update a contract with the name *OurFirstContract*.

```powershell
PS C:\> $CustomProperties = @{'ID' = 12;'Name' = 'OurFirstContract'}
PS C:\> Import-GOContactItem -url 'http://localhost/webservice/' -apikey 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618' -ImportHandlerIdentifier 'CreateCustomItem' -CustomProperties $CustomProperties
```

### Example 2

In this exampel we use the importhandler *CreateProject* to create a project with status Ongoing.

```powershell
PS C:\> $importEasitItem = @{
            url = 'http://localhost/webservice/'
            api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
        }
PS C:\> $CustomProperties = @{'Name' = 'ACustomProject';'Status' = 'Ongoing'}
PS C:\> Import-GOContactItem @importEasitItem -ImportHandlerIdentifier 'CreateCustomItem' -CustomProperties $CustomProperties
```

### Example 3

In this example we have a configuration file located in our users home directory with the url and apikey.

```powershell
PS C:\> $CustomProperties = @{'Name' = 'ACustomProject';'Status' = 'Ongoing'}
PS C:\> Import-GOContactItem -ImportHandlerIdentifier 'CreateCustomItem' -CustomProperties $CustomProperties
```

## PARAMETERS

### -apikey

API-key for Easit BPS / Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Attachment
{{ Fill Attachment Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: File

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConfigurationDirectory

Path to directory where the configuration file for the web service is.

```yaml
Type: String
Parameter Sets: (All)
Aliases: configdir

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CustomProperties

Hashtable of key-value-pair with the properties and its values that you want to send to Easit BPS / Easit GO.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -dryRun

If specified, payload will be save as payload_1.xml (or next available number) to your desktop instead of sent to Easit BPS / Easit GO. This parameter does not append, rewrite or remove any files from your desktop.

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

### -ImportHandlerIdentifier

ImportHandler to import data with.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ihi

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SSO

Used if system is using SSO with IWA (Active Directory).
Not need when using SAML2

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

URL to Easit BPS / Easit GO web service.

```yaml
Type: String
Parameter Sets: (All)
Aliases: uri

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UseBasicParsing

This parameter is required when Internet Explorer is not installed on the computers, such as on a Server Core installation of a Windows Server operating system.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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

### System.String
### System.Collections.Hashtable
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Import-GOCustomItem.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Import-GOCustomItem.ps1)