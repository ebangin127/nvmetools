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

  FirmwareRevision: TLanguageString =
    ('펌웨어', 'Firmware');
  SerialNumber: TLanguageString =
    ('시리얼', 'Serial');

  CriticalWarning: TLanguageString =
    ('치명적 오류', 'Critical Warning');
  CompositeTemperature: TLanguageString =
    ('온도(켈빈)', 'Composite Temperature(In Kelvin)');
  AvailableSpare: TLanguageString =
    ('남은 예비 용량(%)', 'Available Spare(%)');
  AvailableSpareThreshold: TLanguageString =
    ('최소 예비 용량(%)', 'Available Spare Threshold(%)');
  PercentageUsed: TLanguageString =
    ('수명 사용 정도(%)', 'Percentage Used(%)');
  DataUnitsRead: TLanguageString =
    ('누적 읽기량(0.5KB)', 'Data Units Read(0.5KB)');
  DataUnitsWritten: TLanguageString =
    ('누적 쓰기량(0.5KB)', 'Data Units Written(0.5KB)');
  HostReadCommands: TLanguageString =
    ('처리된 읽기 명령 수', 'Host Read Commands');
  HostWriteCommands: TLanguageString =
    ('처리된 쓰기 명령 수', 'Host Write Commands');
  ControllerBusyTime: TLanguageString =
    ('누적 컨트롤러 작업 시간(분)', 'Controller Busy Time(In Minutes)');
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

  RAWValue: TLanguageString =
    ('원시값', 'RAW');
  HumanReadableValue: TLanguageString =
    ('변환값', 'Human Readable');

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
