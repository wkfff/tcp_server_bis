program DIOCPTCPServer;

{$R *.dres}
{ Reduce EXE size by disabling as much of RTTI as possible (delphi XE10.1 }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}
uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Winapi.Windows,
  ServerMMonitorFrm in 'TCPServer\ServerMMonitorFrm.pas' {FMMonitor: TFrame},
  ServerMainFrm in 'TCPServer\ServerMainFrm.pas' {frmDIOCPTcpServer},
  uDIOCPStreamCoder in 'TCPServer\uDIOCPStreamCoder.pas',
  uIntfTCPClientContext in 'TCPServer\uIntfTCPClientContext.pas',
  uRunTimeINfoTools in 'TCPServer\uRunTimeINfoTools.pas',
  uEHSBIntf in 'IntfModule\uEHSBIntf.pas',
  uTCPServerIntf in 'IntfModule\uTCPServerIntf.pas',
  uEwellMqExpts in 'IntfModule\uEwellMqExpts.pas',
  uBaseIntf in 'IntfModule\uBaseIntf.pas',
  uResource in 'lib\uResource.pas',
  EHSBdfrm in 'IntfModule\EHSBdfrm.pas' {dfrmEHSB: TDataModule},
  uLogAppender in 'lib\uLogAppender.pas',
  uHBTMintf in 'IntfModule\uHBTMintf.pas',
  ICalculateService in 'IntfModule\ICalculateService.pas';

{$R *.res}
var
  ServerMain: TfrmDIOCPTcpServer;
  hMutex: HWND;
  iRet: Integer;

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}
  Application.Initialize;
  hMutex := CreateMutex(nil, False, PChar(FMutex));//创建互斥对象
  iRet := GetLastError;
  if iRet <> ERROR_ALREADY_EXISTS then //创建成功, 运行程序
  begin
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Windows10 SlateGray');
    Application.CreateForm(TfrmDIOCPTcpServer, ServerMain);
    Application.Run;
  end;
  ReleaseMutex(hMutex);    //释放互斥对象
end.

