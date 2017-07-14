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
///���Ӷ��й�����������������Ĭ�����ӵ�һ�����ã�����MQMGR1��
/// </summary>
/// <returns> 0��ʧ�� 1���ɹ�</returns>
function ConnectMQ(): integer; stdcall; external 'EwellMq.dll';
/// <summary>
///���Ӷ��й�������ָ�����ӵ�ĳ��������
/// </summary>
/// <params>
/// serverName �������������ͼini�У������ǡ�MQMGR1����MQMGR2��
/// </params>
/// <returns> 0��ʧ�� 1���ɹ�</returns>
function ConnectMQX(serverName: PAnsiChar): integer; stdcall; external 'EwellMq.dll';
  /// <summary>
/// �Ͽ�����
/// </summary>
/// <returns>0:ʧ�ܣ�1���ɹ��� </returns>
function DisConnectMQ(): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ������Ϣ������������������ϢID
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����D</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function PutMsgMQ(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����D</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function GetMsgMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QMsg: PAnsiChar;
  ErrMsg: PAnsiChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ�� �����ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
/// </summary>
/// <param name=" Fid ">����id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">��Ϣ����</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
function BrowseMsgMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QMsg:
  PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall; external 'EwellMq.dll';
/// <summary>
/// ���ݷ���Id����Ӧ���������ָ����ϢId�ĵ�һ����Ϣ��������ṩId���������һ���������ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
/// </summary>
/// <param name=" Fid ">����id</param>
/// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
/// <param name=" QMsgID ">��ϢID�����û����ϢId�򴫿�ֵ</param>
/// <param name=" QMsg ">��Ϣ����</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
function PutMsgWithId(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar):
  Integer; stdcall; external 'EwellMq.dll';
/// <summary>
///������Ϣ�������������ȴ����շ��ش���Ϣ��Ž�����������һ��һ������
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" QMsg ">������Ϣ����D</param>
/// <param name=" QoutMsg ">���ش���������</param>
/// <param name=" ErrMsg ">���ش�������</param>
/// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
function putMsgTC(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QinMsg:
  PAnsiChar; QoutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall; external
  'EwellMq.dll';
/// <summary>
///������Ϣ���У�һ������Ϣ��������ȡ�����ص�����
/// </summary>
/// <param name=" Fid ">����Id</param>
/// <param name=" QMsgID ">��ϢID</param>
/// <param name=" func">�ص�����</param>
/// <returns>0:ʧ�ܣ�1:�ɹ��� </returns>
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
    raise MQException.Create('���Ӷ��й�����ʧ��!');
  FActive := True;
end;

procedure TMQClass.Connect(AServerName: string);
var
  iReturn: Integer;
begin
  iReturn := ConnectMQX(PAnsiChar(AServerName));
  if iReturn <> 1 then
    raise MQException.Create('���Ӷ��й����� '+ AServerName +' ʧ��!');
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
    raise MQException.Create('�Ͽ����Ӷ��й�����ʧ��!');
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
    raise MQException.Create('���й�����δ����');
  Result := 0;
  PSecId := PAnsiChar(ServiceId);
  pMsgid := @FMessageId;
  pErrorMsg := @FLastError;
  pPutMsg := PAnsiChar(CreateQueryParamsMsg);
  iReturn := PutMsgMQ(PSecId, pMsgid, pPutMsg, pErrorMsg);
  if iReturn <> 1 then
  begin
    raise MQException.Create(Format('������Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s',
      [ServiceId, iReturn, pErrorMsg]));
  end;

  GetMem(pGetMsg, 1024 * 20);
  try
    iReturn := GetMsgMQ(PSecId, 10000, pMsgid, pGetMsg, pErrorMsg);
    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s',
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

