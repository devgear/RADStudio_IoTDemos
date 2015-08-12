program DangerZoneAdmin;

uses
  System.StartUpCopy,
  FMX.Forms,
  AdminForm in 'AdminForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
