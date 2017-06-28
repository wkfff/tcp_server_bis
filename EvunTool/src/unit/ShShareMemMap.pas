unit ShShareMemMap;

interface

uses
  classes, windows;

const
  CN_QUEUE_SIZE = 100 * 1024 * 1024;

type
  TShareMemMap = class
  private
    FName: String;
    FHandle: THandle;
    FAddress: Pointer;

    function  DoCreateOpenMap(AName: WideString; ASize: Integer; AIsWide: Boolean): THandle;
    function  DoOpenMap(AName: WideString; ASize: Integer; AIsWide: Boolean): THandle;
    function  GetOpened: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function  CreateOpenMap(AName: String; ASize: Integer): THandle;
    function  CreateOpenMapW(AName: WideString; ASize: Integer): THandle;
    function  OpenMap(AName: String; ASize: Integer): THandle;
    function  OpenMapW(AName: WideString; ASize: Integer): THandle;
    procedure CloseMap;

    function  Read(AData: Pointer; ASize: DWORD; AOffset: Integer = 0): Boolean;
    function  Write(AData: Pointer; ASize: DWORD; AOffset: Integer = 0): Boolean;

    function  GetSecurityAttributes: PSecurityAttributes;
    procedure FreeSecurityAttributes(var ASA: PSecurityAttributes);
    function  GetErrorLast: DWORD;

    property Name: String read FName;
    property Handle: THandle read FHandle;
    property Opened: Boolean read GetOpened;
  end;

  TShareMapQueue = class
  private
    FMap: TShareMemMap;
    FMapSize: Integer;
    FDataSize: TShareMemMap;  //存放实际使用的共享内存数据大小
    FMutex: THandle;
    FIsOpenMap: Boolean;
    FQueueName: String;

    procedure DoOpenMap;
    function  GetOpened: Boolean;
  public
    constructor Create(AQueueName: String; AIsCreate: Boolean;
                       ASize: Integer = CN_QUEUE_SIZE);
    destructor Destroy; override;

    function  Pop(var AData: Pointer): DWORD;  //内存由对象内部分配，调用者用完后释放
    procedure Push(const AData: Pointer; ASize: DWORD);

    property Opened: Boolean read GetOpened;
  end;

implementation

{ TShareMemMap }

procedure TShareMemMap.CloseMap;
begin
  if FHandle > 0 then
  begin
    // 删除共享内存
    UnmapViewOfFile(FAddress);
    CloseHandle(FHandle);
    FHandle := 0;
  end;
end;

constructor TShareMemMap.Create;
begin
  FName    := '';
  FHandle  := 0;
  FAddress := nil;
end;

function TShareMemMap.CreateOpenMap(AName: String; ASize: Integer): THandle;
begin
  Result := DoCreateOpenMap(AName, ASize, False);
end;

function TShareMemMap.CreateOpenMapW(AName: WideString; ASize: Integer): THandle;
begin
  Result := DoCreateOpenMap(AName, ASize, True);
end;

destructor TShareMemMap.Destroy;
begin
  CloseMap;

  inherited Destroy;
end;

function TShareMemMap.DoCreateOpenMap(AName: WideString; ASize: Integer;
  AIsWide: Boolean): THandle;
var
  pSA: PSecurityAttributes;
begin
  if FHandle > 0 then
  begin
    Result := FHandle;
    exit;
  end;

  // 新建共享内存
  FName    := AName;
  pSA      := GetSecurityAttributes;
  FHandle  := 0;
  FAddress := nil;

  //创建MAP
  try
    if AIsWide then
      FHandle := CreateFileMappingW($FFFFFFFF, pSA, PAGE_READWRITE, 0,
                                    ASize, PWideChar(AName))
    else
      FHandle := CreateFileMapping($FFFFFFFF, pSA, PAGE_READWRITE, 0,
                                   ASize, PChar(String(AName)));

    if (FHandle > 0) then// and (GetLastError <> ERROR_ALREADY_EXISTS) then
      try
        FAddress := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, ASize);
      except
      end;
  except
  end;

  if (FHandle > 0) and (FAddress = nil) then
  begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;

  FreeSecurityAttributes(pSA);
  Result := FHandle;
end;

function TShareMemMap.DoOpenMap(AName: WideString; ASize: Integer;
  AIsWide: Boolean): THandle;
begin
  if FHandle > 0 then
  begin
    Result := FHandle;
    exit;
  end;

  FName    := AName;
  FAddress := nil;
  FHandle  := 0;

  try
    if AIsWide then
      FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, True, PWideChar(AName))
    else
      FHandle := OpenFileMapping(FILE_MAP_ALL_ACCESS, True, PChar(AName));

    if FHandle > 0 then
      try
        FAddress := MapViewOfFile(FHandle, FILE_MAP_ALL_ACCESS, 0, 0, ASize);
      except
      end;
  except
  end;

  if (FHandle > 0) and not Assigned(FAddress) then
  begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;

  Result := FHandle;
end;

procedure TShareMemMap.FreeSecurityAttributes(var ASA: PSecurityAttributes);
var
  p: PSecurityAttributes;
