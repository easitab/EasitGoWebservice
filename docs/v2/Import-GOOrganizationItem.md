---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/development/docs/v2/Import-GOOrganizationItem.md
schema: 2.0.0
---

# Import-GOOrganizationItem

## SYNOPSIS

Send data to Easit BPS / Easit GO with web services.

## SYNTAX

```
Import-GOOrganizationItem [-url <String>] [-apikey <String>] [-ImportHandlerIdentifier <String>]
 [-ConfigurationDirectory <String>] [-Country <String>] [-Category <String>] [-Status <String>]
 [-ParentItemID <Int32>] [-MainContractID <String>] [-ID <String>] [-AnvNamn <String>]
 [-BusinessDebit <String>] [-Counterpart <String>] [-CustomerNumber <String>] [-DeliveryAddress <String>]
 [-DeliveryCity <String>] [-DeliveryZipCode <String>] [-ExternalId <String>] [-Fax <String>] [-Losen <String>]
 [-Name <String>] [-Notes <String>] [-Ort <String>] [-Phone <String>] [-PostNummer <String>]
 [-ResponsibilityDebit <String>] [-UtdelningsAdress <String>] [-VisitingAddress <String>]
 [-VisitingCity <String>] [-VisitingZipCode <String>] [-Webshop <String>] [-Website <String>]
 [-AccountManager <String>] [-ServiceManager <String>] [-uid <Int32>] [-Attachment <String>] [-SSO]
 [-UseBasicParsing] [-dryRun] [<CommonParameters>]
```

## DESCRIPTION

Update and / or create organizations in Easit BPS / Easit GO. Specify 'ID' to update an existing asset.

## EXAMPLES

### EXAMPLE 1

Creates a new organization with *Name* as 'IT and things', *CustomerNumber* as '1648752', *BusinessDebit* as '4687', *Country* as 'Sverige' *Status* as 'Active' and as a *child* to the organization with ID 124, all verbose message will be shown and the ID for the new organization will be returned to host.

```powershell
Import-GOOrganizationItem -url 'http://localhost/webservice/' -apikey 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618' -ImportHandlerIdentifier 'CreateOrganization' -Name 'IT and things' -ParentItemID '124' -CustomerNumber '1648752' -BusinessDebit '4687' -Country 'Sverige' -Status 'Active' -Verbose -ShowDetails
```

### EXAMPLE 2

Creates a new organization with *Name* as 'Stuff and IT', *CustomerNumber* as '4678524' and *BusinessDebit* as '1684'. It will set a existing contact with the email 'account.manager@company.com' as *AccountManager*, it will set an existing contract with ID '85' as *MainContract* and an existing user with username 'username123' as *ServiceManager*.

```powershell
$url = 'http://localhost/webservice/'
$apikey = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
Import-GOOrganizationItem -url "$url" -apikey "$apikey" -ihi 'CreateOrganizationExternal' -Name 'Stuff and IT' -CustomerNumber '4678524' -BusinessDebit '1684' -AccountManager 'account.manager@company.com' -MainContractID '85' -ServiceManager 'username123'
```

### EXAMPLE 3

Updates the organization with ID 467 the values from parameters *Category* and *Status*.

```powershell
$importEasitItem = @{
    url = 'http://localhost/webservice/'
    api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
    ImportHandlerIdentifier = 'CreateOrganizationSupplier'
    ID = '467'
    Category = 'Food'
    Status = 'Active'
}
Import-GOOrganizationItem @importEasitItem
```

### EXAMPLE 4

Updates the organization with ID 156 to have 'Inactive' as *Status*.

```powershell
$importEasitItem = @{
    url = 'http://localhost/webservice/'
    api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
    ImportHandlerIdentifier = 'CreateOrganizationSupplier'
    ID = '156'
}
Import-GOOrganizationItem @importEasitItem -Status 'Inactive'
```

### EXAMPLE 5

```powershell
$importEasitItem = @{
    ImportHandlerIdentifier = 'CreateOrganizationSupplier'
    ID = '156'
}
Import-GOOrganizationItem @importEasitItem -Status 'Inactive'
```

In this example we have a configuration file located in our users home directory with the url and apikey.

### EXAMPLE 6

```powershell
Import-GOOrganizationItem
    -ImportHandlerIdentifier 'CreateOrganizationSupplier'
    -ID '456'
    -Attachment 'file;C:\Path\To\Attachment.docx','base64;filename.txt;base64stringofattachment'
```

In this example we have a configuration file located in our users home directory with the url and apikey.\
We are updating an supplier with ID 456 with 2 attachments.

## PARAMETERS

### -AccountManager

Email or username of user that should be used as AccountManager.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Kundansvarig

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AnvNamn

Username at organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: UserName

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

### -BusinessDebit

BusinessDebit for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Verksamhetdebet

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Category

Category of organization.

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

### -Counterpart

Counterpart for organization.

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

### -Country

Country that organization is located in or belongs to.

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

### -CustomerNumber

Organization customer number

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

### -DeliveryAddress

Delivery address for organization.

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

### -DeliveryCity

Delivery city for organization (Leveransadress).

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

### -DeliveryZipCode

Delivery zip code for organization.

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

### -ExternalId

External id for organization.
Can be used as unique identifier for integrations with other systems.

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

### -Fax

Fax number for organization.

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

ID of organization in Easit BPS / Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: OrganizationID

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
Default value: CreateOrganization_Internal
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Losen

Password at organization website.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Password

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MainContractID

ID of main contract that organization is connected to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Contract

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name

Name of organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Namn

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Notes

Notes for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Anteckningar

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Ort

City for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: City

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentItemID

ID of parent organisation to organization.

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

### -Phone

Phone number for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Telefon

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PostNummer

Postal number for organization.

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

### -ResponsibilityDebit

Responsibility debit for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Ansvardebet

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceManager

Email or username of user that should be used as ServiceManager.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Serviceansvarig

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Status

Status of organization.

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

Parameter to specify what value to set as attribut UID and id for the XML property ItemToImport.

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
Default value: Http://localhost/webservice/
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

### -UtdelningsAdress

Delivery address for organization (Utdelningsadress).

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

### -VisitingAddress

Visiting address for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Besoksadress

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VisitingCity

Visiting city for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Besoksort

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VisitingZipCode

Visiting zip code for organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Besokspostnummer

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Webshop

URL to organizations webshop.

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

### -Website

URL to organizations website.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Webb, homepage

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### System.Int32
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

[https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Import-GOOrganizationItem.ps1](https://github.com/easitab/EasitGoWebservice/blob/development/source/public/Import-GOOrganizationItem.ps1)
