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
  qxml,
  QWorker,
  qstring,
  SynEdit,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  ChromeTabs,
  ChromeTabsTypes,
  ChromeTabsClasses,
  uShareMemServer,
  JvPageList,
  JvExControls,
  SynHighlighterXML,
  SynEditHighlighter,
  SynHighlighterIni,
  Vcl.Buttons,
  Vcl.Menus,
  System.ImageList,
  Vcl.ImgList,
  VirtualTrees,
  Vcl.Imaging.pngimage,
  JvExExtCtrls,
  JvNetscapeSplitter,
  JvXPCore,
  JvXPButtons,
  Vcl.Mask,
  RzEdit,
  RzBtnEdt,
  RzButton,
  RzPanel;

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
    pnlArgus: TPanel;
    pnlReturn: TPanel;
    chrmtbReturn: TChromeTabs;
    lstReturn: TJvPageList;
    sedtArgus: TSynEdit;
    SynIniSyn1: TSynIniSyn;
    SynXMLSyn1: TSynXMLSyn;
    pmXML: TPopupMenu;
    mniXML1: TMenuItem;
    ilMenu: TImageList;
    pnlList: TPanel;
    vstMethodList: TVirtualStringTree;
    pmArgus: TPopupMenu;
    mniClear: TMenuItem;
    mniN1: TMenuItem;
    mniN2: TMenuItem;
    splMain: TJvNetscapeSplitter;
    pnlServer: TPanel;
    btnClosePanel: TJvXPToolButton;
    pmList: TPopupMenu;
    mniN3: TMenuItem;
    mniN4: TMenuItem;
    mniN5: TMenuItem;
    lblServer: TLabel;
    RzButtonEdit1: TRzButtonEdit;
    tbrExcute: TRzToolbar;
    btnLog: TRzToolButton;
    btnListVisible: TRzToolButton;
    RzSpacer1: TRzSpacer;
    chkActive: TCheckBox;
    RzSpacer2: TRzSpacer;
    btnExcute: TRzToolButton;
    RzSpacer3: TRzSpacer;
    sedtXML: TSynEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure chkActiveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mniXML1Click(Sender: TObject);
    procedure pnlListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vstMethodListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstMethodListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure img1Click(Sender: TObject);
    procedure vstMethodListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstMethodListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstMethodListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure mniClearClick(Sender: TObject);
    procedure mniN1Click(Sender: TObject);
    procedure mniN2Click(Sender: TObject);
    procedure btnClosePanelClick(Sender: TObject);
    procedure mniN3Click(Sender: TObject);
    procedure chrmtbReturnChange(Sender: TObject; ATab: TChromeTab;
      TabChangeType: TTabChangeType);
    procedure chrmtbReturnActiveTabChanging(Sender: TObject; AOldTab,
      ANewTab: TChromeTab; var Allow: Boolean);
    procedure btnListVisibleClick(Sender: TObject);
  private
    { Private declarations }
    FWindow_X: Integer;
    FWindow_Y: Integer;
    FListDrag: Boolean;
    FDMSInfoList: TStringList;
    FDCSInfoList: TStringList;
    FShareMem: TShareMemServer;
    procedure DoFreeFormJob(AJob: PQJob);
    procedure DoShowFormJob(AJob: PQJob);
    procedure InitializBCEditer;
    procedure DoGetShareMemData(AJob: PQJob);
    procedure DoClearDebugListenInfo;
    procedure DoRefrashVST(AVST: TVirtualStringTree);
    procedure TabDelete(ATab: TChromeTab);
    procedure ClearTabControl;
  public
    { Public declarations }
  end;

implementation

uses
  uResourceString,
  virtualstringtreefram;

var
  AForm: TfrmDMSTool;

{$R *.dfm}

procedure DoCreateFormJob(AJob: PQJob);
begin
  if not Assigned(AForm) then
    AForm := TfrmDMSTool.Create(Application);
  AForm.Tag := TQParams(AJob.Data).ByName('TabIndex').AsInteger;
end;

procedure TfrmDMSTool.btnClosePanelClick(Sender: TObject);
begin
  pnlList.Visible := False;
end;

procedure TfrmDMSTool.btnListVisibleClick(Sender: TObject);
begin
  pnlList.Visible := True;
end;

