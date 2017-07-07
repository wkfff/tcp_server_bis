unit ShThread;

interface

uses
  windows, classes;

type
  // ִ���߳��¼�
  TOnExecuteEvent = procedure(Sender: TObject; AParam: Pointer;
                              var ARetValue: Integer) of object;

  // ִ���߳��¼�
  TOnExecuteEventEx = procedure(Sender: TObject; AParam: Pointer;
                              var ARetValue: Integer);

  // ͬ���¼�
  TOnSynchEvent = procedure(Sender: TObject; AParam: Pointer) of object;
  // ͬ���¼�
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
    // ȡ�Ƿ�����ֹ
    boolTerminated := Terminated;

    // ��ֹ
    Terminate;

    SetEvent(FEvent);

    {$WARNINGS OFF}
    // ��������
    if not boolTerminated and Suspended then
      Resume;

    {$WARNINGS ON}
  end;
end;

constructor TShThread.Create(AEventName: String);
begin
  // ��ʼ��
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
  // ����¼�
  FOnExecute := nil;
  FOnSynchronize := nil;

  Close;
  CloseHandle(FEvent);
  
  inherited;
end;

procedure TShThread.DoSynchronize;
begin
  try
    // ͬ������
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
  // �߳̿�ʼ
  FIsRunning := True;
  intRetValue := 0;

  // ���� OnExecute �¼�
  try
    if Assigned(FOnExecute) then
      FOnExecute(Self, FExecParam, intRetValue)
    else if Assigned(FOnExecuteEx) then
      FOnExecuteEx(Self, FExecParam, intRetValue);
  except
  end;

  // �߳̽���
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
      // �ر�
      objThread.Close;

      // �ȴ��߳̽��������̳߳�ʱ��ǿ���ͷ�
      hThread := objThread.Handle;
      if WaitForSingleObject(hThread, ATimeout) <> WAIT_TIMEOUT then
        objThread.Free
      else
        try
          //�رճ�ʱǿ�ƹر�
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
    // �����߳�
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
  // ��֤�ǵ�ǰ�߳�
  if FIsRunning and (GetCurrentThreadID = ThreadID) then
  begin
    try
      FSynchParam := AParam;

      // ���и���� Synchronize ����
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
