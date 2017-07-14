program DIOCPTCPServer;

{$R *.dres}

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  ServerMMonitorFrm in 'TCPServer\ServerMMonitorFrm.pas' {FMMonitor: TFrame},
  ServerMainFrm in 'TCPServer\ServerMainFrm.pas' {frmDIOCPTcpServer},
  uDIOCPStreamCoder in 'TCPServer\uDIOCPStreamCoder.pas',
  uIntfTCPClientContext in 'TCPServer\uIntfTCPClientContext.pas',
  uRunTimeINfoTools in 'TCPServer\uRunTimeINfoTools.pas',
  uEHSBIntf in 'IntfModule\uEHSBIntf.pas',
  uTCPServerIntf in 'IntfModule\uTCPServerIntf.pas',
  untWaterEffect in 'lib\untWaterEffect.pas',
  uEwellMqExpts in 'IntfModule\uEwellMqExpts.pas',
  uBaseIntf in 'IntfModule\uBaseIntf.pas',
  uResource in 'lib\uResource.pas',
  EHSBdfrm in 'IntfModule\EHSBdfrm.pas' {dfrmEHSB: TDataModule};

{$R *.res}
var
  ServerMain: TfrmDIOCPTcpServer;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.CreateForm(TfrmDIOCPTcpServer, ServerMain);
  Application.Run;
end.
