unit DataAccessModule;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Backend.KinveyProvider,
  REST.Backend.ServiceTypes, REST.Backend.MetaTypes, System.JSON,
  REST.Backend.KinveyServices, REST.Backend.Providers,
  REST.Backend.ServiceComponents, FMX.Types, FMX.Media, FMX.Notification,
  System.Beacon, System.Beacon.Components, REST.Backend.PushTypes,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Backend.BindSource;

const
  WARNNING_DISTANCE     = 1;    // 위험 경고 거리(m)
  WARNNING_REPORT_COUNT = 5;     // 관리자에게 보고해야 하는 횟수(회)

  SENDLOG_TERM_SEC  = 3;        // 3초에 한번 로그전송

type
  TdmDataAccess = class(TDataModule)
    KinveyProvider1: TKinveyProvider;
    BackendUsers1: TBackendUsers;
    BackendStorage1: TBackendStorage;
    NotificationCenter1: TNotificationCenter;
    MediaPlayer1: TMediaPlayer;
    Beacon1: TBeacon;
    Timer1: TTimer;
    BackendPush1: TBackendPush;
    procedure Beacon1BeaconEnter(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure Beacon1BeaconExit(const Sender: TObject; const ABeacon: IBeacon;
      const CurrentBeaconList: TBeaconList);
    procedure Timer1Timer(Sender: TObject);
  private
    FUsername: string;
    FBeacon: IBeacon;
    FActive: Boolean;

    // 지정거리 안에 진입
    FIsWarnnig: Boolean;  // 진입여부
    FWarnTimes: Integer;  // 진입 후 회사

    FSendLogTerm: Integer;
    FIsSendLog: Boolean;  // 로그 전송 여부

    FOnAlertStop: TNotifyEvent;
    FOnAlertStart: TNotifyEvent;

    procedure SetUsername(const Value: string);

    procedure SetActive(const Value: Boolean);

    // 진입 알림(푸쉬 메시지)
    procedure FireNotification(const AMsg: string);
    procedure SendRemotePush(const AMsg, AWarning: string);

    // 위험 경고 사이렌
    procedure StartAlertSiren;
    procedure StopAlertSiren;

    // 위험지역 진입 로그
    procedure SendDangerZoneLog(const ADistance: Double);
    // 위험지역 지정거리 이내 진입 시 관리자에 알림
    procedure SendPushEnterDangerZone;
    procedure SendPushExitDangerZone;
//    procedure SendDangerZonePushToAdmin(const ADistance: Double);

    procedure DoEnterBeacon;
    procedure DoExitBeacon;
    procedure DoStartAlert;
    procedure DoStopAlert;
  public
    { Public declarations }
    property Username: string read FUsername write SetUsername;

    property Active: Boolean read FActive write SetActive;
    procedure SetSendLog(const Value: Boolean);
    property Beacon: IBeacon read FBeacon;

    property OnAlertStart: TNotifyEvent read FOnAlertStart write FOnAlertStart;
    property OnAlertStop: TNotifyEvent read FOnAlertStop write FOnAlertStop;
  end;

var
  dmDataAccess: TdmDataAccess;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IOUtils;

{ TdmDataAccess }

procedure TdmDataAccess.Beacon1BeaconEnter(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := ABeacon;

  DoEnterBeacon;
end;

procedure TdmDataAccess.Beacon1BeaconExit(const Sender: TObject;
  const ABeacon: IBeacon; const CurrentBeaconList: TBeaconList);
begin
  FBeacon := nil;

  DoExitBeacon;
end;

procedure TdmDataAccess.DoEnterBeacon;
begin
  FireNotification('근방에 위험지역 있습니다. 안전한 지역으로 이동하세요.');
  Timer1.Enabled := True;
end;

procedure TdmDataAccess.DoExitBeacon;
begin
  DoStopAlert;
  Timer1.Enabled := False;
end;

procedure TdmDataAccess.DoStartAlert;
begin
  FireNotification('위험지역에 진입했습니다. 안전한 지역으로 이동하세요.');
  StartAlertSiren;

  if Assigned(FOnAlertStart) then
    FOnAlertStart(Self)
end;

procedure TdmDataAccess.DoStopAlert;
begin
  StopAlertSiren;

  if Assigned(FOnAlertStop) then
    FOnAlertStop(Self)
end;

procedure TdmDataAccess.FireNotification(const AMsg: string);
var
  Noti: TNotification;
begin
  Noti := NotificationCenter1.CreateNotification;
  try
    Noti.Name := '위험지역 진입';
    Noti.AlertBody := AMsg;
    Noti.EnableSound := True;
    Noti.AlertAction := 'Launch';
    Noti.HasAction := True;
    Noti.FireDate := Now();
    NotificationCenter1.ScheduleNotification(Noti);
  finally
    Noti.DisposeOf;
  end;
end;

// 사이렌 울리기
procedure TdmDataAccess.StartAlertSiren;
begin
  MediaPlayer1.FileName := TPath.Combine(TPath.GetDocumentsPath, 'alert.mp3');
  MediaPlayer1.Play;
end;

procedure TdmDataAccess.StopAlertSiren;
begin
  MediaPlayer1.Stop;
end;

procedure TdmDataAccess.Timer1Timer(Sender: TObject);
begin
  if not Assigned(FBeacon) then
  begin
    Timer1.Enabled := False;
    Exit;
  end;

  // 지정거리(1m) 내에 진입 시 경고
  if not FIsWarnnig then
  begin
    if FBeacon.Distance <= WARNNING_DISTANCE then
    begin
      DoStartAlert;
      FIsWarnnig := True;
    end;
  end;

  // 지정거리(1m) 밖으로 퇴장 시 경고 중단
  if FIsWarnnig then
  begin
    if FBeacon.Distance > WARNNING_DISTANCE then
    begin
      DoStopAlert;
      FIsWarnnig := False;
    end;
  end;

  // 3초(설정 주기)마다 위험지역과의 거리로그 전송
  if FSendLogTerm = SENDLOG_TERM_SEC then
  begin
    SendDangerZoneLog(FBeacon.Distance);
    FSendLogTerm := 0;
  end
  else
    Inc(FSendLogTerm);

  // 5초 이상 머무른 경우 관리자 보고
  if FIsWarnnig then
  begin
    Inc(FWarnTimes);
    if FWarnTimes = WARNNING_REPORT_COUNT then
      SendPushEnterDangerZone;
  end
  else
  begin
    // 5초 이상 머물러 관리자에 보고 된 경우 중단 알림
    if FWarnTimes >= WARNNING_REPORT_COUNT then
      SendPushExitDangerZone;

    FWarnTimes := 0;
  end;
end;

// 클라우드에 로그 기록
procedure TdmDataAccess.SendDangerZoneLog(const ADistance: Double);
var
  JSON : TJSONObject;
  ACreatedObject: TBackendEntityValue;
begin
  if not FIsSendLog then
    Exit;

  JSON := TJSONObject.Create;
  JSON.AddPair('username', FUsername);
  JSON.AddPair('distance', ADistance.ToString);
  JSON.AddPair('datetime', FormatDateTime('YYYY-MM-DD HH:NN:SS', Now));
  JSON.AddPair('uuid', FBeacon.GUID.ToString);
  JSON.AddPair('major', FBeacon.Major.ToString);
  JSON.AddPair('minor', FBeacon.Minor.ToString);

  BackendStorage1.Storage.CreateObject('dangerzonelog', JSON, ACreatedObject);
end;

procedure TdmDataAccess.SendPushEnterDangerZone;
begin
  SendDangerZoneLog(FBeacon.Distance);
  SendRemotePush(Format('[%s] 위험지역 진입', [FUsername]), 'ON');
end;

procedure TdmDataAccess.SendPushExitDangerZone;
begin
  SendRemotePush(Format('[%s] 위험지역 퇴장', [FUsername]), 'OFF');
end;

// 원격 푸쉬 메시지 전송
procedure TdmDataAccess.SendRemotePush(const AMsg, AWarning: string);
var
  Data: TPushData;
begin
  Data := TPushData.Create;
  try
    Data.Message      := AMsg;
    Data.GCM.Title    := '위험지역 진입 경보';
    Data.GCM.Message  := AMsg;
    Data.Extras.Add('username', 'admin');
    Data.Extras.Add('worker', FUsername);
    Data.Extras.Add('warning', AWarning);

    BackEndPush1.PushData(Data);
  finally
    Data.Free;
  end;
end;

procedure TdmDataAccess.SetActive(const Value: Boolean);
begin
  if FActive = Value then
    Exit;

  FActive := Value;
  Beacon1.Enabled := Value;
end;

procedure TdmDataAccess.SetSendLog(const Value: Boolean);
begin
  FIsSendLog := Value;
end;

procedure TdmDataAccess.SetUsername(const Value: string);
begin
  FUsername := Value;
end;

end.
