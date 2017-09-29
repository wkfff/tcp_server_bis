program InterfaceServer;

{$DEFINE FZSE_INTF} //�Ƿ����ø����ж��ӿڣ��ýӿ������ⲿDLL

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
{$IFDEF FZSE_INTF}
  ServiceFZSE in 'hospitalservices\ServiceFZSE.pas',
  ManagerEntity in 'hospitalservices\EwllMQClass\ManagerEntity.pas',
  EWellMQClass in 'hospitalservices\EwllMQClass\EWellMQClass.pas',
  MQClass in 'hospitalservices\EwllMQClass\mq\MQClass.pas',
  MQI in 'hospitalservices\EwllMQClass\mq\MQI.pas',
  MQIC in 'hospitalservices\EwllMQClass\mq\MQIC.pas',
  EwellMqExpts in 'hospitalservices\EwllMQClass\EwellMqExpts.pas',
{$ENDIF}
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
  hMutex := CreateMutex(nil, False, PChar('INTERFACESERVER_BIS_TEST'));//�����������
  iRet := GetLastError;
  if iRet <> ERROR_ALREADY_EXISTS then //�����ɹ�, ���г���
  begin
    Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Windows10 SlateGray');
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;
  ReleaseMutex(hMutex);    //�ͷŻ������
end.
