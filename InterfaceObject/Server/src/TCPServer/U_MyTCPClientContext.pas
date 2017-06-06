unit U_MyTCPClientContext;

interface

uses
  Classes,
  SysUtils,
  diocp_coder_tcpServer,
  utils_zipTools,
  utils_safeLogger,
  qxml,
  QPlugins,
  qstring,
  U_TCPServerInterface;

type
  TMyTCPClientContext = class(TIOCPCoderClientContext)
  private
  protected
    procedure OnDisconnected; override;
    procedure OnConnected; override;
    function GetRemoteInfo: string;
    procedure GenerateErrorXML(AErrorMsg: string; AErrorXML: TQXMLNode);
  protected

  public
    /// <summary>
    ///   接收、处理数据
    /// </summary>
    /// <param name="pvDataObject"> (TObject) </param>
    procedure DoContextAction(const pvDataObject: TObject); override;
  end;

implementation

const
  HospitalCodeXmlPath = 'interfacemessage.hospitalcode';
  HospitalCodeError = '未传入医院代码【hospitalcode】';
  HospitalInterfaceError = '未注册对应医院接口，HospitalCode【%s】';
  HospitalIntfExcutError = '接口逻辑处理错误，错误信息：%s';

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

    sfLogger.logMessage(GetRemoteInfo + recvXMLNode.Encode(False));

    HospitalCode := recvXMLNode.TextByPath(HospitalCodeXmlPath, '-1');
    if HospitalCode = '-1' then      //检查医院代码是否传入
    begin
      GenerateErrorXML(HospitalCodeError, sendXMLNode);
      sfLogger.logMessage(HospitalCodeError,'', lgvError);
    end
    else
    begin
      excuIntf := PluginsManager.ByPath(PWideChar('Services/Interface/' + HospitalCode)) as ITCPServerInterface;
      if Assigned(excuIntf) then     //检查医院接口是否注册
      begin
        try
          excuIntf.ExecuteIntf(recvXMLNode, sendXMLNode)
        except
          on E: Exception do
          begin
            GenerateErrorXML(Format(HospitalIntfExcutError, [E.Message]), sendXMLNode);
            sfLogger.logMessage(Format(HospitalIntfExcutError, [E.Message]), '', lgvError);
          end;
        end;
      end
      else
      begin
        GenerateErrorXML(Format(HospitalInterfaceError, [HospitalCode]), sendXMLNode);
        sfLogger.logMessage(Format(HospitalInterfaceError, [HospitalCode]), '', lgvError);
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
    FreeAndNil(sendXMLNode);
    FreeAndNil(recvXMLNode);
    FreeAndNil(unzipStream);
    FreeAndNil(sendStream);
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
  sfLogger.logMessage(Format('客户端连接成功：【%s】',[GetRemoteInfo]));
end;

procedure TMyTCPClientContext.OnDisconnected;
begin
  inherited;
  sfLogger.logMessage(Format('客户端连接断开：【%s】',[GetRemoteInfo]));
end;

end.
