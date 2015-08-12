unit CollectorForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.MultiView,
  System.ImageList, FMX.ImgList, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, IPPeerClient, IPPeerServer, System.Tether.Manager,
  System.Tether.AppProfile, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.ExtCtrls,
  FMX.Edit, FMXTee.Engine, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.ListView.Types, FMX.ListView, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageJSON;

type
  TfrmCollector = class(TForm)
    MultiView1: TMultiView;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    lbUsers: TListBox;
    lbProximityUsers: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxHeader2: TListBoxHeader;
    ImageList1: TImageList;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    ToolBar1: TToolBar;
    btnConnectRepeater: TButton;
    VertScrollBox1: TVertScrollBox;
    Layout7: TLayout;
    Layout6: TLayout;
    Layout8: TLayout;
    BindSourceDB2: TBindSourceDB;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    LinkListControlToField2: TLinkListControlToField;
    Editusername: TEdit;
    Labelusername: TLabel;
    Circle1: TCircle;
    chartWeight: TChart;
    seriesWeight: TLineSeries;
    Chart1: TChart;
    seriesHRD: TLineSeries;
    Editage: TEdit;
    Labelage: TLabel;
    EditHeight: TEdit;
    LabelHeight: TLabel;
    Editsex: TEdit;
    Labelsex: TLabel;
    Editweight: TEdit;
    Labelweight: TLabel;
    Layout10: TLayout;
    ListView1: TListView;
    StyleBook1: TStyleBook;
    ToolBar2: TToolBar;
    Text1: TText;
    btnRefreshWeight: TButton;
    Layout9: TLayout;
    lblWeight: TLabel;
    Label5: TLabel;
    Button3: TButton;
    Text3: TText;
    ToolBar3: TToolBar;
    Text2: TText;
    lytMain: TLayout;
    lytUserInfo: TLayout;
    Rectangle1: TRectangle;
    Layout5: TLayout;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    Circle2: TCircle;
    BindSourceDB5: TBindSourceDB;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    LinkControlToField8: TLinkControlToField;
    BindSourceDB6: TBindSourceDB;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    BindSourceDB4: TBindSourceDB;
    LinkFillControlToField1: TLinkFillControlToField;
    Button4: TButton;
    lytHRD: TLayout;
    Rectangle4: TRectangle;
    Label8: TLabel;
    Rectangle5: TRectangle;
    Button5: TButton;
    cbxHRDManagers: TComboBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure btnConnectRepeaterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbProximityUsersItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Button3Click(Sender: TObject);
    procedure btnRefreshWeightClick(Sender: TObject);
    procedure lbUsersItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Button1Click(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    FSelectedUsername: string;

    procedure ChangeScaleData(Sender: TObject);

    procedure ShowUserInfo;
    procedure HideUserInfo;
    procedure SelectUser(AUsername: string);
    procedure ImmediateUser(Sender: TObject);
    procedure ConnectedRepeater(Sender: TObject);

    procedure TetheringEndManagerDiscovery(Sender: TObject);
    procedure TetheringEndAppProfileDiscovery(Sender: TObject);
    procedure ReceiveHRData(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmCollector: TfrmCollector;

implementation

{$R *.fmx}

uses DataCollectorModule;

procedure TfrmCollector.FormCreate(Sender: TObject);
begin
  HideUserInfo;
  lytHRD.Visible := False;

  dmDataCollector.OnChangeScaleData := ChangeScaleData;
  dmDataCollector.OnEnterImmediate := ImmediateUser;
  dmDataCollector.OnConnectedRepeater := ConnectedRepeater;

  dmDataCollector.OnTetheringEndManagerDiscovery := TetheringEndManagerDiscovery;
  dmDataCollector.OnTetheringEndAppProfileDiscovery := TetheringEndAppProfileDiscovery;
  dmDataCollector.OnReceiveHRData := ReceiveHRData;

  seriesWeight.Clear;
  seriesHRD.Clear;
end;

procedure TfrmCollector.ShowUserInfo;
begin
  lytUserInfo.Visible := True;
end;

procedure TfrmCollector.TetheringEndAppProfileDiscovery(Sender: TObject);
begin
  if dmDataCollector.TetheringAppProfile.Connect(
      dmDataCollector.TetheringManager.RemoteProfiles.First) then
  begin
    Button5.Enabled := True;
  end;
end;

procedure TfrmCollector.TetheringEndManagerDiscovery(Sender: TObject);
var
  Info: TTetheringManagerInfo;
begin
  cbxHRDManagers.Items.Clear;
  for Info in dmDataCollector.TetheringManager.RemoteManagers do
    cbxHRDManagers.Items.Add(Info.ManagerText);

  cbxHRDManagers.ItemIndex := 0;
end;

procedure TfrmCollector.HideUserInfo;
begin
  lytUserInfo.Visible := False;
end;

procedure TfrmCollector.ImmediateUser(Sender: TObject);
var
  ImageIndex: Integer;
  Bitmap: TBitmap;
begin
  ImageIndex := dmDataCollector.FDQueryIds.FieldByName('image').AsInteger;
  Bitmap := ImageList1.Destination[ImageIndex].Layers[0].MultiResBitmap[0].Bitmap;
  Circle2.Fill.Bitmap.Bitmap := Bitmap;

  ShowUserInfo;
end;

procedure TfrmCollector.lbProximityUsersItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  SelectUser(Item.Text);
end;

procedure TfrmCollector.lbUsersItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  SelectUser(Item.Text);
end;

procedure TfrmCollector.ReceiveHRData(Sender: TObject);
var
  dt: TDateTime;
  bpm: Integer;
begin
  seriesHRD.Clear;
  dmDataCollector.memHRD.First;
  while not dmDataCollector.memHRD.Eof do
  begin
    dt := dmDataCollector.memHRD.FieldByName('time').AsDateTime;
    bpm := dmDataCollector.memHRD.FieldByName('bpmlog').AsInteger;

    seriesHRD.AddXY(dt, bpm);
    dmDataCollector.memHRD.Next;
  end;

  lytHRD.Visible := False;
end;

procedure TfrmCollector.Rectangle1Click(Sender: TObject);
begin
  HideUserInfo;
end;

procedure TfrmCollector.SelectUser(AUsername: string);
var
  ImageIndex: Integer;
  Bitmap: TBitmap;
begin
  dmDataCollector.SelectUser(AUsername);

  ImageIndex := dmDataCollector.FDQueryUsename.FieldByName('image').AsInteger;
  Bitmap := ImageList1.Destination[ImageIndex].Layers[0].MultiResBitmap[0].Bitmap;
  Circle1.Fill.Bitmap.Bitmap := Bitmap;
end;

procedure TfrmCollector.btnConnectRepeaterClick(Sender: TObject);
begin
  dmDataCollector.ConnectTethering('REPEATER_MANAGER');
end;

procedure TfrmCollector.Button1Click(Sender: TObject);
var
  Username: string;
begin
  Username := dmDataCollector.FDQueryIds.FieldByName('username').AsString;
  SelectUser(Username);
  HideUserInfo;
end;

procedure TfrmCollector.Button3Click(Sender: TObject);
begin
  dmDataCollector.SaveWeightData(FSelectedUsername);
  btnRefreshWeightClick(nil);
end;

procedure TfrmCollector.Button4Click(Sender: TObject);
begin
  dmDataCollector.ConnectTethering;
//  TetheringManagerHRD.DiscoverManagers(3000);
  lytHRD.Visible := not lytHRD.Visible;
end;

procedure TfrmCollector.Button5Click(Sender: TObject);
begin
  seriesHRD.Clear;
    dmDataCollector.TetheringAppProfile.SendString(
      dmDataCollector.TetheringAppProfile.ConnectedProfiles.First,
      'GETHRD', 'gethrd'
    );
end;

procedure TfrmCollector.Button6Click(Sender: TObject);
var
  Info: TTetheringManagerInfo;
begin
  seriesHRD.Clear;
  cbxHRDManagers.Items.Clear;

  for Info in dmDataCollector.TetheringManager.RemoteManagers do
  begin
    cbxHRDManagers.Items.Add(Info.ManagerText);
  end;
end;

procedure TfrmCollector.Button7Click(Sender: TObject);
begin
  dmDataCollector.TetheringManager.PairManager(
    dmDataCollector.TetheringManager.RemoteManagers[cbxHRDManagers.ItemIndex]);
end;

procedure TfrmCollector.Button8Click(Sender: TObject);
begin
  lytHRD.Visible := False;
end;

procedure TfrmCollector.btnRefreshWeightClick(Sender: TObject);
var
  Dt: TDateTime;
  Weight: Single;
begin
  dmDataCollector.QueryWeightData(FSelectedUsername);

  seriesWeight.Clear;
  dmDataCollector.memWeightData.First;
  while not dmDataCollector.memWeightData.Eof do
  begin
    Dt      := StrToDateTime(dmDataCollector.memWeightData.FieldByName('datetime').AsString);
    Weight  := dmDataCollector.memWeightData.FieldByName('weight').AsSingle;
    seriesWeight.AddXY(Dt, Weight);
    dmDataCollector.memWeightData.Next;
  end;

end;

procedure TfrmCollector.ChangeScaleData(Sender: TObject);
begin
  lblWeight.Text := Format('%3.1f',[dmDataCollector.WeightScale]);
end;

procedure TfrmCollector.ConnectedRepeater(Sender: TObject);
begin
  ShowMessage('리피터와 연결되었습니다.');
end;

end.
