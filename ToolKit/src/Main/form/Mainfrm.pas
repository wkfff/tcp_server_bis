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
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  JvImageList,
  RzPanel,
  RzButton,
  RzCommon,
  RzSplit,
  RzGroupBar,
  RzTabs,
  RzStatus,
  qstring,
  qplugins_base,
  QPlugins,
  qplugins_loader_lib,
  qplugins_formsvc,
  qplugins_vcl_messages,
  qplugins_vcl_formsvc,
  qworker,
  utils_safeLogger,
  Logfrm;

type
  TfrmToolBox = class(TForm, IQNotify)
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
    actConfig: TAction;
    mniConfig: TMenuItem;
    procedure actCloseExecute(Sender: TObject);
    procedure actEvunToolExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcClientClose(Sender: TObject; var AllowClose: Boolean);
    procedure pgcClientChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure btnLogClick(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure rpsMainClick(Sender: TObject);
  private
    FNotifyIdProgressStart: Integer;
    FNotifyIdProgressEnd: Integer;
    FNotifyIdProgressCancel: Integer;
    FShowProgress: Boolean;
    procedure DoShowDockForm(ACaption: string; AImageIndex: Integer);
    procedure DockPage(AFormService: IQFormService;AImageIndex: Integer;
      AHoldNeeded: Boolean = True);
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
    procedure DoShowProgress(AJob: PQJob);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmToolBox.actCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmToolBox.actConfigExecute(Sender: TObject);
begin
  //
end;

procedure TfrmToolBox.actEvunToolExecute(Sender: TObject);
begin
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
  ANotifyManager: IQNotifyManager;
begin
  APath := ExtractFilePath(Application.ExeName);
  PluginsManager.Loaders.Add(TQDLLLoader.Create(APath, '.dll'));
  PluginsManager.Loaders.Add(TQBPLLoader.Create(APath, '.bpl'));
  PluginsManager.Start;

  ANotifyManager := (PluginsManager as IQNotifyManager);

  FNotifyIdProgressStart  := ANotifyManager.IdByName('main_form.progress.start_update');
  FNotifyIdProgressEnd    := ANotifyManager.IdByName('main_form.progress.end_update');
  FNotifyIdProgressCancel := ANotifyManager.IdByName('main_form.progress.cancel');
  ANotifyManager.Subscribe(FNotifyIdProgressStart, Self);
  ANotifyManager.Subscribe(FNotifyIdProgressEnd, Self);
  ANotifyManager.Subscribe(FNotifyIdProgressCancel, Self);
  FShowProgress := False;
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

procedure TfrmToolBox.DoShowProgress(AJob: PQJob);
begin
  if FShowProgress then
  begin
    rpsMain.Percent := rpsMain.Percent + 1;
    if rzstspnStatus.Font.Color = clRed then
      rzstspnStatus.Font.Color := clBlue
    else if rzstspnStatus.Font.Color = clBlue then
      rzstspnStatus.Font.Color := clRed;
    Workers.Delay(DoShowProgress, 5000, AJob.Data, False);
    Application.ProcessMessages;
  end;
end;

procedure TfrmToolBox.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  if AId = FNotifyIdProgressStart then
  begin
    FShowProgress := True;
    rpsMain.Percent := 0;
    rzstspnStatus.Caption := AParams.Items[0].AsString.Value;
    rzstspnStatus.Font.Color := clRed;
    Workers.Post(DoShowProgress, Pointer(AParams), False)
  end
  else if AId = FNotifyIdProgressEnd then
  begin
    FShowProgress := False;
    rzstspnStatus.Font.Color := clGreen;
    rzstspnStatus.Caption := 'HTTP方法调用完成';
    rpsMain.Percent := 100;
  end
  else if AId = FNotifyIdProgressCancel then
  begin
    FShowProgress := False;
    rzstspnStatus.Font.Color := clBlack;
    rzstspnStatus.Caption := 'HTTP方法调用取消';
    rpsMain.Percent := 0;
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

procedure TfrmToolBox.rpsMainClick(Sender: TObject);
begin
  if FShowProgress then
  begin
    Workers.Clear(False);
    (PluginsManager as IQNotifyManager).Send(FNotifyIdProgressCancel, nil);
  end;
end;

end.

