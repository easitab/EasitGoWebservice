---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v1/Ping-GOWebService.md
schema: 2.0.0
---

# Ping-GOWebService

## SYNOPSIS
Ping BPS/GO web services.

## SYNTAX

```
Ping-GOWebService [[-url] <String>] [-apikey] <String> [<CommonParameters>]
```

## DESCRIPTION
Can be used to check if service is available and correct credentials have been provided..

## EXAMPLES

### EXAMPLE 1
```
Ping-GOWebService -url http://localhost/test/webservice/ -apikey 4745f62b7371c2aa5cb80be8cd56e6372f495f6g8c60494ek7f231548bb2a375
```

## PARAMETERS

### -apikey
API key for BPS/GO.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

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

[https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Ping-GOWebService.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Ping-GOWebService.ps1)

