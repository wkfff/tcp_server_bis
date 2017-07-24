unit uDragOnRunTime;

interface

uses
  Controls,
  Windows,
  Messages,
  Forms,
  SysUtils,
  Classes,
  ExtCtrls,
  Contnrs,
  Vcl.Dialogs,
  qplugins_base,
  uPubliclibsBase,
  qstring,
  QPlugins;

type
  TExtControl = class(TControl);

  TDrapOnRunTime = class(TQService, IDragOnRunTime)
  private
    InReposition: Boolean;
    FOldPos: TPoint;
    FOwner: TControl;
    FSelectControl: TControl;
    FOldMouseUp, FOldMouseDown: TMouseEvent;
    FOldMouseMove:TMouseMoveEvent;
    FCapturedEvents: Boolean;
    function GetSelectControl: TControl;
    procedure SetSelectControl(const Value: TControl);
    procedure CaptureEvents;
    procedure FreeEvents;
    procedure ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    constructor Create(const AId: TGuid; AName: QStringW); overload; override;
    destructor Destroy; override;
    property Owner: TControl read FOwner write FOwner;
    property SelectControl: TControl read GetSelectControl write SetSelectControl;
  end;

implementation

{ TDrapOnRunTime }

procedure TDrapOnRunTime.CaptureEvents;
begin
  FCapturedEvents := True;
  FOldMouseDown := TExtControl(Self.FSelectControl).OnMouseDown;
  FOldMouseMove := TExtControl(Self.FSelectControl).OnMouseMove;
  FOldMouseUp := TExtControl(Self.FSelectControl).OnMouseUp;

  TExtControl(Self.FSelectControl).OnMouseDown := ControlMouseDown;
  TExtControl(Self.FSelectControl).OnMouseMove := ControlMouseMove;
  TExtControl(Self.FSelectControl).OnMouseUp := ControlMouseUp;
end;

procedure TDrapOnRunTime.ControlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TWinControl) then
  begin
    inReposition := True;
    SetCapture(TWinControl(Sender).Handle);
    GetCursorPos(FOldPos);
  end;
end;

procedure TDrapOnRunTime.ControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
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
        Left := Left - FOldPos.X + newPos.X;
        Top := Top - FOldPos.Y + newPos.Y;
        FOldPos := newPos;
      end;
    end;
  end;
end;

procedure TDrapOnRunTime.ControlMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if InReposition then
  begin
    Screen.Cursor := crDefault;
    ReleaseCapture;
    InReposition := False;
  end;
end;

constructor TDrapOnRunTime.Create(const AId: TGuid; AName: QStringW);
begin
  inherited;
  FCapturedEvents := False;
  InReposition := False;
end;

destructor TDrapOnRunTime.Destroy;
begin
  if Assigned(FSelectControl) and FCapturedEvents then
    FreeEvents;
  inherited;
end;

procedure TDrapOnRunTime.FreeEvents;
begin
  TExtControl(Self.FSelectControl).OnMouseDown := FOldMouseDown;
  TExtControl(Self.FSelectControl).OnMouseMove := FOldMouseMove;
  TExtControl(Self.FSelectControl).OnMouseUp := FOldMouseUp;
end;

function TDrapOnRunTime.GetSelectControl: TControl;
begin
  Result := FSelectControl;
end;

procedure TDrapOnRunTime.SetSelectControl(const Value: TControl);
begin
  if (Value is TForm) or (Value is TFrame) or (Value = FOwner) then
  begin
    Self.SelectControl := nil;
    Exit;
  end;

  if Assigned(FSelectControl) then
    if FSelectControl <> Value then
      FreeEvents
    else
      Exit;

  if not Assigned(Value) then
  begin
    Self.FSelectControl.Cursor := crDefault;
    if FCapturedEvents then
      FreeEvents();
  end;

  FSelectControl := Value;
  CaptureEvents;
end;

initialization
  RegisterServices('Services/Controls',
  [TDrapOnRunTime.Create(IDragOnRunTime, 'DragOnRunTime')]);

finalization
  // 取消服务注册
  UnregisterServices('Services/Controls', ['DragOnRunTime']);

end.

