unit uEwellMqExpts;

interface

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

function Query(Fid :PChar; WaitInterval:Integer; QMsgID :pchar; QinMsg :PChar;
  QoutMsg:PChar; ErrMsg :PChar):Integer; stdcall; external 'EwellMq.dll';

implementation

end.

