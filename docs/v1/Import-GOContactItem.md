---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v1/Import-GOContactItem.md
schema: 2.0.0
---

# Import-GOContactItem

## SYNOPSIS
Send data to BPS/GO with web services.

## SYNTAX

```
Import-GOContactItem [-url <String>] -apikey <String> [-ImportHandlerIdentifier <String>] [-FirstName <String>]
 [-Surname <String>] [-Email <String>] [-ID <Int32>] [-SecId <String>] [-OrganizationID <String>]
 [-Category <String>] [-Position <String>] [-ManagerID <String>] [-Impact <String>]
 [-PreferredMethodForNotification <String>] [-Building <String>] [-Checkbox_Authorized_Purchaser <String>]
 [-Checkbox_Responsible_Manager <String>] [-Deparment <String>] [-ExternalId <String>] [-FQDN <String>]
 [-Inactive <String>] [-MobilePhone <String>] [-Note <String>] [-Phone <String>] [-Room <String>]
 [-Title <String>] [-Username <String>] [-uid <Int32>] [-Attachment <String>] [-SSO] [-dryRun] [-ShowDetails]
 [<CommonParameters>]
```

## DESCRIPTION
Update and create contacts in Easit BPS/GO.
Returns ID for item in Easit BPS/GO.
Specify 'ID' to update an existing contact.

## EXAMPLES

### EXAMPLE 1
```
Import-GOContactItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateContact -OrganizationID "12" -Position "Manager" -Deparment "Support" -FirstName "Test" -Surname "Testsson" -Username "te12te" -SecId "97584621" -Verbose -ShowDetails
```

### EXAMPLE 2
```
Import-GOContactItem -url http://localhost/webservice/ -apikey a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ihi CreateContact -ID "649" -Inactive "true"
```

### EXAMPLE 3
```
Import-GOContactItem -url http://localhost/webservice/ -api a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618 -ImportHandlerIdentifier CreateContact -ID "649" -Surname "Andersson" -Email "test.anders@company.com" -FQDN "$FQDN"
```

### EXAMPLE 4
```
Import-GOContactItem -url $url -apikey $api -ihi $identifier -ID "156" -Inactive "false" -Responsible_Manager "true"
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

### -Building
Buildning that the contact is located in.

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

### -Checkbox_Authorized_Purchaser
Can be set to true or false.

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

### -Checkbox_Responsible_Manager
Can be set to true or false.

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

### -Deparment
Department to which the contact belongs.

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
If specified, payload will be save as payload.xml to your desktop instead of sent to BPS.

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

### -Email
Contacts email.

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

### -ExternalId
Contacts external id.

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

### -FirstName
First name of contact in BPS/GO.

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

### -FQDN
Contacts fully qualified domain name.

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

### -ID
ID for contact in BPS/GO.

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

### -Impact
Contacts impact level.
1.
Minor, 2.
Medium or 3.
Major.

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
Default = CreateContact

```yaml
Type: String
Parameter Sets: (All)
Aliases: ihi

Required: False
Position: Named
Default value: CreateContact
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Inactive
Used to set contact as inactive.
Can be set to true or false.

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

### -ManagerID
ID of contact that should be used as Manager.

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

### -MobilePhone
Contacts mobilephone.

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

### -Note
Notes regarding contact.

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
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Phone
Contacts phone.

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

### -Position
Contacts position.

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

### -PreferredMethodForNotification
Contacts preferred method for notification.
Mail or Telephone.

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

### -Room
Room in which contact is located.

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

### -SecId
Contacts security id.

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

### -Surname
Last name of contact in BPS/GO.

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

### -Title
Contact title, eg CEO.

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

### -Username
Contacts username.

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

[https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Import-GOContactItem.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/EasitGoWebservice/Import-GOContactItem.ps1)

