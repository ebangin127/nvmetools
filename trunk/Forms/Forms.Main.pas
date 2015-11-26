unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls,
  Getter.PhysicalDriveList.Auto, Device.PhysicalDrive.List,
  Device.PhysicalDrive, Device.SMART.List, MeasureUnit.DataSize,
  Getter.DeviceDriver, LanguageStrings, Getter.SlotSpeed, Vcl.ComCtrls;

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
  private
    FilledRowCount: Integer;
    FilledColumnCount: Integer;
    DriveList: TPhysicalDriveList;
    procedure RefreshDrives;
    procedure AddRow(const RowName: String);
    procedure AddColumn(const ColumnName: String);
    procedure RefreshGridBasic;
    procedure RefreshGridSMART;
    procedure FillGridRAWValue;
    procedure FillGridReadableValue;
    procedure RefreshGridDriver;
    procedure SetCaption;
    procedure RefreshGridPCI;
    procedure ResizeGrid;
    procedure ResizeTab;
    procedure AddDriverRow;
    procedure AddBasicRow;
    procedure AddSMARTRow;
    procedure SetBasicTab;
    procedure ClearRowColumn;
    procedure AddBasicColumn;
    procedure SetDriverTab;
    procedure SetSMARTTab;
    procedure SetTabCaption;
    procedure SetCriticalWarningTab;
    procedure AddCriticalWarningRow;
    procedure RefreshGridCriticalWarning;
    procedure FillCellWithBoolean(const Column, Row: Integer;
      const Value: Boolean);
    procedure RefreshGridStatus;
    procedure ResizeGridColumn;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.cSelectDriveChange(Sender: TObject);
begin
  if cSelectDrive.ItemIndex >= 0 then
    tValuesChange(tValues);
end;

procedure TfMain.RefreshGridDriver;
var
  DeviceDriverGetter: TDeviceDriverGetter;
  DeviceDriverInformation: TDeviceDriver;
begin
  DeviceDriverGetter := TDeviceDriverGetter.Create(
    DriveList[cSelectDrive.ItemIndex].GetPathOfFileAccessing);
  DeviceDriverInformation := DeviceDriverGetter.GetDeviceDriver;
  FreeAndNil(DeviceDriverGetter);

  gValues.Cells[1, 1] := DeviceDriverInformation.Name;
  gValues.Cells[1, 2] := DeviceDriverInformation.Provider;
  gValues.Cells[1, 3] := DeviceDriverInformation.Date;
  gValues.Cells[1, 4] := DeviceDriverInformation.InfName;
  gValues.Cells[1, 5] := DeviceDriverInformation.Version;
end;

procedure TfMain.RefreshGridPCI;
var
  SlotSpeedGetter: TSlotSpeedGetter;
  SlotSpeed: TSlotMaxCurrSpeed;
begin
  SlotSpeedGetter := TSlotSpeedGetter.Create(
    DriveList[cSelectDrive.ItemIndex].GetPathOfFileAccessing);
  SlotSpeed := SlotSpeedGetter.GetSlotSpeed;
  gValues.Cells[1, 4] :=
    SlotSpecificationString[SlotSpeed.Current.SpecVersion] + ' x' +
    IntToStr(Ord(SlotSpeed.Current.LinkWidth));
  gValues.Cells[1, 5] :=
    SlotSpecificationString[SlotSpeed.Maximum.SpecVersion] + ' x' +
    IntToStr(Ord(SlotSpeed.Maximum.LinkWidth));
  FreeAndNil(SlotSpeedGetter);
end;

procedure TfMain.tValuesChange(Sender: TObject);
const
  BasicTab = 0;
  DriverTab = 1;
  CriticalWarningTab = 2;
  SMARTTab = 3;
begin
  ClearRowColumn;
  case tValues.TabIndex of
    BasicTab:
      SetBasicTab;
    DriverTab:
      SetDriverTab;
    CriticalWarningTab:
      SetCriticalWarningTab;
    SMARTTab:
      SetSMARTTab;
  end;
  ResizeGridColumn;
end;

procedure TfMain.SetBasicTab;
begin
  AddBasicRow;
  AddBasicColumn;
  RefreshGridBasic;
end;

procedure TfMain.SetDriverTab;
begin
  AddDriverRow;
  AddBasicColumn;
  RefreshGridDriver;
end;

procedure TfMain.SetCriticalWarningTab;
begin
  AddCriticalWarningRow;
  AddBasicColumn;
  RefreshGridCriticalWarning;
end;

procedure TfMain.SetSMARTTab;
begin
  AddSMARTRow;
  AddBasicColumn;
  RefreshGridSMART;
end;

procedure TfMain.RefreshGridCriticalWarning;
var
  SMARTList: TSMARTValueList;
  CriticalWarningValue: UInt64;
const
  CriticalWarningID = 0;
