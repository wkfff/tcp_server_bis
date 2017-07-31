unit Unit2;

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
  QPlugins,
  qplugins_base,
  qplugins_loader_lib,
  uPubliclibsBase,
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
  Data.DB,
  FireDAC.Comp.Client,
  Vcl.Samples.Gauges,
  qworker, Vcl.StdCtrls;

type
  TForm2 = class(TForm, IQNotify)
    Panel1: TPanel;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    con1: TFDConnection;
    Gauge1: TGauge;
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    FNotifyIdProgressStart: Integer;
    FNotifyIdProgressEnd: Integer;
    FShowProgress: Boolean;
    inReposition: Boolean;
    FDragOnRunTime: IDragOnRunTime;
    oldPos: TPoint;
    procedure ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
    procedure DoShowProgress(AData: PQJob);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit3;

procedure TForm2.btn1Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm2.ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  if (Sender is TWinControl) then
  begin
    inReposition := True;
    SetCapture(TWinControl(Sender).Handle);
    GetCursorPos(oldPos);
  end;
end;

procedure TForm2.ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
const
  minWidth = 20;
  minHeight = 20;
var
  newPos: TPoint;
  frmPoint: TPoint;
begin
  if inReposition then
  begin
    with TWinControl(Sender) do
    begin
      GetCursorPos(newPos);

      if ssShift in Shift then
      begin //resize
        Screen.Cursor := crSizeNWSE;
        frmPoint := ScreenToClient(Mouse.CursorPos);
        if frmPoint.X > minWidth then
          Width := frmPoint.X;
        if frmPoint.Y > minHeight then
          Height := frmPoint.Y;
      end
      else //move
      begin
        Screen.Cursor := crSize;
        Left := Left - oldPos.X + newPos.X;
        Top := Top - oldPos.Y + newPos.Y;
        oldPos := newPos;
      end;
    end;
  end;
end;

procedure TForm2.ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  if inReposition then
  begin
    Screen.Cursor := crDefault;
    ReleaseCapture;
    inReposition := False;
  end;
end;

procedure TForm2.DoShowProgress(AData: PQJob);
begin
  Gauge1.Progress := Gauge1.Progress + 1;
  if FShowProgress then
    Workers.Delay(DoShowProgress, Q1Second, nil, False);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  APath: string;
begin
  APath := ExtractFilePath(Application.ExeName);
  PluginsManager.Loaders.Add(TQDLLLoader.Create(APath, '.dll'));
  PluginsManager.Loaders.Add(TQBPLLoader.Create(APath, '.bpl'));
  PluginsManager.Start;

  if Supports(PluginsManager.ByPath(PChar('/Services/Controls/DragOnRunTime')),
    IDragOnRunTime, FDragOnRunTime) then
    FDragOnRunTime.SelectControl := Panel1;
  FNotifyIdProgressStart := (PluginsManager as IQNotifyManager).IdByName('ProgressStart');
  FNotifyIdProgressEnd := (PluginsManager as IQNotifyManager).IdByName('ProgressEnd');
  (PluginsManager as IQNotifyManager).Subscribe(FNotifyIdProgressStart, Self);
  (PluginsManager as IQNotifyManager).Subscribe(FNotifyIdProgressEnd, Self);
  FShowProgress := False;
end;

procedure TForm2.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  if AId = FNotifyIdProgressStart then
  begin
    FShowProgress := True;
    Workers.Delay(DoShowProgress, Q1Second, nil, False);
  end
  else if AId = FNotifyIdProgressEnd then
  begin
    FShowProgress := False;
  end;
end;

end.

