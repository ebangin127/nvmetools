unit View.Tab.Basic;

interface

uses
  SysUtils,
  View.Tab, Device.SMART.List, Getter.SlotSpeed;

type
  TBasicTab = class sealed(TTab)
  private
    function GetModel: String;
    function GetFirmwareRevision: String;
    function GetSerialNumber: String;
    function GetPCICurrentSpeed(const Current: TSlotSpeed): String;
    function GetPCIMaxSpeed(const Maximum: TSlotSpeed): String;
    function GetStatus: String;
    procedure FillBasics;
    procedure FillPCIStatus;
    procedure FillFinalStatus;
    function GetSlotSpeed: TSlotMaxCurrSpeed;
  protected
    procedure FillTab; override;
  end;

implementation

uses
  LanguageStrings;

{ TBasicTab }

procedure TBasicTab.FillTab;
begin
  FillBasics;
  FillPCIStatus;
  FillFinalStatus;
end;

procedure TBasicTab.FillBasics;
begin
  AddRow(Model[CurrLang], GetModel);
  AddRow(FirmwareRevision[CurrLang], GetFirmwareRevision);
  AddRow(SerialNumber[CurrLang], GetSerialNumber);
end;

procedure TBasicTab.FillPCIStatus;
var
  SlotSpeed: TSlotMaxCurrSpeed;
begin
  SlotSpeed := GetSlotSpeed;
  AddRow(PCICurrentSpeed[CurrLang], GetPCICurrentSpeed(SlotSpeed.Current));
  AddRow(PCIMaxSpeed[CurrLang], GetPCIMaxSpeed(SlotSpeed.Maximum));
end;

function TBasicTab.GetSlotSpeed: TSlotMaxCurrSpeed;
var
  SlotSpeedGetter: TSlotSpeedGetter;
begin
  SlotSpeedGetter := TSlotSpeedGetter.Create(
    GetSelectedDrive.GetPathOfFileAccessing);
  result := SlotSpeedGetter.GetSlotSpeed;
  FreeAndNil(SlotSpeedGetter);
end;

procedure TBasicTab.FillFinalStatus;
begin
  AddRow(Status[CurrLang], GetStatus);
end;

function TBasicTab.GetModel: String;
begin
  result := GetSelectedDrive.IdentifyDeviceResult.Model;
end;

function TBasicTab.GetFirmwareRevision: String;
begin
  result := GetSelectedDrive.IdentifyDeviceResult.Firmware;
end;

function TBasicTab.GetSerialNumber: String;
begin
  result := GetSelectedDrive.IdentifyDeviceResult.Serial;
end;

function TBasicTab.GetPCICurrentSpeed(const Current: TSlotSpeed): String;
begin
  result :=
    SlotSpecificationString[Current.SpecVersion] + ' x' +
    IntToStr(Ord(Current.LinkWidth));
end;

function TBasicTab.GetPCIMaxSpeed(const Maximum: TSlotSpeed): String;
begin
  result :=
    SlotSpecificationString[Maximum.SpecVersion] + ' x' +
    IntToStr(Ord(Maximum.LinkWidth));
end;

function TBasicTab.GetStatus: String;
var
  SMARTList: TSMARTValueList;
const
  CriticalWarningID = 0;
  AvailableSpare = 2;
begin
  SMARTList := GetSelectedDrive.GetSMARTList;
  if SMARTList[CriticalWarningID].RAW = 0 then
    result := Normal[CurrLang]
  else
    result := Warning[CurrLang];
  result := result + IntToStr(SMARTList[AvailableSpare].RAW) + '%)';
end;

end.
