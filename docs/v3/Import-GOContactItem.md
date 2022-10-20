---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Import-GOContactItem.md
schema: 2.0.0
---

# Import-GOContactItem

## SYNOPSIS

Send data to a importhandler configured in Easit BPS / Easit GO.

## SYNTAX

```powershell
Import-GOContactItem [-url <String>] [-apikey <String>] [-ImportHandlerIdentifier <String>]
 [-ConfigurationDirectory <String>] [-FirstName <String>] [-Surname <String>] [-Email <String>] [-ID <Int32>]
 [-SecId <String>] [-OrganizationID <String>] [-Category <String>] [-Position <String>] [-ManagerID <String>]
 [-Impact <String>] [-PreferredMethodForNotification <String>] [-Building <String>]
 [-Checkbox_Authorized_Purchaser <String>] [-Checkbox_Responsible_Manager <String>] [-Deparment <String>]
 [-ExternalId <String>] [-FQDN <String>] [-Inactive <String>] [-MobilePhone <String>] [-Note <String>]
 [-Phone <String>] [-Room <String>] [-Title <String>] [-Username <String>] [-uid <Int32>]
 [-Attachment <String>] [-dryRun] [<CommonParameters>]
```

## DESCRIPTION

**This command is considered deprecated as of the release of version 3 of the module EasitGoWebservice.<br>
This command will not get any new functionality and is used as a proxy for Import-GOItem. Please use Import-GOItem instead.**

Update and create contacts in Easit BPS / Easit GO. Specify 'ID' to update an existing contact.<br>
This command used SOAP/XML and Invoke-WebRequest to communicate with the web service in BPS / GO.

## EXAMPLES

### EXAMPLE 1

```powershell
Import-GOContactItem -url 'http://localhost/webservice/' -apikey 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618' -ImportHandlerIdentifier 'CreateContact' -OrganizationID 12 -Position 'Manager' -Deparment 'Support' -FirstName 'Test' -Surname 'Testsson' -Username 'te12te' -SecId '97584621'
```

### EXAMPLE 2

```powershell
$url = 'http://localhost/webservice/'
$apikey = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
Import-GOContactItem -url "$url" -apikey "$apikey" -ihi 'CreateContact' -ID 649 -Inactive 'true'
```

### EXAMPLE 3

```powershell
$importEasitItem = @{
    url = 'http://localhost/webservice/'
    api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
    ImportHandlerIdentifier = 'CreateContact'
    ID = 649
    Surname = 'Andersson'
    Email = 'test.anders@company.com'
    FQDN = "$FQDN"
}
Import-GOContactItem @importEasitItem
```

### EXAMPLE 4

```powershell
$importEasitItem = @{
    url = 'http://localhost/webservice/'
    api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
    ImportHandlerIdentifier = 'CreateContact'
}
Import-GOContactItem @importEasitItem -ID 156 -Inactive 'false' -Responsible_Manager 'true'
```

### EXAMPLE 5

```powershell
$importEasitItem = @{
    ImportHandlerIdentifier = 'CreateContact'
}
Import-GOContactItem @importEasitItem -ID 156 -Inactive 'false' -Responsible_Manager 'true'
```

In this example we have a configuration file located in our users home directory with the url and apikey.

### EXAMPLE 6

```powershell
Import-GOContactItem
    -ImportHandlerIdentifier 'CreateContact'
    -ID '456'
    -Attachment 'file;C:\Path\To\Attachment.docx','base64;filename.txt;base64stringofattachment'
```

In this example we have a configuration file located in our users home directory with the url and apikey.\
We are updating an contact with ID 456 with 2 attachments.

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

First name of contact in Easit BPS / Easit GO.

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

ID for contact in Easit BPS / Easit GO.

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

1. Minor
2. Medium
3. Major

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

ID for organization to which the contact belongs to.<br>
Can be found on the organization in Easit BPS / Easit GO.

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

### -Surname

Last name of contact in Easit BPS / Easit GO.

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

Unique ID for object during import.

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

URL to Easit BPS / Easit GO web service.

```yaml
Type: String
Parameter Sets: (All)
Aliases: uri

Required: False
Position: Named
Default value: http://localhost/webservice/
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

### None. You cannot pipe objects to this function.

## OUTPUTS

### PSCustomObject

## NOTES

Copyright 2022 Easit AB

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

[Source code](https://github.com/easitab/EasitGoWebservice/blob/main/source/private/Import-GOContactItem.ps1)
