program DemoGoogleMaps;

uses
  FastMM4,
  Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
