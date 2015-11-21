unit Device.SMART.List;

interface

uses
  SysUtils, Generics.Collections;

type
  TSMARTValueEntry = record
    ID: Byte;
    Current: Byte;
    Worst: Byte;
    Threshold: Byte;
    RAW: UInt64;
    class operator Subtract(LSide: TSMARTValueEntry; RSide: TSMARTValueEntry):
      TSMARTValueEntry;
    class operator NotEqual(LSide: TSMARTValueEntry; RSide: TSMARTValueEntry):
      Boolean;
    class function ToString(What: TSMARTValueEntry): String; static;
  end;

  TSMARTValueList = class(TList<TSMARTValueEntry>)
  public
    function GetEntryByID(ID: Byte): TSMARTValueEntry;
    function GetIndexByID(ID: Byte): Integer;
    function GetRAWByID(ID: Byte): UInt64;
  end;

implementation

{ TSMARTValueList }

function TSMARTValueList.GetIndexByID(ID: Byte): Integer;
var
  CurrentEntryNumber: Integer;
begin
  for CurrentEntryNumber := 0 to (Self.Count - 1) do
    if Self[CurrentEntryNumber].ID = ID then
      exit(CurrentEntryNumber);
  result := 0;
end;

function TSMARTValueList.GetEntryByID(ID: Byte): TSMARTValueEntry;
begin
  result := self[GetIndexByID(ID)];
end;

function TSMARTValueList.GetRAWByID(ID: Byte): UInt64;
begin
  result := self[GetIndexByID(ID)].RAW;
end;

{ TSMARTValueEntry }

class operator TSMARTValueEntry.NotEqual(LSide,
  RSide: TSMARTValueEntry): Boolean;
begin
  result :=
    (LSide.RAW <> RSide.RAW) or
    (LSide.ID <> RSide.ID) or
    (LSide.Current <> RSide.Current) or
    (LSide.Worst <> RSide.Worst) or
    (LSide.Threshold <> RSide.Threshold);
end;

class operator TSMARTValueEntry.Subtract(LSide,
  RSide: TSMARTValueEntry): TSMARTValueEntry;
begin
  result.ID := LSide.ID;
  result.Current := LSide.Current - RSide.Current;
  result.Worst := LSide.Worst - RSide.Worst;
  result.Threshold := LSide.Threshold - RSide.Threshold;
  result.RAW := LSide.RAW - RSide.RAW;
end;

class function TSMARTValueEntry.ToString(What: TSMARTValueEntry): String;
begin
  result :=
    'ID: ' + IntToStr(What.ID) + ' / ' +
    'Current: ' + IntToStr(What.Current) + ' / ' +
    'Worst: ' + IntToStr(What.Worst) + ' / ' +
    'Threshold: ' + IntToStr(What.Threshold) + ' / ' +
    'RAW: ' + IntToStr(What.RAW);
end;

end.