procedure TfrmDMSTool.Button1Click(Sender: TObject);
var
  AStatus: TQWorkerStatus;
  I: Integer;
  ASeconds: Int64;
  S: string;
begin
  AStatus := Workers.EnumWorkerStatus;
  for I := Low(AStatus) to High(AStatus) do
  begin
    S := S + '【工作者 ' + IntToStr(I) + '(ID=' + IntToStr(AStatus[I].ThreadId) + ')】'#13#10 + ' 已处理:' + IntToStr(AStatus[I].Processed) + ' 状态:';
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

procedure TfrmDMSTool.TabDelete(ATab: TChromeTab);
var
  addTab: TChromeTab;
begin
  if ATab.Index = 0 then
  begin
    sedtXML.Clear;
    addTab := chrmtbReturn.Tabs.Add;
    addTab.Caption := 'XML';
    addTab.Data := Pointer(lstReturn.Pages[0]);
  end
  else
    TJvCustomPage(ATab.Data).Free;
end;

procedure TfrmDMSTool.chrmtbReturnActiveTabChanging(Sender: TObject; AOldTab,
  ANewTab: TChromeTab; var Allow: Boolean);
begin
  lstReturn.ActivePage := TJvCustomPage(ANewTab.Data);
end;

procedure TfrmDMSTool.chrmtbReturnChange(Sender: TObject; ATab: TChromeTab;
  TabChangeType: TTabChangeType);
begin
  case TabChangeType of
    tcAdded: ;
    tcMoved: ;
    tcDeleting: TabDelete(ATab);
    tcDeleted: ;
    tcPropertyUpdated: ;
    tcActivated: ;
    tcDeactivated: ;
    tcPinned: ;
    tcControlState: ;
    tcVisibility: ;
  end;
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
  IsDms: Boolean;
  I: Integer;
  aData: PDMSDebugInfo;
  aInfoList: TStringList;
const
  AscII_11: PWideChar = #11;
  AscII_12: PWideChar = #12;
  AscII_Enter: PWideChar = #13 + #10;
begin
  IsNew := True;
  pReceive := PWideChar(AJob.Data);
  if CharInW(AscII_12, pReceive) then
    IsNew := False;

  if Pos('DMS_I', pReceive) > 0 then
    aInfoList := FDMSInfoList
  else
    aInfoList := FDCSInfoList;

  IsDms := aInfoList = FDMSInfoList;

  I := 0;
  if IsNew then
  begin
    New(aData);
    while pReceive^ <> #0 do
    begin
      ADecode := DecodeTokenW(pReceive, AscII_11, WideChar(0), True);
      case I of
        0:
          begin
            aData.PostTime := LeftStrW(ADecode, 19, False);
          end;
        1:
          begin
            aData.PostMethod := ADecode;
            aInfoList.AddObject(aData.PostMethod, aData);
          end;
        2:
          begin
            pArgus := PWideChar(ADecode);
            ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
            ATemp := DecodeTokenW(pArgus, AscII_Enter, WideChar(0), True);
            aData.PostServer := ATemp;
            aData.PostArgus := pArgus;
          end;
      end;
      Inc(I);
    end
  end
  else
  begin
    if aInfoList.Count < 1 then
      Exit;
    ATemp := DecodeTokenW(pReceive, AscII_12, WideChar(0), True);
    ATemp := DecodeTokenW(pReceive, AscII_11, WideChar(0), True);
    I := aInfoList.Count - 1;
    while (I >= 0) do
    begin
      if SameText(ATemp, aInfoList.Strings[I]) then
        Break;
      Dec(I);
    end;
    aData := PDMSDebugInfo(aInfoList.Objects[I]);
    aData.ReceiveXML := pReceive;

    DoRefrashVST(vstMethodList);
    if IsDms then
      vstMethodList.ScrollIntoView((vstMethodList.RootNode.LastChild.LastChild), True)
    else
      vstMethodList.ScrollIntoView((vstMethodList.RootNode.FirstChild.LastChild), True);

  end;

  if IsNew then
  begin
    sedtArgus.BeginUpdate;
    pArgus := PWideChar(PDMSDebugInfo(aInfoList.Objects[aInfoList.Count - 1]).PostArgus);
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
    sedtXML.BeginUpdate;
    sedtXML.Lines.Text := (PDMSDebugInfo(aInfoList.Objects[aInfoList.Count - 1]).ReceiveXML);
    sedtXML.GotoLineAndCenter(sedtArgus.Lines.Count);
    sedtXML.EndUpdate;
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
  Workers.PostSignal(Workers.RegisterSignal('MainForm.DeleteTabItem'), AParams, jdfFreeAsObject);
  FreeAndNil(AForm);