begin
  SMARTList := DriveList[cSelectDrive.ItemIndex].GetSMARTList;
  CriticalWarningValue := SMARTList[0].RAW;
  FillCellWithBoolean(1, 1, (CriticalWarningValue and (1)) <> 0);
  FillCellWithBoolean(1, 2, (CriticalWarningValue and (1 shl 1)) <> 0);
  FillCellWithBoolean(1, 3, (CriticalWarningValue and (1 shl 2)) <> 0);
  FillCellWithBoolean(1, 4, (CriticalWarningValue and (1 shl 3)) <> 0);
  FillCellWithBoolean(1, 5, (CriticalWarningValue and (1 shl 4)) <> 0);
end;

procedure TfMain.ClearRowColumn;
begin
  FilledRowCount := 0;
  FilledColumnCount := 0;
  gValues.RowCount := 0;
  gValues.ColCount := 0;
end;

procedure TfMain.FillCellWithBoolean(const Column, Row: Integer;
  const Value: Boolean);
begin
  if Value then
    gValues.Cells[Column, Row] := Yes[CurrLang]
  else
    gValues.Cells[Column, Row] := No[CurrLang];
end;

procedure TfMain.AddBasicColumn;
begin
  AddColumn(Value[CurrLang]);
end;

procedure TfMain.RefreshGridBasic;
begin
  gValues.Cells[1, 1] :=
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Model;
  gValues.Cells[1, 2] :=
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Firmware;
  gValues.Cells[1, 3] :=
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Serial;
  RefreshGridPCI;
  RefreshGridStatus;
end;

procedure TfMain.RefreshGridSMART;
begin
  FillGridRAWValue;
  FillGridReadableValue;
end;

procedure TfMain.RefreshGridStatus;
var
  SMARTList: TSMARTValueList;
const
  CriticalWarningID = 0;
  AvailableSpare = 2;
begin
  SMARTList := DriveList[cSelectDrive.ItemIndex].GetSMARTList;
  if SMARTList[CriticalWarningID].RAW = 0 then
    gValues.Cells[1, 6] := Normal[CurrLang]
  else
    gValues.Cells[1, 6] := Warning[CurrLang];
  gValues.Cells[1, 6] := gValues.Cells[1, 6] +
    IntToStr(SMARTList[AvailableSpare].RAW) + '%)';
end;

procedure TfMain.FillGridRAWValue;
var
  SMARTList: TSMARTValueList;
  SMARTValueIndex: Integer;
const
  AvailableSpare = 2;
  SMARTStartPoint = 0;
begin
  SMARTList := DriveList[cSelectDrive.ItemIndex].GetSMARTList;
  for SMARTValueIndex := 1 to SMARTList.Count - 1 do
  begin
    if SMARTList[SMARTValueIndex].ID < AvailableSpare then
      gValues.Cells[1, SMARTStartPoint + SMARTValueIndex] :=
        IntToStr(SMARTList[SMARTValueIndex].RAW)
    else if SMARTList[SMARTValueIndex].ID = AvailableSpare then
    begin
      gValues.Cells[1, SMARTStartPoint + SMARTValueIndex] :=
        IntToStr(SMARTList[SMARTValueIndex].RAW);
      gValues.Cells[1, SMARTStartPoint + SMARTValueIndex + 1] :=
        IntToStr(SMARTList[SMARTValueIndex].Threshold);
    end
    else
      gValues.Cells[1, SMARTStartPoint + SMARTValueIndex + 1] :=
        IntToStr(SMARTList[SMARTValueIndex].RAW);
  end;
end;

procedure TfMain.FillGridReadableValue;
  function LBAToMB(const SizeInLBA: Int64): Double;
  begin
    result := SizeInLBA * 0.5 / 1024 * 1000;
  end;
const
  KelvinToCelcius = 273;
  BinaryPoint2: TFormatSizeSetting = (FNumeralSystem: Binary; FPrecision: 2);
begin
  gValues.Cells[1, 1] := IntToStr(StrToInt64(gValues.Cells[1, 1]) -
    KelvinToCelcius) + ' ¡ÆC';
  gValues.Cells[1, 2] := gValues.Cells[1, 2] + ' %';
  gValues.Cells[1, 3] := gValues.Cells[1, 3] + ' %';
  gValues.Cells[1, 4] := gValues.Cells[1, 4] + ' %';
  gValues.Cells[1, 5] := FormatSizeInMB(
    LBAToMB(StrToInt64(gValues.Cells[1, 5])), BinaryPoint2);
  gValues.Cells[1, 6] := FormatSizeInMB(
    LBAToMB(StrToInt64(gValues.Cells[1, 6])), BinaryPoint2);
  gValues.Cells[1, 7] := gValues.Cells[1, 7] + ' ' + Counts[CurrLang];
  gValues.Cells[1, 8] := gValues.Cells[1, 8] + ' ' + Counts[CurrLang];

  if StrToUInt64(gValues.Cells[1, 9]) > 1 then
    gValues.Cells[1, 9] := gValues.Cells[1, 9] + ' ' + Minute[CurrLang] +
      Plural[CurrLang]
  else
    gValues.Cells[1, 9] := gValues.Cells[1, 9] + ' ' + Minute[CurrLang];

  gValues.Cells[1, 10] := gValues.Cells[1, 10] + ' ' + Repeats[CurrLang];

  if StrToUInt64(gValues.Cells[1, 11]) > 1 then
    gValues.Cells[1, 11] := gValues.Cells[1, 11] + ' ' + Hour[CurrLang] +
      Plural[CurrLang]
  else
    gValues.Cells[1, 11] := gValues.Cells[1, 11] + ' ' + Hour[CurrLang];

  gValues.Cells[1, 12] := gValues.Cells[1, 12] + ' ' + Repeats[CurrLang];
  gValues.Cells[1, 13] := gValues.Cells[1, 13] + ' ' + Repeats[CurrLang];
  gValues.Cells[1, 14] := gValues.Cells[1, 14] + ' ' + Counts[CurrLang];
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(DriveList);
end;

