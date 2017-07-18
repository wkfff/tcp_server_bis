unit Mainfrm;

interface

uses
  System.Rtti,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
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
  qjson,
  qplugins,
  qplugins_base,
  qplugins_params,
  qplugins_vcl_Messages,
  qplugins_formsvc,
  Progressfrm,
  RzPrgres,
  qworker,
  RzStatus;

type

  TModuleInfo = class
    ServiceId: THandle;
    ID: string;
    Path: string;
    Loader: string;
    ModulePath: string;
  end;

  TfrmMain = class(TForm, IQNotify)
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
    btnEvunTool: TRzToolButton;
    scrTools: TRzSpacer;
    grpTools: TRzGroup;
    actEvunTool: TAction;
    grpSystem: TRzGroup;
    btnThemeB: TRzMenuButton;
    actQuit: TAction;
    RzProgressBar1: TRzProgressBar;
    rzsbrMain: TRzStatusBar;
    RzGlyphStatus1: TRzGlyphStatus;
    RzProgressStatus1: TRzProgressStatus;
    RzStatusPane1: TRzStatusPane;
    RzClockStatus1: TRzClockStatus;
    procedure FormCreate(Sender: TObject);
    procedure actEvunToolExecute(Sender: TObject);
    procedure actQuitExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcMainClose(Sender: TObject; var AllowClose: Boolean);
    procedure FormResize(Sender: TObject);
  private
    FLock: Boolean;
    FPrgFrm: TfrmPrg;
    FModuleList: TDictionary<string, TModuleInfo>;
    FChangVCLStyleId: Cardinal;
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
    /// 初始化 Qplugins
    /// </summary>
    procedure InitializeQplugins;
    /// <summary>
    /// 初始化 ModuleList
    /// </summary>
    procedure initializeModuleListFromConfigFile;
    /// <summary>
    /// Dock窗口释放事件
    /// </summary>
    procedure DoDockChildFree(AForm: IQFormService);
    /// <summary>
    /// 窗体 Dock  TabPage控件
    /// </summary>
    procedure DockPage(AFormService: IQFormService; AImageIndex: Integer;
       AHoldNeeded: Boolean = False);
    /// <summary>
    /// 按路径加载模块
    /// </summary>
    procedure LoadModule(AParams: TQParams);

    procedure LoadServices(AQjob: PQJob);

    function LoadFormServiceByCaption(ACaption: string; AImageIndex: Integer): IQFormService;

    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  public
    { Public declarations }
  end;

implementation

const
  MODULE_JSON_FILE = '\Module.json';

{$R *.dfm}

procedure TfrmMain.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  if not Assigned(FPrgFrm) then
    FPrgFrm := TfrmPrg.Create(Application);
  if AId = NID_PLUGIN_LOADING then    //开始加载  插件
  begin

  end
  else if AId = NID_PLUGIN_LOADED then    //结束加载 插件
  begin
    RzProgressBar1.Percent := 100;
//    FPrgFrm.Close;
  end
  else if AId = NID_PLUGIN_UNLOADING then   // 开始卸载 插件
  begin
//    FPrgFrm.Show;
  end
  else if AId = NID_PLUGIN_UNLOADED then   // 结束卸载 插件
  begin
//    FPrgFrm.Close;
  end;
end;

procedure TfrmMain.pgcMainClose(Sender: TObject; var AllowClose: Boolean);
var
  APath: PWideChar;
  AModule: TModuleInfo;
  ALoader: IQLoader;
begin
  AModule := FModuleList.Items['/Services/Docks/Forms/' + pgcMain.ActivePage.Caption];
  APath := PWideChar(AModule.ModulePath);

  if Pos('.dll', APath) > 0 then
  begin
    ALoader := PluginsManager.ByPath('/Loaders/Loader_DLL') as IQLoader;
    if not Assigned(ALoader) then
    begin
      ALoader := TQDLLLoader.Create('', '.dll');
      PluginsManager.Loaders.Add(ALoader);
    end;
  end
  else // BPL
  begin
    ALoader := PluginsManager.ByPath('/Loaders/Loader_BPL') as IQLoader;
    if not Assigned(ALoader) then
    begin
      ALoader := TQBPLLoader.Create('', '.bpl');
      PluginsManager.Loaders.Add(ALoader);
    end;
  end;
  ALoader.UnLoadServices(AModule.ServiceId, False);
  AllowClose := True;
end;

procedure TfrmMain.LoadModule(AParams: TQParams);
var
  AModulePath: string;
  ALoader: IQLoader;
  AFilePath: string;
  AName: string;
  AImageIndex: Integer;
  Module: TModuleInfo;
begin
  AModulePath := AParams.ByName('Path').AsString;
  AName := AParams.ByName('Name').AsString;
  try
    Module := FModuleList.Items[AModulePath];
  except
    On E: EListError do
    begin
      ShowMessage('错误: 未找到服务，检查Module.json配置文件');
    end;
  end;
  FLock := False;
  Workers.Post(LoadServices, Pointer(Module), False, jdfFreeByUser);

//  repeat
//    Sleep(50);
//    if RzProgressBar1.Percent < 100 then
//      RzProgressBar1.Percent := RzProgressBar1.Percent + 1;
//  until FLock;

  RzGlyphStatus1.Caption := AName;
  TryStrToInt(AParams.ByName('ImageIndex').AsString, AImageIndex);
  RzGlyphStatus1.ImageIndex := AImageIndex;

  LoadFormServiceByCaption(AName, AImageIndex);
