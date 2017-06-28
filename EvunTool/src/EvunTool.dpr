program EvunTool;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  ToolMainfrm in 'form\ToolMainfrm.pas' {Mainfrm},
  DMSToolfrm in 'form\DMSToolfrm.pas' {frmDMSTool},
  uResourceString in 'unit\uResourceString.pas',
  ShShareMemMap in 'unit\ShShareMemMap.pas',
  ShThread in 'unit\ShThread.pas';

{$R *.res}

var
  Mainfrm: TMainfrm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TMainfrm, Mainfrm);
  Application.Run;
end.
