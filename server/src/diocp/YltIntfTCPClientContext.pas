unit YltIntfTCPClientContext;

interface

uses
  Classes,
  SysUtils,
  diocp_coder_tcpServer,
  utils_zipTools,
  CnDebug,
  qxml,
  QPlugins,
  qstring;

type
  TMyTCPClientContext = class(TIOCPCoderClientContext)
  private
  protected
    function ExecuteIntf(const ARecvXML: TQXML;var ASendXML: TQXML):Boolean;
    procedure OnDisconnected; override;
    procedure OnConnected; override;
    function GetRemoteInfo: string;
    procedure GenerateErrorXML(AErrorMsg: string; AErrorXML: TQXMLNode);
  public
    /// <summary>
    ///   接收、处理数据
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure DoContextAction(const pvDataObject: TObject); override;
  end;

implementation

uses
  YltShareVariable,
  IHospitalBISServiceIntf;

{ TMyTCPClientContext }

procedure TMyTCPClientContext.DoContextAction(const pvDataObject: TObject);
var
  recvStream: TStream;
  unzipStream: TMemoryStream;
  sendStream: TMemoryStream;
  recvXMLNode: TQXMLNode;
  sendXMLNode: TQXMLNode;
begin
  recvStream := TStream(pvDataObject);
  recvStream.Position := 0;

  unzipStream   := nil;
  sendStream    := nil;
  recvXMLNode   := nil;
  sendXMLNode   := nil;

  try
    unzipStream := TMemoryStream.Create;
    sendStream  := TMemoryStream.Create;
    recvXMLNode := TQXMLNode.Create;
    sendXMLNode := TQXMLNode.Create;

    TZipTools.UnZipStream(recvStream, unzipStream);
    unzipStream.Position := 0;

    recvXMLNode.LoadFromStream(unzipStream);

    CnDebugger.TraceMsg(GetRemoteInfo + recvXMLNode.Encode(False));

    try
      ExecuteIntf(recvXMLNode, sendXMLNode);
      CnDebugger.TraceMsg(GetRemoteInfo + sendXMLNode.Encode(False));
    except
      on E: Exception do
      begin
        GenerateErrorXML(Format(HOSPITAL_INTFEXCUT_ERROR, [E.Message]), sendXMLNode);
        CnDebugger.TraceMsgError(Format(HOSPITAL_INTFEXCUT_ERROR, [E.Message]));
      end;
    end;

    sendStream.Size := 0;
    sendXMLNode.SaveToStream(sendStream, teUTF8);
    sendStream.Position := 0;
    TZipTools.ZipStream(sendStream, sendStream);
    sendStream.Position := 0;
    WriteObject(sendStream);
  finally
    FreeAndNilObject(sendXMLNode);
    FreeAndNilObject(recvXMLNode);
    FreeAndNilObject(unzipStream);
    FreeAndNilObject(sendStream);
  end;
end;

function TMyTCPClientContext.ExecuteIntf(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
var
  intfName: string;
  AService: IHospitalBISService;
  HospitalCode: string;
begin
  Result := False;
  intfName := ARecvXML.TextByPath('interfacemessage.interfacename','');
  if intfName = '' then
    raise Exception.Create('interfacemessage.interfacename 为空，无法执行相应服务');

  HospitalCode := ARecvXML.TextByPath(HOSPITAL_CODE_XMLPATH, '-1');
  if HospitalCode = '-1' then
  begin
    GenerateErrorXML(HOSPITAL_CODE_ERROR, ASendXML);
    CnDebugger.TraceMsgError(HOSPITAL_CODE_ERROR);
  end
  else
  begin
    AService := PluginsManager.ByPath(PWideChar('Services/Interface/' + HospitalCode))
      as IHospitalBISService;
    if not Assigned(AService) then
      raise Exception.Create(Format(HOSPITAL_INTERFACE_ERROR, [HospitalCode]));
  end;

  try
    if intfName = 'getwardinfos' then
      Result := AService.GetWardInfos(ARecvXML, ASendXML)
    else if intfName = 'getdeptinfos' then
      Result := AService.GetDeptInfos(ARecvXML, ASendXML)
    else if intfName = 'getstaffinfos' then
      Result := AService.GetStaffInfos(ARecvXML, ASendXML)
    else if intfName = 'getchargeiteminfos' then
      Result := AService.GetChargeItemInfos(ARecvXML, ASendXML)
    else if intfName = 'gettreatmentiteminfos' then
      Result := AService.GetTreatmentItemInfos(ARecvXML, ASendXML)
    else if intfName = 'getsurgeryinfos' then
      Result := AService.GetSurgeryInfos(ARecvXML, ASendXML)
    else if intfName = 'getdiagnosesinfos' then
      Result := AService.GetDiagnosesInfos(ARecvXML, ASendXML)
    else if intfName = 'gettestiteminfos' then
      Result := AService.GetTestItemInfos(ARecvXML, ASendXML)
    else if intfName = 'getpateintinfos' then
      Result := AService.GetPateintInfos(ARecvXML, ASendXML)
    else if intfName = 'gettestitemresultinfos' then
      Result := AService.GetTestItemResultInfos(ARecvXML, ASendXML)
    else if intfName = 'sendclinicalrequisitionorder' then
      Result := AService.SendClinicalRequisitionOrder(ARecvXML, ASendXML)
    else if intfName = 'sendpatientconsts' then
      Result := AService.SendPatientConsts(ARecvXML, ASendXML)
    else if intfName = 'deleteclinicalrequisitionorder' then
      Result := AService.DeleteClinicalRequisitionOrder(ARecvXML, ASendXML)
  except
    on E: Exception do
    begin
      raise Exception.Create('ExecuteIntf Error Message:' + E.Message);
    end;
  end;
end;

procedure TMyTCPClientContext.GenerateErrorXML(AErrorMsg: string;
  AErrorXML: TQXMLNode);
var
  FChildNode: TQXMLNode;
begin
  AErrorXML := AErrorXML.AddNode('root');
  FChildNode := AErrorXML.AddNode('resultcode');
  FChildNode.Text := '-1';
  FChildNode := AErrorXML.AddNode('resultmessage');
  FChildNode.Text := AErrorMsg;
  AErrorXML.AddNode('results');
end;

function TMyTCPClientContext.GetRemoteInfo: string;
begin
  Result := RemoteAddr + ':' + IntToStr(RemotePort);
end;

procedure TMyTCPClientContext.OnConnected;
begin
  inherited;
  CnDebugger.LogMsg(Format('客户端连接成功：【%s】',[GetRemoteInfo]));
end;

procedure TMyTCPClientContext.OnDisconnected;
begin
  inherited;
  CnDebugger.LogMsg(Format('客户端连接断开：【%s】',[GetRemoteInfo]));
end;

end.


