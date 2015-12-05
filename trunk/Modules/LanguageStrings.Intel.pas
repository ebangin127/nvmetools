unit LanguageStrings.Intel;

interface

uses LanguageStrings;

const
  CurrentTemperature: TLanguageString =
    ('현재 온도', 'Current Temperature');
  HighestTemperature: TLanguageString =
    ('가장 높은 온도 (상한)', 'Highest Temperature (Limit)');
  LowestTemperature: TLanguageString =
    ('가장 낮은 온도 (하한)', 'Lowest Temperature (Limit)');
  ProgramFailCount: TLanguageString =
    ('프로그램 실패 횟수', 'Program Fail Count');
  EraseFailCount: TLanguageString =
    ('지우기 실패 횟수', 'Erase Fail Count');
  MinimumEraseCycles: TLanguageString =
    ('최소 지우기 횟수', 'Minimum Erase Cycles');
  MaximumEraseCycles: TLanguageString =
    ('최대 지우기 횟수', 'Maximum Erase Cycles');
  AverageEraseCycles: TLanguageString =
    ('평균 지우기 횟수', 'Average Erase Cycles');
  EndToEndErrorDetection: TLanguageString =
    ('종단간 오류 발견 횟수', 'End-to-End Error Detection Count');
  CRCErrorCount: TLanguageString =
    ('PCIe CRC 오류 횟수', 'PCIe CRC Error Count');
  TimedWorkloadMediaWear: TLanguageString =
    ('최대 사이클 대비 사용률', 'Timed Workload, Media Wear');
  TimedWorkloadHostReadWriteRatio: TLanguageString =
    ('전체 I/O 중 읽기 비율', 'Timed Workload, Host Reads %');
  TimedWorkloadTimer: TLanguageString =
    ('워크로드 측정 시간', 'Timed Workload, Timer');
  ThermalThrottleStatus: TLanguageString =
    ('발열로 인한 성능 제한 상태', 'Thermal Throttling Status %');
  ThermalThrottleCount: TLanguageString =
    ('발열로 인한 성능 제한 횟수', 'Thermal Throttling Count');
  RetryBufferOverflowCount: TLanguageString =
    ('재시도 버퍼 넘침 횟수', 'Retry Buffer Overflow Count');
  PLLLockLossCount: TLanguageString =
    ('위상 동기화 루프 해제 횟수', 'PLL Lock Loss Count');
  NANDBytesWritten: TLanguageString =
    ('낸드 쓰기', 'NAND Writes');
  HostBytesWritten: TLanguageString =
    ('호스트 쓰기', 'Host Writes');

implementation

end.
