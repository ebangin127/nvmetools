unit View.Tab.VendorSpecificSMART;

interface

uses
  Classes, SysUtils,
  View.Tab, Device.SMART.List, VendorInterpreter, VendorInterpreter.Factory;

type
  TVendorSpecificSMARTTab = class sealed(TTab)
  private
    function GetEntries: TInterpretedSMARTList;
    procedure FillSMARTValues(const ValueList: TInterpretedSMARTList);
  protected
    procedure FillTab; override;
  end;

implementation

{ TVendorSpecificSMARTTab }

procedure TVendorSpecificSMARTTab.FillTab;
var
  ValueList: TInterpretedSMARTList;
begin
  ValueList := GetEntries;
  FillSMARTValues(ValueList);
  FreeAndNil(ValueList);
end;

function TVendorSpecificSMARTTab.GetEntries: TInterpretedSMARTList;
var
  Interpreter: TVendorInterpreter;
  RAWSMARTList: TSMARTValueList;
begin
  Interpreter := VendorInterpeterFactory.GetSuitableInterpreter(
    GetSelectedDrive.IdentifyDeviceResult.Model,
    GetSelectedDrive.IdentifyDeviceResult.Firmware);
  RAWSMARTList := GetSelectedDrive.GetSMARTList;
  result := Interpreter.GetSMARTInterpreted(RAWSMARTList);
  FreeAndNil(Interpreter);
end;

procedure TVendorSpecificSMARTTab.FillSMARTValues(
  const ValueList: TInterpretedSMARTList);
var
  Entry: TInterpretedSMARTEntry;
begin
  for Entry in ValueList do
    AddRow(Entry.Name, Entry.Value);
end;

end.
