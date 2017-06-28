unit DMSToolfrm;

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
  JvTabBar,
  qplugins_base,
  qplugins_params,
  QWorker,
  qstring,
  SynEdit,
  Vcl.StdCtrls,
  ShShareMemMap, BCEditor.Editor, Vcl.ExtCtrls;

type
  TShareMemServer = class
  private
    FActive: Boolean;
    FMap: TShareMapQueue;
    procedure SetActive(const Value: Boolean);
    procedure DoGetDebugData(AJob: PQJob);
    procedure DoShowDebugData(AJob: PQJob);
  public
    constructor Create(AName: string; AMemorySize: Integer = CN_QUEUE_SIZE);
    destructor Destroy; override;
    property Active: Boolean read FActive write SetActive;
  end;

  TfrmDMSTool = class(TForm)
    chkActive: TCheckBox;
    bce1: TBCEditor;
    pnlArgus: TPanel;
    pnlActive: TPanel;
    splMain: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chkActiveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FShareMem: TShareMemServer;
    procedure DoFreeFormJob(AJob: PQJob);
    procedure DoShowFormJob(AJob: PQJob);
    procedure InitializBCEditer;
  public
    { Public declarations }
  end;

implementation

uses
  uResourceString;

var
  AForm: TfrmDMSTool;

{$R *.dfm}

procedure DoCreateFormJob(AJob: PQJob);
begin
  if not Assigned(AForm) then
    AForm := TfrmDMSTool.Create(Application);
  AForm.WindowState := wsMaximized;
end;

procedure TfrmDMSTool.chkActiveClick(Sender: TObject);
begin
  FShareMem.Active := chkActive.Checked;
end;

procedure TfrmDMSTool.DoFreeFormJob(AJob: PQJob);
begin
  FreeAndNil(AForm);
end;

procedure TfrmDMSTool.DoShowFormJob(AJob: PQJob);
begin
  if AForm.Active then
    Exit;
  AForm.WindowState := wsMaximized;
  AForm.Show;
end;

procedure TfrmDMSTool.FormClose(Sender: TObject; var Action: TCloseAction);
var
  AParams: TQParams;
begin
  AParams := TQParams.Create;
  AParams.Add('TabItemCaption', AForm.Caption);
  Workers.PostSignal(Workers.RegisterSignal('MainForm.DeleteTabItem'), AParams,
    jdfFreeAsObject);
end;

procedure TfrmDMSTool.InitializBCEditer;
begin
  bce1.Highlighter.LoadFromFile('E:\WHTX\EvunTool\src\Highlighters\XML.json');
  bce1.Highlighter.Colors.LoadFromFile('E:\WHTX\EvunTool\src\Colors\Visual Studio.json');
  bce1.WordWrap.Enabled := True;
  bce1.Font.Size := 10;
  bce1.LeftMargin.Autosize := False;
  bce1.LeftMargin.Width := 40;
//  bce1.ReadOnly := True;

end;

procedure TfrmDMSTool.FormCreate(Sender: TObject);
begin
  Workers.Wait(DoFreeFormJob, Workers.RegisterSignal('MDIChildForm.' +
    ModuleSign + '.Free'), True);
  Workers.Wait(DoShowFormJob, Workers.RegisterSignal('MDIChildForm.' +
    ModuleSign + '.Show'), True);
  FShareMem := TShareMemServer.Create(Debug_MapMem);
  InitializBCEditer;
end;

procedure TfrmDMSTool.FormDestroy(Sender: TObject);
begin
  Workers.Clear(FShareMem, -1, False);
  FShareMem.Free;
end;

procedure TfrmDMSTool.FormResize(Sender: TObject);
begin
  pnlArgus.Width := Width div 2 - 20;
end;

{ TShareMemServer }

constructor TShareMemServer.Create(AName: string; AMemorySize: Integer);
begin
  FMap := TShareMapQueue.Create(AName, True, AMemorySize);
  FActive := False;
end;

destructor TShareMemServer.Destroy;
begin
  FMap.Free;
  inherited;
end;

procedure TShareMemServer.DoGetDebugData(AJob: PQJob);
var
  lstTemp: TStringList;
  pData: Pointer;
  dwSize: DWORD;
  i: Integer;
  strTemp: string;
begin
  lstTemp := TStringList.Create;

  //每条日志区分符
  lstTemp.LineBreak := #8;

  //读取队列中数据，一次全部读完
  dwSize := FMap.Pop(pData);
  if (dwSize > 0) then
  begin
    try
      SetString(strTemp, PAnsiChar(pData), dwSize);
      lstTemp.Text := strTemp;
      for i := 0 to lstTemp.Count - 1 do
        Workers.Post(DoShowDebugData, PChar(lstTemp[i] + '  @@@@@'), True);
    except
    end;
    FreeMem(pData, dwSize);
  end;
  lstTemp.Free;
  if FActive then
    Workers.Delay(DoGetDebugData, Q1Second, nil);
end;

procedure TShareMemServer.DoShowDebugData(AJob: PQJob);
begin
  if not Assigned(AForm) then
    Exit;
  AForm.bce1.Lines.Add(PChar(AJob.Data));
end;

procedure TShareMemServer.SetActive(const Value: Boolean);
begin
  FActive := Value;

  if FActive then
    Workers.Delay(DoGetDebugData, Q1Second, nil);
end;

initialization
  Workers.Wait(DoCreateFormJob, Workers.RegisterSignal('MDIChildForm.' +
    ModuleSign + '.Create'), True);

finalization

end.

