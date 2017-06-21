unit uEwellMqExpts;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TCALLBACK_FUN = procedure(AMsgID,AMsg: PChar);

  TMQClass = class(TObject)
  private
    FActive: Boolean;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function GetMessageOneWay(AFid: string;var AMsg: string): Boolean;
    procedure Connect; overload;
    procedure Connect(AServerName:string); overload;
    procedure DisConnect;
    property Active: Boolean read GetActive write SetActive;
  end;

/// <summary>
///连接队列管理器，不带参数则默认连接第一个配置，即“MQMGR1”
/// </summary>
/// <returns> 0：失败 1：成功</returns>
function ConnectMQ(): integer; stdcall; external 'EwellMq.dll';
/// <summary>
///连接队列管理器，指定连接到某个服务器
/// </summary>
/// <params>
/// serverName 服务参数，从上图ini中，可以是”MQMGR1”或”MQMGR2”
/// </params>
/// <returns> 0：失败 1：成功</returns>
function ConnectMQX(serverName: PCHAR): integer; stdcall; external 'EwellMq.dll';
  /// <summary>
/// 断开连接
/// </summary>
/// <returns>0:失败；1：成功； </returns>
function DisConnectMQ(): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 发送消息到服务器，将返回消息ID
/// </summary>
/// <param name=" Fid ">服务Id</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" QMsg ">消息内容D</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；-1：未连接</returns>
function PutMsgMQ(Fid: PChar; QMsgID: PChar; QMsg: PChar; ErrMsg: PChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 根据服务Id从相应队列中获取指定消息Id的第一条消息
/// </summary>
/// <param name=" Fid ">服务Id</param>
/// <param name=" WaitInterval ">等待时间：毫秒</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" QMsg ">消息内容D</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；-1：未连接</returns>
function GetMsgMQ(Fid: PChar; WaitInterval: Integer; QMsgID: PChar; QMsg: PChar;
  ErrMsg: PChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 根据服务Id从相应队列中获取指定消息Id的第一条消息， 方法提供超时等待设置，参数waitInterval为等待时间，单位：毫秒
/// </summary>
/// <param name=" Fid ">服务id</param>
/// <param name=" WaitInterval ">等待时间：毫秒</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" QMsg ">消息内容</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；；-1：未连接</returns>
function BrowseMsgMQ(Fid: PChar; WaitInterval: Integer; QMsgID: PChar; QMsg:
  PChar; ErrMsg: PChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 根据服务Id从相应队列中浏览指定消息Id的第一条消息，如果不提供Id，则浏览第一条。方法提供超时等待设置，参数waitInterval为等待时间，单位：毫秒
/// </summary>
/// <param name=" Fid ">服务id</param>
/// <param name=" WaitInterval ">等待时间：毫秒</param>
/// <param name=" QMsgID ">消息ID，如果没有消息Id则传空值</param>
/// <param name=" QMsg ">消息内容</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；；-1：未连接</returns>
function PutMsgWithId(Fid: PChar; QMsgID: pchar; QMsg: PChar; ErrMsg: PChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
///推送消息到服务器，并等待接收方回传消息后才结束，适用于一对一的推送
/// </summary>
/// <param name=" Fid ">服务Id</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" QMsg ">返回消息内容D</param>
/// <param name=" QoutMsg ">返回处理结果内容</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；-1：未连接</returns>
function putMsgTC(Fid: PChar; WaitInterval: Integer; QMsgID: pchar; QinMsg:
  PChar; QoutMsg: PChar; ErrMsg: PChar): Integer; stdcall; external
  'EwellMq.dll';
/// <summary>
///侦听消息队列，一旦有消息就立即获取，并回调函数
/// </summary>
/// <param name=" Fid ">服务Id</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" func">回调函数</param>
/// <returns>0:失败；1:成功； </returns>
function MessageListener(Fid :PChar; QMsgID :PChar; func:TCALLBACK_FUN) :Integer;
  stdcall;external 'EwellMq.dll';

function Query(Fid :PChar; WaitInterval:Integer; QMsgID :pchar; QinMsg :PChar;
  QoutMsg:PChar; ErrMsg :PChar):Integer; stdcall; external 'EwellMq.dll';

implementation

{ TMQClass }

procedure TMQClass.Connect;
var
  iReturn: Integer;
begin
  iReturn := ConnectMQ;
  if iReturn < 1 then
    raise Exception.Create('连接队列管理器失败!');
  FActive := True;
end;

procedure TMQClass.Connect(AServerName: string);
var
  iReturn: Integer;
begin
  iReturn := ConnectMQX(PChar(AServerName));
  if iReturn < 1 then
    raise Exception.Create('连接队列管理器 '+ AServerName +' 失败!');
  FActive := True;
end;

constructor TMQClass.Create;
begin
  inherited;
  FActive := False;
end;

destructor TMQClass.Destroy;
begin
  if FActive then
    DisConnect;
  inherited;
end;

procedure TMQClass.DisConnect;
var
  iReturn: Integer;
begin
  iReturn := DisConnectMQ;
  FActive := False;
  if iReturn < 1 then
    raise Exception.Create('断开连接队列管理器失败!');
end;

function TMQClass.GetActive: Boolean;
begin
  Result := FActive;
end;

function TMQClass.GetMessageOneWay(AFid: string;var AMsg: string): Boolean;
var
  ErrMsg: PChar;
  MsgId: PChar;
  Msg: PChar;
  iReturn: Integer;
begin
  if not FActive then
    raise Exception.Create('未连接队列管理器!');

  GetMem(ErrMsg, 1024);
  GetMem(MsgId,48);
  GetMem(Msg, 1024);

  try
    iReturn := GetMsgMQ(PChar(AFid), 1000, @MsgId[0], @Msg[0], @ErrMsg[0]);

    if iReturn < 1 then
      raise Exception.Create('获取消息失败!【'+ AFid + '】错误信息:' + ErrMsg);

    AMsg := Msg;
  finally
    FreeMem(ErrMsg);
    FreeMem(MsgId);
    FreeMem(Msg);
  end;
end;

procedure TMQClass.SetActive(const Value: Boolean);
begin
  if not FActive and Value then
    Connect;

  if FActive and (not Value) then
    DisConnect;

  FActive := Value;
end;

end.

