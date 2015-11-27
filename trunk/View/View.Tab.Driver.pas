unit View.Tab.Driver;

interface

uses
  View.Tab, Getter.DeviceDriver;

type
  TDriverTab = class sealed(TTab)
  private
    function GetDeviceDriver: TDeviceDriver;
  protected
    procedure FillTab; override;
  end;

implementation

uses
  LanguageStrings;

{ TDriverTab }

procedure TDriverTab.FillTab;
var
  DeviceDriver: TDeviceDriver;
begin
  DeviceDriver := GetDeviceDriver;
  AddRow(DriverName[CurrLang], DeviceDriver.Name);
  AddRow(DriverVendor[CurrLang], DeviceDriver.Provider);
  AddRow(DriverDate[CurrLang], DeviceDriver.Date);
  AddRow(DriverFileName[CurrLang], DeviceDriver.InfName);
  AddRow(DriverVersion[CurrLang], DeviceDriver.Version);
end;

function TDriverTab.GetDeviceDriver: TDeviceDriver;
var
  DeviceDriverGetter: TDeviceDriverGetter;
begin
  DeviceDriverGetter := TDeviceDriverGetter.Create(
    GetSelectedDrive.GetPathOfFileAccessing);
  result := DeviceDriverGetter.GetDeviceDriver;
  DeviceDriverGetter.Free;
end;

end.
