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
  SynEdit, SynEditHighlighter, SynHighlighterXML, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btnSend: TButton;
    btn1: TButton;
    sedt1: TSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    SynEdit1: TSynEdit;
    pnl1: TPanel;
    spl1: TSplitter;
    sedt2: TSynEdit;
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
  sSend: string;
  ASend: PWideChar;
  I: Integer;
begin
  //
  for I := 0 to 100 do
  begin
    sSend := SynEdit1.Text;
    ASend := IntfGetHisInfo(PWideChar(sSend));
  end;
end;

procedure TForm1.btnSendClick(Sender: TObject);
var
  sSend: string;
  ASend: PWideChar;
begin
  //
  sSend := sedt1.Text;
  ASend := IntfGetHisInfo(PWideChar(sSend));
  sedt2.Text := ASend;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sedt1.Text := '<?xml version="1.0" encoding="utf-8"?>' + '<interfacemessage>'
    + '<hospitalcode>hospitalcode</hospitalcode>' +
    '<interfacename>getwardinfos</interfacename>' +
    '<interfaceparms>none</interfaceparms>' + '</interfacemessage>';
end;

end.

