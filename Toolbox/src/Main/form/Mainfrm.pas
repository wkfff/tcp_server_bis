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
  cxGraphics,
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
  qplugins_vcl_formsvc;

type
  TfrmToolBox = class(TForm)
    tbrMenu: TRzToolbar;
    btnSystem: TRzMenuToolbarButton;
    ilSmall_16X16: TcxImageList;
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
    procedure actCloseExecute(Sender: TObject);
    procedure actEvunToolExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcClientClose(Sender: TObject; var AllowClose: Boolean);
  private
    procedure DoDockChildClose(ASender: IQFormService; var Action: TCloseAction);
    procedure DoShowDockForm(ACaption: string; AImageIndex: Integer);
    procedure DoDockChildFree(AForm: IQFormService);
    procedure DockPage(AFormService: IQFormService;AImageIndex: Integer; AHoldNeeded: Boolean = True);
    { Private declarations }
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
  DoShowDockForm('EvunTool', 360);
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
  AEvents.OnClose := DoDockChildClose;
  AEvents.OnFree := DoDockChildFree;
  AFormService.HookEvents(AEvents);
  if AHoldNeeded then
    HoldByComponent(APage, AFormService);
  pgcClient.ActivePage := APage;
  splMain.CloseHotSpot;
end;

procedure TfrmToolBox.DoDockChildClose(ASender: IQFormService;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmToolBox.DoDockChildFree(AForm: IQFormService);
var
  I: Integer;
begin
  for I := 0 to pgcClient.PageCount - 1 do
  begin
    if pgcClient.Pages[I].Tag = IntPtr(AForm) then
    begin
      AForm.UnhookEvents;
      FreeObject(pgcClient.Pages[I]);
      Break;
    end;
  end;
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
    AForm._Release;
  end;
end;

procedure TfrmToolBox.pgcClientClose(Sender: TObject; var AllowClose: Boolean);
var
  AFormService: IQFormService;
begin
  AllowClose := False;
  AFormService := IQFormService(Pointer(pgcClient.ActivePage.Tag));
  AFormService.Close;
end;

end.

