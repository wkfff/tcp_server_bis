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
  VirtualTrees,
  QPlugins,
  qplugins_base,
  qplugins_loader_lib,
  uPubliclibsBase;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    inReposition: Boolean;
    FDragOnRunTime: IDragOnRunTime;
    oldPos: TPoint;
    procedure ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{ TForm2 }

procedure TForm2.ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  if (Sender is TWinControl) then
  begin
    inReposition := True;
    SetCapture(TWinControl(Sender).Handle);
    GetCursorPos(oldPos);
  end;
end; (*ControlMouseDown*)

procedure TForm2.ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
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
end; (*ControlMouseMove*)

procedure TForm2.ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  if inReposition then
  begin
    Screen.Cursor := crDefault;
    ReleaseCapture;
    inReposition := False;
  end;
end; (*ControlMouseUp*)

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
end;

end.

