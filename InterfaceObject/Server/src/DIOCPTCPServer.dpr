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
  MQClass in 'lib\MQClass.pas',
  MQI in 'lib\MQI.pas',
  MQIC in 'lib\MQIC.pas',
  untWaterEffect in 'lib\untWaterEffect.pas',
  uEwellMqExpts in 'IntfModule\uEwellMqExpts.pas';

{$R *.res}
var
  ServerMain: TfrmDIOCPTcpServer;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Carbon');
  Application.CreateForm(TfrmDIOCPTcpServer, ServerMain);
  Application.Run;
end.
