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
  qplugins_base,
  QWorker,
  qplugins_params,
  ChromeTabs,
  ChromeTabsClasses, RzButton, RzPanel, RzTabs;

type
  TMainfrm = class(TForm)
    ilIcons: TImageList;
    mmMenu: TMainMenu;
    mniSystem: TMenuItem;
    mniQuit: TMenuItem;
    mniTool: TMenuItem;
    mniDMSTool: TMenuItem;
    chrmtbTool: TChromeTabs;
    tbrMain: TRzToolbar;
    btnDMSTool: TRzToolButton;
    RzSpacer1: TRzSpacer;
    procedure FormCreate(Sender: TObject);
    procedure mniQuitClick(Sender: TObject);
    procedure btnDMSClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chrmtbToolButtonCloseTabClick(Sender: TObject; ATab: TChromeTab;
      var Close: Boolean);
    procedure chrmtbToolActiveTabChanged(Sender: TObject; ATab: TChromeTab);
    procedure mniDMSToolClick(Sender: TObject);
  private
    { Private declarations }
    procedure Initialize;
    procedure DoDeleteTabItemJob(AJob: PQJob);
    function FindTab(ACaption: string): TChromeTab;
    procedure OpenChildByCaption(AImageIndex: Integer; ACaption: string);
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TMainfrm.FindTab(ACaption: string): TChromeTab;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to chrmtbTool.Tabs.Count - 1 do
    if SameText(chrmtbTool.Tabs.Items[I].Caption, ACaption) then
    begin
      Result := chrmtbTool.Tabs.Items[I];
      Break;
    end;
end;

procedure TMainfrm.btnDMSClick(Sender: TObject);
begin
  OpenChildByCaption(TRzToolButton(Sender).ImageIndex, TRzToolButton(Sender).Caption);
end;

procedure TMainfrm.chrmtbToolActiveTabChanged(Sender: TObject;
  ATab: TChromeTab);
begin
  Workers.PostSignal('MDIChildForm.' + ATab.Caption + '.Show', nil);
end;

procedure TMainfrm.chrmtbToolButtonCloseTabClick(Sender: TObject;
  ATab: TChromeTab; var Close: Boolean);
begin
  Workers.PostSignal('MDIChildForm.' + ATab.Caption + '.Free', nil);
  Close := True;
end;

procedure TMainfrm.DoDeleteTabItemJob(AJob: PQJob);
var
  objTabItem: TChromeTab;
  AParams: TQParams;
  AIndex: Integer;
  AClose: Boolean;
begin
  AParams := TQParams(AJob.Data);
  AIndex := AParams.ByName('TabIndex').AsInteger;
  chrmtbTool.BeginUpdate;
  chrmtbTool.Tabs.DeleteTab(AIndex, True);
  chrmtbTool.EndUpdate;
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

procedure TMainfrm.mniDMSToolClick(Sender: TObject);
begin
  OpenChildByCaption(TMenuItem(Sender).ImageIndex, TMenuItem(Sender).Hint);
end;

procedure TMainfrm.mniQuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainfrm.OpenChildByCaption(AImageIndex: Integer; ACaption: string);
var
  ATab: TChromeTab;
  AParams: TQParams;
begin
  ATab := FindTab(ACaption);
  if Assigned(ATab) then
    Exit;
  chrmtbTool.BeginUpdate;
  ATab := chrmtbTool.Tabs.Add;
  ATab.Caption := ACaption;
  ATab.ImageIndex := AImageIndex;
  chrmtbTool.EndUpdate;
  AParams := TQParams.Create;
  AParams.Add('TabIndex', ATab.Index);
  Workers.PostSignal('MDIChildForm.' + ACaption + '.Create', AParams, jdfFreeAsObject);
end;

end.