end;

procedure TfrmDMSTool.InitializBCEditer;
begin
  sedtArgus.Font.Size := 10;
  sedtXML.Font.Size := 10;
end;

procedure TfrmDMSTool.mniClearClick(Sender: TObject);
begin
  sedtArgus.Clear;
end;

procedure TfrmDMSTool.mniN1Click(Sender: TObject);
begin
  sedtXML.Clear;
end;

procedure TfrmDMSTool.DoClearDebugListenInfo;
var
  I: Integer;
begin
  ClearTabControl;
  sedtXML.Clear;
  sedtArgus.Clear;
  for I := 0 to FDCSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDCSInfoList.Objects[I]));
  FDCSInfoList.Clear;

  for I := 0 to FDCSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDMSInfoList.Objects[I]));
  FDMSInfoList.Clear;

  DoRefrashVST(vstMethodList);
end;

procedure TfrmDMSTool.DoRefrashVST(AVST: TVirtualStringTree);
var
  OldRootCount: Integer;
begin
  OldRootCount := AVST.RootNodeCount;
  AVST.RootNodeCount := 0;
  AVST.RootNodeCount := OldRootCount;
end;

procedure TfrmDMSTool.mniN2Click(Sender: TObject);
begin
  DoClearDebugListenInfo;
end;

procedure TfrmDMSTool.mniN3Click(Sender: TObject);
begin
  DoClearDebugListenInfo;
end;

procedure TfrmDMSTool.ClearTabControl;
var
  I: Integer;
begin
  chrmtbReturn.BeginUpdate;
  try
  if chrmtbReturn.Tabs.Count > 1 then
    for I := chrmtbReturn.Tabs.Count - 1 downto 1 do
      chrmtbReturn.Tabs.DeleteTab(I, True);

  if lstReturn.PageCount > 1 then
    for I := lstReturn.PageCount - 1 downto 1 do
      lstReturn.Pages[I].Destroy;
  finally
    chrmtbReturn.EndUpdate;
  end;
end;

procedure TfrmDMSTool.mniXML1Click(Sender: TObject);
var
  rootXML: TQXML;
  BodyXML: TQXML;
  DataSetXML: TQXML;
  I: Integer;
  ATab: TChromeTab;
  APage: TJvCustomPage;
  AFrame: Tfrmvirtualstringtree;
begin
  rootXML := nil;
  ClearTabControl;
  chrmtbReturn.BeginUpdate;
  try
    rootXML := TQXML.Create;
    rootXML.Parse(sedtXML.Text);
    if rootXML.Count < 1 then
      Exit;
    BodyXML := rootXML.ItemByPath('RESPONSE.BODY');
    if BodyXML.Count < 1 then
      Exit;
    for I := 0 to BodyXML.Count - 1 do
    begin
      DataSetXML := BodyXML.Items[I];
      if (not Assigned(DataSetXML)) or (DataSetXML.Count < 1) or (DataSetXML.Attrs.Count < 1) then
        Continue;

      ATab := chrmtbReturn.Tabs.Add;
      ATab.Caption := DataSetXML.Attrs.ItemByName('NAME').Value;

      APage := TJvCustomPage.Create(lstReturn);
      APage.PageList := lstReturn;

      AFrame := Tfrmvirtualstringtree.Create(APage);
      AFrame.Parent := APage;
      AFrame.DataSetXML := DataSetXML;
      ATab.Data := Pointer(APage);
    end;
    chrmtbReturn.ActiveTabIndex := 0;
    if BodyXML.Count - 1 > 0 then
      chrmtbReturn.ActiveTabIndex := BodyXML.Count;
  finally
    chrmtbReturn.EndUpdate;
    FreeAndNil(rootXML);
  end;
end;

procedure TfrmDMSTool.pnlListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FListDrag := True;
  FWindow_X := X;
  FWindow_Y := Y;
end;

procedure TfrmDMSTool.pnlListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if FListDrag then
  begin
    pnlList.Left := pnlList.Left + X - FWindow_X;
    pnlList.Top := pnlList.Top + Y - FWindow_Y;
  end;
end;