begin
  p   := ASA;
  ASA := nil;

  if Assigned(p) then
    try
      FreeMem(p^.lpSecurityDescriptor);
      Dispose(p);
    except
    end;
end;

function TShareMemMap.GetErrorLast: DWORD;
begin
  Result := GetLastError;
end;

function TShareMemMap.GetOpened: Boolean;
begin
  Result := (FHandle > 0);
end;

function TShareMemMap.GetSecurityAttributes: PSecurityAttributes;
var
  pSA: PSecurityAttributes;
  pSD: PSECURITY_DESCRIPTOR;
begin
  Result := nil;

  try
    GetMem(pSD, SECURITY_DESCRIPTOR_MIN_LENGTH);
    new(pSA);

    if not InitializeSecurityDescriptor(pSD, SECURITY_DESCRIPTOR_REVISION) then
    begin
      FreeMem(pSD, SECURITY_DESCRIPTOR_MIN_LENGTH);
      exit;
    end;

    if not SetSecurityDescriptorDacl(pSD, True, nil, False) then
    begin
      FreeMem(pSD, SECURITY_DESCRIPTOR_MIN_LENGTH);
      exit;
    end;

	  pSA.nLength := SizeOf(TSecurityAttributes);
	  pSA.lpSecurityDescriptor := pSD;
	  pSA.bInheritHandle := True;

    Result := pSA;
  except
  end;
end;

function TShareMemMap.OpenMap(AName: String; ASize: Integer): THandle;
begin
  Result := DoOpenMap(AName, ASize, False);
end;

function TShareMemMap.OpenMapW(AName: WideString; ASize: Integer): THandle;
begin
  Result := DoOpenMap(AName, ASize, True);
end;

function TShareMemMap.Read(AData: Pointer; ASize: DWORD;
  AOffset: Integer): Boolean;
begin
  Result := False;

  if FHandle > 0 then
  begin
    Move(Pointer(Integer(FAddress) + AOffset)^, AData^, ASize);
    Result := True;
  end;
end;

function TShareMemMap.Write(AData: Pointer; ASize: DWORD;
  AOffset: Integer): Boolean;
begin
  Result := False;

  if FHandle > 0 then
  begin
    Move(AData^, Pointer(Integer(FAddress) + AOffset)^, ASize);
    Result := True;
  end;
end;

{ TShareMapQueue }

constructor TShareMapQueue.Create(AQueueName: String; AIsCreate: Boolean;
  ASize: Integer);
begin
  FMap       := TShareMemMap.Create;
  FDataSize  := TShareMemMap.Create;
  FMapSize   := ASize;   // 初始化 100M
  FIsOpenMap := not AIsCreate;
  FQueueName := AQueueName;

  if AIsCreate then
  begin
    FMutex := CreateMutex(nil, False, PWideChar(AQueueName + '_MUTEX'));

    if FDataSize.CreateOpenMap(AQueueName + '_SIZE_SH', 8) > 0 then
    begin
      FDataSize.Write(@FMapSize, 4);
      FMap.CreateOpenMap(AQueueName, FMapSize);
    end;
  end
  else
    DoOpenMap;
end;

destructor TShareMapQueue.Destroy;
begin
  FDataSize.Free;
  FMap.Free;

  ReleaseMutex(FMutex);
  CloseHandle(FMutex);

  inherited;
end;

procedure TShareMapQueue.DoOpenMap;
begin
  FMutex := OpenMutex(MUTEX_ALL_ACCESS, False, PWideChar(FQueueName + '_MUTEX'));

  if FDataSize.OpenMap(FQueueName + '_SIZE_SH', 8) > 0 then
  begin
    FDataSize.Read(@FMapSize, 4);
    FMap.OpenMap(FQueueName, FMapSize);
  end;
end;

function TShareMapQueue.GetOpened: Boolean;
begin
  Result := FMap.Opened;
end;

function TShareMapQueue.Pop(var AData: Pointer): DWORD;
var
  dwTemp: DWORD;
begin
  Result := 0;

  if not FMap.Opened and FIsOpenMap then
    DoOpenMap;

  if FMap.Opened and (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  begin
    try
      FDataSize.Read(@Result, SizeOf(Result), 4);   //读取共享内存中的数据大小

      if Result > 0 then
      begin
        GetMem(AData, Result);     //分配存放内存
        FMap.Read(AData, Result);

        dwTemp := 0;
        FDataSize.Write(@dwTemp, SizeOf(dwTemp), 4);
      end;
    except
    end;

    ReleaseMutex(FMutex);
  end;
end;

procedure TShareMapQueue.Push(const AData: Pointer; ASize: DWORD);
var
  dwTemp: DWORD;
begin
  if not FMap.Opened and FIsOpenMap then
    DoOpenMap;

  if FMap.Opened and (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  begin
    try
      FDataSize.Read(@dwTemp, SizeOf(dwTemp), 4);   //读取共享内存中的数据大小
      FMap.Write(AData, ASize, dwTemp);

      dwTemp := dwTemp + ASize;
      FDataSize.Write(@dwTemp, SizeOf(dwTemp), 4);
    except
    end;

    ReleaseMutex(FMutex);
  end;
end;

end.