procedure TfMain.SetCaption;
begin
  Caption := 'Naraeon NVMe Tools Alpha 2 (' +
    ToRefreshPress[CurrLang] + ' - F5)';
end;

procedure TfMain.SetTabCaption;
begin
  tValues.Tabs[0] := Basic[CurrLang];
  tValues.Tabs[1] := Driver[CurrLang];
  tValues.Tabs[2] := CriticalWarning[CurrLang];
  tValues.Tabs[3] := SMART[CurrLang];
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
var
  PhysicalDrive: IPhysicalDrive;
begin
  if DriveList <> nil then
    FreeAndNil(DriveList);
  DriveList := AutoPhysicalDriveListGetter.GetPhysicalDriveList;
  for PhysicalDrive in DriveList do
  begin
    cSelectDrive.Items.Add(
      PhysicalDrive.GetPathOfFileAccessingWithoutPrefix + ' - ' +
      PhysicalDrive.IdentifyDeviceResult.Model);
  end;
  if (cSelectDrive.ItemIndex = -1) and (cSelectDrive.Items.Count > 0) then
  begin
    cSelectDrive.ItemIndex := 0;
    cSelectDriveChange(cSelectDrive);
  end;
end;
 
procedure TfMain.AddColumn(const ColumnName: String);
begin
  if gValues.ColCount < FilledColumnCount + 2 then
    gValues.ColCount := gValues.ColCount + 1;
  Inc(FilledColumnCount);
  gValues.Cells[FilledColumnCount, 0] := ColumnName;
end;

procedure TfMain.AddRow(const RowName: String);
begin
  if gValues.RowCount < FilledRowCount + 2 then
    gValues.RowCount := gValues.RowCount + 1;
  Inc(FilledRowCount);
  gValues.Cells[0, FilledRowCount] := RowName;
end;

procedure TfMain.FormResize(Sender: TObject);
begin
  cSelectDrive.Width := ClientWidth;
  ResizeTab;
  ResizeGrid;
end;

procedure TfMain.ResizeTab;
begin
  tValues.Left := 0;
  tValues.Top := cSelectDrive.Top + cSelectDrive.Height;
  tValues.Width := ClientWidth;
  tValues.Height := ClientHeight - tValues.Top;
end;

procedure TfMain.AddDriverRow;
begin
  AddRow(DriverName[CurrLang]);
  AddRow(DriverVendor[CurrLang]);
  AddRow(DriverDate[CurrLang]);
  AddRow(DriverFileName[CurrLang]);
  AddRow(DriverVersion[CurrLang]);
end;

procedure TfMain.AddBasicRow;
begin
  AddRow(Model[CurrLang]);
  AddRow(FirmwareRevision[CurrLang]);
  AddRow(SerialNumber[CurrLang]);
  AddRow(PCICurrentSpeed[CurrLang]);
  AddRow(PCIMaxSpeed[CurrLang]);
  AddRow(Status[CurrLang]);
end;

procedure TfMain.AddSMARTRow;
begin
  AddRow(CompositeTemperature[CurrLang]);
  AddRow(AvailableSpare[CurrLang]);
  AddRow(AvailableSpareThreshold[CurrLang]);
  AddRow(PercentageUsed[CurrLang]);
  AddRow(DataUnitsRead[CurrLang]);
  AddRow(DataUnitsWritten[CurrLang]);
  AddRow(HostReadCommands[CurrLang]);
  AddRow(HostWriteCommands[CurrLang]);
  AddRow(ControllerBusyTime[CurrLang]);
  AddRow(PowerCycles[CurrLang]);
  AddRow(PowerOnHours[CurrLang]);
  AddRow(UnsafeShutdowns[CurrLang]);
  AddRow(IntegrityErrors[CurrLang]);
  AddRow(NumberOfErrorLogs[CurrLang]);
end;

procedure TfMain.AddCriticalWarningRow;
begin
  AddRow(AvailableSpaceError[CurrLang]);
  AddRow(TemperatureError[CurrLang]);
  AddRow(DeviceReliabilityDegraded[CurrLang]);
  AddRow(ReadOnlyMode[CurrLang]);
  AddRow(VolatileMemoryFailed[CurrLang]);
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
begin
  if gValues.ColCount >= 2 then
    gValues.ColWidths[1] := gValues.Width - gValues.ColWidths[0] - 8;
end;
end.
