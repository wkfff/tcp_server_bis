program ToolKit;

{ Reduce EXE size by disabling as much of RTTI as possible (delphi XE10.1 }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}

uses
  Vcl.Forms,
  Winapi.Windows,
  Mainfrm in 'form\Mainfrm.pas' {frmToolBox},
  VersionInfofrm in 'form\VersionInfofrm.pas' {frmVersionInfo};

{$R *.res}

var
  frmToolBox: TfrmToolBox;
  hMutex: HWND;
  iRet: Integer;

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  hMutex := CreateMutex(nil, False, PChar('TOOL_KIT_MUTEX_ONE'));//�����������
  iRet := GetLastError;
  if iRet <> ERROR_ALREADY_EXISTS then //�����ɹ�, ���г���
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmToolBox, frmToolBox);
    Application.Run;
  end;
  ReleaseMutex(hMutex);    //�ͷŻ������
end.