end;

procedure TfrmMain.LoadServices(AQjob: PQJob);
var
  Module: TModuleInfo;
  ALoader: IQLoader;
  AFilePath: string;
begin
  Module := TModuleInfo(AQjob.Data);
  if Pos('.dll', Module.ModulePath) > 0 then
  begin
    ALoader := PluginsManager.ByPath('/Loaders/Loader_DLL') as IQLoader;
    if not Assigned(ALoader) then
    begin
      ALoader := TQDLLLoader.Create('', '.dll');
      PluginsManager.Loaders.Add(ALoader);
    end;
  end
  else // BPL
  begin
    ALoader := PluginsManager.ByPath('/Loaders/Loader_BPL') as IQLoader;
    if not Assigned(ALoader) then
    begin
      ALoader := TQBPLLoader.Create('', '.bpl');
      PluginsManager.Loaders.Add(ALoader);
    end;
  end;
  AFilePath := ExtractFilePath(Application.ExeName) + Module.ModulePath;

  Module.ServiceId := ALoader.LoadServices(PWideChar(AFilePath));
  FLock := True;
end;

function TfrmMain.LoadFormServiceByCaption(ACaption: string; AImageIndex: Integer): IQFormService;
var
  I: Integer;
begin
  if Supports(PluginsManager.ByPath(PWideChar('Services/Docks/Forms/'+ ACaption)), IQFormService,
    Result) then
  begin
    for I := 0 to pgcMain.PageCount - 1 do
      if pgcMain.Pages[I].Tag = intPtr(Result) then     //确保单例打开
        Exit;
//    Result.Show;
    DockPage(Result, AImageIndex);
  end
  else
    ShowMessage('错误: 未找到服务，检查Module.json配置文件');
end;

procedure TfrmMain.actEvunToolExecute(Sender: TObject);
var
  AParams: TQParams;
  ctx: TRttiContext;
  rttitype: TRttiType;
  rttiprop: TRttiProperty;
  value: TValue;
  AJob: TQJob;
begin
  AParams := TQParams.Create;
  AParams.Add('Path', '/Services/Docks/Forms/EvunTool');
  AParams.Add('Name', 'EvunTool');
  ctx := TRttiContext.Create;
  rttitype := ctx.GetType(Sender.ClassType);
  rttiprop := rttitype.GetProperty('ImageIndex');
  value := rttiprop.GetValue(Sender);
  AParams.Add('ImageIndex', value.ToString);
  LoadModule(AParams);
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
  if not Assigned(pgcMain) then
    Exit;
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
  AFormService: IQFormService;
  AParams: TQParams;
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
  AParams := TQParams.Create;
  AParams.Add('VCLStyleName', ptUnicodeString).AsString := AItem.Hint;

  //广播主题变化信息
  (PluginsManager as IQNotifyManager).Send(FChangVCLStyleId, AParams);

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

procedure TfrmMain.initializeModuleListFromConfigFile;
var
  ModuleListJson: TQJson;
  ItemJson: TQJson;
  Module: TModuleInfo;
  I: Integer;
begin
  ModuleListJson := TQJson.Create;

  ModuleListJson.LoadFromFile(ExtractFilePath(Application.ExeName) + MODULE_JSON_FILE);
  for I := 0 to ModuleListJson.Count - 1 do
  begin
    Module := TModuleInfo.Create;
    ItemJson := ModuleListJson.Items[I];
    Module.ID := ItemJson.ValueByName('Id', '');
    Module.Path := ItemJson.ValueByName('Path', '');
    Module.Loader := ItemJson.ValueByName('Loader', '');
    Module.ModulePath := ItemJson.ValueByName('Module', '');
    FModuleList.Add(Module.Path, Module);
  end;
end;

procedure TfrmMain.InitializeQplugins;
var
  ANotifyMgr: IQNotifyManager;
begin
  PluginsManager.Stop;
  //获取 主题变化 Notify ID
  FChangVCLStyleId := (PluginsManager as IQNotifyManager).IdByName('CHANGE_VCL_STYLE');
  ANotifyMgr := PluginsManager as IQNotifyManager;
  ANotifyMgr.Subscribe(NID_PLUGIN_LOADED, Self);
  ANotifyMgr.Subscribe(NID_PLUGIN_LOADING, Self);
  ANotifyMgr.Subscribe(NID_PLUGIN_UNLOADED, Self);
  ANotifyMgr.Subscribe(NID_PLUGIN_UNLOADING, Self);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FModuleList := TDictionary<string,TModuleInfo>.Create;
  //初始化  主菜单
  InitializeSystemMenu;
  //初始化  主界面状态
  InitializeMainFormStates;
  //初始化  ModuleList
  initializeModuleListFromConfigFile;
  //初始化  Qplugins
  InitializeQplugins;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeObject(FModuleList);
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  AFormService: IQFormService;
  I: Integer;
begin
  for I := 0 to pgcMain.PageCount - 1 do
  begin
    AFormService := IQFormService(Pointer(pgcMain.Pages[I].Tag));
    AFormService.DockTo(pgcMain.Pages[I].Handle, faContent);
  end;
end;

end.



