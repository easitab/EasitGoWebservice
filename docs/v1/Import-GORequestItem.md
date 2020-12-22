---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v1/Import-GORequestItem.md
schema: 2.0.0
---

# Import-GORequestItem

## SYNOPSIS
Send data to BPS/GO with web services.

## SYNTAX

```
Import-GORequestItem [-url <String>] -apikey <String> [-ImportHandlerIdentifier <String>] [-ID <Int32>]
 [-ContactID <Int32>] [-OrganizationID <Int32>] [-Category <String>] [-ManagerGroup <String>]
 [-Manager <String>] [-Type <String>] [-Status <String>] [-ParentItemID <Int32>] [-Priority <String>]
 [-Description <String>] [-FaqKnowledgeResolutionText <String>] [-Subject <String>]
 [-AssetsCollectionID <Int32>] [-CausalField <String>] [-ClosingCategory <String>] [-Impact <String>]
 [-Owner <String>] [-ReferenceContactID <Int32>] [-ReferenceOrganizationID <Int32>] [-ServiceID <Int32>]
 [-SLAID <String>] [-Urgency <String>] [-ClassificationID <Int32>] [-KnowledgebaseArticleID <Int32>]
 [-CIID <Int32>] [-uid <Int32>] [-Attachment <String>] [-SSO] [-dryRun] [-ShowDetails] [<CommonParameters>]
```

## DESCRIPTION
Update and create requests in Easit BPS/GO.
Returns ID for item in Easit BPS/GO..
Specify 'ID' to update an existing item.

## EXAMPLES

### EXAMPLE 1
```
Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad -Verbose -ShowDetails
```

### EXAMPLE 2
```
Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -Subject Testing1 -Description Testing1 -ContactID 5 -Status Registrerad
```

### EXAMPLE 3
```
Import-GORequestItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateRequest -ID "156" -Description "Testing2. Nytt test!"
```

### EXAMPLE 4
```
Import-GORequestItem -url $url -apikey $api -ihi $identifier -ID "156" -Description "Updating description for request 156"
```

## PARAMETERS

### -apikey
API-key for BPS/GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetsCollectionID
ID of asset to connect to the request.
Adds item to collection.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Asset

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Attachment
Full path to file to be included in payload.

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

### -Category
Contacts category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CausalField
Closure cause.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ClosureCause

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CIID
{{ Fill CIID Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: CI

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ClassificationID
ID of classification to connect with request.
Can be found on the classification in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Classification

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ClosingCategory
Closure category.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ContactID
ID of contact in BPS/GO.
Can be found on the contact in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Description of request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -dryRun
If specified, payload will be save as payload.xml to your desktop instead of sent to BPS/GO.

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

### -FaqKnowledgeResolutionText
Solution for the request.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Resolution, FAQ

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ID
ID for request in BPS/GO.
Existing item will be updated if provided.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Item, ItemID

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Impact
Impact of request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ImportHandlerIdentifier
ImportHandler to import data with.
Default = CreateRequest

```yaml
Type: String
Parameter Sets: (All)
Aliases: ihi

Required: False
Position: Named
Default value: CreateRequest
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -KnowledgebaseArticleID
ID of knowledgebase article to connect with request.
Can be found on the knowledgebase article in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: KnowledgebaseArticle, KB

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Manager
Username or email of user that should be used as manager.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ManagerGroup
Name of manager group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OrganizationID
ID for organization to which the contact belongs to.
Can be found on the organization in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Owner
Owner of request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentItemID
ID of parent item.
Matches agains existing items.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Parent

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Priority
Priority for item.
Matches agains existing priorities.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReferenceContactID
ID of reference contact.
Can be found on the contact in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReferenceOrganizationID
ID of reference organization.
Can be found on the organization in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceID
ID of article to connect with request.
Can be found on the article in BPS/GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Article

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowDetails
If specified, the response, including ID, will be displayed to host.

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

### -SLAID
ID of contract to connect with request.
Can be found on the contract in BPS/GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: SLA

Required: False
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

### -Status
Name of status.
Matches agains existing statuses.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Subject
Subject of request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Type
Name of type.
Matches agains existing types.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -uid
{{ Fill uid Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Urgency
Urgency of request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -url
Address to BPS/GO webservice.
Default = http://localhost/webservice/

```yaml
Type: String
Parameter Sets: (All)
Aliases: uri

Required: False
Position: Named
Default value: Http://localhost/webservice/
Accept pipeline input: True (ByPropertyName)
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

[https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Import-GORequestItem.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Import-GORequestItem.ps1)

