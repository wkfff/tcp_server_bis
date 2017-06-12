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
uses SysUtils,
      MQIC;

type
  TMQClass = class
  private
    FHconn     : MQHCONN;
    FO_options : MQLONG;
    FHobj      : MQLONG;

    FQueneMgn : string;
    FChannel : string;
    FServerIP : string;
    FServerPort : string;

    F_MQCD:  PMQCD;
    F_MQCNO: PMQCNO;
    F_MQOD:  PMQOD;
    F_MQPMD: PMQMD;
    F_MQPMO: PMQPMO;
    F_MQGMD: PMQMD;
    F_MQGMO: PMQGMO;
  protected
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure MQConnect(var CompCode,Reason:MQLONG);
    procedure MQDisConn(var CompCode,Reason:MQLONG);
    procedure MQOpenQueue(QueueName: string;var CompCode,Reason:MQLONG);
    procedure MQCloseQueue(var CompCode,Reason:MQLONG);
    procedure MQPutMsg(QueueName,MQmessage: string;var CompCode,Reason:MQLONG);
    procedure MQGetMsg(QueueName: string;var Buffer: PChar;BufferLen: integer;var DataLength,CompCode,Reason:MQLONG);

    property QueneMgn: string read FQueneMgn write FQueneMgn;
    property Channel: string read FChannel write FChannel;
    property ServerIP: string read FServerIP write FServerIP;
    property ServerPort: string read FServerPort write FServerPort;
  end;

implementation

// -----------------------------------------------------------------------------
Constructor TMQClass.Create;
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
Destructor TMQClass.Destroy;
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
procedure TMQClass.MQConnect(var CompCode,Reason:MQLONG);
var
  mgr: MQCHAR48;
begin
  SetMQCD_DEFAULT(F_MQCD^);
  StrpCopy(F_MQCD.QMgrName,FQueneMgn);
  StrpCopy(F_MQCD.ConnectionName,FServerIP + '(' + FServerPort + ')');
  StrpCopy(F_MQCD.ChannelName,FChannel);

  SetMQCNO_DEFAULT(F_MQCNO^);
  F_MQCNO.ClientConnPtr:= F_MQCD;
  F_MQCNO.Version:= MQCNO_VERSION_4;
  //F_MQCNO.Options:= MQCNO_FASTPATH_BINDING + MQCNO_HANDLE_SHARE_BLOCK;

  StrpCopy(mgr,FQueneMgn);
  MQCONNX(@mgr,F_MQCNO,@FHconn,@CompCode,@Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQDisConn(var CompCode,Reason:MQLONG);
begin
  MQDISC(@FHconn, @CompCode, @Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQOpenQueue(QueueName: string;var CompCode,Reason:MQLONG);
begin
  SetMQOD_DEFAULT(F_MQOD^);
  StrpCopy(F_MQOD.ObjectName,QueueName);
  FO_options := MQOO_INPUT_AS_Q_DEF + MQOO_OUTPUT + MQOO_FAIL_IF_QUIESCING;
  MQOPEN(FHconn, F_MQOD, FO_options, @FHobj, @CompCode, @Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQCloseQueue(var CompCode,Reason:MQLONG);
begin
  MQCLOSE(FHconn, @FHobj, 0, @CompCode, @Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQPutMsg(QueueName,MQmessage: string;var CompCode,Reason:MQLONG);
var
  vBufferLen:MQLONG;
  Buffer:Pchar;
begin
  SetMQMD_DEFAULT(F_MQPMD^);
  SetMQPMO_DEFAULT(F_MQPMO^);
  Buffer:= Pchar(MQmessage);
  vBufferLen:= length(MQmessage);
  MQPUT(FHConn,FHObj,F_MQPMD,F_MQPMO,vbufferLen,Buffer,@CompCode,@Reason);
end;

// -----------------------------------------------------------------------------
procedure TMQClass.MQGetMsg(QueueName: string;var Buffer: PChar;BufferLen: integer;var DataLength,CompCode,Reason:MQLONG);
begin
  SetMQGMO_DEFAULT(F_MQGMO^);
  F_MQGMO.Options := MQGMO_WAIT+ MQGMO_CONVERT;
  F_MQGMO.WaitInterval := 200;
  SetMQMD_DEFAULT(F_MQGMD^);
  MQGET(FHconn,FHobj,F_MQGMD,F_MQGMO,BufferLen,Buffer,@DataLength,@CompCode,@Reason);
end;

end.
