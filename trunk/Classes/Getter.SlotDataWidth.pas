unit Getter.SlotDataWidth;

interface

uses
  Windows, ActiveX, ComObj, Variants, SysUtils, Dialogs,
  OSFile, Getter.PhysicalDriveList, Device.PhysicalDrive,
  Device.PhysicalDrive.List, CommandSet.Factory;

type
  TSlotDataWidth = (
    Other = $1, Unknown = $2,
    PCI8b = $3, PCI16b = $4, PCI32b = $5, PCI64b = $6, PCI128b = $7,
    PCIX1x = $8, PCIX2x = $9, PCIX4x = $A, PCIX8x = $B, PCIX12x = $C,
    PCIX16x = $D, PCIX32x = $E);

  TSlotDataWidthGetter = class sealed(TOSFile)
  public
    function GetSlotDataWidth: TSlotDataWidth;
  private
    SlotDataWidth: Cardinal;
    function ConnectToWMIObjectByMoniker: IDispatch;
    function GetStorageDeviceID(WMIObject: IDispatch): String;
    function GetDefaultMonikerFromObjectPath(ObjectPath: String;
      BindableContext: IBindCtx): IMoniker;
    function GetLocalhostWMIRepositoryURI: String;
    function GetMonikerBindableContext: IBindCtx;
    function GetReferredObjectByMoniker(DefaultMoniker: IMoniker;
      BindableContext: IBindCtx): IDispatch;
    procedure TryToGetSlotDataWidth;
    function GetControllerDeviceID(WMIObject: IDispatch;
      StorageDeviceID: String): String;
    function GetSlotDataWidthByNumber(WMIObject: IDispatch;
      BusNumber: String): Cardinal;
    function GetBusNumber(WMIObject: IDispatch;
      ControllerDeviceID: String): String;
    procedure CheckDataWidth;
  end;

const
  SlotDataWidthString: Array[TSlotDataWidth] of String = (
    'Other', 'Unknown',
    'PCI 8bit', 'PCI 16bit', 'PCI 32bit', 'PCI 64bit', 'PCI 128bit',
    'PCI Express 1x', 'PCI Express 2x', 'PCI Express 4x', 'PCI Express 8x',
    'PCI Express 12x', 'PCI Express 16x', 'PCI Express 32x');

implementation

{ TDeviceDriverGetter }

function TSlotDataWidthGetter.GetSlotDataWidth: TSlotDataWidth;
begin
  try
    TryToGetSlotDataWidth;
  except
    SlotDataWidth := Cardinal(TSlotDataWidth.Unknown);
  end;
  CheckDataWidth;
  result := TSlotDataWidth(SlotDataWidth);
end;

procedure TSlotDataWidthGetter.TryToGetSlotDataWidth;
var
  WMIObject: IDispatch;
  StorageDeviceID: String;
  ControllerDeviceID: String;
  SlotNumber: String;
begin
  WMIObject := ConnectToWMIObjectByMoniker;
  StorageDeviceID := GetStorageDeviceID(WMIObject);
  ControllerDeviceID := GetControllerDeviceID(WMIObject, StorageDeviceID);
  SlotNumber := GetBusNumber(WMIObject, ControllerDeviceID);
  SlotDataWidth := GetSlotDataWidthByNumber(WMIObject, SlotNumber);
end;

function TSlotDataWidthGetter.ConnectToWMIObjectByMoniker: IDispatch;
var
  ContextToBindMoniker: IBindCtx;
  DefaultMoniker: IMoniker;
begin
  ContextToBindMoniker := GetMonikerBindableContext;
  DefaultMoniker :=
    GetDefaultMonikerFromObjectPath(
      GetLocalhostWMIRepositoryURI,
      ContextToBindMoniker);
  result :=
    GetReferredObjectByMoniker(
      DefaultMoniker,
      ContextToBindMoniker);
end;

function TSlotDataWidthGetter.GetMonikerBindableContext: IBindCtx;
const
  ReservedAndMustBeZero = 0;
begin
  OleCheck(CreateBindCtx(ReservedAndMustBeZero, result));
end;

function TSlotDataWidthGetter.GetDefaultMonikerFromObjectPath
  (ObjectPath: String; BindableContext: IBindCtx): IMoniker;
var
  LengthOfURISuccessfullyParsed: Integer;
begin
  OleCheck(
    MkParseDisplayName(BindableContext,
      PWideChar(ObjectPath),
      LengthOfURISuccessfullyParsed,
      result));
end;

function TSlotDataWidthGetter.GetLocalhostWMIRepositoryURI: String;
const
  WMIService = 'winmgmts:\\';
  Localhost = 'localhost\';
  WMIRepositoryPrefix = 'root\cimv2';
begin
  result := WMIService + Localhost + WMIRepositoryPrefix;
