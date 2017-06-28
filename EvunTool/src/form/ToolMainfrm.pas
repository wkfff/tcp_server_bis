unit ToolMainfrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Types,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  System.ImageList,
  Vcl.ImgList,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Menus,
  Vcl.ToolWin,
  Vcl.ComCtrls,
  DMSToolfrm,
  JvTabBar,
  qplugins_base,
  QWorker,
  qplugins_params;

type
  TMainfrm = class(TForm)
    ilIcons: TImageList;
    mmMenu: TMainMenu;
    mniSystem: TMenuItem;
    mniQuit: TMenuItem;
    mniTool: TMenuItem;
    mniDMSTool: TMenuItem;
    jvtbrTab: TJvTabBar;
    tlbTool: TToolBar;
    btnDMSTool: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure mniQuitClick(Sender: TObject);
    procedure btnDMSClick(Sender: TObject);
    procedure jvtbrTabTabClosed(Sender: TObject; Item: TJvTabBarItem);
    procedure FormDestroy(Sender: TObject);
    procedure jvtbrTabTabSelected(Sender: TObject; Item: TJvTabBarItem);
  private
    { Private declarations }
    procedure Initialize;
    procedure DoDeleteTabItemJob(AJob: PQJob);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TMainfrm.btnDMSClick(Sender: TObject);
var
  ASign: string;
begin
  ASign := TToolButton(Sender).Caption;
  Workers.PostSignal('MDIChildForm.' + ASign + '.Create', nil);
  if not Assigned(jvtbrTab.FindTab(ASign)) then
    jvtbrTab.AddTab(ASign);
end;

procedure TMainfrm.DoDeleteTabItemJob(AJob: PQJob);
var
  objTabItem: TJvTabBarItem;
  AParams: TQParams;
  ASign: string;
begin
  AParams := TQParams(AJob.Data);
  ASign := AParams.ByName('TabItemCaption').AsString;
  objTabItem := jvtbrTab.FindTab(ASign);
  if not Assigned(objTabItem) then
    Exit;
  jvtbrTab.CloseTab(objTabItem);
end;

procedure TMainfrm.FormCreate(Sender: TObject);
begin
  Initialize;

  Workers.Wait(DoDeleteTabItemJob, Workers.RegisterSignal('MainForm.DeleteTabItem'),
    True);
end;

procedure TMainfrm.FormDestroy(Sender: TObject);
begin
  Workers.Clear;
end;

procedure TMainfrm.Initialize;
begin
  Position := poDesktopCenter;
  WindowState := wsMaximized;
end;

procedure TMainfrm.jvtbrTabTabClosed(Sender: TObject; Item: TJvTabBarItem);
begin
  Workers.PostSignal('MDIChildForm.' + Item.Caption + '.Free', nil);
end;

procedure TMainfrm.jvtbrTabTabSelected(Sender: TObject; Item: TJvTabBarItem);
begin
  //
  if not Assigned(Item) then
    Exit;
  Workers.PostSignal('MDIChildForm.' + Item.Caption + '.Show', nil);
end;

procedure TMainfrm.mniQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.

