program EvunTool;

uses
  System.ShareMem,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  ToolMainfrm in 'form\ToolMainfrm.pas' {Mainfrm},
  DMSToolfrm in 'form\DMSToolfrm.pas' {frmDMSTool},
  uResourceString in 'unit\uResourceString.pas',
  ShShareMemMap in 'unit\ShShareMemMap.pas',
  ShThread in 'unit\ShThread.pas',
  uShareMemServer in 'unit\uShareMemServer.pas',
  virtualstringtreefram in 'frame\virtualstringtreefram.pas'
    {frmvirtualstringtree: TFrame};

{$R *.res}

var
  Mainfrm: TMainfrm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TMainfrm, Mainfrm);
  Application.Run;
end.

