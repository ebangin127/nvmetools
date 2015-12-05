unit VendorInterpreter.Intel;

interface

uses
  SysUtils,
  Device.SMART.List, VendorInterpreter, LanguageStrings, LanguageStrings.Intel;

type
  TIntelVendorInterpreter = class(TVendorInterpreter)
  public
    function GetSupportStatus: Boolean; override;
    function GetSMARTInterpreted(const SMARTValueList: TSMARTValueList):
      TInterpretedSMARTList; override;
  private
    FSMARTValueList: TSMARTValueList;
    procedure AddInterpretedSMARTEntries(
      const InterpretedSMARTList: TInterpretedSMARTList);
    function GetAverageEraseCycles: TInterpretedSMARTEntry;
    function GetCRCErrorCount: TInterpretedSMARTEntry;
    function GetEndToEndErrorDetection: TInterpretedSMARTEntry;
    function GetEraseFailCount: TInterpretedSMARTEntry;
    function GetHostBytesWritten: TInterpretedSMARTEntry;
    function GetMaximumEraseCycles: TInterpretedSMARTEntry;
    function GetMinimumEraseCycles: TInterpretedSMARTEntry;
    function GetNANDBytesWritten: TInterpretedSMARTEntry;
    function GetPLLLockLossCount: TInterpretedSMARTEntry;
    function GetRetryBufferOverflowCount: TInterpretedSMARTEntry;
    function GetThermalThrottleCount: TInterpretedSMARTEntry;
    function GetThermalThrottleStatus: TInterpretedSMARTEntry;
    function GetTimedWorkloadHostReadWriteRatio: TInterpretedSMARTEntry;
    function GetTimedWorkloadMediaWear: TInterpretedSMARTEntry;
    function GetTimedWorkloadTimer: TInterpretedSMARTEntry;
    function GetProgramFailCount: TInterpretedSMARTEntry;
    function GetCurrentTemperature: TInterpretedSMARTEntry;
    function GetMaximumTemperature: TInterpretedSMARTEntry;
    function GetMinimumTemperature: TInterpretedSMARTEntry;
    type
      TIntelSMARTID = (
        IDCurrentTemperature = $40,
        IDHighestTemperature = $41,
        IDLowestTemperature = $42,
        IDMaximumTemperature = $43,
        IDMinimumTemperature = $44,
        IDProgramFailCount = $AB,
        IDEraseFailCount = $AC,
        IDWearLevelingCount = $AD,
        IDEndToEndErrorDetection = $B8,
        IDCRCErrorCount = $C7,
        IDTimedWorkloadMediaWear = $E2,
        IDTimedWorkloadHostReadWriteRatio = $E3,
        IDTimedWorkloadTimer = $E4,
        IDThermalThrottleStatus = $EA,
        IDRetryBufferOverflowCount = $F0,
        IDPLLLockLossCount = $F3,
        IDNANDBytesWritten = $F4,
        IDHostBytesWritten = $F5);
  end;

implementation

{ TIntelVendorInterpreter }

function TIntelVendorInterpreter.GetSupportStatus: Boolean;
begin
  result := Pos('INTEL', Model) = 1;
end;

function TIntelVendorInterpreter.GetSMARTInterpreted(
  const SMARTValueList: TSMARTValueList): TInterpretedSMARTList;
begin
  FSMARTValueList := SMARTValueList;
  result := TInterpretedSMARTList.Create;
  AddInterpretedSMARTEntries(result);
end;

procedure TIntelVendorInterpreter.AddInterpretedSMARTEntries(
  const InterpretedSMARTList: TInterpretedSMARTList);
begin
  InterpretedSMARTList.Add(GetCurrentTemperature);
  InterpretedSMARTList.Add(GetMaximumTemperature);
  InterpretedSMARTList.Add(GetMinimumTemperature);
  InterpretedSMARTList.Add(GetProgramFailCount);
  InterpretedSMARTList.Add(GetEraseFailCount);
  InterpretedSMARTList.Add(GetMinimumEraseCycles);
  InterpretedSMARTList.Add(GetMaximumEraseCycles);
  InterpretedSMARTList.Add(GetAverageEraseCycles);
  InterpretedSMARTList.Add(GetEndToEndErrorDetection);
  InterpretedSMARTList.Add(GetCRCErrorCount);
  InterpretedSMARTList.Add(GetTimedWorkloadMediaWear);
  InterpretedSMARTList.Add(GetTimedWorkloadHostReadWriteRatio);
  InterpretedSMARTList.Add(GetTimedWorkloadTimer);
  InterpretedSMARTList.Add(GetThermalThrottleStatus);
  InterpretedSMARTList.Add(GetThermalThrottleCount);
  InterpretedSMARTList.Add(GetRetryBufferOverflowCount);
  InterpretedSMARTList.Add(GetPLLLockLossCount);
  InterpretedSMARTList.Add(GetNANDBytesWritten);
  InterpretedSMARTList.Add(GetHostBytesWritten);
end;

function TIntelVendorInterpreter.GetCurrentTemperature: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDCurrentTemperature));
  result.Name := CurrentTemperature[CurrLang];
  result.Value := FormatAsCelcius(Entry.RAW);
