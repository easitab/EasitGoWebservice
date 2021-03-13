---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Ping-GOWebService.md
schema: 2.0.0
---

# Ping-GOWebService

## SYNOPSIS

Ping Easit BPS / Easit GO web services.

## SYNTAX

```
Ping-GOWebService [[-url] <String>] [[-apikey] <String>] [[-ConfigurationDirectory] <String>] [-SSO]
 [-UseBasicParsing] [-dryRun] [<CommonParameters>]
```

## DESCRIPTION

Can be used to check if service is available and correct credentials have been provided.

## EXAMPLES

### EXAMPLE 1

```powershell
Ping-GOWebService -url 'http://localhost/test/webservice/' -apikey '4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375'
```

### EXAMPLE 2

In this example we have a configuration file located in our users home directory with the url and apikey.

```powershell
Ping-GOWebService
```

## PARAMETERS

### -apikey

API-key for Easit BPS / Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationDirectory

Path to directory where the configuration file for the web service is.

```yaml
Type: String
Parameter Sets: (All)
Aliases: configdir

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dryRun

If specified, payload will be save as payload_1.xml (or next available number) to your desktop instead of sent to Easit BPS / Easit GO.
This parameter does not append, rewrite or remove any files from your desktop.

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

### -SSO

Used if system is using SSO with IWA (Active Directory). Not needed when using SSO with SAML2.<br>
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

URL to Easit BPS / Easit GO web service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: Http://localhost/webservice/
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

Copyright 2021 Easit AB

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

[https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Ping-GOWebService.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Ping-GOWebService.ps1)
