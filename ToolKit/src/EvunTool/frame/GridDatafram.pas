unit GridDatafram;

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
  VirtualTrees,
  Vcl.ExtCtrls,
  RzPanel,
  Vcl.StdCtrls,
  RzCmboBx,
  qxml,
  qplugins_base,
  QPlugins,
  qplugins_params,
  Vcl.Mask,
  RzEdit,
  RzBtnEdt,
  Logfrm;

type
  TResultColumn = class
    ColumnName: string;
    ColumnIndex: Integer;
  end;

  Tfrmvirtualstringtree = class(TFrame)
    vstMain: TVirtualStringTree;
    tlbrFrame: TRzToolbar;
    vstColumns: TVirtualStringTree;
    btnColumns: TRzButtonEdit;
    procedure vstMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstMainInitNode(Sender: TBaseVirtualTree; ParentNode, Node:
      PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstMainBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas:
      TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode:
      TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstMainDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: string; const
      CellRect: TRect; var DefaultDraw: Boolean);
    procedure vstColumnsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstColumnsCompareNodes(Sender: TBaseVirtualTree; Node1, Node2:
      PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure btnColumnsChange(Sender: TObject);
    procedure btnColumnsButtonClick(Sender: TObject);
    procedure vstColumnsFocusChanged(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Column: TColumnIndex);
    procedure vstColumnsDblClick(Sender: TObject);
    procedure btnColumnsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstColumnsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstColumnsInitNode(Sender: TBaseVirtualTree; ParentNode, Node:
      PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstColumnsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstColumnsExit(Sender: TObject);
  private
    { Private declarations }
    FColumns: TQParams;
    FDataSetXML: TQXML;
    FMetaXML: TQXML;
    FChooseIndex: Integer;
    function GetDataSetXML: TQXML;
    procedure SetDataSetXML(const Value: TQXML);
    procedure Log(AMessage: string);
    procedure DoIterateSubtreeSetVisible(Sender: TBaseVirtualTree; Node:
      PVirtualNode; Data: Pointer; var Abort: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DataSetXML: TQXML read GetDataSetXML write SetDataSetXML;
  end;

implementation

{$R *.dfm}

{ Tfrmvirtualstringtree }

procedure Tfrmvirtualstringtree.btnColumnsButtonClick(Sender: TObject);
begin
  vstColumns.Visible := True;
end;

procedure Tfrmvirtualstringtree.btnColumnsChange(Sender: TObject);
begin
  if not vstColumns.Visible then
    vstColumns.Visible := True;
  vstColumns.BeginUpdate;
  try
    //iterate the tree setting the visiblity of the nodes based on the above flag
    vstColumns.IterateSubtree(nil, DoIterateSubtreeSetVisible, nil, [], True);
  finally
    vstColumns.EndUpdate;
  end;
end;

procedure Tfrmvirtualstringtree.btnColumnsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then
  begin
    if not vstColumns.Visible then
      vstColumns.Visible := True;
    vstColumns.SetFocus;
  end;
end;

constructor Tfrmvirtualstringtree.Create(AOwner: TComponent);
begin
  inherited;
  vstMain.RootNodeCount := 0;
  FDataSetXML := TQXML.Create;
  FColumns := TQParams.Create;
  vstColumns.RootNodeCount := 0;
  vstColumns.NodeDataSize := SizeOf(TResultColumn);

  FChooseIndex := 0;
end;

destructor Tfrmvirtualstringtree.Destroy;
begin
  FDataSetXML.Free;
  FColumns.Clear;
  FColumns.Free;
  inherited;
end;

procedure Tfrmvirtualstringtree.DoIterateSubtreeSetVisible(Sender:
  TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  NodeData: TResultColumn;
begin
  NodeData := Node.GetData<TResultColumn>;
  Sender.IsVisible[Node] := (Pos(UpperCase(btnColumns.Text), NodeData.ColumnName)
    > 0) or (Trim(btnColumns.Text) = '');
end;

procedure Tfrmvirtualstringtree.Log(AMessage: string);
begin
  ToolLog.logMessage(AMessage);
end;

function Tfrmvirtualstringtree.GetDataSetXML: TQXML;
begin
  Result := FDataSetXML;
end;

procedure Tfrmvirtualstringtree.SetDataSetXML(const Value: TQXML);
var
  I: Integer;
  headCol: TVirtualTreeColumn;
begin
  if (not Assigned(Value)) or (Value.Count < 1) or (Value.Attrs.Count < 1) then
    raise Exception.Create('Error DataSetXML');

  FDataSetXML.Assign(Value);

  vstMain.BeginUpdate;
  try
    FColumns.Clear;
    FMetaXML := FDataSetXML.ItemByName('META');
    for I := 0 to FMetaXML.Attrs.Count - 1 do
    begin
      headCol := vstMain.Header.Columns.Add;
      headCol.Text := FMetaXML.Attrs[I].Name;
      headCol.CaptionAlignment := taCenter;
      headCol.Options := headCol.Options + [coUseCaptionAlignment];
      headCol.Width := vstMain.Canvas.TextWidth(headCol.Text) + 20;
      FColumns.Add(FMetaXML.Attrs[I].Name, IntToStr(I));
    end;
    vstMain.RootNodeCount := GetDataSetXML.Count - 1;
    vstColumns.RootNodeCount := FColumns.Count;
  finally
    vstMain.EndUpdate;
  end;
end;

procedure Tfrmvirtualstringtree.vstColumnsCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1: TResultColumn;
  Data2: TResultColumn;
begin
  Data1 := Node1.GetData<TResultColumn>;
  Data2 := Node2.GetData<TResultColumn>;
  case Column of
    0:
      Result := CompareText(Data1.ColumnName, Data2.ColumnName);
    1:
      if Data1.ColumnIndex = Data2.ColumnIndex then
        Result := 0
      else if Data1.ColumnIndex > Data2.ColumnIndex then
        Result := 1
      else
        Result := -1;
  end;
end;

procedure Tfrmvirtualstringtree.vstColumnsDblClick(Sender: TObject);
begin
  btnColumns.Text := vstColumns.GetFirstSelected(False).GetData<TResultColumn>.ColumnName;
  vstColumns.Visible := False;
end;

procedure Tfrmvirtualstringtree.vstColumnsExit(Sender: TObject);
begin
  vstColumns.Visible := False;
end;

procedure Tfrmvirtualstringtree.vstColumnsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data: TResultColumn;
begin
  Data := Node.GetData<TResultColumn>;
  FChooseIndex := Data.ColumnIndex;
  vstMain.BeginUpdate;
  vstMain.ScrollIntoView(FChooseIndex, True);
  vstMain.EndUpdate;
end;

procedure Tfrmvirtualstringtree.vstColumnsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  Node.GetData<TResultColumn>.Free;
end;

procedure Tfrmvirtualstringtree.vstColumnsGetText(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: TResultColumn;
begin
  Data := Sender.GetNodeData<TResultColumn>(Node);
  case Column of
    0:
      CellText := Data.ColumnName;
    1:
      CellText := IntToStr(Data.ColumnIndex);
  end;
end;

procedure Tfrmvirtualstringtree.vstColumnsInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: TResultColumn;
begin
  Data := TResultColumn.Create;
  Data.ColumnName := FColumns.Items[Node.Index].Name;
  Data.ColumnIndex := FColumns.Items[Node.Index].AsInteger;
  Sender.SetNodeData(Node, Data);
end;

procedure Tfrmvirtualstringtree.vstColumnsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    btnColumns.Text := vstColumns.GetFirstSelected(False).GetData <
      TResultColumn > .ColumnName;
    vstColumns.Visible := False;
  end;
end;

procedure Tfrmvirtualstringtree.vstMainBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode:
  TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Node.Index mod 2 <> 0 then
  begin
    TargetCanvas.Brush.Color := $00E9B68F;
    TargetCanvas.FillRect(CellRect);
  end;
  if (Column = FChooseIndex) then
  begin
    TargetCanvas.Brush.Color := $00E9B68F;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure Tfrmvirtualstringtree.vstMainDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text:
  string; const CellRect: TRect; var DefaultDraw: Boolean);
begin
  if (Column = FChooseIndex) then
  begin
    TargetCanvas.Font.Color := clRed;
  end;
end;

procedure Tfrmvirtualstringtree.vstMainGetText(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: TQXML;
begin
  Data := Sender.GetNodeData<TQXML>(Node);
  CellText := Data.Attrs.Items[Column].Value;
end;

procedure Tfrmvirtualstringtree.vstMainInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  Data: TQXML;
begin
  Data := GetDataSetXML.Items[Node.Index + 1];
  Sender.SetNodeData(Node, Data);
end;

end.

