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
  dxSkinsCore,
  dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark,
  dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light,
  dxSkinsdxBarPainter,
  dxBar,
  cxClasses,
  System.ImageList,
  Vcl.ImgList,
  cxGraphics,
  dxRibbonGallery,
  dxSkinChooserGallery,
  cxLookAndFeels, System.Actions, Vcl.ActnList, cxControls,
  cxLookAndFeelPainters, dxNavBarCollns, dxNavBarBase, cxSplitter, dxNavBar,
  dxSkinsdxNavBarPainter, dxSkinsdxNavBarAccordionViewPainter, Vcl.ExtCtrls,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, RzPanel, RzSplit;

type
  TfrmToolbox = class(TForm)
    bmMain: TdxBarManager;
    barMainMenu: TdxBar;
    bsiSystem: TdxBarSubItem;
    bsiTheme: TdxBarSubItem;
    imgLarge_32X32: TcxImageList;
    imgSmall_16X16: TcxImageList;
    scgiMain: TdxSkinChooserGalleryItem;
    lfcMain: TcxLookAndFeelController;
    bbtnClose: TdxBarButton;
    actMain: TActionList;
    actClose: TAction;
    RzSplitter1: TRzSplitter;
    procedure scgiMainSkinChanged(Sender: TObject; const ASkinName: string);
    procedure actCloseExecute(Sender: TObject);
  private
    procedure SetSkin(ASkinItem: TdxSkinChooserGalleryGroupItem);
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmToolbox.actCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmToolbox.scgiMainSkinChanged(Sender: TObject; const ASkinName:
  string);
begin
  SetSkin(scgiMain.SelectedGroupItem);
end;

procedure TfrmToolbox.SetSkin(ASkinItem: TdxSkinChooserGalleryGroupItem);
begin
  ASkinItem.ApplyToRootLookAndFeel;
end;

end.

