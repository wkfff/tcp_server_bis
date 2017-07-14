unit uEwellMqExpts;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  qplugins_params,
  qxml,
  utils_safeLogger;

type
  MQException = class(Exception)
  
  end;
  
  TCALLBACK_FUN = procedure(AMsgID, AMsg: PAnsiChar);
  TMessageId = array[0..49] of AnsiChar;
  TErrorMessage = array[0..1024] of AnsiChar;

  TMQClass = class(TObject)
  private
    FLastError: TErrorMessage;
    FMessageId: TMessageId; 
    FActive: Boolean;
    FServiceId: string;
    FUserName: string;
    FPassWord: string;
    FTargetSysCode: string;
    FQueryItems: TList<TQParams>;
    FOrderItems: TList<TQParams>;
    FWaitInterval: Integer;
    FrespMsg: TQXML;
    FSourceSysCode: string;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    function GetLastErro: TErrorMessage;
    procedure SetWaitInterval(const Value: Integer);
    function CreateQueryParamsMsg: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect; overload;
    procedure Connect(AServerName:string); overload;
    procedure DisConnect;
    function Query: Integer;
  public
    property respMsg : TQXML read FrespMsg;
    property WaitInterval: Integer read FWaitInterval write SetWaitInterval;
    property LastErro: TErrorMessage read GetLastErro;
    property MessageId: TMessageId read FMessageId;
    property QueryItems: TList<TQParams> read FQueryItems write FQueryItems;
    property OrderItems: TList<TQParams> read FOrderItems write FOrderItems;
    property Active: Boolean read GetActive write SetActive;
    property ServiceId: string read FServiceId write FServiceId;
    property UserName: string read FUserName write FUserName;
    property PassWord: string read FPassWord write FPassWord;
    property TargetSysCode: string read FTargetSysCode write FTargetSysCode;
    property SourceSysCode: string read FSourceSysCode write FSourceSysCode;
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
function ConnectMQX(serverName: PAnsiChar): integer; stdcall; external 'EwellMq.dll';
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
function PutMsgMQ(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar):
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
function GetMsgMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QMsg: PAnsiChar;
  ErrMsg: PAnsiChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 根据服务Id从相应队列中获取指定消息Id的第一条消息， 方法提供超时等待设置，参数waitInterval为等待时间，单位：毫秒
/// </summary>
/// <param name=" Fid ">服务id</param>
/// <param name=" WaitInterval ">等待时间：毫秒</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" QMsg ">消息内容</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；；-1：未连接</returns>
function BrowseMsgMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QMsg:
  PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// 根据服务Id从相应队列中浏览指定消息Id的第一条消息，如果不提供Id，则浏览第一条。方法提供超时等待设置，参数waitInterval为等待时间，单位：毫秒
