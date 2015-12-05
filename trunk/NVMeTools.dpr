program NVMeTools;

uses
  Vcl.Forms,
  Windows,
  Forms.Main in 'Forms\Forms.Main.pas' {fMain},
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
  Getter.SlotSpeed in 'Classes\Getter.SlotSpeed.pas',
  OS.SetupAPI in 'Modules\OS.SetupAPI.pas',
  Getter.SlotSpeedByDeviceID in 'Classes\Getter.SlotSpeedByDeviceID.pas',
  View.Tab.Basic in 'View\View.Tab.Basic.pas',
  View.Tab in 'View\View.Tab.pas',
  View.Tab.Driver in 'View\View.Tab.Driver.pas',
  View.Tab.CriticalWarning in 'View\View.Tab.CriticalWarning.pas',
  View.Tab.SMART in 'View\View.Tab.SMART.pas',
  CommandSet.SAT in 'WindowsFileAPI\CommandSet.SAT.pas',
  BufferInterpreter.ATA in 'WindowsFileAPI\BufferInterpreter.ATA.pas',
  CommandSet.NVMe in 'WindowsFileAPI\CommandSet.NVMe.pas',
  BufferInterpreter.NVMe in 'WindowsFileAPI\BufferInterpreter.NVMe.pas',
  CommandSet.NVMe.Intel in 'WindowsFileAPI\CommandSet.NVMe.Intel.pas',
  Getter.SCSIAddress in 'WindowsFileAPI\Getter.SCSIAddress.pas',
  CommandSet.NVMe.Intel.PortPart in 'WindowsFileAPI\CommandSet.NVMe.Intel.PortPart.pas',
  BufferInterpreter.NVMe.Intel in 'WindowsFileAPI\BufferInterpreter.NVMe.Intel.pas',
  View.Tab.VendorSpecificSMART in 'View\View.Tab.VendorSpecificSMART.pas',
  VendorInterpreter in 'VendorInterpreter\VendorInterpreter.pas',
  VendorInterpreter.Intel in 'VendorInterpreter\VendorInterpreter.Intel.pas',
  LanguageStrings.Intel in 'Modules\LanguageStrings.Intel.pas',
  VendorInterpreter.Factory in 'VendorInterpreter\VendorInterpreter.Factory.pas';

{$R *.res}
{$SETPEOPTFLAGS $140}
{$SETPEFLAGS IMAGE_FILE_RELOCS_STRIPPED}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.
