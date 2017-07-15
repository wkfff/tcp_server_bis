unit uLogAppender;

interface

uses
  System.Classes,
  System.SysUtils,
  utils_safeLogger,
  Winapi.Windows;

type
  TMyStringsAppender = class(TBaseAppender)
  private
    FAddThreadINfo: Boolean;
    FAddTimeInfo: Boolean;
    FAppendLineBreak: Boolean;
    FMaxLines: Integer;
    FStrings: TStrings;
  protected
    procedure AppendLog(pvData:TLogDataObject); override;
  public
    constructor Create(AStrings: TStrings);
    property AddThreadINfo: Boolean read FAddThreadINfo write FAddThreadINfo;
    property AddTimeInfo: Boolean read FAddTimeInfo write FAddTimeInfo;
    property AppendLineBreak: Boolean read FAppendLineBreak write FAppendLineBreak;

    property MaxLines: Integer read FMaxLines write FMaxLines;
  end;

  TMyLogFileAppender = class(TBaseAppender)
  private
    FProcessIDStr: String;
    FAddProcessID: Boolean;
    FFilePreFix:String;
    FAddThreadINfo: Boolean;
    FAddThreadIDToFileID:Boolean;
    FBasePath: string;
    FLogFile: TextFile;
    FInitialized: Boolean;
    procedure checkInitialized;
    function openLogFile(pvPre: String = ''): Boolean;
  protected
    procedure AppendLog(pvData:TLogDataObject); override;
  public
    constructor Create(pvAddThreadINfo: Boolean);
    property AddProcessID: Boolean read FAddProcessID write FAddProcessID;
    property AddThreadIDToFileID: Boolean read FAddThreadIDToFileID write
        FAddThreadIDToFileID;
    property AddThreadINfo: Boolean read FAddThreadINfo write FAddThreadINfo;
    property FilePreFix: String read FFilePreFix write FFilePreFix;
  end;

implementation

constructor TMyStringsAppender.Create(AStrings: TStrings);
begin
  inherited Create;
  FStrings := AStrings;
  FAddTimeInfo := true;
  FAddThreadINfo := false;
  FAppendLineBreak := true;
  FMaxLines := 500;
end;

procedure TMyStringsAppender.AppendLog(pvData:TLogDataObject);
var
  lvMsg :String;
begin
  {$IFDEF RELEASE}
   Exit;
  {$ENDIF}
  inherited;
  Assert(FStrings <> nil);
  lvMsg := '';
  if FAddTimeInfo then
  begin
    lvMsg := Format('%s[%s]',
        [FormatDateTime('hh:nn:ss:zzz', pvData.FTime)
          , TLogLevelCaption[pvData.FLogLevel]
        ]);
  end;

  if FAddThreadINfo then
  begin
    lvMsg := lvMsg + Format('[PID:%d,ThreadID:%d]',
        [GetCurrentProcessID(), pvData.FThreadID]);
  end;


  if lvMsg <> '' then lvMsg := lvMsg + ':' + pvData.FMsg else lvMsg := pvData.FMsg;


  if FStrings.Count > FMaxLines then FStrings.Clear;

  if Self.AppendLineBreak then
  begin
    FStrings.Add(lvMsg);
  end else
  begin
    FStrings.Add(lvMsg);
  end;
end;

procedure TMyLogFileAppender.AppendLog(pvData: TLogDataObject);
var
  lvMsg:String;
  lvPreFix :String;
begin
  {$IFDEF RELEASE}
   Exit;
  {$ENDIF}
  checkInitialized;
  if FAddThreadIDToFileID then
  begin
    lvPreFix := FFilePreFix + pvData.FMsgType+ '_' + IntToStr(pvData.FThreadID) + '_';
  end else
  begin
    lvPreFix := FFilePreFix + pvData.FMsgType;
  end;

  if FAddProcessID then
    lvPreFix := FProcessIDStr + '_' + lvPreFix;

  if OpenLogFile(lvPreFix) then
  begin
    try
      if FAddThreadINfo then
      begin
        if not FAddProcessID then
        begin     // 文件名已经添加了ProcessID
          lvMsg := Format('%s[%s][ThreadID:%d]:%s',
              [FormatDateTime('hh:nn:ss:zzz', pvData.FTime)
                , TLogLevelCaption[pvData.FLogLevel]
                , pvData.FThreadID
                , pvData.FMsg
              ]
              );
        end else
        begin
          lvMsg := Format('%s[%s][PID:%s,ThreadID:%d]:%s',
              [FormatDateTime('hh:nn:ss:zzz', pvData.FTime)
                , TLogLevelCaption[pvData.FLogLevel]
                , FProcessIDStr
                , pvData.FThreadID
                , pvData.FMsg
              ]
              );
        end;
      end else
      begin
        lvMsg := Format('%s[%s]:%s',
            [FormatDateTime('hh:nn:ss:zzz', pvData.FTime)
              , TLogLevelCaption[pvData.FLogLevel]
              , pvData.FMsg
            ]
            );
      end;
      writeln(FLogFile, lvMsg);
      flush(FLogFile);
    finally
      CloseFile(FLogFile);
    end;
  end else
  begin
    FOwner.incErrorCounter;
  end;
end;

procedure TMyLogFileAppender.checkInitialized;
begin
  if FInitialized then exit;
  if not DirectoryExists(FBasePath) then ForceDirectories(FBasePath);
  FInitialized := true;
end;

constructor TMyLogFileAppender.Create(pvAddThreadINfo: Boolean);
begin
  inherited Create;

  FAddThreadINfo := pvAddThreadINfo;
  FAddProcessID := true;
  {$IFDEF MSWINDOWS}
  FProcessIDStr := IntToStr(GetCurrentProcessId);
  FBasePath :=ExtractFilePath(ParamStr(0)) + 'TCPlog';
  {$ELSE}
  FProcessIDStr := '0';
  FBasePath := TPath.GetSharedDocumentsPath + TPath.DirectorySeparatorChar;
  {$ENDIF}
end;

function TMyLogFileAppender.openLogFile(pvPre: String = ''): Boolean;
var
  lvFileName:String;
begin
  lvFileName :=FBasePath + '\' + pvPre + FormatDateTime('yyyymmddhh', Now()) + '.log';
  try
    AssignFile(FLogFile, lvFileName);
    if (FileExists(lvFileName)) then
      append(FLogFile)
    else
      rewrite(FLogFile);

    Result := true;
  except
    Result := false;
  end;
end;

end.
