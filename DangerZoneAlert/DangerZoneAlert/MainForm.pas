unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Effects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.Ani, FMX.ListBox, FMX.ScrollBox, FMX.Memo;

type
  TfrmMain = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Layout1: TLayout;
    Layout2: TLayout;
    Text1: TText;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    btnLogin: TButton;
    edtPassword: TEdit;
    edtUsername: TEdit;
    ShadowEffect1: TShadowEffect;
    StatusBar1: TStatusBar;
    lblDistanceInfo: TLabel;
    rectAlert: TRectangle;
    pnlAlert: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Image2: TImage;
    Text2: TText;
    txtAlertDistance: TText;
    FloatAnimation1: TFloatAnimation;
    Timer1: TTimer;
    Switch1: TSwitch;
    EmployeeRecordNotes: TMemo;
    EmployeesTabToolbar: TToolBar;
    EmployeeProfile: TLabel;
    RefreshBtn: TSpeedButton;
    MultiViewBtn: TSpeedButton;
    EmploymentHistoryList: TListBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    Position1: TListBoxItem;
    Position2: TListBoxItem;
    Namebadge: TButton;
    EmployeeName: TLabel;
    EmployeeTitle: TLabel;
    HireDate: TLabel;
    EmployeeBadgePhoto: TImage;
    Layout3: TLayout;
    TabletHRList: TListBox;
    FileAttachmentsHeader: TListBoxGroupHeader;
    UploadListItem: TListBoxItem;
    Edit1: TEdit;
    UploadBtn: TSpeedButton;
    UploadIcon: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
  private
    { Private declarations }
    procedure StartAlert(Sender: TObject);
    procedure StopAlert(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.iPhone47in.fmx IOS}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}

uses
  DataAccessModule,
  REST.Backend.MetaTypes;

procedure TfrmMain.btnLoginClick(Sender: TObject);
var
  CreateObj: TBackendEntityValue;
begin
  TabControl1.TabIndex := 1;

  // worker / 1234
  dmDataAccess.BackendUsers1.Users.LoginUser(edtUsername.Text, edtPassword.Text, CreateObj);
  dmDataAccess.Username := edtUsername.Text;
  dmDataAccess.Active := True;

  Timer1.Enabled := True;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.TabIndex := 0;

  rectAlert.Visible := False;
  lblDistanceInfo.Text := '';

  dmDataAccess.OnAlertStart := StartAlert;
  dmDataAccess.onAlertStop := StopAlert;
  dmDataAccess.SetSendLog(False);
end;

procedure TfrmMain.StartAlert(Sender: TObject);
begin
  rectAlert.Visible := True;
  rectAlert.BringToFront;
  FloatAnimation1.Enabled := True;
end;

procedure TfrmMain.StopAlert(Sender: TObject);
begin
  FloatAnimation1.Enabled := False;
  rectAlert.Visible := False;
end;

procedure TfrmMain.Switch1Switch(Sender: TObject);
begin
  dmDataAccess.SetSendLog(Switch1.IsChecked);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  if Assigned(dmDataAccess.Beacon) then
  begin
    lblDistanceInfo.Text := Format('위험지역과 거리: %f m', [dmDataAccess.Beacon.Distance]);
    txtAlertDistance.Text := dmDataAccess.Beacon.Distance.ToString;
  end
  else
  begin
    lblDistanceInfo.Text := '';
  end;
end;

end.
