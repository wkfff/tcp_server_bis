unit EvunToolfrm;

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
  qstring,
  qplugins_base,
  QPlugins,
  qplugins_vcl_formsvc,
  qplugins_vcl_messages,
  qplugins_params,
  Vcl.ExtCtrls,
  RzPanel,
  RzSplit,
  System.ImageList,
  Vcl.ImgList,
  cxGraphics,
  RzTabs,
  SynEdit,
  RzButton,
  RzRadChk,
  JvImageList,
  SynEditHighlighter,
  SynHighlighterIni,
  SynHighlighterXML,
  VirtualTrees,
  qxml,
  uShareMemServer,
  System.Actions,
  Vcl.ActnList,
  Vcl.Menus,
  virtualstringtreefram,
  Vcl.StdCtrls,
  RzLabel,
  Vcl.Mask,
  RzEdit,
  iocp.Http.Client,
  qworker;

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

  TfrmEvunTool = class(TForm)
    splEvunTool: TRzSplitter;
    tbrButtons: TRzToolbar;
    sedtArgus: TSynEdit;
    pgcResults: TRzPageControl;
    tstXML: TRzTabSheet;
    cbxStart: TRzCheckBox;
    il16X16: TJvImageList;
    rzpnlServer: TRzPanel;
    sedtXML: TSynEdit;
    sxsXML: TSynXMLSyn;
    pcr1: TRzSpacer;
    btnList: TRzToolButton;
    btnLog: TRzToolButton;
    btnExcute: TRzToolButton;
    rzpnlList: TRzPanel;
    vstMethodList: TVirtualStringTree;
    actEvunTool: TActionList;
    actStartListener: TAction;
    sisIni: TSynIniSyn;
    actClearArgus: TAction;
    pmArgus: TPopupMenu;
    pmArgusList: TPopupMenu;
    pmXML: TPopupMenu;
    mniClearArgus: TMenuItem;
    actClearArgusedt: TAction;
    mniClearArgusedt: TMenuItem;
    actResolveXML: TAction;
    mniResolveXML: TMenuItem;
    mniN1: TMenuItem;
    actClearXML: TAction;
    mniClearXML: TMenuItem;
    lblServer: TRzLabel;
    edtServer: TRzEdit;
    btbtnExcute: TRzBitBtn;
    actExcuteHttp: TAction;
    mniCopy: TMenuItem;
    mniCopy1: TMenuItem;
    mniPaste: TMenuItem;
    mniPaste1: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure vstMethodListDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vstMethodListFocusChanged(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex);
    procedure vstMethodListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstMethodListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstMethodListInitChildren(Sender: TBaseVirtualTree; Node:
      PVirtualNode; var ChildCount: Cardinal);
    procedure vstMethodListInitNode(Sender: TBaseVirtualTree; ParentNode, Node:
      PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure actStartListenerExecute(Sender: TObject);
    procedure actClearArgusExecute(Sender: TObject);
    procedure actClearArgusedtExecute(Sender: TObject);
    procedure actClearXMLExecute(Sender: TObject);
    procedure actResolveXMLExecute(Sender: TObject);
    procedure pgcResultsClose(Sender: TObject; var AllowClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure actExcuteHttpExecute(Sender: TObject);
    procedure mniCopyClick(Sender: TObject);
    procedure mniCopy1Click(Sender: TObject);
    procedure mniPasteClick(Sender: TObject);
    procedure mniPaste1Click(Sender: TObject);
  private
    FNotifyId_log: Integer;
    FShareMem: TShareMemServer;
    FDMSInfoList: TStringList;
    FDCSInfoList: TStringList;
    procedure DoGetShareMemData(AJob: PQJob);
    procedure DoRefrashVST(AVST: TVirtualStringTree);
    procedure ClearTabControl;
    procedure DoLogMessage(AMessage: PChar);
    procedure Log(AMessage: string);
  public
    { Public declarations }
  end;

implementation

const
  Debug_MapMem: string = '__Debug_MapMem_v_x_MapMem__';


{$R *.dfm}

procedure TfrmEvunTool.actClearArgusedtExecute(Sender: TObject);
begin
  sedtArgus.Clear;
end;

procedure TfrmEvunTool.actClearArgusExecute(Sender: TObject);
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

procedure TfrmEvunTool.actClearXMLExecute(Sender: TObject);
begin
  ClearTabControl;
  sedtXML.Clear;
end;

procedure TfrmEvunTool.actExcuteHttpExecute(Sender: TObject);
var
  AHeader: THttpHeaders;
  AData: string;
  I: Integer;
  AEnd: Integer;
  AStart: Integer;
begin
  AHeader := nil;

  try
    AHeader := THttpHeaders.Create;
    AHeader.Add('Content-Encoding','gzip');
    AHeader.Add('Content-Type','application/x-www-form-urlencoded');
    AHeader.Add('Accept','text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
    AHeader.Add('Accept-Encoding', 'gzip, deflate, identity');
    AHeader.Add('User-Agent', 'UserClient');
    AData := sedtArgus.SelText;

    if Trim(AData) = '' then
    begin
      for I := sedtArgus.CaretY - 1 to sedtArgus.Lines.Count - 1 do
      begin
        if (Trim(sedtArgus.Lines[I]) = '')  then
        begin
          AEnd := I - 1;
          Break;
        end
        else if (I = sedtArgus.Lines.Count - 1) then
        begin
          AEnd := I;
          Break;
        end;
      end;
      for I := AEnd downto 0 do
      begin
        if (Trim(sedtArgus.Lines[I]) = '') then
          Break;
        if AData = '' then
          AData := sedtArgus.Lines[I]
        else
          AData := sedtArgus.Lines[I] + '&' + AData;
      end;
    end
    else
    begin
      for I := sedtArgus.BlockEnd.Line downto sedtArgus.BlockBegin.Line do
      begin
        if Trim(sedtArgus.Lines[I]) = '' then
          Continue;
        if AData = '' then
          AData := sedtArgus.Lines[I]
        else
          AData := sedtArgus.Lines[I] + '&' + AData;
      end;
    end;

    try
      sedtXML.Text := HttpPost(edtServer.Text, AData, hct_UTF8, AHeader);
      actResolveXML.Execute;
      pgcResults.ActivePageIndex := 0;
      if pgcResults.PageCount > 1 then
        pgcResults.ActivePageIndex := pgcResults.PageCount - 1;
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
        Log('Eorr:' + E.Message);
      end;
    end;
  finally
    FreeAndNil(AHeader);
  end;
end;

procedure TfrmEvunTool.actResolveXMLExecute(Sender: TObject);
var
  rootXML: TQXML;
  BodyXML: TQXML;
  DataSetXML: TQXML;
  I: Integer;
  APage: TRzTabSheet;
  AFrame: Tfrmvirtualstringtree;
begin
  rootXML := nil;
  ClearTabControl;
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
      if (not Assigned(DataSetXML)) or (DataSetXML.Count < 1) or (DataSetXML.Attrs.Count
        < 1) then
        Continue;

      APage := TRzTabSheet.Create(pgcResults);
      APage.PageControl := pgcResults;
      APage.Caption := DataSetXML.Attrs.ItemByName('NAME').Value;

      AFrame := Tfrmvirtualstringtree.Create(APage);
      AFrame.Parent := APage;
      AFrame.DataSetXML := DataSetXML;

      APage.Data := Pointer(APage);
      APage.ImageIndex := 45;
    end;
    pgcResults.ActivePageIndex := 0;
    if pgcResults.PageCount > 1 then
      pgcResults.ActivePageIndex := pgcResults.PageCount - 1;
  finally
    FreeAndNil(rootXML);
  end;
end;

procedure TfrmEvunTool.actStartListenerExecute(Sender: TObject);
begin
  FShareMem.Active := cbxStart.Checked;
end;

procedure TfrmEvunTool.btnListClick(Sender: TObject);
begin
  if rzpnlList.Showing then
    rzpnlList.Hide
  else
    rzpnlList.Show;
end;

procedure TfrmEvunTool.DoLogMessage(AMessage: PChar);
begin
  (PluginsManager as IQNotifyManager).Send(FNotifyId_log, NewParams([AMessage]));
end;

procedure TfrmEvunTool.Log(AMessage: string);
begin
  DoLogMessage(PChar(AMessage));
end;

procedure TfrmEvunTool.mniPaste1Click(Sender: TObject);
begin
  sedtXML.PasteFromClipboard;
end;

procedure TfrmEvunTool.mniPasteClick(Sender: TObject);
begin
  sedtArgus.PasteFromClipboard;
end;

procedure TfrmEvunTool.mniCopy1Click(Sender: TObject);
begin
  sedtXML.CopyToClipboard;
end;

procedure TfrmEvunTool.mniCopyClick(Sender: TObject);
begin
  sedtArgus.CopyToClipboard;
end;

procedure TfrmEvunTool.DoGetShareMemData(AJob: PQJob);
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
  if (Pos('DMS_IBASEPARAMETERS.QUERYDTSYSPARAMETERS', pReceive) > 0)
    or (Pos('DMS_IDTCICLOUDSUPPORT.QUERYSTANDBY', pReceive) > 0) then
    Exit;

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
      vstMethodList.ScrollIntoView((vstMethodList.RootNode.LastChild.LastChild),
        True)
    else
      vstMethodList.ScrollIntoView((vstMethodList.RootNode.FirstChild.LastChild),
        True);

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
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
    sedtArgus.EndUpdate;
  end
  else
  begin
    sedtXML.BeginUpdate;
    sedtXML.Lines.Text := (PDMSDebugInfo(aInfoList.Objects[aInfoList.Count - 1]).ReceiveXML);
    sedtXML.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
    sedtXML.EndUpdate;
  end;
end;

procedure TfrmEvunTool.DoRefrashVST(AVST: TVirtualStringTree);
var
  OldRootCount: Integer;
begin
  OldRootCount := AVST.RootNodeCount;
  AVST.RootNodeCount := 0;
  AVST.RootNodeCount := OldRootCount;
end;

procedure TfrmEvunTool.FormCreate(Sender: TObject);
begin
  FShareMem := TShareMemServer.Create(Debug_MapMem);
  FShareMem.OnGetData := DoGetShareMemData;

  FDMSInfoList := TStringList.Create;
  FDCSInfoList := TStringList.Create;

  vstMethodList.NodeDataSize := SizeOf(TDMSDebugInfo);
  vstMethodList.RootNodeCount := 2;

  FNotifyId_log := (PluginsManager as IQNotifyManager).IdByName('__safe_Logger__');
  rzpnlList.Hide;
end;

procedure TfrmEvunTool.FormDestroy(Sender: TObject);
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

procedure TfrmEvunTool.FormResize(Sender: TObject);
begin
  splEvunTool.UsePercent := False;
  splEvunTool.Percent := 50;
  splEvunTool.UsePercent := True;
end;

procedure TfrmEvunTool.FormShow(Sender: TObject);
begin
  sedtArgus.SetFocus;
end;

procedure TfrmEvunTool.pgcResultsClose(Sender: TObject; var AllowClose: Boolean);
begin
  AllowClose := pgcResults.ActivePageIndex <> 0;
  if not AllowClose then
    sedtXML.Text := '';
end;

procedure TfrmEvunTool.vstMethodListDblClick(Sender: TObject);
begin
  rzpnlList.Hide;
end;

procedure TfrmEvunTool.vstMethodListFocusChanged(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex);
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
    sedtArgus.Text := sedtArgus.Text + PDMSDebugInfo(aInfoList.Objects[Node.Index]).PostArgus
      + #13 + #10 + #13 + #10 + #13 + #10;
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
    pgcResults.ActivePageIndex := 0;
  end;
end;

procedure TfrmEvunTool.vstMethodListFreeNode(Sender: TBaseVirtualTree; Node:
  PVirtualNode);
var
  Data: PDMSDebugInfo;
begin
  Data := Sender.GetNodeData(Node);
  Finalize(Data^);
end;

procedure TfrmEvunTool.vstMethodListGetText(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
  string);
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

procedure TfrmEvunTool.vstMethodListInitChildren(Sender: TBaseVirtualTree; Node:
  PVirtualNode; var ChildCount: Cardinal);
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

procedure TfrmEvunTool.vstMethodListInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
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
    PDMSDebugInfo(Sender.GetNodeData(Node)).PostMethod := PDMSDebugInfo(aInfoList.Objects
      [Node.Index]).PostMethod;
  end;
end;

procedure TfrmEvunTool.ClearTabControl;
var
  I: Integer;
begin
  if pgcResults.PageCount > 1 then
    for I := pgcResults.PageCount - 1 downto 1 do
      pgcResults.Pages[I].Free;
  pgcResults.ActivePageIndex := 0;
end;

initialization
  RegisterFormService('/Services/Docks/Forms', 'EvunTool', TfrmEvunTool, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['EvunTool']);

end.

