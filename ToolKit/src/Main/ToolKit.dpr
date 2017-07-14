program ToolKit;

uses
  System.ShareMem,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  ToolMainfrm in 'form\ToolMainfrm.pas' {frmToolMain},
  DMSToolfrm in 'form\DMSToolfrm.pas' {frmDMSTool},
  uResourceString in 'unit\uResourceString.pas',
  ShShareMemMap in 'unit\ShShareMemMap.pas',
  ShThread in 'unit\ShThread.pas',
  uShareMemServer in 'unit\uShareMemServer.pas',
  virtualstringtreefram in 'frame\virtualstringtreefram.pas' {frmvirtualstringtree: TFrame},
  Mainfrm in 'form\Mainfrm.pas' {frmMain},
  uSystemModule in 'unit\uSystemModule.pas',
  Progressfrm in 'form\Progressfrm.pas' {frmPrg};

{$R *.res}
{$R VCLStyles.res}

var
  ToolMainform: TfrmToolMain;
  MainForm: TfrmMain;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TfrmMain, MainForm);
  //  Application.CreateForm(TfrmToolMain, ToolMainform);
  Application.Run;
end.

