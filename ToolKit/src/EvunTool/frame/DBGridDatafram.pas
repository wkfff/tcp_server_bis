unit DBGridDatafram;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Math,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.ExtCtrls,
  RzPanel,
  RzDBNav,
  Vcl.Grids,
  Vcl.DBGrids,
  RzDBGrid,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TframDBGridData = class(TFrame)
    nvData: TRzDBNavigator;
    grdData: TRzDBGrid;
    dsData: TDataSource;
    SQLiteDLData: TFDPhysSQLiteDriverLink;
    conData: TFDConnection;
    qryData: TFDQuery;
    tbControl: TRzToolbar;
    procedure FrameExit(Sender: TObject);
  private
    FOpenSQL: string;
    function GetOpenSQL: string;
    procedure SetOpenSQL(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property OpenSQL: string read GetOpenSQL write SetOpenSQL;
    procedure Query;
  end;

implementation

{$R *.dfm}

procedure FitGrid(Grid: TDBGrid);
const
  C_Add = 13;
var
  ds: TDataSet;
  bm: TBookmark;
  i: Integer;
  w: Integer;
  a: Array of Integer;
begin
  ds := Grid.DataSource.DataSet;
  if Assigned(ds) then
  begin
    ds.DisableControls;
    bm := ds.GetBookmark;
    try
      ds.First;
      SetLength(a, Grid.Columns.Count);
      while not ds.Eof do
      begin
        for I := 0 to Grid.Columns.Count - 1 do
        begin
          if Assigned(Grid.Columns[i].Field) then
          begin
            w := Max(Grid.Canvas.TextWidth(ds.FieldByName(Grid.Columns[i].Field.FieldName).DisplayText),
              Grid.Canvas.TextWidth(Grid.Columns[i].Field.FieldName));
            if a[i] < w  then
               a[i] := w ;
          end;
        end;
        ds.Next;
      end;
      for I := 0 to Grid.Columns.Count - 1 do
        Grid.Columns[i].Width := a[i] + C_Add;
        ds.GotoBookmark(bm);
    finally
      ds.FreeBookmark(bm);
      ds.EnableControls;
    end;
  end;
end;

{ TframDBGridData }

procedure TframDBGridData.FrameExit(Sender: TObject);
begin
  Self.Visible := False;
end;

function TframDBGridData.GetOpenSQL: string;
begin
  Result := FOpenSQL;
end;

procedure TframDBGridData.Query;
var
  I: Integer;
  AColumn: TColumn;
begin
  conData.Connected := True;
  qryData.Open;
  grdData.Columns.Clear;
  for I := 0 to qryData.FieldCount - 1 do
  begin
    AColumn := grdData.Columns.Add;
    AColumn.FieldName := qryData.Fields[I].FieldName;
  end;
  FitGrid(grdData);
end;

procedure TframDBGridData.SetOpenSQL(const Value: string);
begin
  FOpenSQL := Value;
  qryData.SQL.Clear;
  qryData.SQL.Add(Value);
end;

end.

