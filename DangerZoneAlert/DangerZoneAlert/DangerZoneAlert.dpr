program DangerZoneAlert;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  DataAccessModule in 'DataAccessModule.pas' {dmDataAccess: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDataAccess, dmDataAccess);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
