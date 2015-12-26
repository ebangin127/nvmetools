unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ComCtrls, UITypes,
  Getter.PhysicalDriveList.Auto, Device.PhysicalDrive.List,
  Device.PhysicalDrive, LanguageStrings, View.Tab, View.Tab.Basic,
  View.Tab.Driver, View.Tab.CriticalWarning, View.Tab.SMART,
  View.Tab.VendorSpecificSMART, VendorInterpreter, VendorInterpreter.Factory;

type
  TfMain = class(TForm)
    cSelectDrive: TComboBox;
    tValues: TTabControl;
    gValues: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cSelectDriveChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tValuesChange(Sender: TObject);
    procedure gValuesClick(Sender: TObject);
  public
    procedure ResizeGridColumn;
  private
    DriveList: TPhysicalDriveList;
    LastDrive: Integer;
    DisplaySerial: Boolean;
    OriginalSerial: String;
    procedure RefreshDrives;
    procedure SetCaption;
    procedure ResizeGrid;
    procedure ResizeTab;
    procedure SetTabCaption;
    procedure AddPhysicalDrivesToCombo;
    function IsVendorInterpreterAvailable: Boolean;
    function InvalidIndex: Boolean;
    procedure RefreshVendorSpecificTab;
    procedure AddVendorSpecificTab;
    procedure DeleteVendorSpecificTab;
    procedure IfNoSupportedClose;
    function GetMaxTextWidth(const Column: Integer): Cardinal;
    procedure RefreshScreen;
    procedure HideSerial;
    procedure ShowSerial;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}


function TfMain.InvalidIndex: Boolean;
begin
  result := (DriveList.Count <= cSelectDrive.ItemIndex) or
    (cSelectDrive.ItemIndex = -1);
end;

procedure TfMain.cSelectDriveChange(Sender: TObject);
const
  BasicTab = 0;
begin
  if (cSelectDrive.ItemIndex >= 0) and
    (cSelectDrive.ItemIndex <> LastDrive) then
  begin
    tValues.TabIndex := BasicTab;
    RefreshScreen;
    LastDrive := cSelectDrive.ItemIndex;
  end;
end;

procedure TfMain.RefreshVendorSpecificTab;
begin
  if IsVendorInterpreterAvailable then
    AddVendorSpecificTab
  else
    DeleteVendorSpecificTab;
end;

procedure TfMain.AddVendorSpecificTab;
var            
  VendorSpecificTabName: String;
begin
  VendorSpecificTabName := VendorSpecificSMART[CurrLang];
  if tValues.Tabs[tValues.Tabs.Count - 1] <> VendorSpecificTabName then
    tValues.Tabs.Add(VendorSpecificTabName);
end;

procedure TfMain.DeleteVendorSpecificTab;
var            
  VendorSpecificTabName: String;
begin
  VendorSpecificTabName := VendorSpecificSMART[CurrLang];
  if tValues.Tabs[tValues.Tabs.Count - 1] = VendorSpecificTabName then
    tValues.Tabs.Delete(tValues.Tabs.Count - 1);
end;

procedure TfMain.tValuesChange(Sender: TObject);
const
  BasicTab = 0;
  DriverTab = 1;
  CriticalWarningTab = 2;
  SMARTTab = 3;
  VendorSpecificSMARTTab = 4;
var
  CurrentTab: TTab;
begin
  if InvalidIndex then
    exit;
  if (tValues.TabIndex = BasicTab) and (not DisplaySerial) then
    ShowSerial;
  case tValues.TabIndex of
    BasicTab:
      CurrentTab := TBasicTab.Create(DriveList[cSelectDrive.ItemIndex]);
    DriverTab:
      CurrentTab := TDriverTab.Create(DriveList[cSelectDrive.ItemIndex]);
    CriticalWarningTab:
      CurrentTab := TCriticalWarningTab.Create(
        DriveList[cSelectDrive.ItemIndex]);
    SMARTTab:
      CurrentTab := TSMARTTab.Create(DriveList[cSelectDrive.ItemIndex]);
    VendorSpecificSMARTTab:
      CurrentTab := TVendorSpecificSMARTTab.Create(
        DriveList[cSelectDrive.ItemIndex]);
  end;
  CurrentTab.ShowTab;
  FreeAndNil(CurrentTab);
  if (tValues.TabIndex = BasicTab) and (not DisplaySerial) then
    HideSerial;
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(DriveList);
end;

procedure TfMain.SetCaption;
begin
  Caption := 'Naraeon NVMe Tools Alpha 5 (' +
    ToRefreshPress[CurrLang] + ' - F5)';
end;

procedure TfMain.SetTabCaption;
begin
  tValues.Tabs[0] := Basic[CurrLang];
  tValues.Tabs[1] := Driver[CurrLang];
  tValues.Tabs[2] := CriticalWarning[CurrLang];
  tValues.Tabs[3] := SMART[CurrLang];
end;

