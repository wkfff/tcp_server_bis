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
  cxGraphics,
  RzTabs;

type
  TfrmMain = class(TForm)
    szpnlMenuButtons: TRzSizePanel;
    gbrMenuButtons: TRzGroupBar;
    tlbrMenuButtons: TRzToolbar;
    mmMain: TMainMenu;
    mniSystem: TMenuItem;
    mniThemes: TMenuItem;
    mniQuit: TMenuItem;
    imgSmall_16X16: TcxImageList;
    imgLarge_32X32: TcxImageList;
    pgcMain: TRzPageControl;
    scrSystem: TRzSpacer;
    btnTheme: TRzMenuButton;
    btnClose: TRzToolButton;
    pmTheme: TPopupMenu;
    mniTools: TMenuItem;
    mniDMSTool: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure mniQuitClick(Sender: TObject);
  private
    { Private declarations }
    /// <summary>
    /// Hook����˵������¼�
    /// </summary>
    procedure DoThemeSubMenuItemClick(Sender: TObject);
    /// <summary>
    /// ��ʼ��ϵͳ�˵�
    /// </summary>
    procedure InitializeSystemMenu;
    /// <summary>
    /// ��ʼ��������״̬
    /// </summary>
    procedure InitializeMainFormStates;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmMain.DoThemeSubMenuItemClick(Sender: TObject);
var
  AItem: TMenuItem;
  I: Integer;
begin
  if not (Sender is TMenuItem) then
    Exit;
  AItem := TMenuItem(Sender);
  TStyleManager.TrySetStyle(AItem.Hint, False);
  for I := 0 to AItem.Parent.Count - 1 do
    AItem.Parent.Items[I].Checked := False;
  AItem.Checked := True;
end;

procedure TfrmMain.InitializeSystemMenu;
var
  I: Integer;
  AThemeSubItem: TMenuItem;
  APopItem: TMenuItem;
begin
  for I := Low(TStyleManager.StyleNames) to High(TStyleManager.StyleNames) do
  begin
    AThemeSubItem := TMenuItem.Create(mniThemes);
    AThemeSubItem.Caption := TStyleManager.StyleNames[I];
    AThemeSubItem.Hint := TStyleManager.StyleNames[I];
    AThemeSubItem.OnClick := DoThemeSubMenuItemClick;
    if SameText(TStyleManager.ActiveStyle.Name, TStyleManager.StyleNames[I]) then
      AThemeSubItem.Checked := True;

    APopItem := TMenuItem.Create(mniThemes);
    APopItem.Caption := TStyleManager.StyleNames[I];
    APopItem.Hint := TStyleManager.StyleNames[I];
    APopItem.OnClick := DoThemeSubMenuItemClick;
    if SameText(TStyleManager.ActiveStyle.Name, TStyleManager.StyleNames[I]) then
      APopItem.Checked := True;
    pmTheme.Items.Add(APopItem);
    mniThemes.Add(AThemeSubItem);
  end;
end;

procedure TfrmMain.mniQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.InitializeMainFormStates;
begin
  WindowState := wsMaximized;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //��ʼ��  ���˵�
  InitializeSystemMenu;
  //��ʼ��  ������״̬
  InitializeMainFormStates;

end;

end.

