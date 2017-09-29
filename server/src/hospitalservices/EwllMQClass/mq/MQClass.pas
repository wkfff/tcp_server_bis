unit MQClass;
// MQClass by su fei
// 2013 by su fei. All rights reserved
//
// This file is not distributable without permission by su fei
//
// Mail: speedfly@vip.qq.com
//
// MPL 1.1 licenced

interface

uses
  SysUtils,
  System.AnsiStrings,
  Windows,
  MQIC,
  CnDebug;

type
  TMQClass = class
  private
    FHconn: MQHCONN;
    FO_options: MQLONG;
    FHobj: MQLONG;
    FQueneMgn: AnsiString;
    FChannel: AnsiString;
    FServerIP: AnsiString;
    FServerPort: AnsiString;
    F_MQCD: PMQCD;
    F_MQCNO: PMQCNO;
    F_MQOD: PMQOD;
    F_MQPMD: PMQMD;
    F_MQPMO: PMQPMO;
    F_MQGMD: PMQMD;
    F_MQGMO: PMQGMO;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure MQConnect(var CompCode, Reason: MQLONG);
    procedure MQDisConn(var CompCode, Reason: MQLONG);
    procedure MQOpenQueueForIn(QueueName: AnsiString; var CompCode, Reason: MQLONG);
    procedure MQOpenQueueForOut(QueueName: AnsiString; var CompCode, Reason: MQLONG);
    procedure MQOpenQueueForBrowse(QueueName: AnsiString; var CompCode, Reason: MQLONG);
    procedure MQCloseQueue(var CompCode, Reason: MQLONG);
    procedure MQPutMsg(var MsgId: AnsiString; QueueName, MQmessage: AnsiString; ccsid:
      integer; var CompCode, Reason: MQLONG);
    procedure MQGetMsg(flag: integer; QueueName: AnsiString; WaitInterval: Integer;
      ccsid: integer; var MsgId: PAnsiChar; var Buffer: PAnsiChar; BufferLen: Longint;
      var DataLength: Longint; var CompCode, Reason: MQLONG);
    procedure MQPutMsgWithID(MsgId, QueueName, MQmessage: AnsiString; ccsid: integer;
      var CompCode, Reason: MQLONG);
    property QueneMgn: AnsiString read FQueneMgn write FQueneMgn;
    property Channel: AnsiString read FChannel write FChannel;
    property ServerIP: AnsiString read FServerIP write FServerIP;
    property ServerPort: AnsiString read FServerPort write FServerPort;
  end;

implementation

// -----------------------------------------------------------------------------
constructor TMQClass.Create;
begin
  inherited;
  New(F_MQCD);
  New(F_MQCNO);
  New(F_MQOD);
  New(F_MQPMD);
  new(F_MQPMO);
  New(F_MQGMD);
  New(F_MQGMO);
end;

// -----------------------------------------------------------------------------
destructor TMQClass.Destroy;
begin
  inherited;
  Dispose(PMQCD(F_MQCD));
  Dispose(PMQCNO(F_MQCNO));
  Dispose(PMQOD(F_MQOD));
  Dispose(PMQMD(F_MQPMD));
  Dispose(PMQPMO(F_MQPMO));
  Dispose(PMQMD(F_MQGMD));
  Dispose(PMQGMO(F_MQGMO));
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQConnect(var CompCode, Reason: MQLONG);
var
  mgr: MQCHAR48;
begin
  SetMQCD_DEFAULT(F_MQCD^);
  F_MQCD.MaxMsgLength := 104857600;
  System.AnsiStrings.StrpCopy(F_MQCD.QMgrName, FQueneMgn);
  System.AnsiStrings.StrpCopy(F_MQCD.ConnectionName, FServerIP + '(' + FServerPort + ')');
  System.AnsiStrings.StrpCopy(F_MQCD.ChannelName, FChannel);

  SetMQCNO_DEFAULT(F_MQCNO^);
  F_MQCNO.ClientConnPtr := F_MQCD;
  F_MQCNO.Version := MQCNO_VERSION_4;

  System.AnsiStrings.StrpCopy(mgr, FQueneMgn);

  MQCONNX(@mgr, F_MQCNO, @FHconn, @CompCode, @Reason);
end;

