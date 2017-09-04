unit MainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  Vcl.ComCtrls,
  System.IniFiles,
  CnDebug,
  diocp_coder_tcpServer, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    ilMain: TImageList;
    mmMain: TMainMenu;
    actServer: TActionList;
    actOpen: TAction;
    actClose: TAction;
    actDebug: TAction;
    actReOpen: TAction;
    actStop: TAction;
    N1: TMenuItem;
    mniReOpen: TMenuItem;
    mniDebug: TMenuItem;
    mniStop: TMenuItem;
    mniOpen: TMenuItem;
    pgcMain: TPageControl;
    tsServerStates: TTabSheet;
    pnlMonitor: TPanel;
    traMain: TTrayIcon;
    pmTray: TPopupMenu;
    actHide: TAction;
    actShow: TAction;
    mniShow: TMenuItem;
    mniHide: TMenuItem;
    mniOpen1: TMenuItem;
    mniReOpen1: TMenuItem;
    mniStop1: TMenuItem;
    mniClose: TMenuItem;
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure actOpenExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actDebugExecute(Sender: TObject);
    procedure actReOpenExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actHideExecute(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure traMainDblClick(Sender: TObject);
  private
    { Private declarations }
    FTcpServer: TDiocpCoderTcpServer;
    procedure SetServerPort;
  public
    { Public declarations }
  end;

implementation

uses
  YltShareVariable,
  YltStreamCoder,
  YltIntfTCPClientContext,
  ServerMMonitorFrame;

{$R *.dfm}

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.actDebugExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.actHideExecute(Sender: TObject);
begin
  Hide;
  WindowState := wsMinimized;
end;

procedure TfrmMain.actOpenExecute(Sender: TObject);
begin
  if not FTcpServer.Active then
    FTcpServer.Active := True;
  actOpen.Enabled := False;
end;

procedure TfrmMain.actReOpenExecute(Sender: TObject);
begin
  FTcpServer.SafeStop;
  SetServerPort;
  FTcpServer.Active := True;
end;

procedure TfrmMain.actShowExecute(Sender: TObject);
begin
  WindowState := wsNormal;
  Show;
  Application.BringToFront;
end;

procedure TfrmMain.actStopExecute(Sender: TObject);
begin
  FTcpServer.SafeStop;
  actOpen.Enabled := True;
end;

procedure TfrmMain.FormCanResize(Sender: TObject; var NewWidth, NewHeight:
  Integer; var Resize: Boolean);
begin
  Resize := False;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Hide;
  WindowState := wsMinimized;
  CanClose := False;
end;

procedure TfrmMain.SetServerPort;
var
  AIni: TIniFile;
begin
  if not Assigned(FTcpServer) then
    Exit;
  AIni := nil;
  try
    AIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + SERVER_INI_FILE_PATH);
    FTcpServer.Port := AIni.ReadInteger('Server', 'Port', 8923);
  finally
    FreeAndNil(AIni);
  end;
end;

procedure TfrmMain.traMainDblClick(Sender: TObject);
begin
  actShow.Execute;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //
  CnDebugger.AutoStart := False;
  CnDebugger.DumpFileName := LOG_FILE_NAME;
  CnDebugger.DumpToFile := True;
  CnDebugger.ExceptTracking := False;

  FTcpServer := TDiocpCoderTcpServer.Create(Self);
  SetServerPort;
  FTcpServer.Name := 'tcp_server_bis_main';
  FTcpServer.createDataMonitor;
  FTcpServer.registerCoderClass(TIOCPStreamDecoder, TIOCPStreamEncoder);
  FTcpServer.registerContextClass(TMyTCPClientContext);

  TFMMonitor.createAsChild(pnlMonitor, FTcpServer);
  FTcpServer.LogicWorkerNeedCoInitialize := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FTcpServer.Free;
end;

end.

