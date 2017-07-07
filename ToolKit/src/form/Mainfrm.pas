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
  RzTabs,
  System.Actions,
  Vcl.ActnList,
  qplugins_vcl_formsvc,
  qplugins_loader_lib,
  qstring,
  qplugins,
  qplugins_base,
  qplugins_params,
  qplugins_vcl_Messages,
  qplugins_formsvc;

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
    actMenu: TActionList;
    btnDMSTool: TRzToolButton;
    scrTools: TRzSpacer;
    grpTools: TRzGroup;
    actEvunTool: TAction;
    grpSystem: TRzGroup;
    btnThemeB: TRzMenuButton;
    actQuit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actEvunToolExecute(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
  private
    { Private declarations }
    /// <summary>
    /// Hook主题菜单单击事件
    /// </summary>
    procedure DoThemeSubMenuItemClick(Sender: TObject);
    /// <summary>
    /// 初始化系统菜单
    /// </summary>
    procedure InitializeSystemMenu;
    /// <summary>
    /// 初始化主界面状态
    /// </summary>
    procedure InitializeMainFormStates;
    /// <summary>
    /// Dock窗口释放事件
    /// </summary>
    procedure DoDockChildFree(AForm: IQFormService);
    /// <summary>
    /// 窗体 Dock  TabPage控件
    /// </summary>
    procedure DockPage(AFormService: IQFormService; AImageIndex: Integer;
       AHoldNeeded: Boolean = False);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmMain.actEvunToolExecute(Sender: TObject);
var
  I: Integer;
  AFormService: IQFormService;
begin
  if Supports(PluginsManager.ByPath('Services/Docks/Forms/EvunTool'), IQFormService,
    AFormService) then
  begin
    for I := 0 to pgcMain.PageCount - 1 do
      if pgcMain.Pages[I].Tag = intPtr(AFormService) then     //确保单例打开
        Exit;
    DockPage(AFormService, 6);
  end;
end;

procedure TfrmMain.DockPage(AFormService: IQFormService; AImageIndex: Integer;
  AHoldNeeded: Boolean);
var
  APage: TRzTabSheet;
  AEvents: TQFormEvents;
begin
  APage := TRzTabSheet.Create(pgcMain);
  APage.PageControl := pgcMain;
  APage.Caption := (AFormService as IQService).Name;
  APage.ImageIndex := AImageIndex;
  APage.Tag := IntPtr(AFormService);

  AFormService.DockTo(APage.Handle, faContent);
  FillChar(AEvents, SizeOf(AEvents), 0);
  AEvents.OnFree := DoDockChildFree;
  AFormService.HookEvents(AEvents);
  if AHoldNeeded then
    HoldByComponent(APage, AFormService);
  pgcMain.ActivePage := APage;
end;

procedure TfrmMain.DoDockChildFree(AForm: IQFormService);
var
  I: Integer;
begin
  for I := 0 to pgcMain.PageCount - 1 do
  begin
    if pgcMain.Pages[I].Tag = IntPtr(AForm) then
    begin
      AForm.UnhookEvents;
      FreeObject(pgcMain.Pages[I]);
      Break;
    end;
  end;
end;

procedure TfrmMain.actQuitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

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
  begin
    mniThemes.Items[I].Checked := mniThemes.Items[I].Hint = AItem.Hint;
    pmTheme.Items[I].Checked := mniThemes.Items[I].Checked;
  end;
  btnTheme.Caption := AItem.Hint;
  btnThemeB.Caption := AItem.Hint;
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
    if SameText(TStyleManager.ActiveStyle.Name, TStyleManager.StyleNames[I])
      then
      AThemeSubItem.Checked := True;

    APopItem := TMenuItem.Create(mniThemes);
    APopItem.Caption := TStyleManager.StyleNames[I];
    APopItem.Hint := TStyleManager.StyleNames[I];
    APopItem.OnClick := DoThemeSubMenuItemClick;
    if SameText(TStyleManager.ActiveStyle.Name, TStyleManager.StyleNames[I])
      then
      APopItem.Checked := True;
    pmTheme.Items.Add(APopItem);
    mniThemes.Add(AThemeSubItem);
  end;
  btnTheme.Caption := TStyleManager.ActiveStyle.Name;
  btnThemeB.Caption := TStyleManager.ActiveStyle.Name;
end;

procedure TfrmMain.InitializeMainFormStates;
begin
  WindowState := wsMaximized;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //初始化  主菜单
  InitializeSystemMenu;
  //初始化  主界面状态
  InitializeMainFormStates;

end;

end.

