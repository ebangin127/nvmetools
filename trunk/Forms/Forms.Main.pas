unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls,
  Getter.PhysicalDriveList.Auto, Device.PhysicalDrive.List,
  Device.PhysicalDrive, Device.SMART.List, MeasureUnit.DataSize,
  Getter.DeviceDriver, LanguageStrings;

type
  TfMain = class(TForm)
    cSelectDrive: TComboBox;
    gValues: TStringGrid;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cSelectDriveChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FilledRowCount: Integer;
    FilledColumnCount: Integer;
    DriveList: TPhysicalDriveList;
    procedure RefreshDrives;
    procedure InitializeGrid;
    procedure AddRow(const RowName: String);
    procedure AddColumn(const ColumnName: String);
    procedure RefreshGrid;
    procedure RefreshGridBasic;
    procedure RefreshGridSMART;
    procedure FillGridRAWValue;
    procedure FillGridReadableValue;
    procedure RefreshGridDriver;
    procedure SetRowName;
    procedure SetColumnName;
    procedure SetCaption;
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

procedure TfMain.cSelectDriveChange(Sender: TObject);
begin
  if cSelectDrive.ItemIndex >= 0 then
    RefreshGrid;
end;

procedure TfMain.RefreshGrid;
begin
  RefreshGridDriver;
  RefreshGridBasic;
  RefreshGridSMART;
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

procedure TfMain.SetRowName;
begin
  AddRow(DriverName[CurrLang]);
  AddRow(DriverVendor[CurrLang]);
  AddRow(DriverDate[CurrLang]);
  AddRow(DriverFileName[CurrLang]);
  AddRow(DriverVersion[CurrLang]);
  AddRow(FirmwareRevision[CurrLang]);
  AddRow(SerialNumber[CurrLang]);
  AddRow(CriticalWarning[CurrLang]);
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

procedure TfMain.SetColumnName;
begin
  AddColumn(RAWValue[CurrLang]);
  AddColumn(HumanReadableValue[CurrLang]);
end;

procedure TfMain.RefreshGridBasic;
begin
  gValues.Cells[1, 6] :=
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Firmware;
  gValues.Cells[1, 7] :=
    DriveList[cSelectDrive.ItemIndex].IdentifyDeviceResult.Serial;
end;

procedure TfMain.RefreshGridSMART;
begin
  FillGridRAWValue;
  FillGridReadableValue;
end;

procedure TfMain.FillGridRAWValue;
var
  SMARTList: TSMARTValueList;
  SMARTValueIndex: Integer;
const
  AvailableSpare = 2;
  StartingCellForSMART = 8;
begin
  SMARTList := DriveList[cSelectDrive.ItemIndex].GetSMARTList;
  for SMARTValueIndex := 0 to SMARTList.Count - 1 do
  begin
    if SMARTList[SMARTValueIndex].ID < AvailableSpare then
      gValues.Cells[1, StartingCellForSMART + SMARTValueIndex] :=
        IntToStr(SMARTList[SMARTValueIndex].RAW)
    else if SMARTList[SMARTValueIndex].ID = AvailableSpare then
    begin
      gValues.Cells[1, StartingCellForSMART + SMARTValueIndex] :=
        IntToStr(SMARTList[SMARTValueIndex].RAW);
      gValues.Cells[1, StartingCellForSMART + SMARTValueIndex + 1] :=
        IntToStr(SMARTList[SMARTValueIndex].Threshold);
    end
    else
      gValues.Cells[1, StartingCellForSMART + SMARTValueIndex + 1] :=
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
  gValues.Cells[2, 9] := IntToStr(StrToInt64(gValues.Cells[1, 9]) -
    KelvinToCelcius) + '¡ÆC';
  gValues.Cells[2, 13] := FormatSizeInMB(
    LBAToMB(StrToInt64(gValues.Cells[1, 13])), BinaryPoint2);
  gValues.Cells[2, 14] := FormatSizeInMB(
    LBAToMB(StrToInt64(gValues.Cells[1, 14])), BinaryPoint2);
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(DriveList);
end;

procedure TfMain.SetCaption;
begin
  Caption := 'Naraeon NVMe Tools Alpha 1 (' +
    ToRefreshPress[CurrLang] + ' - F5)';
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  SetCaption;
  RefreshDrives;
  InitializeGrid;
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

procedure TfMain.InitializeGrid;
begin
  SetRowName;
  SetColumnName;
end;

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
  gValues.Left := 0;
  gValues.Top := cSelectDrive.Top + cSelectDrive.Height;
  gValues.Width := ClientWidth;
  gValues.Height := ClientHeight - gValues.Top;
end;

end.
