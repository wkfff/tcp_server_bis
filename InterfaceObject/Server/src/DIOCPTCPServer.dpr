program DIOCPTCPServer;

{$R *.dres}

uses
  Vcl.Forms,
  F_whtxServerMain in 'F_whtxServerMain.pas' {frmDIOCPTcpServer},
  Vcl.Themes,
  Vcl.Styles,
  U_DIOCPStreamCoder in 'U_DIOCPStreamCoder.pas',
  F_DIOCPMMonitor in 'F_DIOCPMMonitor.pas' {FMMonitor: TFrame},
  U_RunTimeINfoTools in 'U_RunTimeINfoTools.pas',
  U_MyTCPClientContext in 'U_MyTCPClientContext.pas';

{$R *.res}
var
  ServerMain: TfrmDIOCPTcpServer;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TfrmDIOCPTcpServer, ServerMain);
  Application.Run;
end.
