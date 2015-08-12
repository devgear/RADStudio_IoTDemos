unit AdminForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  REST.Backend.PushTypes, System.JSON, REST.Backend.KinveyPushDevice,
  System.PushNotification, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Backend.BindSource, REST.Backend.PushDevice, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, REST.Backend.KinveyProvider, FMX.ListView.Types,
  FMX.StdCtrls, FMX.ListView, FMX.MultiView, REST.Backend.KinveyServices,
  REST.Backend.ServiceTypes, REST.Backend.MetaTypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FMX.Layouts, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Backend.ServiceComponents, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.DBScope,
  System.ImageList, FMX.ImgList, System.IniFiles, REST.Client, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    KinveyProvider1: TKinveyProvider;
    PushEvents1: TPushEvents;
    BackendQuery1: TBackendQuery;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    ListView2: TListView;
    ToolBar2: TToolBar;
    Label2: TLabel;
    MultiView1: TMultiView;
    ListView1: TListView;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Layout1: TLayout;
    ImageList1: TImageList;
    AniIndicator1: TAniIndicator;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    IdHTTP1: TIdHTTP;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure PushEvents1PushReceived(Sender: TObject; const AData: TPushData);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FEnvIni: TIniFile;

    FBridgeIp: string;  // 스마트 조명의 브릿지 IP
    FUsername: string;  // 브릿지에 등록한 사용자 명
    FLightsId: Integer;

    // 스마트조명 브릿지의 IP 정보 조회
    function DiscoverBridgeIp: Boolean;
    // 사용자 등록
    function RegistUsername: Boolean;
    // BaseURL 갱신
    procedure UpdateBaseURL;

    procedure ProcessLightsAlert(AStart: Boolean);
    procedure StartLightsAlert;
    procedure StopLightsAlert;

    procedure SearchDangerZoneLog(const AWorker: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Math, System.IOUtils, REST.Types, System.StrUtils;

procedure TForm1.FormCreate(Sender: TObject);
var
  Path: string;
begin
  Path := TPath.Combine(TPath.GetDocumentsPath, 'smart_lights_env.ini');
  FEnvIni := TIniFile.Create(Path);

  FBridgeIp := FEnvIni.ReadString('smart_lights', 'bridgeip', ''); //. 'http://192.168.0.67';
  FUsername := FEnvIni.ReadString('smart_lights', 'username', '');  //'humpherykim';

  UpdateBaseURL;

  FLightsId := 1;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FEnvIni.WriteString('smart_lights', 'bridgeip', FBridgeIp);
  FEnvIni.WriteString('smart_lights', 'username', FUsername);

  FEnvIni.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DiscoverBridgeIp;

  UpdateBaseURL;

  RegistUsername;
end;

function TForm1.DiscoverBridgeIp: Boolean;
var
  JsonData: string;
  JValue: TJSONValue;
  JObject: TJSONObject;
begin
  Result := False;
  try
    JsonData := IdHttp1.Get('https://www.meethue.com/api/nupnp');
    JValue := TJSONObject.ParseJSONValue(JsonData);

    if JValue.TryGetValue<string>('[0].internalipaddress', FBridgeIp) then
      Result := True;
  except
    FBridgeIp := '';
  end;
end;

function TForm1.RegistUsername: Boolean;
var
  Value: TJSONValue;
  ErrorNo, ErrorDesc: string;
begin
  Result := False;

  try
    RESTRequest1.Resource := '/api/';
    RESTRequest1.Params[0].Value := '{"devicetype":"appname#devicename", "username":"devgeardemo"}';
    RESTRequest1.Method := TRESTRequestMethod.rmPOST;
    RESTRequest1.Execute;

    Value := RESTResponse1.JSONValue;

    // 에러인 경우
    if Value.TryGetValue<string>('[0].error.type', ErrorNo) then
    begin
      Value.TryGetValue<string>('[0].error.description', ErrorDesc);
      // 브릿지 버튼으
      if ErrorNo = '101' then
      begin
        MessageDlg('브릿지 중앙의 버튼을 누르고 [확인] 버튼을 눌러주세요.',
                    TMsgDlgType.mtInformation,
                    [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel],
                    0,
                    procedure(const AResult: TModalResult)
                    begin
                      if AResult = mrOK then
                        if RegistUsername then
                          ShowMessage('등록되었습니다.');
                    end
        );
      end
      else
      begin
        ShowMessage('오류: ' + ErrorDesc);
        Exit;
      end;
    end
    else
    begin
      if Value.TryGetValue<string>('[0].success.username', FUsername) then
        Result := True;
    end;
  except
    FBridgeIp := '';
  end;
end;

procedure TForm1.UpdateBaseURL;
begin
  RESTClient1.BaseURL := FBridgeIp;
  RESTClient1.ContentType := 'application/json';
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Worker: string;
begin
  Worker := AItem.Data['worker'].AsString;

  SearchDangerZoneLog(Worker);
end;

type
  TExtrasHelper = class helper for TPushData.TExtras
  public
    function Value(const AKey: string): string;
  end;

{ TExtrasHelper }

function TExtrasHelper.Value(const AKey: string): string;
var
  Idx: Integer;
begin
  Result := '';
  Idx := IndexOf(AKey);
  if Idx > -1 then
    Result := Items[Idx].Value;
end;

procedure TForm1.PushEvents1PushReceived(Sender: TObject;
  const AData: TPushData);
var
  Item: TListViewitem;
  Idx: Integer;
begin
  Item := ListView1.Items.AddItem(0);
  Item.Text := AData.Message;
  Item.Detail := FormatDateTime('YYYY-MM-DD HH:NN:SS', Now);
  Item.Data['worker'] := TValue.From<string>(AData.Extras.Value('worker'));

  if AData.Extras.Value('warning') = 'ON' then
    StartLightsAlert
  else
    StopLightsAlert;
end;

procedure TForm1.SearchDangerZoneLog(const AWorker: string);
const
  _QUERY_DANGERZONELOG = 'query={"username":"%s"}'#13#10'sort={"datetime": -1}';
var
  I: Integer;
  Item: TListViewItem;
  Distance: Single;
begin
  ListView2.Items.Clear;
  AniIndicator1.Visible := True;
  Application.ProcessMessages;
  BackendQuery1.QueryLines.Text := Format(_QUERY_DANGERZONELOG, [AWorker]);
  BackendQuery1.Execute;
  ListView2.BeginUpdate;
  try
    while not FDMemTable1.Eof do
    begin
      Item := ListView2.Items.Add;
      Distance := FDMemTable1.FieldByName('distance').AsSingle;
      Item.ImageIndex := IfThen(Distance > 0.5, 0, 1);
      Item.Text := Format('%s(%f)', [
        FDMemTable1.FieldByName('datetime').AsString, Distance
      ]);

      FDMemTable1.Next;
    end;
  finally
    AniIndicator1.Visible := False;
    ListView2.EndUpdate;
  end;
end;

procedure TForm1.ProcessLightsAlert(AStart: Boolean);
begin
  RESTRequest1.Resource := Format('/api/%s/lights/%d/state', [FUsername, FLightsId]);

  RESTRequest1.Params[0].Value := Format('{"on": %s, "alert":"%s"}', [IfThen(AStart, 'true', 'false'), IfThen(AStart, 'lselect', 'none')]);
  RESTRequest1.Method := rmPUT;
  RESTRequest1.Execute;
end;

procedure TForm1.StartLightsAlert;
begin
  ProcessLightsAlert(True);
end;

procedure TForm1.StopLightsAlert;
begin
  ProcessLightsAlert(False);
end;

end.
