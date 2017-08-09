unit uEwellMqExpts;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Winapi.Windows,
  qplugins_params,
  qxml,
  qstring,
  utils_safeLogger;

type
  MQException = class(Exception)
  end;

  TCALLBACK_FUN = procedure(AMsgID, AMsg: PAnsiChar);

  TConnectMQfuc = function(): Integer; stdcall;

  TConnectMQXfuc = function(serverName: PAnsiChar): Integer; stdcall;

  TDisConnectMQfuc = function(): Integer; stdcall;

  TPutMsgMQfuc = function(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar;
    ErrMsg: PAnsiChar): Integer; stdcall;

  TGetMsgMQfuc = function(Fid: PAnsiChar; WaitInterval: Integer; QMsgID:
    PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall;

  TBrowseMsgMQfuc = function(Fid: PAnsiChar; WaitInterval: Integer; QMsgID:
    PAnsiChar; QMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall;

  TPutMsgWithIdfuc = function(Fid: PAnsiChar; QMsgID: PAnsiChar; QMsg: PAnsiChar;
    ErrMsg: PAnsiChar): Integer; stdcall;

  TputMsgTCfuc = function(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar;
    QinMsg: PAnsiChar; QoutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall;

  TMessageListenerfuc = function(Fid: PAnsiChar; QMsgID: PAnsiChar; func:
    TCALLBACK_FUN): Integer; stdcall;

  TQueryfuc = function(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar;
    QinMsg: PAnsiChar; QoutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall;

  TMQClass = class(TObject)
  private
    FDllHandle: THandle;
    /// <summary>
    ///���Ӷ��й�����������������Ĭ�����ӵ�һ�����ã�����MQMGR1��
    /// </summary>
    /// <returns> 0��ʧ�� 1���ɹ�</returns>
    ConnectMQ: TConnectMQfuc;
    /// <summary>
    ///���Ӷ��й�������ָ�����ӵ�ĳ��������
    /// </summary>
    /// <params>
    /// serverName �������������ͼini�У������ǡ�MQMGR1����MQMGR2��
    /// </params>
    /// <returns> 0��ʧ�� 1���ɹ�</returns>
    ConnectMQX: TConnectMQXfuc;
    /// <summary>
    /// �Ͽ�����
    /// </summary>
    /// <returns>0:ʧ�ܣ�1���ɹ��� </returns>
    DisConnectMQ: TDisConnectMQfuc;
    /// <summary>
    /// ������Ϣ������������������ϢID
    /// </summary>
    /// <param name=" Fid ">����Id</param>
    /// <param name=" QMsgID ">��ϢID</param>
    /// <param name=" QMsg ">��Ϣ����D</param>
    /// <param name=" ErrMsg ">���ش�������</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
    PutMsgMQ: TPutMsgMQfuc;
    /// <summary>
    /// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ
    /// </summary>
    /// <param name=" Fid ">����Id</param>
    /// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
    /// <param name=" QMsgID ">��ϢID</param>
    /// <param name=" QMsg ">��Ϣ����D</param>
    /// <param name=" ErrMsg ">���ش�������</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
    GetMsgMQ: TGetMsgMQfuc;
    /// <summary>
    /// ���ݷ���Id����Ӧ�����л�ȡָ����ϢId�ĵ�һ����Ϣ�� �����ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
    /// </summary>
    /// <param name=" Fid ">����id</param>
    /// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
    /// <param name=" QMsgID ">��ϢID</param>
    /// <param name=" QMsg ">��Ϣ����</param>
    /// <param name=" ErrMsg ">���ش�������</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
    BrowseMsgMQ: TBrowseMsgMQfuc;
    /// <summary>
    /// ���ݷ���Id����Ӧ���������ָ����ϢId�ĵ�һ����Ϣ��������ṩId���������һ���������ṩ��ʱ�ȴ����ã�����waitIntervalΪ�ȴ�ʱ�䣬��λ������
    /// </summary>
    /// <param name=" Fid ">����id</param>
    /// <param name=" WaitInterval ">�ȴ�ʱ�䣺����</param>
    /// <param name=" QMsgID ">��ϢID�����û����ϢId�򴫿�ֵ</param>
    /// <param name=" QMsg ">��Ϣ����</param>
    /// <param name=" ErrMsg ">���ش�������</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ�����-1��δ����</returns>
    PutMsgWithId: TPutMsgWithIdfuc;
    /// <summary>
    ///������Ϣ�������������ȴ����շ��ش���Ϣ��Ž�����������һ��һ������
    /// </summary>
    /// <param name=" Fid ">����Id</param>
    /// <param name=" QMsgID ">��ϢID</param>
    /// <param name=" QMsg ">������Ϣ����D</param>
    /// <param name=" QoutMsg ">���ش���������</param>
    /// <param name=" ErrMsg ">���ش�������</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ���-1��δ����</returns>
    putMsgTC: TputMsgTCfuc;
    /// <summary>
    ///������Ϣ���У�һ������Ϣ��������ȡ�����ص�����
    /// </summary>
    /// <param name=" Fid ">����Id</param>
    /// <param name=" QMsgID ">��ϢID</param>
    /// <param name=" func">�ص�����</param>
    /// <returns>0:ʧ�ܣ�1:�ɹ��� </returns>
    MessageListener: TMessageListenerfuc;

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
    procedure LoadDllLibray;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetWaitInterval(const Value: Integer);
    function CreateQueryParamsMsg: string;
    function ConvertStringToAnsiChar(AData: string): PAnsiChar;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect; overload;
    procedure Connect(AServerName: string); overload;
    procedure DisConnect;
    function Query: Integer;
    function PutMQMessage: Integer;
  public
    property respMsg: TQXML read FrespMsg;
    property WaitInterval: Integer read FWaitInterval write SetWaitInterval;
    property QueryItems: TList<TQParams> read FQueryItems write FQueryItems;
    property OrderItems: TList<TQParams> read FOrderItems write FOrderItems;
    property Active: Boolean read GetActive write SetActive;
    property ServiceId: string read FServiceId write FServiceId;
    property UserName: string read FUserName write FUserName;
    property PassWord: string read FPassWord write FPassWord;
    property TargetSysCode: string read FTargetSysCode write FTargetSysCode;
    property SourceSysCode: string read FSourceSysCode write FSourceSysCode;
  end;

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
  iReturn := ConnectMQX(PAnsiChar(AnsiString(AServerName)));
  if iReturn <> 1 then
    raise MQException.Create('���Ӷ��й����� ' + AServerName + ' ʧ��!');
  FActive := True;
end;

function TMQClass.ConvertStringToAnsiChar(AData: string): PAnsiChar;
begin
  Result := PAnsiChar(AnsiString(AData));
end;

procedure TMQClass.LoadDllLibray;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'EwellMq.dll') then
    raise Exception.Create('TMQClass.Create Error not found EwellMq.dll');

  FDllHandle := SafeLoadLibrary(ExtractFilePath(ParamStr(0)) + 'EwellMq.dll');

  @ConnectMQ := GetProcAddress(FDllHandle, 'ConnectMQ');
  @ConnectMQX := GetProcAddress(FDllHandle, 'ConnectMQX');
  @PutMsgMQ := GetProcAddress(FDllHandle, 'PutMsgMQ');
  @putMsgTC := GetProcAddress(FDllHandle, 'putMsgTC');
  @GetMsgMQ := GetProcAddress(FDllHandle, 'GetMsgMQ');
  @BrowseMsgMQ := GetProcAddress(FDllHandle, 'BrowseMsgMQ');
  @PutMsgWithId := GetProcAddress(FDllHandle, 'PutMsgWithId');
  @MessageListener := GetProcAddress(FDllHandle, 'MessageListener');
end;

constructor TMQClass.Create;
begin
  inherited;
  LoadDllLibray;

  FWaitInterval := 10000;
  FActive := False;
  FQueryItems := TList<TQParams>.Create;
  FOrderItems := TList<TQParams>.Create;
  FrespMsg := TQXML.Create;
end;

destructor TMQClass.Destroy;
var
  I: Integer;
begin
  FreeAndNilObject(FrespMsg);
  for I := 0 to FQueryItems.Count - 1 do
    FQueryItems.Items[I].Free;
  FreeAndNilObject(FQueryItems);
  for I := 0 to FOrderItems.Count - 1 do
    FOrderItems.Items[I].Free;
  FreeAndNilObject(FOrderItems);
  if Active then
    DisConnect;

  FreeLibrary(FDllHandle);
  inherited;
end;

procedure TMQClass.DisConnect;
var
  iReturn: Integer;
begin
  iReturn := DisConnectMQ;
  if iReturn <> 1 then
    raise MQException.Create('�Ͽ����Ӷ��й�����ʧ��!');
  FActive := False;
end;

function TMQClass.GetActive: Boolean;
begin
  Result := FActive;
end;

function TMQClass.PutMQMessage: Integer;
begin

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
    FreeAndNilObject(AMsgXML);
  end;
end;

function TMQClass.Query: Integer;
var
  iReturn: Integer;
  pSecId: PAnsiChar;
  pMsgId: PAnsiChar;
  pErrorMsg: PAnsiChar;
  pPutMsg: PAnsiChar;
  pGetMsg: PAnsiChar;
begin
  if not Active then
    raise MQException.Create('���й�����δ����');
  Result := 0;

  pSecId := ConvertStringToAnsiChar(ServiceId);
  sfLogger.logMessage('����ID:' + string(pSecId));

  GetMem(pMsgId, 49);
  GetMem(pErrorMsg, 2048);
  GetMem(pGetMsg, 1024 * 1024 * 100);
  try
    FillChar(pMsgId[0], 49, #0);
    FillChar(pErrorMsg[0], 2048, #0);

    pPutMsg := ConvertStringToAnsiChar(CreateQueryParamsMsg);
    sfLogger.logMessage('MQ Put��Ϣ����:' + string(pPutMsg));

    iReturn := PutMsgMQ(PAnsiChar(AnsiString(ServiceId)), @pMsgId[0], pPutMsg, @pErrorMsg
      [0]);
    sfLogger.logMessage('��ϢID:' + string(pMsgId));

    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('������Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
        iReturn, pErrorMsg]));
    end;

    iReturn := GetMsgMQ(PAnsiChar(AnsiString(ServiceId)), 10000, @pMsgId[0],
      pGetMsg, @pErrorMsg[0]);
    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
        iReturn, pErrorMsg]));
    end;
    sfLogger.logMessage('MQ Get��Ϣ����:' + string(pGetMsg));
    FrespMsg.Parse(PWideChar(string(pGetMsg)));
    Result := iReturn;
  finally
    FreeMem(pMsgId);
    FreeMem(pErrorMsg);
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

