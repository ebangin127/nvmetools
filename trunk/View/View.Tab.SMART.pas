unit View.Tab.SMART;

interface

uses
  Classes, SysUtils,
  View.Tab, Device.SMART.List, MeasureUnit.DataSize;

type
  TSMARTTab = class sealed(TTab)
  private
    function GetRAWValues: TStringList;
    procedure FillSMARTValues(const ValueList: TStringList);
    function GetReadableValues(const ValueList: TStringList): TStringList;
    procedure SetCompositeTemperature(const ValueList: TStringList);
    procedure SetPercentValues(const ValueList: TStringList);
    procedure SetReadWriteLBAValues(const ValueList: TStringList);
    procedure SetReadWriteCounts(const ValueList: TStringList);
    procedure SetTimeValues(const ValueList: TStringList);
    procedure SetRepeatAndCounts(const ValueList: TStringList);
    type
      TSMARTID = (
        IDCompositeTemperature = 0,
        IDAvailableSpare,
        IDAvailableSpareThreshold,
        IDPercentageUsed,
        IDDataUnitsRead,
        IDDataUnitsWritten,
        IDHostReadCommands,
        IDHostWriteCommands,
        IDControllerBusyTime,
        IDPowerCycles,
        IDPowerOnHours,
        IDUnsafeShutdowns,
        IDIntegrityErrors,
        IDNumberOfErrorLogs);
  protected
    procedure FillTab; override;
  end;

implementation

uses
  LanguageStrings;

{ TSMARTTab }

procedure TSMARTTab.FillTab;
var
  ValueList: TStringList;
begin
  ValueList := GetRAWValues;
  ValueList := GetReadableValues(ValueList);
  FillSMARTValues(ValueList);
  FreeAndNil(ValueList);
end;

procedure TSMARTTab.FillSMARTValues(const ValueList: TStringList);
const
  NoCriticalWarning = 1;
begin
  AddRow(CompositeTemperature[CurrLang], ValueList[
    Ord(TSMARTID.IDCompositeTemperature)]);
  AddRow(AvailableSpare[CurrLang], ValueList[
    Ord(TSMARTID.IDAvailableSpare)]);
  AddRow(AvailableSpareThreshold[CurrLang], ValueList[
    Ord(TSMARTID.IDAvailableSpareThreshold)]);
  AddRow(PercentageUsed[CurrLang], ValueList[
    Ord(TSMARTID.IDPercentageUsed)]);
  AddRow(DataUnitsRead[CurrLang], ValueList[
    Ord(TSMARTID.IDDataUnitsRead)]);
  AddRow(DataUnitsWritten[CurrLang], ValueList[
    Ord(TSMARTID.IDDataUnitsWritten)]);
  AddRow(HostReadCommands[CurrLang], ValueList[
    Ord(TSMARTID.IDHostReadCommands)]);
  AddRow(HostWriteCommands[CurrLang], ValueList[
    Ord(TSMARTID.IDHostWriteCommands)]);
  AddRow(ControllerBusyTime[CurrLang], ValueList[
    Ord(TSMARTID.IDControllerBusyTime)]);
  AddRow(PowerCycles[CurrLang], ValueList[
    Ord(TSMARTID.IDPowerCycles)]);
  AddRow(PowerOnHours[CurrLang], ValueList[
    Ord(TSMARTID.IDPowerOnHours)]);
  AddRow(UnsafeShutdowns[CurrLang], ValueList[
    Ord(TSMARTID.IDUnsafeShutdowns)]);
  AddRow(IntegrityErrors[CurrLang], ValueList[
    Ord(TSMARTID.IDIntegrityErrors)]);
  AddRow(NumberOfErrorLogs[CurrLang], ValueList[
    Ord(TSMARTID.IDNumberOfErrorLogs)]);
end;

function TSMARTTab.GetRAWValues: TStringList;
var
  SMARTList: TSMARTValueList;
  SMARTValueIndex: Integer;
const
  NoCriticalWarning = 1;
  SMARTStartPoint = 0;
begin
  SMARTList := GetSelectedDrive.GetSMARTList;
  result := TStringList.Create;
  for SMARTValueIndex := 1 to SMARTList.Count - 1 do
  begin
    if SMARTList[SMARTValueIndex].ID <
      Ord(TSMARTID.IDAvailableSpare) + NoCriticalWarning then
        result.Add(UIntToStr(SMARTList[SMARTValueIndex].RAW))
    else if SMARTList[SMARTValueIndex].ID =
      Ord(TSMARTID.IDAvailableSpare) + NoCriticalWarning then
    begin
      result.Add(UIntToStr(SMARTList[SMARTValueIndex].RAW));
      result.Add(UIntToStr(SMARTList[SMARTValueIndex].Threshold));
    end
    else
      result.Add(UIntToStr(SMARTList[SMARTValueIndex].RAW));
  end;
