unit EwellMqExpts;

interface

uses
  System.SysUtils,
  System.AnsiStrings,
  System.Classes,
  System.Generics.Collections,
  qplugins_params,
  qxml,
  qstring,
  CnDebug,
  utils_safeLogger,
  EWellMQClass;

type
  MQException = class(Exception)
  end;

  TTXMQClass = class(TObject)
  private
    FEWellMQ: TEWellMQ;
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
    procedure SetWaitInterval(const Value: Integer);
    function CreateQueryParamsMsg: string;
    function ConvertStringToAnsiChar(AData: string): PAnsiChar;
//    function GetInfoFromMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID,
//      QInMsg, QOutMsg, ErrMsg: PAnsiChar): Integer; stdcall;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Connect; overload;
    procedure Connect(AServerName: string); overload;
    procedure DisConnect;
    function Query: Integer;
    function QueryByParam(const AParam: UnicodeString): Integer;
    function PutMsgMQ(Fid, QMsgID, QMsg, ErrMsg: PAnsiChar): Integer;
    function GetMsgMQ(Fid: PAnsiChar; WaitInterval: Integer;var QMsgID, QMsg,
      ErrMsg: PAnsiChar): Integer;
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

function GetInfoFromMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QInMsg: PAnsiChar;
  QOutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall; external 'EWellMq.dll';

{ TMQClass }

procedure TTXMQClass.Connect;
var
  iReturn: Integer;
begin
  iReturn := FEWellMQ.Connect;
  if iReturn <> 1 then
    raise MQException.Create('���Ӷ��й�����ʧ��!');
  FActive := True;
end;

procedure TTXMQClass.Connect(AServerName: string);
var
  iReturn: Integer;
begin
  iReturn := FEWellMQ.Connect(AnsiString(AServerName));
  if iReturn <> 1 then
    raise MQException.Create('���Ӷ��й����� ' + AServerName + ' ʧ��!');
  FActive := True;
end;

function TTXMQClass.ConvertStringToAnsiChar(AData: string): PAnsiChar;
begin
  Result := PAnsiChar(AnsiString(AData));
end;

constructor TTXMQClass.Create;
begin
  inherited;
  FWaitInterval := 10000;
  FActive := False;
  FQueryItems := TList<TQParams>.Create;
  FOrderItems := TList<TQParams>.Create;
  FrespMsg := TQXML.Create;
  FEWellMQ := TEWellMQ.Create;
end;

destructor TTXMQClass.Destroy;
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
  FEWellMQ.Free;
  inherited;
end;

procedure TTXMQClass.DisConnect;
var
  iReturn: Integer;
begin
  iReturn := FEWellMQ.DisConnect;
  if iReturn <> 1 then
    raise MQException.Create('�Ͽ����Ӷ��й�����ʧ��!');
  FActive := False;
end;

function TTXMQClass.GetActive: Boolean;
begin
  Result := FActive;
end;

function TTXMQClass.PutMQMessage: Integer;
begin
  Result := 0;
end;

function TTXMQClass.CreateQueryParamsMsg: string;
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

function TTXMQClass.PutMsgMQ(Fid, QMsgID, QMsg, ErrMsg: PAnsiChar): Integer;
var
  vFID: AnsiString;
  vMsgID: AnsiString;
  vErrMsg: AnsiString;
begin
  Result := 0;
  if Assigned(FEWellMQ) then
  begin
    vFID := AnsiString(Fid + '_0');
    if Trim(AnsiString(QMsgID)) <> '' then
      Result := FEWellMQ.PutMsgWithID(vFID, QMsg, QMsgID, vErrMsg)
    else
      Result := FEWellMQ.Put(vFID, QMsg, vMsgID, vErrMsg);
    System.AnsiStrings.StrPCopy(QMsgID, vMsgID);
    System.AnsiStrings.StrPCopy(ErrMsg, vErrMsg);
  end;
end;

function TTXMQClass.GetMsgMQ(Fid: PAnsiChar; WaitInterval: Integer;var QMsgID, QMsg,
  ErrMsg: PAnsiChar): Integer;
var
  msg: AnsiString;
  sID: AnsiString;
  vErrMsg: AnsiString;
begin
  Result := 0;
  if Assigned(FEWellMQ) then
  begin
    sID := AnsiString(Fid + '_1');
    msg := FEWellMQ.Get(sID, WaitInterval, mfGet, vErrMsg, QMsgID);
    if msg <> '' then
    begin
      Result := 1;
    end;
    System.AnsiStrings.StrPCopy(QMsg, msg);
    System.AnsiStrings.Strpcopy(ErrMsg, vErrMsg);
  end;
