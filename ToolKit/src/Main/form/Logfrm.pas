unit Logfrm;

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
  SynEdit,
  qplugins_base,
  QPlugins,
  utils_safeLogger,
  Vcl.Menus;

type
  TfrmLogger = class(TForm, IQNotify)
    sedtLog: TSynEdit;
    pm1: TPopupMenu;
    mniN1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniN1Click(Sender: TObject);
  private
    { Private declarations }
    FNotifyId_log: Integer;
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  public
    { Public declarations }
  end;

var
  frmLogger: TfrmLogger;

implementation

{$R *.dfm}

procedure TfrmLogger.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmLogger.FormCreate(Sender: TObject);
begin
  //
  sfLogger.setAppender(TStringsAppender.Create(sedtLog.Lines));
  FNotifyId_log := (PluginsManager as IQNotifyManager).IdByName('__safe_Logger__');
  (PluginsManager as IQNotifyManager).Subscribe(FNotifyId_log, Self);
end;

procedure TfrmLogger.mniN1Click(Sender: TObject);
begin
  sedtLog.Clear;
end;

procedure TfrmLogger.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  if AId = FNotifyId_log then
  begin
    sfLogger.logMessage(AParams.Items[0].AsString.Value);
    sedtLog.GotoLineAndCenter(sedtLog.Lines.Count);
  end;
end;

end.

