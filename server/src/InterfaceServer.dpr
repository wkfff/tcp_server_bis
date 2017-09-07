program InterfaceServer;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Winapi.Windows,
  MainForm in 'mainform\MainForm.pas' {frmMain},
  CnDebug in 'publiclibs\CnDebug.pas',
  CnPropSheetFrm in 'publiclibs\CnPropSheetFrm.pas' {CnPropSheetForm},
  ServerMMonitorFrame in 'diocp\ServerMMonitorFrame.pas' {FMMonitor: TFrame},
  YltRunTimeINfoTools in 'diocp\YltRunTimeINfoTools.pas',
  YltStreamCoder in 'diocp\YltStreamCoder.pas',
  YltShareVariable in 'publiclibs\YltShareVariable.pas',
  YltIntfTCPClientContext in 'diocp\YltIntfTCPClientContext.pas',
  IHospitalBISServiceIntf in 'interfaces\IHospitalBISServiceIntf.pas',
  ServiceHBTM in 'hospitalservices\ServiceHBTM.pas',
  ICalculateServiceIntf in 'interfaces\ICalculateServiceIntf.pas',
  PythonScriptdm in 'datamodule\PythonScriptdm.pas' {dmPythonScript: TDataModule},
  DataBasedm in 'datamodule\DataBasedm.pas' {dmDatabase: TDataModule},
  EwellMqExpts in 'hospitalservices\EwellMqExpts.pas',
  ServiceFZSE in 'hospitalservices\ServiceFZSE.pas',
  IPythonScriptServiceIntf in 'interfaces\IPythonScriptServiceIntf.pas',
  AndyDelphiPy in 'datamodule\AndyDelphiPy.pas';

{$R *.res}

var
  frmMain: TfrmMain;
  hMutex: HWND;
  iRet: Integer;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  hMutex := CreateMutex(nil, False, PChar('INTERFACESERVER_BIS'));//创建互斥对象
  iRet := GetLastError;
  if iRet <> ERROR_ALREADY_EXISTS then //创建成功, 运行程序
  begin
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Windows10 SlateGray');
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  end;
  ReleaseMutex(hMutex);    //释放互斥对象
end.
