unit virtualstringtreefram;

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
  qxml,
  Vcl.ExtCtrls,
  RzPanel,
  Vcl.StdCtrls,
  RzCmboBx;

type
  Tfrmvirtualstringtree = class(TFrame)
    vstMain: TVirtualStringTree;
    tlbrFrame: TRzToolbar;
    cmbCol: TRzComboBox;
    procedure vstMainGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure cmbColChange(Sender: TObject);
    procedure vstMainInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstMainBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstMainDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: string;
      const CellRect: TRect; var DefaultDraw: Boolean);
  private
    { Private declarations }
    FDataSetXML: TQXML;
    FMetaXML: TQXML;
    FChooseIndex: Integer;
    function GetDataSetXML: TQXML;
    procedure SetDataSetXML(const Value: TQXML);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DataSetXML: TQXML read GetDataSetXML write SetDataSetXML;
  end;

implementation

{$R *.dfm}

{ Tfrmvirtualstringtree }

procedure Tfrmvirtualstringtree.cmbColChange(Sender: TObject);
begin
  //
  if cmbCol.Text = '' then
    Exit;
  if not TryStrToInt(cmbCol.Value, FChooseIndex) then
    Exit;

  vstMain.BeginUpdate;
  vstMain.ScrollIntoView(FChooseIndex, True);
  vstMain.EndUpdate;
end;

constructor Tfrmvirtualstringtree.Create(AOwner: TComponent);
begin
  inherited;
  vstMain.RootNodeCount := 0;
  FDataSetXML := TQXML.Create;
end;

destructor Tfrmvirtualstringtree.Destroy;
begin
  FDataSetXML.Free;
  inherited;
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
    FMetaXML := FDataSetXML.ItemByName('META');
    for I := 0 to FMetaXML.Attrs.Count - 1 do
    begin
      headCol := vstMain.Header.Columns.Add;
      headCol.Text := FMetaXML.Attrs[I].Name;
      headCol.CaptionAlignment := taCenter;
      headCol.Options := headCol.Options + [coUseCaptionAlignment];
      headCol.Width := vstMain.Canvas.TextWidth(headCol.Text) + 20;
      cmbCol.Items.Add(FMetaXML.Attrs[I].Name);
      cmbCol.Values.Add(IntToStr(I));
    end;
    vstMain.RootNodeCount := GetDataSetXML.Count - 1;
  finally
    vstMain.EndUpdate;
  end;
end;

procedure Tfrmvirtualstringtree.vstMainBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
begin
  if Node.Index mod 2 <> 0 then
  begin
    TargetCanvas.Brush.Color := $00EAE0A8;
    TargetCanvas.FillRect(CellRect);
  end;
  if (cmbCol.Text <> '') and (Column = FChooseIndex) then
  begin
    TargetCanvas.Brush.Color := $00EAE0A8;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure Tfrmvirtualstringtree.vstMainDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
begin
  if (cmbCol.Text <> '') and (Column = FChooseIndex) then
  begin
    TargetCanvas.Font.Color := clRed;
  end;
end;

procedure Tfrmvirtualstringtree.vstMainGetText(Sender: TBaseVirtualTree; Node:
  PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText:
  string);
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

