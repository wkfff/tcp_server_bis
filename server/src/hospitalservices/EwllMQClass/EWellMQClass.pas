unit EWellMQClass;

interface

uses
  Classes,
  MQClass,
  IniFiles,
  ManagerEntity,
  SysUtils,
  StrUtils,
  Forms,
  Windows,
  Dialogs,
  MQIC;

type
  TMessageFlag = (mfGet, mfBrowse);

  TEWellMQ = class
  private
    FLogOpen: Boolean;
    FQmList: TStrings;
    FActiveMQ: TMQClass;
    FQManager: TQueueManager;
    procedure writeLog(module, text: string);
    procedure writeMQCode(module: AnsiString; CompCode, Reason: Integer);
    function getQueueName(mgr, fid: AnsiString): AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect: Integer; overload;
    function Connect(ServerName: AnsiString): Integer; overload;
    function DisConnect: Integer;
    function Put(fid, msg: AnsiString; var msgID: AnsiString; var ErrMsg: AnsiString): Integer;
    function PutMsgWithID(fid, msg, msgid: AnsiString; var ErrMsg: AnsiString): Integer;
    function Get(fid: AnsiString; WaitInterval: Integer; flag: TMessageFlag; var
      ErrMsg: AnsiString; var msgID: PAnsiChar): AnsiString;
  end;

implementation

uses
  CnDebug;

{ EWellMQ }

{
  ** 描述：连接IBM MQ
  ** 返回：0失败，1成功
}
function TEWellMQ.Connect: Integer;
var
  MQ: TQueueManager;
  CompCode, Reason: Longint;
begin
  Result := 0;
  if FQmList.Count > 0 then
  begin
    MQ := TQueueManager(FQmList.Objects[0]);
    FQManager := MQ;
    FActiveMQ := MQ.QmMQ;
    FActiveMQ.QueneMgn := MQ.QmName;
    FActiveMQ.Channel := MQ.QmCC;
    FActiveMQ.ServerIP := MQ.QmIP;
    FActiveMQ.ServerPort := AnsiString(IntToStr(MQ.QmPort));
    FActiveMQ.MQConnect(CompCode, Reason);
    if CompCode = 2 then
    begin
      writeMQCode('Connect', CompCode, Reason);
      exit;
    end;
    Result := 1;
  end;
end;

function TEWellMQ.Connect(serverName: AnsiString): Integer;
var
  MQ: TQueueManager;
  CompCode, Reason: Longint;
  i: integer;
begin
  Result := 0;
  if FQmList.Count > 0 then
  begin
    i := FQmList.IndexOf(string(serverName));
    if i < 0 then
      Exit;
    MQ := TQueueManager(FQmList.Objects[i]);
    FQManager := MQ;
    FActiveMQ := MQ.QmMQ;
    FActiveMQ.QueneMgn := MQ.QmName;
    FActiveMQ.Channel := MQ.QmCC;
    FActiveMQ.ServerIP := MQ.QmIP;
    FActiveMQ.ServerPort := AnsiString(IntToStr(MQ.QmPort));
    FActiveMQ.MQConnect(CompCode, Reason);
    if CompCode = 2 then
    begin
      writeMQCode('Connect', CompCode, Reason);
      exit;
    end;
    Result := 1;
  end;
end;

constructor TEWellMQ.Create;
var
  vIniFile: TiniFile;
  vAppPath, vFileName: string;
  QmEntity: TQueueManager;
  i: Integer;
  vQms: TStringList;
begin
  GetDir(0, vAppPath);
  vFileName := vAppPath + '\ESBMQClientProperty.ini';

  vIniFile := nil;
  vQms := nil;

  try
    vIniFile := TiniFile.Create(vFileName);
    //加载所有队列管理器
    vQms := TStringList.Create;
    FQmList := TStringList.Create;
    TStringList(FQmList).OwnsObjects := True;
    vIniFile.ReadSection('IP', vQms);
    for i := 0 to vQms.Count - 1 do
    begin
      QmEntity := TQueueManager.Create;
      QmEntity.QmTag := AnsiString(vQms[i]);
      QmEntity.QmIP := AnsiString(vIniFile.ReadString('IP', vQms[i], ''));
      QmEntity.QmName := AnsiString(vIniFile.ReadString(vQms[i], 'MGR', ''));
      QmEntity.QmPort := vIniFile.ReadInteger(vQms[i], 'PORT', 0);
      QmEntity.QmCC := AnsiString(vIniFile.ReadString(vQms[i], 'CC', ''));
      QmEntity.QmCSID := vIniFile.ReadInteger(vQms[i], 'CCSID', 1381);
      FLogOpen := vIniFile.ReadInteger('COMM', 'log', 0) = 1;
      QmEntity.QmMQ := TMQClass.Create;
      FQmList.AddObject(vQms[i], QmEntity);
    end;
  finally
    FreeAndNil(vIniFile);
    FreeAndNil(vQms);
  end;
end;

{
  ** 描述：断开IBM MQ
  ** 返回：0失败，1成功
}
destructor TEWellMQ.Destroy;
begin
  TStringList(FQmList).Free;
  inherited;
end;

function TEWellMQ.DisConnect: Integer;
var
  CompCode, Reason: Longint;
begin
  Result := 0;
  FActiveMQ.MQDisConn(CompCode, Reason);
  if CompCode = 2 then
  begin
    writeMQCode('DisConnect', CompCode, Reason);
    exit;
  end;
  Result := 1;
end;

function TEWellMQ.Get(fid: AnsiString; WaitInterval: Integer; flag: TMessageFlag;
  var ErrMsg: AnsiString; var msgID: PAnsiChar): AnsiString;
