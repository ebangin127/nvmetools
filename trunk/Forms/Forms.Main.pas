unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ComCtrls,
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
  public
    procedure ResizeGridColumn;
  private
    DriveList: TPhysicalDriveList;
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
begin
  if cSelectDrive.ItemIndex >= 0 then
  begin
    RefreshVendorSpecificTab;
    tValuesChange(tValues);
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
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(DriveList);
end;

procedure TfMain.SetCaption;
begin
  Caption := 'Naraeon NVMe Tools Alpha 3 (' +
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
  SetCaption;
  SetTabCaption;
  RefreshDrives;
end;

procedure TfMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
    cSelectDriveChange(cSelectDrive);
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
  ProperColumns = 2;
  FixedColumn = 0;
  ValueColumn = 1;
  Padding = 8;
begin
  if fMain.gValues.ColCount >= ProperColumns then
    fMain.gValues.ColWidths[ValueColumn] := fMain.gValues.Width -
      fMain.gValues.ColWidths[FixedColumn] - Padding;
end;
end.
