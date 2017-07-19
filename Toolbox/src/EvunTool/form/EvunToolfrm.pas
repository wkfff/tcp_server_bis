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
  qplugins_base,
  QPlugins,
  qplugins_vcl_formsvc,
  qplugins_vcl_messages,
  Vcl.ExtCtrls,
  RzPanel,
  RzSplit,
  System.ImageList,
  Vcl.ImgList,
  cxGraphics,
  RzTabs,
  SynEdit,
  RzButton,
  RzRadChk, JvImageList, SynEditHighlighter, SynHighlighterIni,
  SynHighlighterXML, VirtualTrees, dxGDIPlusClasses;

type
  TfrmEvunTool = class(TForm)
    splEvunTool: TRzSplitter;
    tbrButtons: TRzToolbar;
    sedtArgus: TSynEdit;
    pgcResults: TRzPageControl;
    tstXML: TRzTabSheet;
    cbxStart: TRzCheckBox;
    il16X16: TJvImageList;
    rzpnlServer: TRzPanel;
    sedtXML: TSynEdit;
    sisIni: TSynIniSyn;
    sxsXML: TSynXMLSyn;
    pcr1: TRzSpacer;
    btnList: TRzToolButton;
    btnLog: TRzToolButton;
    btnExcute: TRzToolButton;
    rzpnlList: TRzPanel;
    vstList: TVirtualStringTree;
    procedure FormResize(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure vstListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation


{$R *.dfm}

procedure TfrmEvunTool.btnListClick(Sender: TObject);
begin
  rzpnlList.Show;
end;

procedure TfrmEvunTool.FormResize(Sender: TObject);
begin
  splEvunTool.UsePercent := False;
  splEvunTool.Percent := 50;
  splEvunTool.UsePercent := True;
end;

procedure TfrmEvunTool.vstListDblClick(Sender: TObject);
begin
  rzpnlList.Hide;
end;

initialization
  RegisterFormService('/Services/Docks/Forms', 'EvunTool', TfrmEvunTool, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['EvunTool']);

end.

