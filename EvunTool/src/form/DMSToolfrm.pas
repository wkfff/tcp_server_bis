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
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  ChromeTabs,
  uShareMemServer,
  JvPageList,
  JvExControls,
  SynHighlighterXML,
  SynEditHighlighter,
  SynHighlighterIni, Vcl.Buttons;

type
  PDMSDebugInfo = ^TDMSDebugInfo;

  TDMSDebugInfo = record
    PostClient: QStringW;
    PostMethod: QStringW;
    PostTime: QStringW;
    PostArgus: QStringW;
    PostServer: QStringW;
    ReceiveXML: WideString;
  end;

  TfrmDMSTool = class(TForm)
    chkActive: TCheckBox;
    pnlArgus: TPanel;
    pnlActive: TPanel;
    splMain: TSplitter;
    pnlReturn: TPanel;
    chrmtbReturn: TChromeTabs;
    lstReturn: TJvPageList;
    sedtArgus: TSynEdit;
    sedtXML: TSynEdit;
    SynIniSyn1: TSynIniSyn;
    SynXMLSyn1: TSynXMLSyn;
    btn1: TSpeedButton;
    btn2: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chkActiveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    FInfoList: TStringList;
    FShareMem: TShareMemServer;
    procedure DoFreeFormJob(AJob: PQJob);
    procedure DoShowFormJob(AJob: PQJob);
    procedure InitializBCEditer;
    procedure DoGetShareMemData(AJob: PQJob);
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
  AForm.Tag := TQParams(AJob.Data).ByName('TabIndex').AsInteger;
  AForm.WindowState := wsMaximized;
end;

procedure TfrmDMSTool.btn2Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FInfoList.Count - 1 do
  begin
    sedtXML.Text := PDMSDebugInfo(FInfoList.Objects[I]).PostArgus + #13 + #10 + #13 + #10 +  PDMSDebugInfo(FInfoList.Objects[I]).ReceiveXML;
    ShowMessage('');
  end;
end;

procedure TfrmDMSTool.Button1Click(Sender: TObject);
var
  AStatus: TQWorkerStatus;
  I: Integer;
  ASeconds: Int64;
  S: String;
begin
  AStatus := Workers.EnumWorkerStatus;
  for I := Low(AStatus) to High(AStatus) do
  begin
    S := S + '【工作者 ' + IntToStr(I) + '(ID=' + IntToStr(AStatus[I].ThreadId) +
      ')】'#13#10 + ' 已处理:' + IntToStr(AStatus[I].Processed) + ' 状态:';
    if AStatus[I].IsIdle then
    begin
      ASeconds := (GetTimeStamp - AStatus[I].LastActive) div Q1Second;
      if ASeconds > 0 then
        S := S + '空闲,末次工作时间:' + RollupTime(ASeconds) + '前)'#13#10#13#10
      else
        S := S + '空闲,末次工作时间:0秒前)'#13#10#13#10;
    end
    else
    begin
      S := S + '忙碌(作业:' + AStatus[I].ActiveJob + ')'#13#10;
      if Length(AStatus[I].Stacks) > 0 then
        S := S + ' 堆栈:'#13#10 + AStatus[I].Stacks + #13#10#13#10
      else
        S := S + #13#10;
    end;
  end;
  ShowMessage(S);
end;

procedure TfrmDMSTool.chkActiveClick(Sender: TObject);
begin
  FShareMem.Active := chkActive.Checked;
end;

procedure TfrmDMSTool.DoFreeFormJob(AJob: PQJob);
begin
  FreeAndNil(AForm);
end;

procedure TfrmDMSTool.DoGetShareMemData(AJob: PQJob);
var
  ADecode: QStringW;
  ATemp: QStringW;
  pReceive: PWideChar;
  pArgus: PWideChar;
  IsNew: Boolean;
  I: Integer;
  FData: PDMSDebugInfo;
const
  AscII_11: PWideChar = #11;
  AscII_12: PWideChar = #12;
  AscII_Enter: PWideChar = #13 + #10;
