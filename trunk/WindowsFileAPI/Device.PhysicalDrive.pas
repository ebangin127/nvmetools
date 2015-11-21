unit Device.PhysicalDrive;

interface

uses
  Windows, SysUtils,
  Device.BusPhysicalDrive, Device.OSPhysicalDrive,
  OSFile, OSFile.Interfaced,
  Getter.DiskGeometry, Getter.PartitionList, Getter.DriveAvailability,
  BufferInterpreter, Device.SMART.List, Getter.NCQAvailability;

type
  IPhysicalDrive = interface
    function GetDiskSizeInByte: TLargeInteger;
    function GetIsDriveAvailable: Boolean;
    function GetIdentifyDeviceResult: TIdentifyDeviceResult;
    function GetNCQAvailability: TNCQAvailability;
    function GetPathOfFileAccessing: String;
    function GetPathOfFileAccessingWithoutPrefix: String;

    property IdentifyDeviceResult: TIdentifyDeviceResult
      read GetIdentifyDeviceResult;

    property DiskSizeInByte: TLargeInteger
      read GetDiskSizeInByte;
    property IsDriveAvailable: Boolean
      read GetIsDriveAvailable;
    property NCQAvailability: TNCQAvailability
      read GetNCQAvailability;
    function GetPartitionList: TPartitionList;
    function GetSMARTList: TSMARTValueList;
  end;

  TPhysicalDrive = class(TInterfacedOSFile, IPhysicalDrive)
  private
    OSPhysicalDrive: TOSPhysicalDrive;
    BusPhysicalDrive: TBusPhysicalDrive;

    function GetDiskSizeInByte: TLargeInteger;
    function GetIsDriveAvailable: Boolean;
    function GetIdentifyDeviceResult: TIdentifyDeviceResult;
    function GetNCQAvailability: TNCQAvailability;

  public
    property IdentifyDeviceResult: TIdentifyDeviceResult
      read GetIdentifyDeviceResult;

    property DiskSizeInByte: TLargeInteger
      read GetDiskSizeInByte;
    property IsDriveAvailable: Boolean
      read GetIsDriveAvailable;
    property NCQAvailability: TNCQAvailability
      read GetNCQAvailability;
    function GetPartitionList: TPartitionList;
    function GetSMARTList: TSMARTValueList;

    constructor Create(FileToGetAccess: String); override;
    class function BuildFileAddressByNumber(DriveNumber: Cardinal): String;
    destructor Destroy; override;

  end;

implementation

{ TPhysicalDrive }

constructor TPhysicalDrive.Create(FileToGetAccess: String);
begin
  inherited Create(FileToGetAccess);
  BusPhysicalDrive := TBusPhysicalDrive.Create(FileToGetAccess);
  OSPhysicalDrive := TOSPhysicalDrive.Create(FileToGetAccess);
end;

class function TPhysicalDrive.BuildFileAddressByNumber(
  DriveNumber: Cardinal): String;
begin
  result :=
    ThisComputerPrefix + PhysicalDrivePrefix + UIntToStr(DriveNumber);
end;

destructor TPhysicalDrive.Destroy;
begin
  if OSPhysicalDrive <> nil then
    FreeAndNil(OSPhysicalDrive);
  if BusPhysicalDrive <> nil then
    FreeAndNil(BusPhysicalDrive);
  inherited;
end;

function TPhysicalDrive.GetDiskSizeInByte: TLargeInteger;
begin
  result := OSPhysicalDrive.DiskSizeInByte;
end;

function TPhysicalDrive.GetNCQAvailability: TNCQAvailability;
begin
  result := OSPhysicalDrive.NCQAvailability;
end;

function TPhysicalDrive.GetIsDriveAvailable: Boolean;
begin
  result := OSPhysicalDrive.IsDriveAvailable;
end;

function TPhysicalDrive.GetPartitionList: TPartitionList;
begin
  result := OSPhysicalDrive.GetPartitionList;
end;

function TPhysicalDrive.GetIdentifyDeviceResult: TIdentifyDeviceResult;
begin
  result := BusPhysicalDrive.IdentifyDeviceResult;
end;

function TPhysicalDrive.GetSMARTList: TSMARTValueList;
begin
  BusPhysicalDrive.ClearCache;
  result := BusPhysicalDrive.SMARTValueList;
end;

end.