end;

function TSMARTTab.GetReadableValues(const ValueList: TStringList): TStringList;
begin
  SetCompositeTemperature(ValueList);
  SetPercentValues(ValueList);
  SetReadWriteLBAValues(ValueList);
  SetReadWriteCounts(ValueList);
  SetTimeValues(ValueList);
  SetRepeatAndCounts(ValueList);
  result := ValueList;
end;

procedure TSMARTTab.SetCompositeTemperature(const ValueList: TStringList);
const
  KelvinToCelcius = 273;
begin
  ValueList[Ord(TSMARTID.IDCompositeTemperature)] :=
    IntToStr(StrToInt64(ValueList[Ord(TSMARTID.IDCompositeTemperature)]) -
      KelvinToCelcius) + ' ¡ÆC';
end;

procedure TSMARTTab.SetPercentValues(const ValueList: TStringList);
begin
  ValueList[Ord(TSMARTID.IDAvailableSpare)] :=
    ValueList[Ord(TSMARTID.IDAvailableSpare)] + ' %';
  ValueList[Ord(TSMARTID.IDAvailableSpareThreshold)] :=
    ValueList[Ord(TSMARTID.IDAvailableSpareThreshold)] + ' %';
  ValueList[Ord(TSMARTID.IDPercentageUsed)] :=
    ValueList[Ord(TSMARTID.IDPercentageUsed)] + ' %';
end;

procedure TSMARTTab.SetReadWriteLBAValues(const ValueList: TStringList);
  function LBAToMB(const SizeInLBA: Int64): Double;
  begin
    result := SizeInLBA * 0.5;
  end;
const
  BinaryPoint2: TFormatSizeSetting = (FNumeralSystem: Binary; FPrecision: 1);
begin
  ValueList[Ord(TSMARTID.IDDataUnitsRead)] := FormatSizeInMB(LBAToMB(
    StrToInt64(ValueList[Ord(TSMARTID.IDDataUnitsRead)])), BinaryPoint2);
  ValueList[Ord(TSMARTID.IDDataUnitsWritten)] := FormatSizeInMB(LBAToMB(
    StrToInt64(ValueList[Ord(TSMARTID.IDDataUnitsWritten)])), BinaryPoint2);
end;

procedure TSMARTTab.SetReadWriteCounts(const ValueList: TStringList);
begin
  ValueList[Ord(TSMARTID.IDHostReadCommands)] :=
    ValueList[Ord(TSMARTID.IDHostReadCommands)] + ' ' + Counts[CurrLang];
  ValueList[Ord(TSMARTID.IDHostWriteCommands)] :=
    ValueList[Ord(TSMARTID.IDHostWriteCommands)] + ' ' + Counts[CurrLang];
end;

procedure TSMARTTab.SetTimeValues(const ValueList: TStringList);
  function GetPlural(const Value: String): String;
  begin
    result := '';
    if StrToUInt64(Value) > 1 then
      result := Plural[CurrLang];
  end;
begin
  ValueList[Ord(TSMARTID.IDControllerBusyTime)] :=
    ValueList[Ord(TSMARTID.IDControllerBusyTime)] + ' ' + Minute[CurrLang] +
      GetPlural(ValueList[Ord(TSMARTID.IDControllerBusyTime)]);
  ValueList[Ord(TSMARTID.IDPowerOnHours)] :=
    ValueList[Ord(TSMARTID.IDPowerOnHours)] + ' ' + Hour[CurrLang] +
      GetPlural(ValueList[Ord(TSMARTID.IDPowerOnHours)]);
end;

procedure TSMARTTab.SetRepeatAndCounts(const ValueList: TStringList);
begin
  ValueList[Ord(TSMARTID.IDPowerCycles)] :=
    ValueList[Ord(TSMARTID.IDPowerCycles)] + ' ' + Repeats[CurrLang];
  ValueList[Ord(TSMARTID.IDUnsafeShutdowns)] :=
    ValueList[Ord(TSMARTID.IDUnsafeShutdowns)] + ' ' + Repeats[CurrLang];
  ValueList[Ord(TSMARTID.IDIntegrityErrors)] :=
    ValueList[Ord(TSMARTID.IDIntegrityErrors)] + ' ' + Repeats[CurrLang];
  ValueList[Ord(TSMARTID.IDNumberOfErrorLogs)] :=
    ValueList[Ord(TSMARTID.IDNumberOfErrorLogs)] + ' ' + Counts[CurrLang];
end;

end.
