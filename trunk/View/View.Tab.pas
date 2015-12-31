unit View.Tab;

interface

uses
  Device.PhysicalDrive;

type
  TTab = class
  private
    FilledRowCount: Integer;
    FilledColumnCount: Integer;
    SelectedDrive: IPhysicalDrive;
    procedure ClearRowColumn;
    procedure ResizeGridColumn;
    procedure AddBasicColumn;
    procedure AddColumn(const ColumnName: String);
    procedure ResizeGridRow;
  protected
    function GetSelectedDrive: IPhysicalDrive;
    procedure AddRow(const RowName, RowValue: String);
    procedure FillTab; virtual; abstract;
  public
    constructor Create(const CurrentDrive: IPhysicalDrive);
    procedure ShowTab;
  end;

implementation

uses
  Forms.Main, LanguageStrings;

{ TTab }

procedure TTab.AddRow(const RowName, RowValue: String);
const
  RowNameColumn = 0;
  RowValueColumn = 1;
begin
  if fMain.gValues.RowCount < FilledRowCount + 2 then
    fMain.gValues.RowCount := fMain.gValues.RowCount + 1;
  Inc(FilledRowCount);
  fMain.gValues.Cells[RowNameColumn, FilledRowCount] := RowName;
  fMain.gValues.Cells[RowValueColumn, FilledRowCount] := RowValue;
end;

procedure TTab.AddColumn(const ColumnName: String);
begin
  if fMain.gValues.ColCount < FilledColumnCount + 2 then
    fMain.gValues.ColCount := fMain.gValues.ColCount + 1;
  Inc(FilledColumnCount);
  fMain.gValues.Cells[FilledColumnCount, 0] := ColumnName;
end;

procedure TTab.ClearRowColumn;
begin
  FilledRowCount := 0;
  FilledColumnCount := 0;
  fMain.gValues.RowCount := 0;
  fMain.gValues.ColCount := 0;
end;

constructor TTab.Create(const CurrentDrive: IPhysicalDrive);
begin
  SelectedDrive := CurrentDrive;
end;

function TTab.GetSelectedDrive: IPhysicalDrive;
begin
  result := SelectedDrive;
end;

procedure TTab.ResizeGridColumn;
begin
  fMain.ResizeGridColumn;
end;

procedure TTab.ResizeGridRow;
begin
  fMain.ResizeGridRow;
end;

procedure TTab.AddBasicColumn;
begin
  AddColumn(Value[CurrLang]);
end;

procedure TTab.ShowTab;
begin
  ClearRowColumn;
  AddBasicColumn;
  FillTab;
  ResizeGridColumn;
  ResizeGridRow;
end;

end.
