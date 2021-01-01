---
external help file:
Module Name:
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Invoke-EasitWebRequest.md
schema: 2.0.0
---

# Invoke-EasitWebRequest

## SYNOPSIS

"Private" cmdlet that act as helper function.

## SYNTAX

```powershell
Invoke-EasitWebRequest [[-Uri] <String>] [[-Apikey] <String>] [[-Method] <String>] [[-ContentType] <String>]
 [[-Body] <XmlDocument>] [-UseDefaultCredentials] [-UseBasicParsing] [<CommonParameters>]
```

## DESCRIPTION

This cmdlet performs the web request to Easit BPS / Easit GO. It uses Invoke-WebRequest to send request.

## EXAMPLES

### Example 1
```powershell
PS C:\> $easitWebRequestParams = @{
            Uri = "$url"
            Apikey = "$apikey"
            Body = $payload
        }
PS C:\> Invoke-EasitWebRequest @easitWebRequestParams
```

## PARAMETERS

### -Apikey

API-key for Easit BPS / Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body

The "body" of the web request. Refered to as the "payload".

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType

Specifies the type of content in the web request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method

What method should the web request use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri

URL to Easit BPS / Easit GO web service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
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

### -UseDefaultCredentials

Used if system is using SSO with IWA (Active Directory). Not needed when using SSO with SAML2.

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

### None

## OUTPUTS

### XmlDocument

## NOTES

## RELATED LINKS

[https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Invoke-EasitWebRequest.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Invoke-EasitWebRequest.ps1)