end;

function TSlotDataWidthGetter.GetReferredObjectByMoniker
  (DefaultMoniker: IMoniker; BindableContext: IBindCtx): IDispatch;
begin
  OleCheck(
    DefaultMoniker.BindToObject(BindableContext, nil, IUnknown, result));
end;

function TSlotDataWidthGetter.GetStorageDeviceID(WMIObject: IDispatch):
  String;
const
  PreQuery = 'ASSOCIATORS OF {Win32_DiskDrive.DeviceID=''';
  PostQuery = '''} WHERE ResultClass=Win32_PnPEntity';
  OneDeviceInformationNeeded = 1;
var
  ResultAsOleVariant: OleVariant;
  EnumVariant: IEnumVARIANT;
  CurrentDevice: OleVariant;
  DeviceReturned: Cardinal;
begin
  ResultAsOleVariant :=
    OleVariant(WMIObject).ExecQuery(PreQuery + GetPathOfFileAccessing +
      PostQuery);
  EnumVariant :=
    IUnknown(ResultAsOleVariant._NewEnum) as IEnumVARIANT;
  EnumVariant.Next(OneDeviceInformationNeeded, CurrentDevice,
    DeviceReturned);
  result := CurrentDevice.DeviceID;
end;

function TSlotDataWidthGetter.GetControllerDeviceID(WMIObject: IDispatch;
  StorageDeviceID: String): String;
const
  PreQuery = 'ASSOCIATORS OF {Win32_PnPEntity.DeviceID=''';
  PostQuery = '''} WHERE AssocClass=Win32_SCSIControllerDevice';
  OneDeviceInformationNeeded = 1;
var
  ResultAsOleVariant: OleVariant;
  EnumVariant: IEnumVARIANT;
  CurrentDevice: OleVariant;
  DeviceReturned: Cardinal;
begin
  ResultAsOleVariant :=
    OleVariant(WMIObject).ExecQuery(PreQuery + StorageDeviceID +
      PostQuery);
  EnumVariant :=
    IUnknown(ResultAsOleVariant._NewEnum) as IEnumVARIANT;
  EnumVariant.Next(OneDeviceInformationNeeded, CurrentDevice,
    DeviceReturned);
  result := CurrentDevice.DeviceID;
end;

function TSlotDataWidthGetter.GetBusNumber(WMIObject: IDispatch;
  ControllerDeviceID: String): String;
const
  PreQuery = 'ASSOCIATORS OF {Win32_PnPEntity.DeviceID=''';
  PostQuery = '''} WHERE AssocClass=Win32_DeviceBus';
  OneDeviceInformationNeeded = 1;
var
  ResultAsOleVariant: OleVariant;
  EnumVariant: IEnumVARIANT;
  CurrentDevice: OleVariant;
  DeviceReturned: Cardinal;
begin
  ResultAsOleVariant :=
    OleVariant(WMIObject).ExecQuery(PreQuery + ControllerDeviceID +
      PostQuery);
  EnumVariant :=
    IUnknown(ResultAsOleVariant._NewEnum) as IEnumVARIANT;
  EnumVariant.Next(OneDeviceInformationNeeded, CurrentDevice,
    DeviceReturned);
  result := CurrentDevice.BusNum;
end;

procedure TSlotDataWidthGetter.CheckDataWidth;
begin
  if (TSlotDataWidth(SlotDataWidth) < TSlotDataWidth.Other) or
     (TSlotDataWidth(SlotDataWidth) > TSlotDataWidth.PCIX32x) then
        raise EInvalidCast.Create('Invalid Data Width: ' +
          IntToStr(SlotDataWidth));
end;

function TSlotDataWidthGetter.GetSlotDataWidthByNumber(WMIObject: IDispatch;
  BusNumber: String): Cardinal;
const
  PreQuery = 'SELECT * FROM Win32_SystemSlot WHERE BusNumber=''';
  PostQuery = '''';
  OneDeviceInformationNeeded = 1;
var
  ResultAsOleVariant: OleVariant;
  EnumVariant: IEnumVARIANT;
  CurrentDevice: OleVariant;
  DeviceReturned: Cardinal;
  Query: String;
begin
  BusNumber := StringReplace(BusNumber, '\', '\\',
    [rfReplaceAll]);
  Query := PreQuery + BusNumber + PostQuery;
  ResultAsOleVariant := OleVariant(WMIObject).ExecQuery(Query);
  EnumVariant :=
    IUnknown(ResultAsOleVariant._NewEnum) as IEnumVARIANT;
  EnumVariant.Next(OneDeviceInformationNeeded, CurrentDevice,
    DeviceReturned);
  result := StrToUInt64(String(CurrentDevice.MaxDataWidth)) + 3;
end;

end.