const
  MAXSIZE = 99999999; //与MQ的最大消息长度保持一致
  MINSIZE = 1024 * 1024 * 4;
var
  buf: PAnsiChar;
  buflen: MQLONG;
  datalen: MQLONG;
  CompCode, Reason: Longint;
  qName: AnsiString;
  iBrowse: integer;
begin
  Result := '';
  writeLog('get-begin', 'msgid:' + msgID);
  qName := getQueueName(FQManager.QmTag, fid);
  if not Assigned(FActiveMQ) then
    Connect;
  iBrowse := 0;
  if flag = mfGet then
    FActiveMQ.MQOpenQueueForOut(qName, CompCode, Reason)
  else if flag = mfBrowse then
  begin
    iBrowse := 1;
    FActiveMQ.MQOpenQueueForBrowse(qName, CompCode, Reason);
  end;
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Get方法Open队列', CompCode, Reason);
    exit;
  end;

  if trim(string(msgID)) = '' then
  begin
    buflen := MINSIZE;
  end
  else
  begin
    buflen := MAXSIZE;
  end;
  buf := GetMemory(buflen);
  datalen := 0;
  FActiveMQ.MQGetMsg(iBrowse, qName, WaitInterval, FQManager.QmCSID, msgID, buf,
    buflen, datalen, CompCode, Reason);
  Result := Copy(buf, 1, datalen);
  FreeMemory(buf);

  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Get方法GetMsg消息', CompCode, Reason);
    exit;
  end;
  FActiveMQ.MQCloseQueue(CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Get方法Close队列', CompCode, Reason);
    exit;
  end;
  writeLog('get-success', 'msgid:' + msgID);
end;

function TEWellMQ.getQueueName(mgr, fid: AnsiString): AnsiString;
var
  vIniFile: TiniFile;
  vAppPath, vFileName: string;
begin
  GetDir(0, vAppPath);
  vFileName := vAppPath + '\ESBMQClientProperty.ini';
  vIniFile := TiniFile.Create(vFileName);
  Result := AnsiString(vIniFile.ReadString(string(mgr), string(fid), ''));
  FreeAndNil(vIniFile);
end;

function TEWellMQ.Put(fid, msg: AnsiString; var msgID: AnsiString;
  var ErrMsg: AnsiString): Integer;
var
  CompCode, Reason: Longint;
  qName: AnsiString;
begin
  Result := 0;
  qName := getQueueName(FQManager.QmTag, fid);
  if not Assigned(FActiveMQ) then
    Connect;
  FActiveMQ.MQOpenQueueForIn(qName, CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Put-OpenQueue', CompCode, Reason);
    writeMQCode('Put-OpenQueue-qName:' + qName + '-QmTag:'+ FQManager.QmTag + '-Fid:' + fid, CompCode, Reason);
    exit;
  end;
  FActiveMQ.MQPutMsg(msgID, qName, msg, FQManager.QmCSID, CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Put-PutMsg', CompCode, Reason);
    exit;
  end;
  FActiveMQ.MQCloseQueue(CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('Put-CloseQueue', CompCode, Reason);
    exit;
  end;
  writeMQCode('Put-success', CompCode, Reason);
  writeLog('Put-success', 'msgid:' + string(msgID));
  Result := 1;
end;

function TEWellMQ.PutMsgWithID(fid, msg, msgid: AnsiString;
  var ErrMsg: AnsiString): Integer;
var
  CompCode, Reason: Longint;
  qName: AnsiString;
begin
  Result := 0;
  qName := getQueueName(FQManager.QmTag, fid);

  if not Assigned(FActiveMQ) then
    Connect;
  FActiveMQ.MQOpenQueueForIn(qName, CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('PutMsgWithID-OpenQueue', CompCode, Reason);
    exit;
  end;
  FActiveMQ.MQPutMsgWithID(msgid, qName, msg, FQManager.QmCSID, CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('PutMsgWithID-PutMsg', CompCode, Reason);
    exit;
  end;
  FActiveMQ.MQCloseQueue(CompCode, Reason);
  if CompCode = 2 then
  begin
    ErrMsg := AnsiString(Format('CompCode:%d;Reason:%d', [CompCode, Reason]));
    writeMQCode('PutMsgWithID-CloseQueue', CompCode, Reason);
    exit;
  end;
  writeMQCode('PutMsgWithID-success', CompCode, Reason);
  writeLog('PutMsgWithID-success', 'msgid:' + string(msgid));
  Result := 1;
end;

procedure TEWellMQ.writeLog(module: string; text: string);
var
  f: TextFile;
  dirPath, fileName: string;
begin
  if not FLogOpen then
    Exit;
  fileName := ExtractFilePath(Application.ExeName) + 'Log\Log' + FormatDateTime('YYYYMMDD',
    Now) + '.txt';
  dirPath := ExtractFilePath(Application.ExeName) + 'Log';
  if not DirectoryExists(dirPath) then
    CreateDirectory(PChar(dirPath), nil);
  AssignFile(f, fileName);
  if FileExists(fileName) then
    Append(f)
  else
    Rewrite(f);
  WriteLn(f, '========================================');
  WriteLn(f, '程序名称:' + Application.ExeName);
  WriteLn(f, '功能模块:' + module);
  WriteLn(f, '发生时间:' + FormatDateTime('YYYY-MM-DD HH:MM:SS', Now));
  WriteLn(f, '记录内容:' + text);
  WriteLn(f, '========================================');
  CloseFile(f);
end;

procedure TEWellMQ.writeMQCode(module: AnsiString; CompCode, Reason: Integer);
begin
  writeLog(string(module), Format('完成码:%d,原因码:%d', [CompCode, Reason]));
end;

end.

