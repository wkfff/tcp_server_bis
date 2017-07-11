unit Progressfrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, RzAnimtr,
  Vcl.ExtCtrls;

type
  TfrmPrg = class(TForm)
    rznmtrProgress: TRzAnimator;
    il1: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrg: TfrmPrg;

implementation

{$R *.dfm}

end.
