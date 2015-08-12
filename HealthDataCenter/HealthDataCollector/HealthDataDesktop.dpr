program HealthDataDesktop;

uses
  System.StartUpCopy,
  FMX.Forms,
  CollectorForm in 'CollectorForm.pas' {frmCollector},
  DataCollectorModule in 'DataCollectorModule.pas' {dmDataCollector: TDataModule},
  CommonTypes in '..\Common\CommonTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmDataCollector, dmDataCollector);
  Application.CreateForm(TfrmCollector, frmCollector);
  Application.Run;
end.
