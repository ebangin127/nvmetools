unit LanguageStrings;

interface

uses Windows;

var
  CurrLang: Integer;

type
  TLanguageString = Array[0..1] of String;

const
  LANG_HANGUL = 0;
  LANG_ENGLISH = 1;

const
  Basic: TLanguageString =
    ('기본', 'Basic');
  Driver: TLanguageString =
    ('드라이버', 'Driver');
  SMART: TLanguageString =
    ('수명 관련 정보', 'SMART');

  DriverName: TLanguageString =
    ('드라이버 이름', 'Driver Name');
  DriverVendor: TLanguageString =
    ('드라이버 제공자', 'Driver Vendor');
  DriverDate: TLanguageString =
    ('드라이버 날짜', 'Driver Date');
  DriverFileName: TLanguageString =
    ('드라이버 파일 이름', 'Driver File Name');
  DriverVersion: TLanguageString =
    ('드라이버 버전', 'Driver Version');

  PCIMaxSpeed: TLanguageString =
    ('최대 속도', 'Maximum Speed');
  PCICurrentSpeed: TLanguageString =
    ('현재 속도', 'Negotiated Speed');

  Model: TLanguageString =
    ('모델', 'Model');
  FirmwareRevision: TLanguageString =
    ('펌웨어', 'Firmware');
  SerialNumber: TLanguageString =
    ('시리얼', 'Serial');
  Status: TLanguageString =
    ('상태', 'Status');

  Yes: TLanguageString =
    ('예', 'Yes');
  No: TLanguageString =
    ('아니오', 'No');

  Normal: TLanguageString =
    ('정상 (', 'Normal (');
  Warning: TLanguageString =
    ('위험 (치명적 오류 탭 참조, ', 'Warning (See "Critical Warning" Tab, ');

  CriticalWarning: TLanguageString =
    ('치명적 경고', 'Critical Warning');
  AvailableSpaceError: TLanguageString =
    ('최소 예비 용량 미달', 'Available spare space is now below threshold');
  TemperatureError: TLanguageString =
    ('온도 경고', 'Temperature Warning');
  DeviceReliabilityDegraded: TLanguageString =
    ('장치 신뢰성 경고', 'Device reliability has been degraded');
  ReadOnlyMode: TLanguageString =
    ('읽기 전용 모드', 'Read only mode');
  VolatileMemoryFailed: TLanguageString =
    ('휘발성 백업 장치 실패', 'Volatile memory backup device failed');

  CompositeTemperature: TLanguageString =
    ('온도', 'Composite Temperature');
  AvailableSpare: TLanguageString =
    ('남은 예비 용량', 'Available Spare');
  AvailableSpareThreshold: TLanguageString =
    ('최소 예비 용량', 'Available Spare Threshold');
  PercentageUsed: TLanguageString =
    ('수명 사용 정도', 'Percentage Used');
  DataUnitsRead: TLanguageString =
    ('누적 읽기량', 'Data Units Read');
  DataUnitsWritten: TLanguageString =
    ('누적 쓰기량', 'Data Units Written');
  HostReadCommands: TLanguageString =
    ('처리된 읽기 명령 수', 'Host Read Commands');
  HostWriteCommands: TLanguageString =
    ('처리된 쓰기 명령 수', 'Host Write Commands');
  ControllerBusyTime: TLanguageString =
    ('누적 컨트롤러 작업 시간', 'Controller Busy Time');
  PowerCycles: TLanguageString =
    ('전원 인가 횟수', 'Power Cycles');
  PowerOnHours: TLanguageString =
    ('전원 인가 시간', 'Power On Hours');
  UnsafeShutdowns: TLanguageString =
    ('안전하지 않은 종료 횟수', 'Unsafe Shutdowns');
  IntegrityErrors: TLanguageString =
    ('매체/데이터 무결성 오류 횟수', 'Media and Data Integrity Errors');
  NumberOfErrorLogs: TLanguageString =
    ('누적 오류 로그 수', 'Number of Error Information Log Entries');

  Value: TLanguageString =
    ('값', 'Value');
  Minute: TLanguageString =
    ('분', 'min');
  Repeats: TLanguageString =
    ('회', '');
  Counts: TLanguageString =
    ('개', '');
  Hour: TLanguageString =
    ('시간', 'hr');
  Plural: TLanguageString =
    ('', 's');

  ToRefreshPress: TLanguageString =
    ('새로고침', 'Refresh');

procedure DetermineLanguage;

implementation

procedure DetermineLanguage;
begin
  if GetSystemDefaultLangID = 1042 then
    CurrLang := LANG_HANGUL
  else
    CurrLang := LANG_ENGLISH;
end;

initialization
  DetermineLanguage;
end.
