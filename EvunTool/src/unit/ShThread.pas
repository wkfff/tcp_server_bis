unit ShThread;

interface

uses
  windows, classes;

type
  // 执行线程事件
  TOnExecuteEvent = procedure(Sender: TObject; AParam: Pointer;
                              var ARetValue: Integer) of object;

  // 执行线程事件
  TOnExecuteEventEx = procedure(Sender: TObject; AParam: Pointer;
                              var ARetValue: Integer);

  // 同步事件
  TOnSynchEvent = procedure(Sender: TObject; AParam: Pointer) of object;
  // 同步事件
  TOnSynchEventEx = procedure(Sender: TObject; AParam: Pointer);

  TShThread = Class(TThread)
  private
    { Private declarations }
    FEvent: THandle;
    FIsRunning: Boolean;
    FIsOver: Boolean;
    FExecParam: Pointer;
    FSynchParam: Pointer;
    FOnExecute: TOnExecuteEvent;
    FOnSynchronize: TOnSynchEvent;
    FOnExecuteEx: TOnExecuteEventEx;
    FOnSynchronizeEx: TOnSynchEventEx;

    procedure DoSynchronize;
  protected
    { Protected declarations }
    procedure Execute; override;
  public
    { Public declarations }
    constructor Create(AEventName: String = '');
    destructor Destroy; override;

    procedure Open(AParam: Pointer);
    procedure Close;

    procedure SynchRun(AParam: Pointer);
    procedure SetReady;
    function  WaitFor(ATimeout: DWORD = INFINITE): DWORD;

    property IsRunning: Boolean read FIsRunning;
    property IsOver: Boolean read FIsOver;
    property Terminated;
    property Event: THandle read FEvent;
    property OnExecute: TOnExecuteEvent read FOnExecute write FOnExecute;
    property OnExecuteEx: TOnExecuteEventEx read FOnExecuteEx write FOnExecuteEx;
    property OnSynchronize: TOnSynchEvent read FOnSynchronize write FOnSynchronize;
    property OnSynchronizeEx: TOnSynchEventEx read FOnSynchronizeEx write FOnSynchronizeEx;

    class procedure FreeThread(var AThread: TShThread; ATimeout: Longword = 60000);
  End;

implementation

{ TShThread }


procedure TShThread.Close;
var
  boolTerminated: Boolean;
begin
  if FIsRunning then
  begin
    // 取是否已终止
    boolTerminated := Terminated;

    // 终止
    Terminate;

    SetEvent(FEvent);

    {$WARNINGS OFF}
    // 唤醒休眠
    if not boolTerminated and Suspended then
      Resume;

    {$WARNINGS ON}
  end;
end;

constructor TShThread.Create(AEventName: String);
begin
  // 初始化
  FIsRunning := False;
  FIsOver := False;
  FExecParam := nil;
  FSynchParam := nil;
  FOnExecute := nil;
  FOnSynchronize := nil;

  FEvent := CreateEvent(nil, false, false, PChar(AEventName));

  inherited Create(True);
end;

destructor TShThread.Destroy;
begin
  // 清除事件
  FOnExecute := nil;
  FOnSynchronize := nil;

  Close;
  CloseHandle(FEvent);
  
  inherited;
end;

procedure TShThread.DoSynchronize;
begin
  try
    // 同步函数
    if Assigned(FOnSynchronize) then
      FOnSynchronize(Self, FSynchParam)
    else if Assigned(FOnSynchronizeEx) then
      FOnSynchronizeEx(Self, FSynchParam);
  except
  end;
end;

procedure TShThread.Execute;
var
  intRetValue: Integer;
begin
  // 线程开始
  FIsRunning := True;
  intRetValue := 0;

  // 激发 OnExecute 事件
  try
    if Assigned(FOnExecute) then
      FOnExecute(Self, FExecParam, intRetValue)
    else if Assigned(FOnExecuteEx) then
      FOnExecuteEx(Self, FExecParam, intRetValue);
  except
  end;

  // 线程结束
  FIsOver := True;
  FIsRunning := False;
  ReturnValue := intRetValue;
end;

class procedure TShThread.FreeThread(var AThread: TShThread; ATimeout: Longword);
var
  hThread: THandle;
  objThread: TShThread;
begin
  objThread := AThread;
  AThread := nil;
  if Assigned(objThread) then
    try
      // 关闭
      objThread.Close;

      // 等待线程结束，若线程超时则强行释放
      hThread := objThread.Handle;
      if WaitForSingleObject(hThread, ATimeout) <> WAIT_TIMEOUT then
        objThread.Free
      else
        try
          //关闭超时强制关闭
          TerminateThread(objThread.Handle, 0);
          objThread.Free;
        except
        end;
    except
    end;
end;

procedure TShThread.Open(AParam: Pointer);
begin
  if not FIsRunning and not FIsOver then
  begin
    FExecParam := AParam;

    {$WARNINGS OFF}
    // 唤醒线程
    if not Terminated and Suspended then
      Resume;

    {$WARNINGS ON}
  end;
end;

procedure TShThread.SetReady;
begin
  SetEvent(FEvent);
end;

procedure TShThread.SynchRun(AParam: Pointer);
begin
  // 保证是当前线程
  if FIsRunning and (GetCurrentThreadID = ThreadID) then
  begin
    try
      FSynchParam := AParam;

      // 运行父类的 Synchronize 方法
      Synchronize(DoSynchronize);
    except
    end;
  end;
end;

function TShThread.WaitFor(ATimeout: DWORD): DWORD;
begin
  Result := WaitForSingleObject(FEvent, ATimeout);
end;

end.
