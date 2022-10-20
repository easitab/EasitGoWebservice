---
external help file: EasitGoWebservice-help.xml
Module Name: EasitGoWebservice
online version: https://github.com/easitab/EasitGoWebservice/blob/main/docs/v3/Import-GOAssetItem.md
schema: 2.0.0
---

# Import-GOAssetItem

## SYNOPSIS

Send data to a importhandler configured in Easit BPS / Easit GO.

## SYNTAX

```powershell
Import-GOAssetItem [-url <String>] [-apikey <String>] [-ImportHandlerIdentifier <String>]
 [-ConfigurationDirectory <String>] [-ID <Int32>] [-AssetType <String>] [-AssetInvoicingPeriod <String>]
 [-AssetSupplierOrganizationID <Int32>] [-Impact <String>] [-Manufacturer <String>] [-OwnerContactID <Int32>]
 [-OwnerOrganizationID <Int32>] [-PriceListConnectionID <Int32>] [-Status <String>] [-CityLocation <String>]
 [-HouseLocation <String>] [-FinLifteTime <String>] [-LifeCycle <String>] [-ActivityDebit <String>]
 [-AssetName <String>] [-AssetStartDate <String>] [-BarCode <String>] [-CIReference <String>]
 [-Description <String>] [-FinancialNotes <String>] [-LastInventoryDate <String>] [-ObjectDebit <String>]
 [-ProjectDebit <String>] [-PurchaseDate <String>] [-PurchaseOrderNumber <String>]
 [-PurchaseValueCurrency <String>] [-RoomLocation <String>] [-SerialNumber <String>]
 [-SupplierInvoiceId <String>] [-TheftId <String>] [-WarrantyExpireDate <String>] [-ModelMonitor <String>]
 [-MonitorType <String>] [-MonitorSize <String>] [-MonitorResolution <String>]
 [-ConectionType_Monitor <String>] [-OperatingSystem <String>] [-Equipment <String>] [-ModelPC <String>]
 [-ComputerType <String>] [-HardriveSize <Int32>] [-InternalMemory <Int32>] [-ProcessorSpeed <String>]
 [-SLA <String>] [-SLAExpiredate <String>] [-UserLogin <String>] [-UserPassword <SecureString>]
 [-AssetPhoneModel <String>] [-AssetPhoneType <String>] [-Operator <String>] [-IMEINumber <String>]
 [-MobilePhoneNumber <String>] [-PhoneNumber <String>] [-PukCode <String>] [-ModelPrinter <String>]
 [-IPAdress <String>] [-MacAddress <String>] [-NetworkName <String>] [-ModelServer <String>]
 [-DNSName <String>] [-ServiceBlackout <String>] [-uid <Int32>] [-Attachment <String>]
 [-dryRun] [<CommonParameters>]
```

## DESCRIPTION

**This command is considered deprecated as of the release of version 3 of the module EasitGoWebservice.<br>
This command will not get any new functionality and is used as a proxy for Import-GOItem. Please use Import-GOItem instead.**

Update or create an asset in Easit BPS / Easit GO. Specify 'ID' to update an existing asset.<br>
This command used SOAP/XML and Invoke-WebRequest to communicate with the web service in BPS / GO.

## EXAMPLES

### EXAMPLE 1

```powershell
Import-GOAssetItem -url 'http://localhost/webservice/' -apikey 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618' -ImportHandlerIdentifier 'CreateAssetGeneral' -AssetName "Test" -SerialNumber "SN-467952" -Description "One general asset." -Status "Active"
```

### EXAMPLE 2

```powershell
$url = 'http://localhost/webservice/'
$apikey = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
Import-GOAssetItem -url "$url" -apikey "$apikey" -ihi 'CreateAssetServer' -AssetStartDate '2018-06-26' -InternalMemory '32' -HardriveSize '500' -Status 'Active'
```

### EXAMPLE 3

```powershell
$importEasitItem = @{
    url = 'http://localhost/webservice/'
    api = 'a8d5eba7f4daa79ea6f1c17c6b453d17df9c27727610b142c70c51bb4eda3618'
    ImportHandlerIdentifier = 'CreateAssetPC' 
    ID = 45
    OperatingSystem = 'Windows 10'
    Status = 'Inactive'
}
Import-GOAssetItem @importEasitItem
```

### EXAMPLE 4

```powershell
$importEasitItem = @{
    url = "$url"
    apikey = "$api"
    ihi = "$identifier"
}
Import-GOAssetItem @importEasitItem -ID 156 -Status 'Inactive'
```

### EXAMPLE 5

