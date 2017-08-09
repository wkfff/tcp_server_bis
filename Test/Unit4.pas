unit Unit4;

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
  Vcl.StdCtrls,
  ICalculateService,
  qxml;

type
  TForm4 = class(TForm)
    sedt1: TSynEdit;
    sedt2: TSynEdit;
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
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.btn1Click(Sender: TObject);
var
  AService: ICalculateServicePortType;
  AInput: TQXML;
  ANode: TQXMLNode;
begin
//  AInput := funInterFace.Create;
//  AInput.in0 := sedt1.Text;
//  AService := GetICalculateServicePortType;
//  sedt2.Text := AService.funInterFace(sedt1.Text);
  AInput := TQXML.Create;
  ANode := AInput.AddNode('funderService');
  ANode.Attrs.Add('functionName').Value := 'xk_queryPatInfo';
  ANode.AddNode('value').Text := '000463271600';
  ANode.AddNode('value').Text := '1';
  sedt2.Text := AInput.Encode(False);
//  sedt2.Text := AOut.out_;
end;

procedure TForm4.btn2Click(Sender: TObject);
Var
  StrDate : string;
  Fmt     : TFormatSettings;
  dt      : TDateTime;
begin
  fmt.ShortDateFormat:='yyyy-mm-dd';
  fmt.DateSeparator  :='-';
  fmt.LongTimeFormat :='hh:nn:ss.z';
  fmt.TimeSeparator  :=':';
  StrDate:='2011-02-23 12:34:56.0';
  dt:=StrToDateTime(StrDate,Fmt);
  ShowMessage(FormatDateTime('yyyy-mm-dd hh:nn:ss.z', dt));
end;

end.

