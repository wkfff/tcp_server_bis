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
  Vcl.Buttons,
  RzButton,
  Vcl.ExtCtrls,
  RzPanel,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  RzCommon,
  RzSplit,
  RzGroupBar,
  RzTabs,
  qstring,
  qplugins_base,
  QPlugins,
  qplugins_loader_lib,
  qplugins_formsvc,
  qplugins_vcl_messages,
  qplugins_vcl_formsvc,
  RzStatus,
  utils_safeLogger,
  Logfrm,
  JvImageList, Vcl.StdCtrls;

type
  TfrmToolBox = class(TForm)
    tbrMenu: TRzToolbar;
    btnSystem: TRzMenuToolbarButton;
    pmSystem: TPopupMenu;
    actlstMain: TActionList;
    actClose: TAction;
    mniClose: TMenuItem;
    pcr1: TRzSpacer;
    mctrMain: TRzMenuController;
    splMain: TRzSplitter;
    grpList: TRzGroupBar;
    rzgrpTools: TRzGroup;
    tbrList: TRzToolbar;
    btnEvunTool: TRzToolButton;
    btnTools: TRzMenuToolbarButton;
    pmTools: TPopupMenu;
    actEvunTool: TAction;
    mniEvunTool: TMenuItem;
    pcr2: TRzSpacer;
    pcr3: TRzSpacer;
    rzsbrMain: TRzStatusBar;
    pgcClient: TRzPageControl;
    rgsModule: TRzGlyphStatus;
    rpsMain: TRzProgressStatus;
    RzClockStatus1: TRzClockStatus;
    rzstspnStatus: TRzStatusPane;
    btnLog: TRzToolButton;
    ilSmall16X16: TJvImageList;
    procedure actCloseExecute(Sender: TObject);
    procedure actEvunToolExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcClientClose(Sender: TObject; var AllowClose: Boolean);
    procedure pgcClientChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure btnLogClick(Sender: TObject);
  private
    FNotifyId_log: Integer;
    procedure DoDockChildClose(ASender: IQFormService; var Action: TCloseAction);
    procedure DoShowDockForm(ACaption: string; AImageIndex: Integer);
    procedure DoDockChildFree(AForm: IQFormService);
    procedure DockPage(AFormService: IQFormService;AImageIndex: Integer; AHoldNeeded: Boolean = True);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmToolBox.actCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmToolBox.actEvunToolExecute(Sender: TObject);
begin
  //
  DoShowDockForm('EvunTool', actEvunTool.ImageIndex);
end;

procedure TfrmToolBox.btnLogClick(Sender: TObject);
begin
  if Assigned(frmLogger) then
    frmLogger.Show;
end;

procedure TfrmToolBox.DockPage(AFormService: IQFormService; AImageIndex: Integer; AHoldNeeded: Boolean);
var
  APage: TRzTabSheet;
  AEvents: TQFormEvents;
begin
  APage := TRzTabSheet.Create(pgcClient);
  APage.PageControl := pgcClient;
  APage.Caption := (AFormService as IQService).Name;
  APage.Tag := IntPtr(AFormService);
  APage.ImageIndex := AImageIndex;
  AFormService.DockTo(APage.Handle, faContent);
  FillChar(AEvents, SizeOf(AEvents), 0);
  AFormService.HookEvents(AEvents);
  if AHoldNeeded then
    HoldByComponent(APage, AFormService);
  pgcClient.ActivePage := APage;
  splMain.CloseHotSpot;
end;

procedure TfrmToolBox.DoDockChildClose(ASender: IQFormService;
  var Action: TCloseAction);
begin
end;

procedure TfrmToolBox.DoDockChildFree(AForm: IQFormService);
begin
end;

procedure TfrmToolBox.DoShowDockForm(ACaption: string; AImageIndex: Integer);
var
  I: Integer;
  AFormService: IQFormService;
begin
  if Supports(PluginsManager.ByPath(PChar('/Services/Docks/Forms/' + ACaption)),
    IQFormService, AFormService) then
  begin
    for I := 0 to pgcClient.PageCount - 1 do
    begin
      if AFormService = IQFormService(Pointer(pgcClient.Pages[I].Tag)) then
        Exit;
    end;
    DockPage(AFormService, AImageIndex);
    rgsModule.ImageIndex := AImageIndex;
    rgsModule.Caption := ACaption;
  end;
end;

procedure TfrmToolBox.FormCreate(Sender: TObject);
var
  APath: string;
begin
  APath := ExtractFilePath(Application.ExeName);
  PluginsManager.Loaders.Add(TQDLLLoader.Create(APath, '.dll'));
  PluginsManager.Loaders.Add(TQBPLLoader.Create(APath, '.bpl'));
  PluginsManager.Start;
end;

procedure TfrmToolBox.FormDestroy(Sender: TObject);
var
  I: Integer;
  AForm: IQFormService;
begin
  for I := 0 to pgcClient.PageCount - 1 do
  begin
    AForm := IQFormService(Pointer(pgcClient.Pages[I].Tag));
    AForm.UnhookEvents;
    AForm.Close;
  end;
end;

procedure TfrmToolBox.pgcClientChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
begin
  rgsModule.ImageIndex := pgcClient.Pages[NewIndex].ImageIndex;
  rgsModule.Caption := pgcClient.Pages[NewIndex].Caption;
end;

procedure TfrmToolBox.pgcClientClose(Sender: TObject; var AllowClose: Boolean);
var
  AFormService: IQFormService;
begin
  AllowClose := True;
  AFormService := IQFormService(Pointer(pgcClient.ActivePage.Tag));
  AFormService.UnhookEvents;
  AFormService.Close;
end;

end.

