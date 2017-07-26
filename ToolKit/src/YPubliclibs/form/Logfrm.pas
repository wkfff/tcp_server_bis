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
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  public
    { Public declarations }
    destructor Destroy;override;
  end;

var
  frmLogger: TfrmLogger;
  ToolLog: TSafeLogger;

implementation

{$R *.dfm}

destructor TfrmLogger.Destroy;
begin
  FreeAndNil(ToolLog);
  inherited;
end;

procedure TfrmLogger.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmLogger.FormCreate(Sender: TObject);
begin
  //
  if not Assigned(ToolLog) then
  begin
    ToolLog := TSafeLogger.Create;
    ToolLog.setAppender(TStringsAppender.Create(sedtLog.Lines));
  end;
end;

procedure TfrmLogger.mniN1Click(Sender: TObject);
begin
  sedtLog.Clear;
end;

procedure TfrmLogger.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
end;

initialization
  if not Assigned(frmLogger) then
    frmLogger := TfrmLogger.Create(Application);

finalization
  FreeAndNil(frmLogger);

end.

