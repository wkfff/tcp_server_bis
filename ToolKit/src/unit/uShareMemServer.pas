unit uShareMemServer;

interface

uses
  SysUtils,
  System.Classes,
  Winapi.Windows,
  ShShareMemMap,
  QWorker,
  qstring;

type
  TShareMemServer = class
  private
    FActive: Boolean;
    FOnGetData: TQJobProc;
    FMap: TShareMapQueue;
    procedure SetActive(const Value: Boolean);
    procedure DoGetDebugData(AJob: PQJob);
    procedure DoShowDebugData(AJob: PQJob);
  public
    constructor Create(AName: string; AMemorySize: Integer = CN_QUEUE_SIZE);
    destructor Destroy; override;
    property OnGetData: TQJobProc read FOnGetData write FOnGetData;
    property Active: Boolean read FActive write SetActive;
  end;

implementation

constructor TShareMemServer.Create(AName: string; AMemorySize: Integer);
begin
  FMap := TShareMapQueue.Create(AName, True, AMemorySize);
  FActive := False;
end;

destructor TShareMemServer.Destroy;
begin
  FMap.Free;
  inherited;
end;

procedure TShareMemServer.DoGetDebugData(AJob: PQJob);
var
  pData: Pointer;
  dwSize: Int64;
  i: Integer;
  strTemp: string;
  p: PWideChar;
  g: TQJobGroup;
  Send: PWideChar;
const
  AscII_8: PWideChar = #8;
begin
  //读取队列中数据，一次全部读完
  dwSize := FMap.Pop(pData);
  if (dwSize > 0) then
  begin
    try
      g := TQJobGroup.Create(False);
      SetString(strTemp, PAnsiChar(pData) , dwSize);
      p := PQCharW(strTemp);
      while p^ <> #0 do
      begin
        Send := PWideChar(DecodeTokenW(p, AscII_8, WideChar(0), True));
        g.Add(DoShowDebugData, Send, True);
        g.MsgWaitFor(Q1Minute * 2);
      end;
    except
    end;
    FreeObject(g);
    FreeMem(pData, dwSize);
  end;

  if FActive then
    Workers.Delay(DoGetDebugData, Q1Second, nil);
end;

procedure TShareMemServer.DoShowDebugData(AJob: PQJob);
begin
  if not Assigned(FOnGetData) then
    Exit;
  FOnGetData(AJob);
end;

procedure TShareMemServer.SetActive(const Value: Boolean);
begin
  FActive := Value;

  if FActive then
    Workers.Delay(DoGetDebugData, Q1Second, nil);
end;

end.