begin
  IsNew := True;
  pReceive := PWideChar(AJob.Data);
  if CharInW(AscII_12, pReceive) then
    IsNew := False;

  I := 0;
  if IsNew then
  begin
    New(FData);
    while pReceive^ <> #0 do
    begin
      ADecode := DecodeTokenW(pReceive, AscII_11, WideChar(0), True);
      case I of
        0:
          begin
            FData.PostTime := LeftStrW(ADecode, 19, False);
          end;
        1:
          begin
            FData.PostMethod := ADecode;
            FInfoList.AddObject(FData.PostMethod,
              FData);
          end;
        2:
          begin
            pArgus := PWideChar(ADecode);
            ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
            ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
            FData.PostServer := ATemp;
            FData.PostArgus := pArgus;
          end;
      end;
      Inc(I);
    end
  end
  else
  begin
    if FInfoList.Count < 1 then
      Exit;
    ATemp := DecodeTokenW(pReceive, AscII_12, WideChar(0), True);
    ATemp := DecodeTokenW(pReceive, AscII_11, WideChar(0), True);
    I := FInfoList.Count - 1;
    while (I >= 0) do
    begin
      if SameText(ATemp, FInfoList.Strings[I]) then
        Break;
      Dec(I);
    end;
    FData := PDMSDebugInfo(FInfoList.Objects[I]);
    FData.ReceiveXML := pReceive;
  end;

  if IsNew then
  begin
    sedtArgus.BeginUpdate;
    pArgus := PWideChar(PDMSDebugInfo(FInfoList.Objects[FInfoList.Count - 1]).PostArgus);
    while pArgus^ <> #0 do
    begin
      ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
      sedtArgus.Lines.Add(ATemp);
    end;
    I := 0;
    while I < 2 do
    begin
      sedtArgus.Lines.Add('');
      Inc(I);
    end;
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count);
    sedtArgus.EndUpdate;
  end
  else
  begin
    sedtArgus.BeginUpdate;
    pArgus := PWideChar(PDMSDebugInfo(FInfoList.Objects[FInfoList.Count - 1]).ReceiveXML);
    while pArgus^ <> #0 do
    begin
      ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
      sedtArgus.Lines.Add(ATemp);
    end;
    I := 0;
    while I < 2 do
    begin
      sedtArgus.Lines.Add('');
      Inc(I);
    end;
//      sedtArgus.Lines.Text := (PDMSDebugInfo(FInfoList.Objects[FInfoList.Count - 1]).ReceiveXML);
//      I := 0;
//      while I < 2 do
//      begin
//        sedtArgus.Lines.Add('');
//        Inc(I);
//      end;
    sedtArgus.GotoLineAndCenter(sedtXML.Lines.Count);
    sedtArgus.EndUpdate;
  end;
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
  AParams.Add('TabIndex', AForm.Tag);
  Workers.PostSignal(Workers.RegisterSignal('MainForm.DeleteTabItem'), AParams,
    jdfFreeAsObject);
  FreeAndNil(AForm);
end;

procedure TfrmDMSTool.InitializBCEditer;
begin
  sedtArgus.Font.Size := 10;
  sedtXML.Font.Size := 10;
  sedtXML.ReadOnly := True;
end;

procedure TfrmDMSTool.FormCreate(Sender: TObject);
begin
  Workers.Wait(DoFreeFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool +
    '.Free'), True);
  Workers.Wait(DoShowFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool +
    '.Show'), True);
  FShareMem := TShareMemServer.Create(Debug_MapMem);
  FShareMem.OnGetData := DoGetShareMemData;
  InitializBCEditer;
  FInfoList := TStringList.Create;
end;

procedure TfrmDMSTool.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FInfoList.Objects[I]));
  FInfoList.Free;
  Workers.Clear(FShareMem, -1, True);
  FShareMem.Free;
end;

procedure TfrmDMSTool.FormResize(Sender: TObject);
begin
  pnlArgus.Width := Width div 2 - 20;
end;

initialization
  Workers.Wait(DoCreateFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool
    + '.Create'), True);

finalization

end.

