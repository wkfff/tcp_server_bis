unit Mainfrm;

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
  Vcl.ExtCtrls,
  RzPanel,
  RzSplit,
  RzGroupBar,
  Vcl.Menus,
  System.ImageList,
  Vcl.ImgList,
  RzButton,
  Vcl.StdCtrls,
  RzCmboBx,
  Vcl.Themes,
  System.Actions,
  Vcl.ActnList,
  cxGraphics, RzTabs,
  DMSToolfrm,
  QWorker,
  qplugins_params;

type
  TfrmMain = class(TForm)
    szpnlMenuButtons: TRzSizePanel;
    gbrMenuButtons: TRzGroupBar;
    tlbrMenuButtons: TRzToolbar;
    mmMain: TMainMenu;
    mniSystem: TMenuItem;
    mniThemes: TMenuItem;
    mniQuit: TMenuItem;
    mniTools: TMenuItem;
    mniDMSTool: TMenuItem;
    grpTools: TRzGroup;
    btnDMSTool: TRzToolButton;
    cmbTheme: TRzComboBox;
    grpTheme: TRzGroup;
    act1: TActionList;
    act2: TAction;
    imgSmall_16X16: TcxImageList;
    imgLarge_32X32: TcxImageList;
    scr1: TRzSpacer;
    pgcMain: TRzPageControl;
    tbsDMS: TRzTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure cmbThemeChange(Sender: TObject);
    procedure grpToolsItems0Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmMain.cmbThemeChange(Sender: TObject);
begin
  if cmbTheme.Text = '' then
    Exit;
  TStyleManager.TrySetStyle(cmbTheme.Text, False);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(TStyleManager.StyleNames) to High(TStyleManager.StyleNames) do
    cmbTheme.Items.Add(TStyleManager.StyleNames[I]);
  WindowState := wsMaximized;
end;

procedure TfrmMain.grpToolsItems0Click(Sender: TObject);
var
  AParams: TQParams;
begin
  //
  AParams := TQParams.Create;
  AParams.Add('TabIndex', pgcMain.ActivePageIndex);
  Workers.PostSignal('MDIChildForm.' + 'DMSTool' + '.Create', AParams,
    jdfFreeAsObject);
end;

end.

