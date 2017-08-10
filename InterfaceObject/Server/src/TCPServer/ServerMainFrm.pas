unit ServerMainFrm;

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
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  System.Actions,
  Vcl.ActnList,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Menus,
  System.IniFiles,
  Vcl.StdCtrls,
  diocp_tcp_server,
  diocp_coder_tcpServer,
  ServerMMonitorFrm,
  uDIOCPStreamCoder,
  uIntfTCPClientContext,
  CnDebug,
  uResource,
  uLogAppender;

type
  TfrmDIOCPTcpServer = class(TForm)
    pgcMain: TPageControl;
    tsServerStaes: TTabSheet;
    traMain: TTrayIcon;
    pmTray: TPopupMenu;
    actShow1: TMenuItem;
    actHide1: TMenuItem;
    actQuit1: TMenuItem;
    actPop: TActionList;
    actShow: TAction;
    actHide: TAction;
    actReopen: TAction;
    pnlMonitor: TPanel;
    actOpen: TAction;
    actOpen1: TMenuItem;
    mmMain: TMainMenu;
    o1: TMenuItem;
    O2: TMenuItem;
    actClose1: TMenuItem;
    mniClose: TMenuItem;
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure actShowExecute(Sender: TObject);
    procedure actHideExecute(Sender: TObject);
    procedure actReopenExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure traMainDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure mniCloseClick(Sender: TObject);
  private
    { Private declarations }
    FTcpServer: TDiocpCoderTcpServer;
    procedure SetServerPort;
  public
    { Public declarations }
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TfrmDIOCPTcpServer.actReopenExecute(Sender: TObject);
begin
  //
  SetServerPort;
  FTcpServer.SafeStop;
  FTcpServer.Active := True;
end;

procedure TfrmDIOCPTcpServer.actHideExecute(Sender: TObject);
begin
  //
  Hide;
  WindowState := wsMinimized;
end;

procedure TfrmDIOCPTcpServer.actOpenExecute(Sender: TObject);
begin
  if not FTcpServer.Active then
    FTcpServer.Active := True;
  actOpen1.Enabled := False;
end;

procedure TfrmDIOCPTcpServer.actShowExecute(Sender: TObject);
begin
  //
  WindowState := wsNormal;
  Show;
  Application.BringToFront;
end;

destructor TfrmDIOCPTcpServer.Destroy;
begin
  traMain.Visible := False;
  FTcpServer.SafeStop;
  FTcpServer.Free;
  inherited Destroy;
end;

procedure TfrmDIOCPTcpServer.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := False;
end;

procedure TfrmDIOCPTcpServer.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Hide;
  WindowState := wsMinimized;
  CanClose := False;
end;

procedure TfrmDIOCPTcpServer.SetServerPort;
var
  ServerIni: TIniFile;
begin
  ServerIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DIOCP_TCP_SERVER_INI_FILE);
  try
    FTcpServer.Port := ServerIni.ReadInteger('Server', 'Port', 8923);
  finally
    ServerIni.Free;
  end;
end;

procedure TfrmDIOCPTcpServer.FormCreate(Sender: TObject);
begin
  CnDebugger.AutoStart := False;
  CnDebugger.DumpToFile := True;
  CnDebugger.DumpFileName := 'tcp_server_log.log';
  FTcpServer := TDiocpCoderTcpServer.Create(Self);
  SetServerPort;
  FTcpServer.Name := 'WHTX_TCPServer';
  FTcpServer.createDataMonitor;
  // register decoder and encoder class
  FTcpServer.registerCoderClass(TIOCPStreamDecoder, TIOCPStreamEncoder);
  FTcpServer.registerContextClass(TMyTCPClientContext);

  TFMMonitor.createAsChild(pnlMonitor, FTcpServer);
  FTcpServer.LogicWorkerNeedCoInitialize := true;
end;

procedure TfrmDIOCPTcpServer.mniCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmDIOCPTcpServer.traMainDblClick(Sender: TObject);
begin
  if Self.Visible then
    actHide.Execute
  else
    actShow.Execute;
end;

end.

