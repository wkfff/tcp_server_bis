program DIOCPTCPServer;

{$R *.dres}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  F_DIOCPMMonitor in 'TCPServer\F_DIOCPMMonitor.pas' {FMMonitor: TFrame},
  F_whtxServerMain in 'TCPServer\F_whtxServerMain.pas' {frmDIOCPTcpServer},
  U_DIOCPStreamCoder in 'TCPServer\U_DIOCPStreamCoder.pas',
  U_MyTCPClientContext in 'TCPServer\U_MyTCPClientContext.pas',
  U_RunTimeINfoTools in 'TCPServer\U_RunTimeINfoTools.pas';

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
