unit BufferInterpreter;

interface

uses
  Device.SMART.List;

type
  T512Buffer = Array[0..511] of Byte;
  TStorageInterface =
    (Probing, ATA, SAT, SCSI, UnknownInterface);
  TSATASpeed =
    (NotSATA, UnknownSATASpeed, SATA150, SATA300, SATA600);
  TIdentifyDeviceResult = record
    Model: String;
    Firmware: String;
    Serial: String;
    UserSizeInKB: UInt64;
    SATASpeed: TSATASpeed;
    LBASize: Cardinal;
    StorageInterface: TStorageInterface;
    IsDataSetManagementSupported: Boolean;
  end;

  TBufferInterpreter = class abstract
  public
    function BufferToIdentifyDeviceResult
      (Buffer: T512Buffer): TIdentifyDeviceResult; virtual; abstract;
    function BufferToSMARTValueList
      (Buffer: T512Buffer): TSMARTValueList; virtual; abstract;
  end;

implementation

end.