end;

function TIntelVendorInterpreter.GetMaximumTemperature: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDHighestTemperature));
  result.Name := HighestTemperature[CurrLang];
  result.Value := FormatAsCelcius(Entry.RAW);
  Entry := FSMARTValueList.GetEntryByID(Ord(IDMaximumTemperature));
  result.Value := result.Value + ' (' +
    FormatAsCelcius(Entry.RAW) + ')';
end;

function TIntelVendorInterpreter.GetMinimumTemperature: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDLowestTemperature));
  result.Name := LowestTemperature[CurrLang];
  result.Value := FormatAsCelcius(Entry.RAW);
  Entry := FSMARTValueList.GetEntryByID(Ord(IDMinimumTemperature));
  result.Value := result.Value + ' (' +
    FormatAsCelcius(Entry.RAW) + ')';
end;

function TIntelVendorInterpreter.GetProgramFailCount: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDProgramFailCount));
  result.Name := ProgramFailCount[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetEraseFailCount: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDEraseFailCount));
  result.Name := EraseFailCount[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetMinimumEraseCycles: TInterpretedSMARTEntry;
const
  CycleMask = $FFFF;
  CycleOrder = 0;
  CycleSize = 16;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDWearLevelingCount));
  Entry.RAW := (Entry.RAW shr (CycleOrder * CycleSize)) and CycleMask;
  result.Name := MinimumEraseCycles[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetMaximumEraseCycles: TInterpretedSMARTEntry;
const
  CycleMask = $FFFF;
  CycleOrder = 1;
  CycleSize = 16;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDWearLevelingCount));
  Entry.RAW := (Entry.RAW shr (CycleOrder * CycleSize)) and CycleMask;
  result.Name := MaximumEraseCycles[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetAverageEraseCycles: TInterpretedSMARTEntry;
const
  CycleMask = $FFFF;
  CycleOrder = 2;
  CycleSize = 16;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDWearLevelingCount));
  Entry.RAW := (Entry.RAW shr (CycleOrder * CycleSize)) and CycleMask;
  result.Name := AverageEraseCycles[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetEndToEndErrorDetection:
  TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDEndToEndErrorDetection));
  result.Name := EndToEndErrorDetection[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW);
end;

function TIntelVendorInterpreter.GetCRCErrorCount: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDCRCErrorCount));
  result.Name := CRCErrorCount[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW);
end;

function TIntelVendorInterpreter.GetTimedWorkloadMediaWear:
  TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDTimedWorkloadMediaWear));
  result.Name := TimedWorkloadMediaWear[CurrLang];
  result.Value := Format('%.3f', [Entry.RAW / 1024]) + ' %';
end;

function TIntelVendorInterpreter.GetTimedWorkloadHostReadWriteRatio:
  TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDTimedWorkloadHostReadWriteRatio));
  result.Name := TimedWorkloadHostReadWriteRatio[CurrLang];
  result.Value := FormatAsPercent(Entry.RAW);
end;

function TIntelVendorInterpreter.GetTimedWorkloadTimer: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDTimedWorkloadTimer));
  result.Name := TimedWorkloadTimer[CurrLang];
  result.Value := FormatAsMinute(Entry.RAW);
end;

function TIntelVendorInterpreter.GetThermalThrottleStatus:
  TInterpretedSMARTEntry;
const
  PercentageMask = $FF;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDThermalThrottleStatus));
  result.Name := ThermalThrottleStatus[CurrLang];
  result.Value := FormatAsPercent(Entry.RAW and PercentageMask);
end;

function TIntelVendorInterpreter.GetThermalThrottleCount:
  TInterpretedSMARTEntry;
const
  PercentageBit = 8;
  EventCountMask = $FFFFFFFF;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDThermalThrottleStatus));
  result.Name := ThermalThrottleCount[CurrLang];
  result.Value := FormatAsRepeat(
    (Entry.RAW shr PercentageBit) and EventCountMask);
end;

function TIntelVendorInterpreter.GetRetryBufferOverflowCount:
  TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDRetryBufferOverflowCount));
  result.Name := RetryBufferOverflowCount[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetPLLLockLossCount: TInterpretedSMARTEntry;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDPLLLockLossCount));
  result.Name := PLLLockLossCount[CurrLang];
  result.Value := FormatAsRepeat(Entry.RAW) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetNANDBytesWritten: TInterpretedSMARTEntry;
const
  IntelUnit = 32;
  MiBtoLBA = 2;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDNANDBytesWritten));
  result.Name := NANDBytesWritten[CurrLang];
  result.Value := FormatAsLBA(Entry.RAW * IntelUnit * MiBtoLBA) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

function TIntelVendorInterpreter.GetHostBytesWritten: TInterpretedSMARTEntry;
const
  IntelUnit = 32;
  MiBtoLBA = 2;
var
  Entry: TSMARTValueEntry;
begin
  Entry := FSMARTValueList.GetEntryByID(Ord(IDHostBytesWritten));
  result.Name := HostBytesWritten[CurrLang];
  result.Value := FormatAsLBA(Entry.RAW * IntelUnit * MiBtoLBA) + ' (' +
    FormatAsPercent(Entry.Current) + ')';
end;

end.