end;

//function TTXMQClass.GetInfoFromMQ(Fid: PAnsiChar; WaitInterval: Integer; QMsgID: PAnsiChar; QInMsg: PAnsiChar;
//  QOutMsg: PAnsiChar; ErrMsg: PAnsiChar): Integer; stdcall;
//var
//  AMQ: TEWellMQ;
//  vMsgID: AnsiString;
//  vErrMsg: AnsiString;
//  vFID: AnsiString;
//  msg: AnsiString;
//begin
//  Result := 0;
//  AMQ := TEWellMQ.Create;
//  try
//    //connect
//    Result := AMQ.Connect;
//    if Result <> 1 then
//    begin
//      ErrMsg := 'MQ Connect Error';
//      Exit;
//    end;
//
//    //put msg
//    vFID := AnsiString(Fid) + '_0';
//    if Trim(QMsgID) <> '' then
//      Result := AMQ.PutMsgWithID(vFID, QInMsg, QMsgID, vErrMsg)
//    else
//      Result := AMQ.Put(vFID, QInMsg, vMsgID, vErrMsg);
//
//    System.AnsiStrings.Strpcopy(QMsgID, vMsgID);
//    System.AnsiStrings.Strpcopy(ErrMsg, vErrMsg);
//    if Result <> 1 then
//      Exit;
//
//    //get msg
//    vFID := Fid + '_1';
//    msg := AMQ.Get(vFID, WaitInterval, mfGet, vErrMsg, QMsgID);
//    if msg <> '' then
//    begin
//      Result := 1;
//    end;
//    System.AnsiStrings.StrPCopy(QOutMsg, msg);
//    System.AnsiStrings.Strpcopy(ErrMsg, vErrMsg);
//    if Result <> 1 then
//      Exit;
//
//    //disconnect
//    Result := AMQ.DisConnect;
//    if Result <> 1 then
//    begin
//      ErrMsg := 'MQ DisConnect Error';
//      Exit;
//    end;
//
//  finally
//    AMQ.Free;
//  end;
//end;

function TTXMQClass.QueryByParam(const AParam: string): Integer;
var
  iReturn: Integer;
  pSecId: PAnsiChar;
  pMsgId: PAnsiChar;
  pErrorMsg: PAnsiChar;
  pPutMsg: PAnsiChar;
  pGetMsg: PAnsiChar;
begin
  Result := 0;

  if ServiceId = '' then
    raise MQException.Create('QueryByParam Error: ServiceId is null');

  GetMem(pSecId, 24);
  GetMem(pMsgId, 49);
  GetMem(pErrorMsg, 2048);
  GetMem(pGetMsg, 1024 * 1024 * 100);
  try
    try
      System.AnsiStrings.StrPCopy(pSecId, AnsiString(ServiceId));
      FillChar(pMsgId[0], 49, #0);
      FillChar(pErrorMsg[0], 2048, #0);
      CnDebugger.LogMsgWithTag(AParam, 'MQPut');
      pPutMsg := ConvertStringToAnsiChar(AParam);

      //�޸ĺ��DLL  ����
      iReturn := GetInfoFromMQ(pSecId,
        1000 * 60, pMsgId, pPutMsg, pGetMsg, pErrorMsg);
      if iReturn <> 1 then
      begin
        raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
          iReturn, pErrorMsg]));
      end;
{$REGION '�Ϸ���'}
//      iReturn := PutMsgMQ(ConvertStringToAnsiChar(ServiceId), pMsgId,
//        pPutMsg, pErrorMsg);
//      CnDebugger.LogMsgWithTag(string(pMsgId), 'MQMessageID');
//
//      if iReturn <> 1 then
//      begin
//        raise MQException.Create(Format('������Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
//          iReturn, pErrorMsg]));
//      end;
//
//      iReturn := GetMsgMQ(ConvertStringToAnsiChar(ServiceId), 1000 * 60 * 5, pMsgId, pGetMsg, pErrorMsg);
//
//      iCount := 0;
//      while (iCount < 5) and (iReturn <> 1) do
//      begin
//        Connect;
//        iReturn := GetMsgMQ(ConvertStringToAnsiChar(ServiceId), 1000 * 60 * 5, pMsgId, pGetMsg, pErrorMsg);
//        iCount := iCount + 1;
//      end;
//
//      if iReturn <> 1 then
//      begin
//        raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
//          iReturn, pErrorMsg]));
//      end;
//      if Active then
//        DisConnect;
{$ENDREGION}
      CnDebugger.LogMsgWithTag(string(pGetMsg), 'MQGet');
      FrespMsg.Parse(PWideChar(string(pGetMsg)));
      Result := iReturn;
    except
      on E: Exception do
      begin
        CnDebugger.LogMsgWithTag(E.Message, 'QueryByParam_Error');
        raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
          iReturn, pErrorMsg]));
      end;
    end;
  finally
    FreeMem(pSecId);
    FreeMem(pMsgId);
    FreeMem(pErrorMsg);
    FreeMem(pGetMsg);
  end;