/// </summary>
/// <param name=" Fid ">服务id</param>
/// <param name=" WaitInterval ">等待时间：毫秒</param>
/// <param name=" QMsgID ">消息ID，如果没有消息Id则传空值</param>
/// <param name=" QMsg ">消息内容</param>
/// <param name=" ErrMsg ">返回错误内容</param>
/// <returns>0:失败；1:成功；；-1：未连接</returns>
function PutMsgWithId(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar):
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
function putMsgTC(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QinMsg:
  PAnsiChar; QoutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall; external
  'EwellMq.dll';
/// <summary>
///侦听消息队列，一旦有消息就立即获取，并回调函数
/// </summary>
/// <param name=" Fid ">服务Id</param>
/// <param name=" QMsgID ">消息ID</param>
/// <param name=" func">回调函数</param>
/// <returns>0:失败；1:成功； </returns>
function MessageListener(Fid :PAnsiChar; QMsgID :PAnsiChar; func:TCALLBACK_FUN) :Integer;
  stdcall;external 'EwellMq.dll';

function Query(Fid :PAnsiChar; WaitInterval:Integer; QMsgID :PAnsiChar; QinMsg :PAnsiChar;
  QoutMsg:PAnsiChar; ErrMsg :PAnsiChar):Integer; stdcall; external 'EwellMq.dll';

implementation

{ TMQClass }

procedure TMQClass.Connect;
var
  iReturn: Integer;
begin
  iReturn := ConnectMQ;
  if iReturn <> 1 then
    raise MQException.Create('连接队列管理器失败!');
  FActive := True;
end;

procedure TMQClass.Connect(AServerName: string);
var
  iReturn: Integer;
begin
  iReturn := ConnectMQX(PAnsiChar(AServerName));
  if iReturn <> 1 then
    raise MQException.Create('连接队列管理器 '+ AServerName +' 失败!');
  FActive := True;
end;

constructor TMQClass.Create;
begin
  inherited;

  FWaitInterval := 10000;
  FActive := False;
  FQueryItems := TList<TQParams>.Create;
  FOrderItems := TList<TQParams>.Create;
  FrespMsg := TQXML.Create;
end;

destructor TMQClass.Destroy;
begin
  FreeAndNil(FrespMsg);
  FreeAndNil(FQueryItems);
  FreeAndNil(FOrderItems);
  if Active then
    DisConnect;
  inherited;
end;

procedure TMQClass.DisConnect;
var
  iReturn: Integer;
begin
  iReturn := DisConnectMQ;
  FActive := False;
  if iReturn <> 1 then
    raise MQException.Create('断开连接队列管理器失败!');
end;

function TMQClass.GetActive: Boolean;
begin
  Result := FActive;
end;

function TMQClass.GetLastErro: TErrorMessage;
begin
  Result := FLastError;
end;

function TMQClass.CreateQueryParamsMsg: string;
var
  AMsgXML: TQXML;
  AChildNode: TQXMLNode;
  AQueryItem: TQXMLNode;
  I: Integer;
begin
  AMsgXML := nil;
  Result := '';
  try
    AMsgXML := TQXML.Create;
    AChildNode := AMsgXML.AddNode('ESBEntry');
    AChildNode := AChildNode.AddNode('AccessControl');
    AChildNode.AddNode('UserName').Text := UserName;
    AChildNode.AddNode('Password').Text := PassWord;
    AChildNode.AddNode('Fid').Text := ServiceId;

    AChildNode := AMsgXML.ItemByPath('ESBEntry');
    AChildNode := AChildNode.AddNode('MessageHeader');
    AChildNode.AddNode('Fid').Text := ServiceId;
    AChildNode.AddNode('SourceSysCode').Text := SourceSysCode;
    AChildNode.AddNode('TargetSysCode').Text := TargetSysCode;
    AChildNode.AddNode('MsgDate').Text := FormatDateTime('yyyy-mm-ddhh:mm:ss', Now);

    AChildNode := AMsgXML.ItemByPath('ESBEntry');
    AChildNode := AChildNode.AddNode('RequestOption');
    AChildNode.AddNode('onceFlag');
    AChildNode.AddNode('startNum');
    AChildNode.AddNode('endNum');

    AChildNode := AMsgXML.ItemByPath('ESBEntry');
    AChildNode := AChildNode.AddNode('MsgInfo');
    for I := 0 to QueryItems.Count - 1 do
    begin  
      AQueryItem := AChildNode.AddNode('query');
      if Assigned(QueryItems[I].ByName('item')) then
        AQueryItem.Attrs.Add('item').Value := QueryItems[I].ByName('item').AsString;
      if Assigned(QueryItems[I].ByName('compy')) then
        AQueryItem.Attrs.Add('compy').Value := QueryItems[I].ByName('compy').AsString;
      if Assigned(QueryItems[I].ByName('value')) then
        AQueryItem.Attrs.Add('value').Value := QueryItems[I].ByName('value').AsString;
      if Assigned(QueryItems[I].ByName('splice')) then
        AQueryItem.Attrs.Add('splice').Value := QueryItems[I].ByName('splice').AsString;
    end;
    for I := 0 to OrderItems.Count - 1 do
    begin  
      AQueryItem := AChildNode.AddNode('order');
      if Assigned(OrderItems[I].ByName('item')) then
        AQueryItem.Attrs.Add('item').Value := OrderItems[I].ByName('item').AsString;
      if Assigned(OrderItems[I].ByName('sort')) then
        AQueryItem.Attrs.Add('sort').Value := OrderItems[I].ByName('sort').AsString;
    end;
    Result := AMsgXML.Encode(False);
  finally
    FreeAndNil(AMsgXML);
  end;
end;

function TMQClass.Query: Integer;
var
  iReturn: Integer;
  PSecId: PAnsiChar;
  pMsgid: PAnsiChar;
  pErrorMsg: PAnsiChar;
  pPutMsg: PAnsiChar;
  pGetMsg: PAnsiChar;
begin
  if not Active then
    raise MQException.Create('队列管理器未连接');
  Result := 0;
  PSecId := PAnsiChar(ServiceId);
  pMsgid := @FMessageId;
  pErrorMsg := @FLastError;
  pPutMsg := PAnsiChar(CreateQueryParamsMsg);
  iReturn := PutMsgMQ(PSecId, pMsgid, pPutMsg, pErrorMsg);
  if iReturn <> 1 then
  begin
    raise MQException.Create(Format('发送消息失败,服务ID：%s,返回值：%d ,错误信息：%s',
      [ServiceId, iReturn, pErrorMsg]));
  end;

  GetMem(pGetMsg, 1024 * 20);
  try
    iReturn := GetMsgMQ(PSecId, 10000, pMsgid, pGetMsg, pErrorMsg);
    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('获取消息失败,服务ID：%s,返回值：%d ,错误信息：%s',
        [ServiceId, iReturn, pErrorMsg]));
    end;
    FrespMsg.Parse(pGetMsg);
    Result := iReturn;
  finally
    FreeMem(pGetMsg);
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

procedure TMQClass.SetWaitInterval(const Value: Integer);
begin
  FWaitInterval := Value;
end;

end.

