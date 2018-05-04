unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.ExtActns, Vcl.Menus, RzButton,
  System.ImageList, Vcl.ImgList, JvImageList, Vcl.ExtCtrls, RzPanel;

type
  TForm5 = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    FileOpen1: TFileOpen;
    FileOpenWith1: TFileOpenWith;
    FileSaveAs1: TFileSaveAs;
    FilePrintSetup1: TFilePrintSetup;
    FilePageSetup1: TFilePageSetup;
    FileRun1: TFileRun;
    FileExit1: TFileExit;
    BrowseForFolder1: TBrowseForFolder;
    tb1: TRzToolbar;
    ilSmall16X16: TJvImageList;
    btn1: TRzToolButton;
    act3: TAction;
    act1: TAction;
    act2: TAction;
    procedure FileSaveAs1BeforeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FileOpenWith1AfterOpen(Sender: TObject);
    procedure FileOpen1BeforeExecute(Sender: TObject);
    procedure FilePrintSetup1BeforeExecute(Sender: TObject);
    procedure FilePageSetup1BeforeExecute(Sender: TObject);
    procedure FileRun1Hint(var HintStr: string; var CanShow: Boolean);
    procedure FileExit1Hint(var HintStr: string; var CanShow: Boolean);
    procedure BrowseForFolder1BeforeExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.BrowseForFolder1BeforeExecute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm5.FileExit1Hint(var HintStr: string; var CanShow: Boolean);
begin
  ShowMessage('');
end;

procedure TForm5.FileOpen1BeforeExecute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm5.FileOpenWith1AfterOpen(Sender: TObject);
begin
  //
  ShowMessage('');
end;

procedure TForm5.FilePageSetup1BeforeExecute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm5.FilePrintSetup1BeforeExecute(Sender: TObject);
begin
  ShowMessage('');
end;

procedure TForm5.FileRun1Hint(var HintStr: string; var CanShow: Boolean);
begin
  ShowMessage('');
end;

procedure TForm5.FileSaveAs1BeforeExecute(Sender: TObject);
begin
  //
  ShowMessage('');
end;

procedure TForm5.FormShow(Sender: TObject);
var
  ABarItem: TActionBarItem;
  AClientItem: TActionClientItem;
  ASubItem: TActionClientItem;
  I: Integer;
begin
  ABarItem := ActionManager1.ActionBars.Add;

  AClientItem := ABarItem.Items.Add;
  AClientItem.Caption := '&File';
  AClientItem.Visible := True;
  for I := 0 to ActionManager1.ActionCount - 1 do
  begin
    if ActionManager1.Actions[I].Category = 'File' then
    begin
      ASubItem := AClientItem.Items.Add;
      ASubItem.Caption := ActionManager1.Actions[I].Caption;
      ASubItem.ImageIndex := ActionManager1.Actions[I].ImageIndex;
      ASubItem.Action := ActionManager1.Actions[I];
      ASubItem.Action.Enabled := True;
      ASubItem.Visible := True;
    end;
  end;

  AClientItem := ABarItem.Items.Add;
  AClientItem.Caption := '&Edit';
  AClientItem.Visible := True;
  for I := 0 to ActionManager1.ActionCount - 1 do
  begin
    if ActionManager1.Actions[I].Category = 'Edit' then
    begin
      ASubItem := AClientItem.Items.Add;
      ASubItem.Caption := ActionManager1.Actions[I].Caption;
      ASubItem.ImageIndex := ActionManager1.Actions[I].ImageIndex;
      ASubItem.Action := ActionManager1.Actions[I];
      ASubItem.Action.Enabled := True;
      ASubItem.Visible := True;
    end;
  end;

  ABarItem.ActionBar := ActionMainMenuBar1;
  with ActionMainMenuBar1 do
      SetBounds(
        0,
        0,
        Controls[ControlCount-1].BoundsRect.Right + 2 + ActionMainMenuBar1.HorzMargin,
        Height
      );
end;

end.
