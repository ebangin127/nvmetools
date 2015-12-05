unit VendorInterpreter.Factory;

interface

uses
  SysUtils,
  VendorInterpreter, VendorInterpreter.Intel;

type
  TMetaVendorInterpreter = class of TVendorInterpreter;
  TVendorInterpeterFactory = class
  public
    function GetSuitableInterpreter(Model, Firmware: String):
      TVendorInterpreter;
    class function Create: TVendorInterpeterFactory;
  private
    function TryVendorInterpeterAndGetRight: TVendorInterpreter;
    function TestNSTSupportCompatibility(
      TVendorInterpreterToTry: TMetaVendorInterpreter;
      LastResult: TVendorInterpreter): TVendorInterpreter;
    var
      FModel: String;
      FFirmware: String;
  end;

var
  VendorInterpeterFactory: TVendorInterpeterFactory;

implementation

{ TVendorInterpeterFactory }

class function TVendorInterpeterFactory.Create: TVendorInterpeterFactory;
begin
  if VendorInterpeterFactory = nil then
    result := inherited Create as self
  else
    result := VendorInterpeterFactory;
end;

function TVendorInterpeterFactory.GetSuitableInterpreter(Model, Firmware: String):
  TVendorInterpreter;
begin
  FModel := Model;
  FFirmware := Firmware;
  result := TryVendorInterpeterAndGetRight;
end;

function TVendorInterpeterFactory.TryVendorInterpeterAndGetRight:
  TVendorInterpreter;
begin
  result := nil;
  result := TestNSTSupportCompatibility(TIntelVendorInterpreter, result);
end;

function TVendorInterpeterFactory.TestNSTSupportCompatibility(
  TVendorInterpreterToTry: TMetaVendorInterpreter;
  LastResult: TVendorInterpreter): TVendorInterpreter;
begin
  if LastResult <> nil then
    exit(LastResult);

  result := TVendorInterpreterToTry.Create(FModel, FFirmware);

  if not result.GetSupportStatus then
    FreeAndNil(result);
end;

initialization
  VendorInterpeterFactory := TVendorInterpeterFactory.Create;
finalization
  VendorInterpeterFactory.Free;
end.
