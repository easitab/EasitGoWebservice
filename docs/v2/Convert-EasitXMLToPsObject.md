---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Convert-EasitXMLToPsObject.md
schema: 2.0.0
---

# Convert-EasitXMLToPsObject

## SYNOPSIS

"Private" cmdlet that act as helper function.

## SYNTAX

```powershell
Convert-EasitXMLToPsObject [-Response] <XmlDocument> [<CommonParameters>]
```

## DESCRIPTION

Converts XML response from Easit BPS and Easit GO to PSObjects.

## EXAMPLES

### Example 1

```powershell
PS C:\> $r = Invoke-WebRequest -Uri $url -Method POST -ContentType 'text/xml' -Body $payload -Headers $headers
PS C:\> [xml]$functionout = $r.Content
PS C:\> Convert-EasitXMLToPsObject -Response $functionout
```

## PARAMETERS

### -Response

XML document to convert.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Xml.XmlDocument

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

[https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Convert-EasitXMLToPsObject.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/private/Convert-EasitXMLToPsObject.ps1)