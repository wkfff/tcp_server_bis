unit EvunToolfrm;

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
  qstring,
  QPlugins,
  qplugins_vcl_formsvc, RzTabs, Vcl.StdCtrls;

type
  TfrmEvunTool = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmEvunTool.btn1Click(Sender: TObject);
begin
  Self.Free;
end;

initialization
  RegisterFormService('/Services/Docks/Forms', 'EvunTool', TfrmEvunTool, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['EvunTool']);

end.

