unit DataCollectorModule;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, REST.Backend.ServiceTypes,
  REST.Backend.MetaTypes, System.JSON, REST.Backend.KinveyServices,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Backend.BindSource,
  REST.Backend.ServiceComponents, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Backend.KinveyProvider,
  System.Generics.Collections, IPPeerServer, System.Tether.Manager,
  System.Tether.AppProfile, CommonTypes, FireDAC.Stan.StorageBin,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLiteVDataSet,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, FireDAC.Comp.UI, REST.Backend.Providers,
  FireDAC.Stan.StorageJSON;

type
  TdmDataCollector = class(TDataModule)
    KinveyProvider1: TKinveyProvider;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    memUsers: TFDMemTable;
    beqryUsers: TBackendQuery;
    TetheringManager: TTetheringManager;
    TetheringAppProfile: TTetheringAppProfile;
    memUsers_id: TWideStringField;
    memUsersusername: TWideStringField;
    memUsersage: TWideStringField;
    memUserssex: TWideStringField;
    memUsersHeight: TWideStringField;
    memUsersweight: TWideStringField;
    memUsersImage: TWideStringField;
    memUsersuuid: TWideStringField;
    memUsersmajor: TWideStringField;
    memUsersminor: TWideStringField;
    memUsers_acl: TWideStringField;
    memUsers_kmd: TWideStringField;
    memUsersproximity: TStringField;
    memUsersdistance: TStringField;
    memBeacons: TFDMemTable;
    memBeaconsdistance: TFloatField;
    FDLocalSQL1: TFDLocalSQL;
    qryBeaconUsers: TFDQuery;
    FDConnection1: TFDConnection;
    memBeaconsmajor: TSmallintField;
    memBeaconsminor: TSmallintField;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qryBeaconUsersusername: TWideStringField;
    qryBeaconUsersImage: TWideStringField;
    qryBeaconUsersdistance: TFloatField;
    qryBeaconUsersmajor: TWideStringField;
    qryBeaconUsersminor: TWideStringField;
    bestrgWeight: TBackendStorage;
    beqryWeight: TBackendQuery;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    memWeightData: TFDMemTable;
    FDQueryIds: TFDQuery;
    FDQueryUsename: TFDQuery;
    memHRD: TFDMemTable;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure TetheringManagerRequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManagerEndManagersDiscovery(const Sender: TObject;
      const ARemoteManagers: TTetheringManagerInfoList);
    procedure TetheringManagerEndProfilesDiscovery(const Sender: TObject;
      const ARemoteProfiles: TTetheringProfileInfoList);
    procedure TetheringAppProfileResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure TetheringManagerRemoteManagerShutdown(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringAppProfileDisconnect(const Sender: TObject;
      const AProfileInfo: TTetheringProfileInfo);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FOnChangeScaleData: TNotifyEvent;
    FOnEnterImmediate: TNotifyEvent;
    FWeightScale: Single;
    FEnterMajorId,
    FEnterMinorId: string;
    FOnConnectedRepeater: TNotifyEvent;
    FOnTetheringEndManagerDiscovery: TNotifyEvent;
    FOnTetheringEndAppProfileDiscovery: TNotifyEvent;
    FOnReceiveHRData: TNotifyEvent;

    FManagerText: string;

    procedure ProcessATDataBeaconList(AData: string);
    procedure ProcessATDataScale(AData: string);
    procedure ProcessHRData(AData: TStream);

    procedure DoChangeScaleData;
    procedure DoEnterImmediate(AMajor, AMinor: string);
  public
    procedure ConnectTethering(AManagerText: string = '');
    procedure SaveWeightData(AUsername: string);
    procedure QueryWeightData(AUsername: string);
    procedure SelectUser(AUsername: string);

    property WeightScale: Single read FWeightScale write FWeightScale;

    property OnChangeScaleData: TNotifyEvent read FOnChangeScaleData write FOnChangeScaleData;
    property OnEnterImmediate: TNotifyEvent read FOnEnterImmediate write FOnEnterImmediate;
    property OnConnectedRepeater: TNotifyEvent read FOnConnectedRepeater write FOnConnectedRepeater;

    property OnTetheringEndManagerDiscovery: TNotifyEvent read FOnTetheringEndManagerDiscovery write FOnTetheringEndManagerDiscovery;
    property OnTetheringEndAppProfileDiscovery: TNotifyEvent read FOnTetheringEndAppProfileDiscovery write FOnTetheringEndAppProfileDiscovery;
    property OnReceiveHRData: TNotifyEvent read FOnReceiveHRData write FOnReceiveHRData;
  end;

var
  dmDataCollector: TdmDataCollector;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  FMX.Types, System.Threading;

procedure TdmDataCollector.ConnectTethering(AManagerText: string);
begin
  FManagerText := AManagerText;
  TetheringManager.DiscoverManagers(3000);
end;

procedure TdmDataCollector.DataModuleCreate(Sender: TObject);
begin
  beqryUsers.Execute;
end;

procedure TdmDataCollector.DataModuleDestroy(Sender: TObject);
begin
  qryBeaconUsers.Close;
end;

procedure TdmDataCollector.TetheringManagerEndManagersDiscovery(
  const Sender: TObject; const ARemoteManagers: TTetheringManagerInfoList);
var
  Info: TTetheringManagerInfo;
begin
  for Info in ARemoteManagers do
  begin
    if (FManagerText = 'REPEATER_MANAGER') and (Info.ManagerText = 'REPEATER_MANAGER') then
    begin
      TetheringManager.PairManager(Info);
      Exit;
    end;
  end;

  if Assigned(FOnTetheringEndManagerDiscovery) then
    FOnTetheringEndManagerDiscovery(Self);
end;

procedure TdmDataCollector.TetheringManagerEndProfilesDiscovery(
  const Sender: TObject; const ARemoteProfiles: TTetheringProfileInfoList);
var
  Info: TTetheringProfileInfo;
begin
  for Info in ARemoteProfiles do
  begin
    if TetheringAppProfile.Connect(Info) then
    begin
      if Info.ProfileText = 'REPEATER_PROFILE' then
      begin
        if Assigned(FOnConnectedRepeater) then
          FOnConnectedRepeater(Self);
      end
      else
      begin
        if Assigned(FOnTetheringEndAppProfileDiscovery) then
          FOnTetheringEndAppProfileDiscovery(Self);
      end;
    end;
  end;

end;

procedure TdmDataCollector.TetheringManagerRemoteManagerShutdown(
  const Sender: TObject; const AManagerIdentifier: string);
begin
  Log.d('RemoteManagerShutdown: ' + AManagerIdentifier);
end;

procedure TdmDataCollector.TetheringManagerRequestManagerPassword(
  const Sender: TObject; const ARemoteIdentifier: string; var Password: string);
begin
  Password := '1234';
end;

procedure TdmDataCollector.TetheringAppProfileDisconnect(const Sender: TObject;
  const AProfileInfo: TTetheringProfileInfo);
begin
  Log.d('Disconnect: ');
end;

procedure TdmDataCollector.TetheringAppProfileResourceReceived(
  const Sender: TObject; const AResource: TRemoteResource);
begin
  if AResource.ResType = TRemoteResourceType.Data then
  begin
    if AResource.Hint = TBeaconDataName.BeaconList then
      ProcessATDataBeaconList(AResource.Value.AsString)
    else if AResource.Hint = TBeaconDataName.ScaleData then
      ProcessATDataScale(AResource.Value.AsString);
  end
  else
  begin
    if AResource.Hint = 'HRD' then
      ProcessHRData(AResource.Value.AsStream);
  end;
end;

procedure TdmDataCollector.ProcessATDataBeaconList(AData: string);
var
  Beacon: TBeaconInfo;
  Beacons: TArray<TBeaconInfo>;
begin
  Beacons := TBeaconListJSON.JSONStrToBeaconInfoArray(AData);

  memBeacons.EmptyDataSet;
  qryBeaconUsers.Close;
  qryBeaconUsers.Open;
  for Beacon in Beacons do
  begin
    memBeacons.Append;
    memBeacons.FieldByName('major').AsInteger := Beacon.MajorId;
    memBeacons.FieldByName('minor').AsInteger := Beacon.MinorId;
    memBeacons.FieldByName('distance').AsSingle := Beacon.Distance;
    if Beacon.Distance <= 0.2 then
    begin
      DoEnterImmediate(Beacon.MajorId.ToString, Beacon.MinorId.ToString);
    end;

    //
    if (Beacon.MajorId.ToString = FEnterMajorId)
      and (Beacon.MinorId.ToString = FEnterMinorId)
      and (Beacon.Distance > 0.2) then
    begin
      FEnterMajorId := '';
      FEnterMinorId := '';
    end;
  end;

  qryBeaconUsers.Refresh;
end;

procedure TdmDataCollector.ProcessATDataScale(AData: string);
var
  Value: Single;
begin
  if not TryStrToFloat(AData, Value) then
    Value := 0;

  if FWeightScale = Value then
    Exit;

  FWeightScale := Value;

  DoChangeScaleData;
end;

procedure TdmDataCollector.ProcessHRData(AData: TStream);
var
  dt: TDateTime;
  bpm: Integer;
begin
  memHRD.Active := False;
  memHRD.LoadFromStream(AData, TFDStorageFormat.sfJSON);
  memHRD.Active := True;

  if Assigned(FOnReceiveHRData) then
    FOnReceiveHRData(Self);
end;

procedure TdmDataCollector.QueryWeightData(AUsername: string);
begin
//  beqryWeight.QueryLines.Text := Format('query={"username":"%s"}', [AUsername]);
  beqryWeight.Execute;
end;

procedure TdmDataCollector.SaveWeightData(AUsername: string);
var
  JSON : TJSONObject;
  ACreatedObject: TBackendEntityValue;
  API: TBackendStorageAPI;
begin
  if FWeightScale = 0 then
    Exit;

  JSON := TJSONObject.Create;
  JSON.AddPair('username', AUsername);
  JSON.AddPair('weight', Format('%3.1f',[FWeightScale]));
  JSON.AddPair('datetime', FormatDateTime('YYYY-MM-DD HH:NN:SS', Now));
  TTask.Run(
    procedure
    begin
      bestrgWeight.Storage.CreateObject('weightdata', JSON, ACreatedObject);
    end);
end;

procedure TdmDataCollector.SelectUser(AUsername: string);
begin
  FDQueryUsename.Close;
  FDQueryUsename.ParamByName('username').AsString := AUsername;
  FDQueryUsename.Open;
end;

procedure TdmDataCollector.DoChangeScaleData;
begin
  if Assigned(FOnChangeScaleData) then
    FOnChangeScaleData(Self);
end;


procedure TdmDataCollector.DoEnterImmediate(AMajor, AMinor: string);
begin
  if (FEnterMajorId = AMajor) and (FEnterMinorId = AMinor) then
    Exit;

  FEnterMajorId := AMajor;
  FEnterMinorId := AMinor;

  FDQueryIds.Close;
  FDQueryIds.ParamByName('major').AsString := AMajor;
  FDQueryIds.ParamByName('minor').AsString := AMinor;
  FDQueryIds.Open;
  if Assigned(FOnEnterImmediate) then
    FOnEnterImmediate(Self);
end;

end.