procedure TMQClass.MQDisConn(var CompCode, Reason: MQLONG);
begin
  MQDISC(@FHconn, @CompCode, @Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQOpenQueueForIn(QueueName: AnsiString; var CompCode, Reason: MQLONG);
begin
  SetMQOD_DEFAULT(F_MQOD^);
  System.AnsiStrings.StrpCopy(F_MQOD.ObjectName, QueueName);
  FO_options := MQOO_OUTPUT + MQOO_FAIL_IF_QUIESCING;
  MQOPEN(FHconn, F_MQOD, FO_options, @FHobj, @CompCode, @Reason);
end;

procedure TMQClass.MQOpenQueueForOut(QueueName: AnsiString; var CompCode, Reason: MQLONG);
begin
  SetMQOD_DEFAULT(F_MQOD^);
  System.AnsiStrings.StrpCopy(F_MQOD.ObjectName, QueueName);
  FO_options := MQOO_INPUT_AS_Q_DEF + MQOO_FAIL_IF_QUIESCING;
  MQOPEN(FHconn, F_MQOD, FO_options, @FHobj, @CompCode, @Reason);
end;

procedure TMQClass.MQOpenQueueForBrowse(QueueName: AnsiString; var CompCode, Reason: MQLONG);
begin
  SetMQOD_DEFAULT(F_MQOD^);
  System.AnsiStrings.StrpCopy(F_MQOD.ObjectName, QueueName);
  FO_options := MQOO_FAIL_IF_QUIESCING + MQOO_BROWSE;
  MQOPEN(FHconn, F_MQOD, FO_options, @FHobj, @CompCode, @Reason);
end;

procedure TMQClass.MQCloseQueue(var CompCode, Reason: MQLONG);
begin
  MQCLOSE(FHconn, @FHobj, 0, @CompCode, @Reason);
end;

procedure TMQClass.MQPutMsg(var MsgId: AnsiString; QueueName, MQmessage: AnsiString;
  ccsid: integer; var CompCode, Reason: MQLONG);
var
  vBufferLen: MQLONG;
  Buffer: PAnsiChar;
  sMsgId: AnsiString;
  i: integer;
begin
  SetMQMD_DEFAULT(F_MQPMD^);
  SetMQPMO_DEFAULT(F_MQPMO^);
  F_MQPMD.CodedCharSetId := ccsid;
  Buffer := PAnsiChar(MQmessage);
  vBufferLen := length(MQmessage);
  MQPUT(FHConn, FHObj, F_MQPMD, F_MQPMO, vBufferLen, Buffer, @CompCode, @Reason);
  for i := 0 to Length(F_MQPMD.MsgId) - 1 do
    sMsgId := sMsgId + AnsiString(IntTohex(byte(F_MQPMD.MsgId[i]), 2));
  MsgId := sMsgId;
end;

procedure TMQClass.MQPutMsgWithID(MsgId: AnsiString; QueueName, MQmessage: AnsiString;
  ccsid: integer; var CompCode, Reason: MQLONG);
var
  vBufferLen: MQLONG;
  Buffer: PAnsiChar;
  s: AnsiString;
  i, index: integer;
begin
  SetMQMD_DEFAULT(F_MQPMD^);
  SetMQPMO_DEFAULT(F_MQPMO^);
  F_MQPMD.CodedCharSetId := ccsid;
  Buffer := PAnsiChar(MQmessage);
  vBufferLen := length(MQmessage);
  index := 1;
  if trim(MsgId) <> '' then
  begin
    for i := 0 to Length(F_MQPMD.MsgId) - 1 do
    begin
      s := Copy(MsgId, index, 2);
      F_MQPMD.CorrelId[i] := byte(StrToInt(string('$' + s)));
      index := index + 2;
    end;
    F_MQPMD.MsgId := F_MQPMD.CorrelId;
  end;
  MQPUT(FHConn, FHObj, F_MQPMD, F_MQPMO, vBufferLen, Buffer, @CompCode, @Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQGetMsg(flag: integer; QueueName: AnsiString; WaitInterval:
  Integer; ccsid: integer; var MsgId: PAnsiChar; var Buffer: PAnsiChar; BufferLen:
  Longint; var DataLength: Longint; var CompCode, Reason: MQLONG);
var
  sMsgId: AnsiString;
  s: AnsiString;
  index, i: Integer;
begin
  sMsgId := AnsiString(MsgId);
  SetMQGMO_DEFAULT(F_MQGMO^);
  F_MQGMO.Options := F_MQGMO.Options + MQGMO_WAIT;
  if flag = 1 then
    F_MQGMO.Options := F_MQGMO.Options + MQGMO_BROWSE_FIRST; //只浏览第一条

  F_MQGMO.WaitInterval := WaitInterval;
  SetMQMD_DEFAULT(F_MQGMD^);
  index := 1;
  if trim(sMsgId) <> '' then
    for i := 0 to Length(F_MQGMD.MsgId) - 1 do
    begin
      s := Copy(sMsgId, index, 2);
      F_MQGMD.CorrelId[i] := byte(StrToInt(string('$' + s)));
      index := index + 2;
    end;
  F_MQGMD.CodedCharSetId := ccsid;
  //F_MQGMD.MsgId := F_MQGMD.CorrelId;
  MQGET(FHconn, FHobj, F_MQGMD, F_MQGMO, BufferLen, Buffer, @DataLength, @CompCode,
    @Reason);
  if trim(sMsgId) = '' then
  begin
    for i := 0 to Length(F_MQGMD.MsgId) - 1 do
      sMsgId := sMsgId + AnsiString(IntTohex(byte(F_MQGMD.MsgId[i]), 2));
    System.AnsiStrings.StrPCopy(MsgId, sMsgId);
  end;
end;

end.

