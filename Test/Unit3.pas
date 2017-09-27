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
  qplugins_base,
  Vcl.StdActns,
  Vcl.DBActns,
  System.Actions,
  Vcl.ActnList,
  Vcl.ToolWin,
  Vcl.ActnMan,
  Vcl.ActnCtrls,
  Vcl.ActnMenus,
  Vcl.PlatformDefaultStyleActnCtrls,
  System.ImageList,
  Vcl.ImgList,
  JvImageList,
  Vcl.ExtCtrls,
  RzPanel,
  Vcl.Menus,
  RzButton,
  RzSplit;

type
  TForm3 = class(TForm)
    Button1: TButton;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    DatasetFirst1: TDataSetFirst;
    DatasetPrior1: TDataSetPrior;
    DatasetNext1: TDataSetNext;
    DatasetLast1: TDataSetLast;
    DatasetInsert1: TDataSetInsert;
    DatasetDelete1: TDataSetDelete;
    DatasetEdit1: TDataSetEdit;
    DatasetPost1: TDataSetPost;
    DatasetCancel1: TDataSetCancel;
    DatasetRefresh1: TDataSetRefresh;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    Action1: TAction;
    ilSmall16X16: TJvImageList;
    RzToolbar1: TRzToolbar;
    RzToolButton1: TRzToolButton;
    RzToolButton2: TRzToolButton;
    scr1: TRzSpacer;
    act1: TAction;
    PopupMenu1: TPopupMenu;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    Action2: TAction;
    RzToolButton3: TRzToolButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure act1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditCopy1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.act1Execute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm3.Action1Execute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm3.Action2Execute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm3.btn1Click(Sender: TObject);
var
  I: Int64;
begin
  //
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName
    ('ProgressStart'), nil);
  for I := 0 to 1000000000 do
  begin
    GetTickCount();
  end;
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName
    ('ProgressEnd'), nil);
end;

procedure TForm3.btn2Click(Sender: TObject);
begin
  (PluginsManager as IQNotifyManager).Send((PluginsManager as IQNotifyManager).IdByName
    ('ProgressEnd'), nil);
end;

procedure TForm3.EditCopy1Execute(Sender: TObject);
begin
  //
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  RzToolbar1.AutoResize := False;
  RzToolbar1.AutoStyle := False;
  RzToolbar1.AutoSize := False;
end;

end.

