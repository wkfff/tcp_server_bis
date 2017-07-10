unit EvunToolfrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.SysStyles,
  qplugins_base,
  QPlugins,
  qstring,
  qplugins_formsvc,
  qplugins_vcl_messages,
  qplugins_vcl_formsvc,
  Vcl.StdCtrls;

type
  Tpanel = class(TForm, IQNotify)
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FNotifyIds: TDictionary<string, Integer>;
  protected
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  public
    { Public declarations }
    destructor Destroy; override;
  end;

const
  NOTIFY_ID_CHANGE_VCL_STYLE = 'CHANGE_VCL_STYLE';
  ServiceName: PWideChar = 'EvunTool';
  ServiceId:TGuid = '{76397A4F-5350-498D-9CE3-AAF3F9CDAB31}';

implementation

{$R *.dfm}

procedure Tpanel.btn1Click(Sender: TObject);
begin
  Self.Close;
end;

destructor Tpanel.Destroy;
var
  ANotifyMgr: IQNotifyManager;
begin
  ANotifyMgr := PluginsManager as IQNotifyManager;
  ANotifyMgr.Unsubscribe(FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE], Self);
  FNotifyIds.Free;
  inherited;
end;

procedure Tpanel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tpanel.FormCreate(Sender: TObject);
var
  ANotifyMgr: IQNotifyManager;
begin
  FNotifyIds := TDictionary<string, Integer>.Create;
  TStyleManager.SystemHooks := TStyleManager.SystemHooks - [shMenus];
  TStyleManager.TrySetStyle('Windows10 SlateGray', False);
  ANotifyMgr := PluginsManager as IQNotifyManager;
  FNotifyIds.Add(NOTIFY_ID_CHANGE_VCL_STYLE, ANotifyMgr.IdByName(NOTIFY_ID_CHANGE_VCL_STYLE));
  ANotifyMgr.Subscribe(FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE], Self);
end;

procedure Tpanel.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  if AId = FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE] then
  begin
    TStyleManager.TrySetStyle(AParams.ByName('VCLStyleName').AsString.Value);
  end;
end;

initialization
  RegisterFormService('/Services/Docks/Forms', 'EvunTool', Tpanel, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['EvunTool']);

end.

