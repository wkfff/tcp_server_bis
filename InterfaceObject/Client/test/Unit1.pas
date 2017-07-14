unit Unit1;

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
  qxml,
  SynEdit;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    btn1: TButton;
    sedt1: TSynEdit;
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function IntfGetHisInfo(const ASendData: PWideChar): PChar; stdcall; external
  'DIOCPTcpClient.dll' name 'IntfGetHisInfo';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  FXmlNode: TQXML;
  FChildNode: TQXML;
begin
  FXmlNode := TQXML.Create;
  FChildNode := FXmlNode.AddNode('results');
  FChildNode := FChildNode.AddNode('resultcode');
  FChildNode.Text := '-1';
  FChildNode := FXmlNode.ItemByPath('results');
  FChildNode := FChildNode.AddNode('message');
  FChildNode.Text := 'Erro';
  sedt1.Text := FXmlNode.AsXML;
end;

procedure TForm1.btnSendClick(Sender: TObject);
var
  sSend: string;
  ASend: PWideChar;
begin
  //
  sSend := sedt1.Text;
  ASend := IntfGetHisInfo(PWideChar(sSend));
  sedt1.Text := ASend;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sedt1.Text := '<?xml version="1.0" encoding="utf-8"?>' + '<interfacemessage>'
    + '<hospitalcode>hospitalcode</hospitalcode>' +
    '<interfacename>getwardinfos</interfacename>' +
    '<interfaceparms>none</interfaceparms>' + '</interfacemessage>';
end;

end.