end;

{$REGION '�Ϸ��� ����'}
//function TMQClass.QueryByParam(const AParam: string): Integer;
//var
//  iReturn: Integer;
//  pSecId: PAnsiChar;
//  pMsgId: PAnsiChar;
//  pErrorMsg: PAnsiChar;
//  pPutMsg: PAnsiChar;
//  pGetMsg: PAnsiChar;
//begin
//  if not Active then
//    raise MQException.Create('���й�����δ����');
//  Result := 0;
//
//  if ServiceId = '' then
//    raise MQException.Create('QueryByParam Error: ServiceId is null');
//
//  pSecId := ConvertStringToAnsiChar(ServiceId);
//  CnDebugger.LogMsgWithTag(string(pSecId), 'ServiceId');
//
//  GetMem(pMsgId, 49);
//  GetMem(pErrorMsg, 2048);
//  GetMem(pGetMsg, 1024 * 1024 * 100);
//  try
//    try
//      FillChar(pMsgId[0], 49, #0);
//      FillChar(pErrorMsg[0], 2048, #0);
//      CnDebugger.LogMsgWithTag(AParam, 'MQPut');
//      pPutMsg := ConvertStringToAnsiChar(AParam);
//      iReturn := PutMsgMQ(ConvertStringToAnsiChar(ServiceId), pMsgId,
//        pPutMsg, pErrorMsg);
//      CnDebugger.LogMsgWithTag(string(pMsgId), 'MQMessageID');
//
//      if iReturn <> 1 then
//      begin
//        raise MQException.Create(Format('������Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
//          iReturn, pErrorMsg]));
//      end;
//
//      iReturn := GetMsgMQ(ConvertStringToAnsiChar(ServiceId), 1000 * 10, pMsgId, pGetMsg, pErrorMsg);
//
//      if iReturn <> 1 then
//      begin
//        raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s', [ServiceId,
//          iReturn, pErrorMsg]));
//      end;
//      if Active then
//        DisConnect;
//      CnDebugger.LogMsgWithTag(string(pGetMsg), 'MQGet');
//      FrespMsg.Parse(PWideChar(string(pGetMsg)));
//      Result := iReturn;
//    except
//      on E: Exception do
//      begin
//        CnDebugger.LogMsgWithTag(E.Message, 'QueryByParam_Error');
//        raise Exception.Create(E.Message);
//      end;
//    end;
//  finally
//    FreeMem(pMsgId);
//    FreeMem(pErrorMsg);
//    FreeMem(pGetMsg);
//  end;
//end;
{$ENDREGION}

function TTXMQClass.Query: Integer;
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

    iReturn := PutMsgMQ(PAnsiChar(AnsiString(ServiceId)), pMsgId, pPutMsg, pErrorMsg);
    sfLogger.logMessage('��ϢID:' + string(pMsgId));

    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('������Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s',
        [ServiceId, iReturn, pErrorMsg]));
    end;

    iReturn := GetMsgMQ(PAnsiChar(AnsiString(ServiceId)), 10000, pMsgId, pGetMsg, pErrorMsg);
    if iReturn <> 1 then
    begin
      raise MQException.Create(Format('��ȡ��Ϣʧ��,����ID��%s,����ֵ��%d ,������Ϣ��%s',
        [ServiceId, iReturn, pErrorMsg]));
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

procedure TTXMQClass.SetActive(const Value: Boolean);
begin
  if not FActive and Value then
    Connect;

  if FActive and (not Value) then
    DisConnect;

  FActive := Value;
end;

procedure TTXMQClass.SetWaitInterval(const Value: Integer);
begin
  FWaitInterval := Value;
end;

initialization
  CnDebugger.LogMsg('Test');

end.

