program NVMeTools;

uses
  Vcl.Forms,
  Forms.Main in 'Forms\Forms.Main.pas' {fMain},
  BufferInterpreter.NVMe.Samsung in 'WindowsFileAPI\BufferInterpreter.NVMe.Samsung.pas',
  BufferInterpreter in 'WindowsFileAPI\BufferInterpreter.pas',
  CommandSet.Factory in 'WindowsFileAPI\CommandSet.Factory.pas',
  CommandSet.NVMe.Samsung in 'WindowsFileAPI\CommandSet.NVMe.Samsung.pas',
  CommandSet in 'WindowsFileAPI\CommandSet.pas',
  Device.BusPhysicalDrive in 'WindowsFileAPI\Device.BusPhysicalDrive.pas',
  Device.OSPhysicalDrive in 'WindowsFileAPI\Device.OSPhysicalDrive.pas',
  Device.PhysicalDrive.List in 'WindowsFileAPI\Device.PhysicalDrive.List.pas',
  Device.PhysicalDrive in 'WindowsFileAPI\Device.PhysicalDrive.pas',
  Device.SMART.List in 'WindowsFileAPI\Device.SMART.List.pas',
  Getter.DiskGeometry in 'WindowsFileAPI\Getter.DiskGeometry.pas',
  Getter.DriveAvailability in 'WindowsFileAPI\Getter.DriveAvailability.pas',
  Getter.DriveList.Fixed in 'WindowsFileAPI\Getter.DriveList.Fixed.pas',
  Getter.DriveList in 'WindowsFileAPI\Getter.DriveList.pas',
  Getter.NCQAvailability in 'WindowsFileAPI\Getter.NCQAvailability.pas',
  Getter.PartitionExtent in 'WindowsFileAPI\Getter.PartitionExtent.pas',
  Getter.PartitionList in 'WindowsFileAPI\Getter.PartitionList.pas',
  Getter.PhysicalDriveList.Auto in 'WindowsFileAPI\Getter.PhysicalDriveList.Auto.pas',
  Getter.PhysicalDriveList.BruteForce in 'WindowsFileAPI\Getter.PhysicalDriveList.BruteForce.pas',
  Getter.PhysicalDriveList in 'WindowsFileAPI\Getter.PhysicalDriveList.pas',
  Getter.PhysicalDriveList.WMI in 'WindowsFileAPI\Getter.PhysicalDriveList.WMI.pas',
  OS.SecurityDescriptor in 'WindowsFileAPI\OS.SecurityDescriptor.pas',
  OSFile.Handle in 'WindowsFileAPI\OSFile.Handle.pas',
  OSFile.Interfaced in 'WindowsFileAPI\OSFile.Interfaced.pas',
  OSFile.IoControl in 'WindowsFileAPI\OSFile.IoControl.pas',
  OSFile in 'WindowsFileAPI\OSFile.pas',
  MeasureUnit.DataSize in 'Modules\MeasureUnit.DataSize.pas',
  Getter.DeviceDriver in 'Classes\Getter.DeviceDriver.pas',
  LanguageStrings in 'Modules\LanguageStrings.pas',
  Getter.SlotDataWidth in 'Classes\Getter.SlotDataWidth.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
