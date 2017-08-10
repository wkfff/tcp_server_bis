unit uIntfTCPClientContext;

interface

uses
  Classes,
  SysUtils,
  diocp_coder_tcpServer,
  utils_zipTools,
  CnDebug,
  qxml,
  QPlugins,
  qstring,
  ITCPServerIntf,
  uResource;

type
  TMyTCPClientContext = class(TIOCPCoderClientContext)
  private
  protected
    procedure OnDisconnected; override;
    procedure OnConnected; override;
    function GetRemoteInfo: string;
    procedure GenerateErrorXML(AErrorMsg: string; AErrorXML: TQXMLNode);
  public
    /// <summary>
    ///   ���ա���������
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure DoContextAction(const pvDataObject: TObject); override;
  end;

implementation

{ TMyTCPClientContext }

procedure TMyTCPClientContext.DoContextAction(const pvDataObject: TObject);
var
  recvStream: TStream;
  unzipStream: TMemoryStream;
  sendStream: TMemoryStream;
  recvXMLNode: TQXMLNode;
  sendXMLNode: TQXMLNode;
  excuIntf: ITCPServerInterface;
  HospitalCode: string;
begin
  recvStream := TStream(pvDataObject);
  recvStream.Position := 0;

  unzipStream   := nil;
  sendStream    := nil;
  recvXMLNode   := nil;
  sendXMLNode   := nil;
  excuIntf      := nil;
  HospitalCode  := '-1';

  try
    unzipStream := TMemoryStream.Create;
    sendStream  := TMemoryStream.Create;
    recvXMLNode := TQXMLNode.Create;
    sendXMLNode := TQXMLNode.Create;

    TZipTools.UnZipStream(recvStream, unzipStream);
    unzipStream.Position := 0;

    recvXMLNode.LoadFromStream(unzipStream);

    CnDebugger.TraceMsg(GetRemoteInfo + recvXMLNode.Encode(False));

    HospitalCode := recvXMLNode.TextByPath(HOSPITAL_CODE_XMLPATH, '-1');
    if HospitalCode = '-1' then      //���ҽԺ�����Ƿ���
    begin
      GenerateErrorXML(HOSPITAL_CODE_ERROR, sendXMLNode);
      CnDebugger.TraceMsgError(HOSPITAL_CODE_ERROR);
    end
    else
    begin
      excuIntf := PluginsManager.ByPath(PWideChar('Services/Interface/' + HospitalCode)) as ITCPServerInterface;
      if Assigned(excuIntf) then     //���ҽԺ�ӿ��Ƿ�ע��
      begin
        try
          excuIntf.ExecuteIntf(recvXMLNode, sendXMLNode);
          CnDebugger.TraceMsg(GetRemoteInfo + sendXMLNode.Encode(False));
        except
          on E: Exception do
          begin
            GenerateErrorXML(Format(HOSPITAL_INTFEXCUT_ERROR, [E.Message]), sendXMLNode);
            CnDebugger.TraceMsgError(Format(HOSPITAL_INTFEXCUT_ERROR, [E.Message]));
          end;
        end;
      end
      else
      begin
        GenerateErrorXML(Format(HOSPITAL_INTERFACE_ERROR, [HospitalCode]), sendXMLNode);
        CnDebugger.TraceMsgError(Format(HOSPITAL_INTERFACE_ERROR, [HospitalCode]));
      end;
    end;

    sendStream.Size := 0;
    sendXMLNode.SaveToStream(sendStream, teUTF8);
    sendStream.Position := 0;
    TZipTools.ZipStream(sendStream, sendStream);
    sendStream.Position := 0;
    WriteObject(sendStream);
  finally
    excuIntf := nil;
    FreeAndNilObject(sendXMLNode);
    FreeAndNilObject(recvXMLNode);
    FreeAndNilObject(unzipStream);
    FreeAndNilObject(sendStream);
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
  CnDebugger.LogMsg(Format('�ͻ������ӳɹ�����%s��',[GetRemoteInfo]));
end;

procedure TMyTCPClientContext.OnDisconnected;
begin
  inherited;
  CnDebugger.LogMsg(Format('�ͻ������ӶϿ�����%s��',[GetRemoteInfo]));
end;

end.


