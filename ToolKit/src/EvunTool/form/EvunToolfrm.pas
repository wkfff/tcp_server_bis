unit EvunToolfrm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.SysStyles,
  qplugins_base,
  QPlugins,
  qstring,
  qplugins_formsvc,
  qplugins_vcl_messages,
  qplugins_vcl_formsvc,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  RzPanel,
  RzSplit,
  SynEdit,
  System.ImageList,
  Vcl.ImgList,
  cxGraphics,
  RzTabs,
  RzButton,
  RzRadChk,
  RzLabel,
  Vcl.Mask,
  RzEdit,
  RzBtnEdt,
  uShareMemServer,
  qworker,
  VirtualTrees;

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

  TfrmEvunTool = class(TForm, IQNotify)
    rzsplEvunTool: TRzSplitter;
    tlbrAction: TRzToolbar;
    pnlServer: TRzPanel;
    pgcResult: TRzPageControl;
    tbsXML: TRzTabSheet;
    imgSmall_16X16: TcxImageList;
    sedtArgus: TSynEdit;
    sedtXML: TSynEdit;
    cbxBegin: TRzCheckBox;
    scr1: TRzSpacer;
    btnExcute: TRzToolButton;
    btnList: TRzToolButton;
    btnLog: TRzToolButton;
    btnServer: TRzButtonEdit;
    lblServer: TRzLabel;
    btbtnExcute: TRzBitBtn;
    pnlList: TRzPanel;
    vst1: TVirtualStringTree;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnListClick(Sender: TObject);
    procedure vstMethodListFocusChanged(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex);
    procedure vstMethodListFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstMethodListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstMethodListInitChildren(Sender: TBaseVirtualTree; Node:
      PVirtualNode; var ChildCount: Cardinal);
    procedure vstMethodListInitNode(Sender: TBaseVirtualTree; ParentNode, Node:
      PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private
    { Private declarations }
    FNotifyIds: TDictionary<string, Integer>;
    FShareMem: TShareMemServer;
    FDMSInfoList: TStringList;
    FDCSInfoList: TStringList;
    procedure DoGetShareMemData(AJob: PQJob);
    procedure DoRefrashVST(AVST: TVirtualStringTree);
  protected
    procedure Notify(const AId: Cardinal; AParams: IQParams; var AFireNext:
      Boolean); stdcall;
  public
    { Public declarations }
    destructor Destroy; override;
  end;

const
  NOTIFY_ID_CHANGE_VCL_STYLE = 'CHANGE_VCL_STYLE';
  ServiceName: PWideChar = 'EvunTool';
  ServiceId: TGuid = '{76397A4F-5350-498D-9CE3-AAF3F9CDAB31}';
  Debug_MapMem: string = '__Debug_MapMem_v_x_MapMem__';

implementation

{$R *.dfm}

procedure TfrmEvunTool.btn1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmEvunTool.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
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

//    DoRefrashVST(vstMethodList);
//    if IsDms then
//      vstMethodList.ScrollIntoView((vstMethodList.RootNode.LastChild.LastChild),
//        True)
//    else
//      vstMethodList.ScrollIntoView((vstMethodList.RootNode.FirstChild.LastChild),
//        True);

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

procedure TfrmEvunTool.DoRefrashVST(AVST: TVirtualStringTree);
var
  OldRootCount: Integer;
begin
  OldRootCount := AVST.RootNodeCount;
  AVST.RootNodeCount := 0;
  AVST.RootNodeCount := OldRootCount;
end;

procedure TfrmEvunTool.FormCreate(Sender: TObject);
var
  ANotifyMgr: IQNotifyManager;
begin
  FNotifyIds := TDictionary<string, Integer>.Create;
  TStyleManager.SystemHooks := TStyleManager.SystemHooks - [shMenus];
  TStyleManager.TrySetStyle('Iceberg Classico', False);
  ANotifyMgr := PluginsManager as IQNotifyManager;
  FNotifyIds.Add(NOTIFY_ID_CHANGE_VCL_STYLE, ANotifyMgr.IdByName(NOTIFY_ID_CHANGE_VCL_STYLE));
  ANotifyMgr.Subscribe(FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE], Self);

  FDMSInfoList := TStringList.Create;
  FDCSInfoList := TStringList.Create;
  FShareMem := TShareMemServer.Create(Debug_MapMem);
  FShareMem.OnGetData := DoGetShareMemData;
end;

procedure TfrmEvunTool.btnListClick(Sender: TObject);
begin
  pnlList.Visible := True;
end;

destructor TfrmEvunTool.Destroy;
var
  ANotifyMgr: IQNotifyManager;
  I: Integer;
begin
  Workers.Clear(FShareMem, -1, True);
  FShareMem.Free;
  for I := 0 to FDCSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDCSInfoList.Objects[I]));
  FDCSInfoList.Free;
  for I := 0 to FDMSInfoList.Count - 1 do
    Dispose(PDMSDebugInfo(FDMSInfoList.Objects[I]));
  FDMSInfoList.Free;
  ANotifyMgr := PluginsManager as IQNotifyManager;
  ANotifyMgr.Unsubscribe(FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE], Self);
  FNotifyIds.Free;
  inherited;
end;

procedure TfrmEvunTool.Notify(const AId: Cardinal; AParams: IQParams; var
  AFireNext: Boolean);
begin
  if AId = FNotifyIds.Items[NOTIFY_ID_CHANGE_VCL_STYLE] then
  begin
    TStyleManager.TrySetStyle(AParams.ByName('VCLStyleName').AsString.Value, False);
  end;
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
//    ClearTabControl;
    sedtXML.Text := PDMSDebugInfo(aInfoList.Objects[Node.Index]).ReceiveXML;
    sedtArgus.Text := sedtArgus.Text + PDMSDebugInfo(aInfoList.Objects[Node.Index]).PostArgus
      + #13 + #10 + #13 + #10 + #13 + #10;
    sedtArgus.GotoLineAndCenter(sedtArgus.Lines.Count - 1);
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

initialization
  RegisterFormService('/Services/Docks/Forms', 'EvunTool', TfrmEvunTool, False);

finalization
  UnregisterServices('/Services/Docks/Forms', ['EvunTool']);

end.

