unit Unit3;

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
  Vcl.StdCtrls,
  QPlugins,
  qplugins_base;

type
  TForm3 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
var
  I: Int64;
begin
  //
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName('ProgressStart'), nil);
   for I := 0 to 1000000000 do
   begin
     GetTickCount();
   end;
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName('ProgressEnd'), nil);
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName('ProgressEnd'), nil);
end;

end.

