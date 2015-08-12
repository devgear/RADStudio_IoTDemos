program HealthDataRepeater;

uses
  System.StartUpCopy,
  FMX.Forms,
  RepeaterForm in 'RepeaterForm.pas' {Form1},
  CommonTypes in '..\Common\CommonTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
