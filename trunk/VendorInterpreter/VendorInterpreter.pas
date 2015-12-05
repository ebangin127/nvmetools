unit VendorInterpreter;

interface

uses
  SysUtils, Classes, Generics.Collections,
  Device.SMART.List, LanguageStrings, MeasureUnit.DataSize;

type
  TInterpretedSMARTEntry = record
    Name: String;
    Value: String;
  end;
  TInterpretedSMARTList = TList<TInterpretedSMARTEntry>;
  TVendorInterpreter = class abstract
  private
    FModel, FFirmware: String;
  protected
    property Model: String read FModel;
    property Firmware: String read FFirmware;
    function FormatAsCount(const Value: UInt64): String;
    function FormatAsRepeat(const Value: UInt64): String;
    function FormatAsMinute(const Value: UInt64): String;
    function FormatAsPercent(const Value: UInt64): String;
    function FormatAsCelcius(const Value: Integer): String;
    function FormatAsLBA(const Value: UInt64): String;
    function FormatAsBoolean(const Value: Boolean): String;
  public
    constructor Create(const ModelToCheck, FirmwareToCheck: String);
    function GetSupportStatus: Boolean; virtual; abstract;
    function GetSMARTInterpreted(const SMARTValueList: TSMARTValueList):
      TInterpretedSMARTList; virtual; abstract;
  end;

implementation

{ TVendorInterpreter }

constructor TVendorInterpreter.Create(
  const ModelToCheck, FirmwareToCheck: String);
begin
  FModel := UpperCase(ModelToCheck);
  FFirmware := UpperCase(FirmwareToCheck);
end;

function TVendorInterpreter.FormatAsCelcius(const Value: Integer): String;
begin
  result := Value.ToString + ' ¡ÆC';
end;

function TVendorInterpreter.FormatAsLBA(const Value: UInt64): String;
  function LBAToMB(const SizeInLBA: UInt64): Double;
  begin
    result := SizeInLBA * 0.5 / 1024 * 1000;
  end;
const
  BinaryPoint2: TFormatSizeSetting = (FNumeralSystem: Binary; FPrecision: 2);
begin
  result := FormatSizeInMB(LBAToMB(Value), BinaryPoint2);
end;

function TVendorInterpreter.FormatAsMinute(const Value: UInt64): String;
  function GetPlural(const Value: UInt64): String;
  begin
    result := '';
    if Value > 1 then
      result := Plural[CurrLang];
  end;
begin
  result := UIntToStr(Value) + ' ' + Minute[CurrLang] + GetPlural(Value);
end;

function TVendorInterpreter.FormatAsPercent(const Value: UInt64): String;
begin
  result := UIntToStr(Value) + ' %';
end;

function TVendorInterpreter.FormatAsCount(const Value: UInt64): String;
begin
  result := UIntToStr(Value) + ' ' + Counts[CurrLang];
end;

function TVendorInterpreter.FormatAsRepeat(const Value: UInt64): String;
begin
  result := UIntToStr(Value) + ' ' + Repeats[CurrLang];
end;

function TVendorInterpreter.FormatAsBoolean(const Value: Boolean): String;
begin
  if Value then
    result := Yes[CurrLang]
  else
    result := No[CurrLang];
end;

end.
