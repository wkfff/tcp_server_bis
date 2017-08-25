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
  Vcl.ExtCtrls,
  System.IniFiles,
  DB,
  RzPanel,
  RzSplit,
  System.ImageList,
  Vcl.ImgList,
  RzTabs,
  SynEdit,
  RzButton,
  RzRadChk,
  JvImageList,
  SynEditHighlighter,
  SynHighlighterIni,
  SynHighlighterXML,
  VirtualTrees,
  System.Actions,
  Vcl.ActnList,
  Vcl.Menus,
  Vcl.StdCtrls,
  Vcl.DBGrids,
  Vcl.Grids,
  RzLabel,
  Vcl.Mask,
  RzEdit,
  qstring,
  qplugins_base,
  uPubliclibsBase,
  QPlugins,
  qxml,
  uShareMemServer,
  qplugins_vcl_formsvc,
  qplugins_vcl_messages,
  qplugins_params,
  iocp.Http.Client,
  qworker,
  GridDatafram,
  Logfrm,
  DBGridDatafram,
  RzBtnEdt,
  RzCommon;

type
  TDMSDebugInfo = class
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
    btbtnExcute: TRzBitBtn;
    actExcuteHttp: TAction;
    mniCopy: TMenuItem;
    mniCopy1: TMenuItem;
    mniPaste: TMenuItem;
    mniPaste1: TMenuItem;
    vstMethodList: TVirtualStringTree;
    frmServerList: TframDBGridData;
    edtServer: TRzButtonEdit;
    actShowList: TAction;
    mniShowList: TMenuItem;
    mniExcuteHttp: TMenuItem;
    mniStartListener: TMenuItem;
    mctrMain: TRzMenuController;
    mniN2: TMenuItem;
    mniN3: TMenuItem;
    mniN4: TMenuItem;
    mniN5: TMenuItem;
    actFormatXML: TAction;
    mniFormatXML: TMenuItem;
    procedure FormResize(Sender: TObject);
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
    procedure vstMethodListDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rzpnlServerResize(Sender: TObject);
    procedure edtServerButtonClick(Sender: TObject);
    procedure frmServerListgrdDataDblClick(Sender: TObject);
    procedure actShowListExecute(Sender: TObject);
    procedure mniStartListenerClick(Sender: TObject);
    procedure mniN5Click(Sender: TObject);
    procedure actFormatXMLExecute(Sender: TObject);
  private
    FExecutingHttpMethod: Boolean;
    FNotifyIdProgressStart: Integer;
    FNotifyIdProgressEnd: Integer;
    FNotifyManager: IQNotifyManager;
    FDragOnRunTime: IDragOnRunTime;
    FShareMem: TShareMemServer;
    FDMSInfoList: TStringList;
    FDCSInfoList: TStringList;
    procedure DoGetShareMemData(AJob: PQJob);
    procedure DoRefrashVST(AVST: TVirtualStringTree);
    procedure ClearTabControl;
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
//  for I := 0 to FDCSInfoList.Count - 1 do
//    FDCSInfoList.Objects[I].Free;
  FDCSInfoList.Clear;

//  for I := 0 to FDMSInfoList.Count - 1 do
//    FDMSInfoList.Objects[I].Free;
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
  AData: string;
  I: Integer;
  AEnd: Integer;
  AMethod: string;
