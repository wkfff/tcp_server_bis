unit toolMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.Menus, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TtoolMainFrm = class(TForm)
    mmMain: TMainMenu;
    actMain: TActionList;
    tlbMain: TToolBar;
    T1: TMenuItem;
    DebugTool1: TMenuItem;
    ilToolbar: TImageList;
    btnXML: TToolButton;
    btn1: TToolButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
