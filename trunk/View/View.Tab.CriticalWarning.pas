unit View.Tab.CriticalWarning;

interface

uses
  View.Tab, Device.SMART.List;

type
  TCriticalWarningTab = class sealed(TTab)
  private
    CriticalWarningValue: UInt64;
    function GetStringOfBoolean(const Value: Boolean): String;
    function GetBitFrom(const Source: UInt64; const BitOrder: Integer): Boolean;
    function GetAvailableSpaceError: String;
    function GetDeviceReliabilityDegraded: String;
    function GetReadOnlyMode: String;
    function GetTemperatureError: String;
    function GetVolatileMemoryFailed: String;
  protected
    procedure FillTab; override;
  end;

implementation

uses
  LanguageStrings;

{ TDriverTab }

procedure TCriticalWarningTab.FillTab;
const
  CriticalWarningID = 0;
begin
  CriticalWarningValue := GetSelectedDrive.GetSMARTList[CriticalWarningID].RAW;
  AddRow(AvailableSpaceError[CurrLang], GetAvailableSpaceError);
  AddRow(TemperatureError[CurrLang], GetTemperatureError);
  AddRow(DeviceReliabilityDegraded[CurrLang], GetDeviceReliabilityDegraded);
  AddRow(ReadOnlyMode[CurrLang], GetReadOnlyMode);
  AddRow(VolatileMemoryFailed[CurrLang], GetVolatileMemoryFailed);
end;

function TCriticalWarningTab.GetAvailableSpaceError: String;
const
  BitOrder = 0;
begin
  result := GetStringOfBoolean(GetBitFrom(CriticalWarningValue, BitOrder));
end;

function TCriticalWarningTab.GetTemperatureError: String;
const
  BitOrder = 1;
begin
  result := GetStringOfBoolean(GetBitFrom(CriticalWarningValue, BitOrder));
end;

function TCriticalWarningTab.GetDeviceReliabilityDegraded: String;
const
  BitOrder = 2;
begin
  result := GetStringOfBoolean(GetBitFrom(CriticalWarningValue, BitOrder));
end;

function TCriticalWarningTab.GetReadOnlyMode: String;
const
  BitOrder = 3;
begin
  result := GetStringOfBoolean(GetBitFrom(CriticalWarningValue, BitOrder));
end;

function TCriticalWarningTab.GetVolatileMemoryFailed: String;
const
  BitOrder = 4;
begin
  result := GetStringOfBoolean(GetBitFrom(CriticalWarningValue, BitOrder));
end;

function TCriticalWarningTab.GetBitFrom(const Source: UInt64;
  const BitOrder: Integer): Boolean;
begin
  result := ((Source shr BitOrder) and 1) <> 0;
end;

function TCriticalWarningTab.GetStringOfBoolean(const Value: Boolean): String;
begin
  if Value then
    result := Yes[CurrLang]
  else
    result := No[CurrLang];
end;

end.