begin
  {TODO -oYU -cGeneral : HttpQueue 顺序执行Http Post}
  if FExecutingHttpMethod then
    Exit;

  AData := sedtArgus.SelText;

  if Trim(AData) = '' then
  begin
    AEnd := 0;
    for I := sedtArgus.CaretY - 1 to sedtArgus.Lines.Count - 1 do
    begin
      if (Trim(sedtArgus.Lines[I]) = '') then
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

      if Pos('ACTION', sedtArgus.Lines[I]) > 0 then
        AMethod := Trim(sedtArgus.Lines[I]);

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
        Break;

      if Pos('ACTION', sedtArgus.Lines[I]) > 0 then
        AMethod := Trim(sedtArgus.Lines[I]);

      if AData = '' then
        AData := sedtArgus.Lines[I]
      else
        AData := sedtArgus.Lines[I] + '&' + AData;
    end;
  end;

  try
    FNotifyManager.Send(FNotifyIdProgressStart, NewParams(['调用HTTP执行方法:' + AMethod]));
    FExecutingHttpMethod := True;
    Workers.Post(procedure(AJob: PQJob)
                 var
                   AHeader: THttpHeaders;
                 begin
                   AHeader := nil;
                   try
                     AHeader := THttpHeaders.Create;
                     AHeader.Add('Content-Encoding', 'gzip');
                     AHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
                     AHeader.Add('Accept',
                       'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
                     AHeader.Add('Accept-Encoding', 'gzip, deflate, identity');
                     AHeader.Add('User-Agent', 'UserClient');
                     sedtXML.Text := HttpPost(edtServer.Text, AData, hct_UTF8, AHeader);
                     FNotifyManager.Send(FNotifyIdProgressEnd, nil);
                     Workers.Post(procedure(AJob: PQJob)
                                  begin
                                    FExecutingHttpMethod := False;
                                    actResolveXML.Execute;
                                    pgcResults.ActivePageIndex := 0;
                                    if pgcResults.PageCount > 1 then
                                      pgcResults.ActivePageIndex := pgcResults.PageCount - 1;
                                  end, nil, True);
                   finally
                     FreeAndNil(AHeader);
                   end;
                 end, nil, False);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Log('Eorr:' + E.Message);
    end;
  end;
end;

procedure TfrmEvunTool.actFormatXMLExecute(Sender: TObject);
var
  AQxml: TQXML;
begin
  AQxml := TQXML.Create;
  try
    AQxml.Parse(PWideChar(sedtXML.Text));
    sedtXML.Text := '<?xml version="1.0" encoding="UTF-8"?>' + #13 + #10
      + AQxml.AsXML;
  finally
    AQxml.Free;
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

procedure TfrmEvunTool.actShowListExecute(Sender: TObject);
begin
  vstMethodList.BringToFront;
  if vstMethodList.Visible then
  begin
    vstMethodList.Visible := False;
  end
  else
  begin
    vstMethodList.Visible := True;
  end;
end;

procedure TfrmEvunTool.actStartListenerExecute(Sender: TObject);
begin
  FShareMem.Active := cbxStart.Checked;
end;

procedure TfrmEvunTool.Log(AMessage: string);
begin
  ToolLog.logMessage(AMessage);
end;

procedure TfrmEvunTool.mniPaste1Click(Sender: TObject);
begin
  sedtXML.PasteFromClipboard;
end;

procedure TfrmEvunTool.mniPasteClick(Sender: TObject);
begin
  sedtArgus.PasteFromClipboard;
end;

procedure TfrmEvunTool.mniStartListenerClick(Sender: TObject);
begin
  cbxStart.Checked := not cbxStart.Checked;
  actStartListener.Execute;
end;

procedure TfrmEvunTool.mniCopy1Click(Sender: TObject);
begin
  sedtXML.CopyToClipboard;
end;

procedure TfrmEvunTool.mniCopyClick(Sender: TObject);
begin
  sedtArgus.CopyToClipboard;
end;

procedure TfrmEvunTool.mniN5Click(Sender: TObject);
begin
  Log('BlockBegin.Char:' + IntToStr(sedtArgus.BlockBegin.Char));
  Log('BlockBegin.Line:' + IntToStr(sedtArgus.BlockBegin.Line));
  Log('BlockEnd.Char:' + IntToStr(sedtArgus.BlockEnd.Char));
  Log('BlockEnd.Line:' + IntToStr(sedtArgus.BlockEnd.Line));
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
  aData: TDMSDebugInfo;
  aInfoList: TStringList;
const
  AscII_11: PWideChar = #11;
  AscII_12: PWideChar = #12;
  AscII_Enter: PWideChar = #13 + #10;
begin
  IsNew := True;
  pReceive := PWideChar(AJob.Data);
  if (Pos('DMS_IBASEPARAMETERS.QUERYDTSYSPARAMETERS', pReceive) > 0) or (Pos('DMS_IDTCICLOUDSUPPORT.QUERYSTANDBY',
    pReceive) > 0) then
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
    aData := TDMSDebugInfo.Create;
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
    aData := TDMSDebugInfo(aInfoList.Objects[I]);
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
    pArgus := PWideChar(TDMSDebugInfo(aInfoList.Objects[aInfoList.Count - 1]).PostArgus);
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
    sedtXML.Lines.Text := (TDMSDebugInfo(aInfoList.Objects[aInfoList.Count - 1]).ReceiveXML);
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

procedure TfrmEvunTool.edtServerButtonClick(Sender: TObject);
begin
  frmServerList.BringToFront;
  frmServerList.OpenSQL := 'SELECT * FROM sys_server_list;';
  frmServerList.Query;
  frmServerList.Visible := True;
end;

procedure TfrmEvunTool.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmEvunTool.FormCreate(Sender: TObject);
begin
  FShareMem := TShareMemServer.Create(Debug_MapMem);
  FShareMem.OnGetData := DoGetShareMemData;

  FDMSInfoList := TStringList.Create;
  FDCSInfoList := TStringList.Create;

  vstMethodList.NodeDataSize := SizeOf(TDMSDebugInfo);
  vstMethodList.RootNodeCount := 2;

  vstMethodList.Hide;

  if Supports(PluginsManager.ByPath(PChar('/Services/Controls/DragOnRunTime')),
    IDragOnRunTime, FDragOnRunTime) then
    FDragOnRunTime.SelectControl := vstMethodList;

  FNotifyManager := (PluginsManager as IQNotifyManager);
  FNotifyIdProgressStart := FNotifyManager.IdByName('main_form.progress.start_update');
  FNotifyIdProgressEnd := FNotifyManager.IdByName('main_form.progress.end_update');
  FExecutingHttpMethod := False;
end;

procedure TfrmEvunTool.FormDestroy(Sender: TObject);
begin
  FreeAndNilObject(FDCSInfoList);
  FreeAndNilObject(FDMSInfoList);

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

procedure TfrmEvunTool.frmServerListgrdDataDblClick(Sender: TObject);
const
  DMS_FILE = 'F:\GeelyEVUN\SVN\Client3.0\DMS\br_dev\bin\config\AppServer.dms';
  DCS_FILE = 'F:\GeelyEVUN\SVN\Client3.0\DCS\br_dev\bin\config\AppServer.dms';
var
  AIni: TIniFile;
  AFileName: string;
begin
  frmServerList.Visible := False;
  if frmServerList.qryData.RecordCount = 0 then
    Exit;
  edtServer.Text := frmServerList.qryData.FieldByName('server_url').AsString;
  if Pos('dms',edtServer.Text) > 0 then
    AFileName := DMS_FILE
  else
    AFileName := DCS_FILE;

  AIni := TIniFile.Create(AFileName);
  AIni.WriteString('Server', 'ISP', '0');
  AIni.WriteString('LAN', 'URL[1]', edtServer.Text);
  AIni.Free;
end;

procedure TfrmEvunTool.pgcResultsClose(Sender: TObject; var AllowClose: Boolean);
begin
  AllowClose := pgcResults.ActivePageIndex <> 0;
  if not AllowClose then
    sedtXML.Text := '';
end;

procedure TfrmEvunTool.rzpnlServerResize(Sender: TObject);
begin
  if rzpnlServer.Width = 0 then
    Exit;
  edtServer.Left := 72;
  edtServer.Width := rzpnlServer.Width - 72 - btbtnExcute.Width - 4;
  btbtnExcute.Left := edtServer.Left + edtServer.Width + 2;
end;

procedure TfrmEvunTool.vstMethodListDblClick(Sender: TObject);
begin
  vstMethodList.Hide;
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
    else
        aInfoList := FDMSInfoList;
    end;
    ClearTabControl;
    sedtXML.Text := TDMSDebugInfo(aInfoList.Objects[Node.Index]).ReceiveXML;
    sedtArgus.Text := sedtArgus.Text + TDMSDebugInfo(aInfoList.Objects[Node.Index]).PostArgus
      + #13 + #10 + #13 + #10 + #13 + #10;
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
    pgcResults.ActivePageIndex := 0;
  end;
end;

procedure TfrmEvunTool.vstMethodListFreeNode(Sender: TBaseVirtualTree; Node:
  PVirtualNode);
var
  Data: TDMSDebugInfo;
begin
  Data := Sender.GetNodeData<TDMSDebugInfo>(Node);
  Data.Free;
end;

procedure TfrmEvunTool.vstMethodListGetText(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
  string);
var
  Data: TDMSDebugInfo;
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
        Data := Sender.GetNodeData<TDMSDebugInfo>(Node);
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
  aData: TDMSDebugInfo;
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
    else
        aInfoList := FDMSInfoList;
    end;
    aData := TDMSDebugInfo.Create;
    aData.PostMethod := TDMSDebugInfo(aInfoList.Objects[Node.Index]).PostMethod;
    Sender.SetNodeData(Node, aData);
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

