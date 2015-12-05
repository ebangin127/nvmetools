unit CommandSet.NVMe.Intel;

interface

uses
  Windows, SysUtils,
  OSFile.IoControl, CommandSet, BufferInterpreter, Device.SMART.List,
  CommandSet.NVMe, CommandSet.NVMe.Intel.PortPart,
  Getter.SCSIAddress;

type
  TIntelNVMeCommandSet = class sealed(TNVMeCommandSet)
  private
    function GetPortIdentifyDevice: TIdentifyDeviceResult;
  public
    function IdentifyDevice: TIdentifyDeviceResult; override;
    function SMARTReadData: TSMARTValueList; override;
  end;

implementation

{ TIntelNVMeCommandSet }

const
  SCSIPrefix = '\\.\SCSI';
  SCSIPostfix = ':';

function TIntelNVMeCommandSet.IdentifyDevice: TIdentifyDeviceResult;
var
  ReadCapacityResult: TIdentifyDeviceResult;
begin
  result := GetPortIdentifyDevice;
  SetBufferAndReadCapacity;
  ReadCapacityResult := InterpretReadCapacityBuffer;
  result.UserSizeInKB := ReadCapacityResult.UserSizeInKB;
  result.LBASize := ReadCapacityResult.LBASize;
  result.IsDataSetManagementSupported := IsDataSetManagementSupported;
end;

function TIntelNVMeCommandSet.GetPortIdentifyDevice: TIdentifyDeviceResult;
var
  PortCommandSet: TIntelNVMePortCommandSet;
  SCSIAddressGetter: TSCSIAddressGetter;
begin
  SCSIAddressGetter := TSCSIAddressGetter.Create(
    GetPathOfFileAccessing);
  PortCommandSet := TIntelNVMePortCommandSet.Create(
    SCSIPrefix + IntToStr(SCSIAddressGetter.GetSCSIAddress.PortNumber) +
    SCSIPostFix);
  result := PortCommandSet.IdentifyDevice;
  FreeAndNil(PortCommandSet);
  FreeAndNil(SCSIAddressGetter);
end;

function TIntelNVMeCommandSet.SMARTReadData: TSMARTValueList;
var
  PortCommandSet: TIntelNVMePortCommandSet;
  SCSIAddressGetter: TSCSIAddressGetter;
begin
  SCSIAddressGetter := TSCSIAddressGetter.Create(
    GetPathOfFileAccessing);
  PortCommandSet := TIntelNVMePortCommandSet.Create(
    SCSIPrefix + IntToStr(SCSIAddressGetter.GetSCSIAddress.PortNumber) +
    SCSIPostFix);
  result := PortCommandSet.SMARTReadData;
  FreeAndNil(PortCommandSet);
  FreeAndNil(SCSIAddressGetter);
end;

end.