```powershell
$importEasitItem = @{
    ihi = "$identifier"
}
Import-GOAssetItem @importEasitItem -ID 156 -Status 'Inactive'
```

In this example we have a configuration file located in our users home directory with the url and apikey.

### EXAMPLE 6

```powershell
Import-GOAssetItem
    -ImportHandlerIdentifier 'CreateAssetGeneral'
    -ID '456'
    -Attachment 'file;C:\Path\To\Attachment.docx','base64;filename.txt;base64stringofattachment'
```

In this example we have a configuration file located in our users home directory with the url and apikey.\
We are updating an asset with ID 456 with 2 attachments.

## PARAMETERS

### -ActivityDebit

Activity debit for asset.

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

### -AssetInvoicingPeriod

Invoicing period for asset.

```yaml
Type: String
Parameter Sets: (All)
Aliases: InvoicingPeriod

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetName

Name of asset.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetPhoneModel

Model of phone.

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

### -AssetPhoneType

Type of phone.

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

### -AssetStartDate

Contract start date for asset.
Format = yyyy-MM-dd

```yaml
Type: String
Parameter Sets: (All)
Aliases: StartDate

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetSupplierOrganizationID

ID of organization to be set as supplier of asset.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: SupplierOrganizationID

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AssetType

Type of asset.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type

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

### -BarCode

Bar code for asset.

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

### -CIReference

Reference ID for asset.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CI

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CityLocation

Location (City) of asset.

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

### -ComputerType

Type of PC/Computer.

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

### -ConectionType_Monitor

Conection type of monitor.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConectionTypeMonitor

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

### -Description

Description of asset.

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

### -DNSName

Server DNS name.

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

### -Equipment

Equipment of asset.

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

### -FinancialNotes

Financial notes for asset.

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

### -FinLifteTime

Financial lifte time of asset.

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

### -HardriveSize

Hardrive size of asset.

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

### -HouseLocation

Location (House) of asset.

```yaml
Type: String
Parameter Sets: (All)
Aliases: House

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ID

ID for asset in Easit BPS / Easit GO.

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

### -IMEINumber

IMEI number of phone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: IMEI

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Impact

Impact of asset.

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
Default value: CreateAssetGeneral
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InternalMemory

Internal memory of asset.

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

### -IPAdress

IP address to printer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: IP

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LastInventoryDate

Last inventory date of asset.
Format = yyyy-MM-dd

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

### -LifeCycle

Life cycle of asset.

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

### -MacAddress

Printer mac address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: MAC

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Manufacturer

Manufacturer of asset.

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

### -MobilePhoneNumber

Mobile phone number.

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

### -ModelMonitor

Model of monitor.

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

### -ModelPC

Model of PC/Computer.

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

### -ModelPrinter

Model of printer.

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

### -ModelServer

Model of server.

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

### -MonitorResolution

Resolution of monitor.

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

### -MonitorSize

Size of monitor.

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

### -MonitorType

Type of monitor.

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

### -NetworkName

Printer network name.

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

### -ObjectDebit

Object debit for asset.

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

### -OperatingSystem

Operating system for asset.

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

### -Operator

Operator for phone.

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

### -OwnerContactID

ID of contact to be set as owner of asset.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: OwnerContact

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OwnerOrganizationID

ID of organization to be set as owner of asset.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: OwnerOrganization

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PhoneNumber

Phone number.

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

### -PriceListConnectionID

ID of price list to connect with asset.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: PriceListConnection, PriceList

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProcessorSpeed

Processor speed of asset.

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

### -ProjectDebit

Project debit for asset.

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

### -PukCode

PUK code for phone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: puk

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PurchaseDate

Date of purchase of asset. Format = yyyy-MM-dd

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

### -PurchaseOrderNumber

Purchase order number of asset.

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

### -PurchaseValueCurrency

Purchase value of asset.

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

### -RoomLocation

Location (Room) of asset.

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

### -SerialNumber

Serial number for asset.

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

### -ServiceBlackout

Notes about when service is undergoing maintenance.

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

### -SLA

Service level agreement of asset.
Valid values = true / false.

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

### -SLAExpiredate

Expire date for SLA of asset.
Format: yyyy-MM-dd

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

### -Status

Status for asset.

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

### -SupplierInvoiceId

ID of invoice from supplier.

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

### -TheftId

Theft ID for asset.

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

### -UserLogin

Username of person using asset.

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

### -UserPassword

Password for person using asset.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WarrantyExpireDate

Date for when warranty of asset expires.
Format = yyyy-MM-dd

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

[Source code](https://github.com/easitab/EasitGoWebservice/blob/main/source/private/Import-GOAssetItem.ps1)