procedure TfMain.AddPhysicalDrivesToCombo;
var
  PhysicalDrive: IPhysicalDrive;
begin
  cSelectDrive.Items.Clear;
  for PhysicalDrive in DriveList do
    cSelectDrive.Items.Add(PhysicalDrive.GetPathOfFileAccessingWithoutPrefix +
      ' - ' + PhysicalDrive.IdentifyDeviceResult.Model);
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  LastDrive := -1;
  SetCaption;
  SetTabCaption;
  RefreshDrives;
  IfNoSupportedClose;
end;

procedure TfMain.IfNoSupportedClose;
begin
  if cSelectDrive.Items.Count = 0 then
  begin
    MessageDlg(NoSupported[CurrLang], mtError, [mbOK], 0);
    Application.Terminate;
  end;
end;

procedure TfMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
    RefreshScreen;
end;

procedure TfMain.RefreshDrives;
begin
  if DriveList <> nil then
    FreeAndNil(DriveList);
  DriveList := AutoPhysicalDriveListGetter.GetPhysicalDriveList;
  AddPhysicalDrivesToCombo;
  if (cSelectDrive.ItemIndex = -1) and (cSelectDrive.Items.Count > 0) then
  begin
    cSelectDrive.ItemIndex := 0;
    cSelectDriveChange(cSelectDrive);
  end;
end;

procedure TfMain.FormResize(Sender: TObject);
begin
  cSelectDrive.Width := ClientWidth;
  ResizeTab;
  ResizeGrid;
end;

function TfMain.IsVendorInterpreterAvailable: Boolean;
var
  Interpreter: TVendorInterpreter;
begin
  if InvalidIndex then
    exit(false);
  Interpreter := VendorInterpeterFactory.GetSuitableInterpreter(
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Model,
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Firmware);
  result := Interpreter <> nil;
  FreeAndNil(Interpreter);
end;

procedure TfMain.ResizeTab;
begin
  tValues.Left := 0;
  tValues.Top := cSelectDrive.Top + cSelectDrive.Height;
  tValues.Width := ClientWidth;
  tValues.Height := ClientHeight - tValues.Top;
end;

procedure TfMain.ResizeGrid;
begin
  gValues.Left := 0;
  gValues.Top := cSelectDrive.Top + cSelectDrive.Height;
  gValues.Width := ClientWidth;
  gValues.Height := ClientHeight - gValues.Top - tValues.Top;
  ResizeGridColumn;
end;

procedure TfMain.ResizeGridColumn;
const
  Padding = 12;
var
  CurrentColumn: Integer;
begin
  for CurrentColumn := 0 to gValues.ColCount - 1 do
    fMain.gValues.ColWidths[CurrentColumn] :=
      GetMaxTextWidth(CurrentColumn) + Padding;
end;

function TfMain.GetMaxTextWidth(const Column: Integer): Cardinal;
var
  TestingBitmap: TBitmap;
  CurrentRow: Integer;
  CurrentWidth: Cardinal;
begin
  TestingBitmap := TBitmap.Create;
  result := 0;
  try
    TestingBitmap.Canvas.Font.Assign(gValues.Font);
    for CurrentRow := 1 to gValues.RowCount - 1 do
    begin
      CurrentWidth := TestingBitmap.Canvas.TextWidth(
        gValues.Cells[Column, CurrentRow]);
      if CurrentWidth > result then
        result := CurrentWidth;
    end;
  finally
    TestingBitmap.Free;
  end;
end;

procedure TfMain.gValuesClick(Sender: TObject);
const
  SerialTab = 0;
  SerialCol = 1;
  SerialRow = 4;
begin
  if (tValues.TabIndex = SerialTab) and
    (gValues.Col = SerialCol) and (gValues.Row = SerialRow) then
  begin
    DisplaySerial := not DisplaySerial;
    if DisplaySerial then
      ShowSerial
    else
      HideSerial;
  end;
end;

procedure TfMain.RefreshScreen;
begin
  if cSelectDrive.ItemIndex < 0 then
    exit;
  RefreshVendorSpecificTab;
  tValuesChange(tValues);
  if not DisplaySerial then
    HideSerial;
end;

procedure TfMain.HideSerial;
const
  SerialTab = 0;
  SerialCol = 1;
  SerialRow = 4;
var
  HiddenSerial: String;
  CurrentChar: Integer;
begin
  if (tValues.TabIndex <> SerialTab) or (OriginalSerial <> '') then
    exit;
  OriginalSerial := gValues.Cells[SerialCol, SerialRow];
  for CurrentChar := 0 to Length(OriginalSerial) - 1 do
    HiddenSerial := HiddenSerial + 'X';
  gValues.Cells[SerialCol, SerialRow] := HiddenSerial;
end;

procedure TfMain.ShowSerial;
const
  SerialCol = 1;
  SerialRow = 4;
begin
  gValues.Cells[SerialCol, SerialRow] := OriginalSerial;
  OriginalSerial := '';
end;
end.