procedure TfrmDMSTool.pnlListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FListDrag := False;
end;

procedure TfrmDMSTool.vstMethodListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  aInfoList: TStringList;
begin
  if (Node <> nil) and (Node.Parent <> Sender.RootNode) then
  begin
    case Node.Parent.Index of
      0:
        aInfoList := FDCSInfoList;
      1:
        aInfoList := FDMSInfoList;
    end;
    ClearTabControl;
    sedtXML.Text := PDMSDebugInfo(aInfoList.Objects[Node.Index]).ReceiveXML;
    sedtArgus.Text := sedtArgus.Text + PDMSDebugInfo(aInfoList.Objects[Node.Index]).PostArgus + #13 + #10 + #13 + #10 + #13 + #10;
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
  end;
end;

procedure TfrmDMSTool.vstMethodListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDMSDebugInfo;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TfrmDMSTool.vstMethodListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PDMSDebugInfo;
begin
  case Column of
    0:
      if Node.Parent = Sender.RootNode then
      begin
        if Node.Index = 0 then
          CellText := 'DCS'
        else
          CellText := 'DMS'
      end
      else
        CellText := '';
    1:
      begin
        if (not Assigned(FDCSInfoList)) or (not Assigned(FDMSInfoList)) then
          Exit;
        if Node.Parent = Sender.RootNode then
        begin
          CellText := '';
          Exit;
        end;
        Data := Sender.GetNodeData(Node);
        CellText := Data.PostMethod;
      end;
  end;
end;

procedure TfrmDMSTool.vstMethodListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  //
  if (not Assigned(FDCSInfoList)) or (not Assigned(FDMSInfoList)) then
    Exit;
  case Node.Index of
    0:
      ChildCount := FDCSInfoList.Count;
    1:
      ChildCount := FDMSInfoList.Count;
  end;
end;

procedure TfrmDMSTool.vstMethodListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  aData: PDMSDebugInfo;
  aInfoList: TStringList;
begin
  if ParentNode = nil then
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded]
  else
  begin
    if (not Assigned(FDCSInfoList)) or (not Assigned(FDMSInfoList)) then
      Exit;

    case Node.Parent.Index of
      0:
        aInfoList := FDCSInfoList;
      1:
        aInfoList := FDMSInfoList;
    end;
    PDMSDebugInfo(Sender.GetNodeData(Node)).PostMethod := PDMSDebugInfo(aInfoList.Objects[Node.Index]).PostMethod;
  end;
end;

procedure TfrmDMSTool.FormCreate(Sender: TObject);
var
  ATab: TChromeTab;
  APage: TJvCustomPage;
begin
  Workers.Wait(DoFreeFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool + '.Free'), True);
  Workers.Wait(DoShowFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool + '.Show'), True);

  FShareMem := TShareMemServer.Create(Debug_MapMem);
  FShareMem.OnGetData := DoGetShareMemData;

  InitializBCEditer;
  FDMSInfoList := TStringList.Create;
  FDCSInfoList := TStringList.Create;

  vstMethodList.NodeDataSize := SizeOf(TDMSDebugInfo);
  vstMethodList.RootNodeCount := 2;

  ATab := chrmtbReturn.Tabs.Add;
  APage := TJvCustomPage.Create(lstReturn);
  APage.PageList := lstReturn;
  sedtXML.Parent := APage;
  sedtXML.Align := alClient;
  ATab.Data := Pointer(APage);
  ATab.Caption := 'XML';
  lstReturn.ActivePage := APage;

end;

procedure TfrmDMSTool.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to FDCSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDCSInfoList.Objects[I]));
  FDCSInfoList.Free;
  for I := 0 to FDMSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDMSInfoList.Objects[I]));
  FDMSInfoList.Free;

  Workers.Clear(FShareMem, -1, True);
  FShareMem.Free;
end;

procedure TfrmDMSTool.FormResize(Sender: TObject);
begin
  pnlArgus.Width := Width div 2 - 20;
  pnlList.Left := pnlArgus.Left + pnlArgus.Width - pnlList.Width;
end;

procedure TfrmDMSTool.img1Click(Sender: TObject);
begin
  pnlList.Visible := False;
end;

initialization
  Workers.Wait(DoCreateFormJob, Workers.RegisterSignal('MDIChildForm.' + DMSTool + '.Create'), True);

finalization

end.

