unit U_GetHisInfoIntf;

interface

uses
  System.Classes,
  System.SysUtils,
  IniFiles,
  qxml,
  utils_safeLogger,
  diocp_tcp_blockClient,
  uRawTcpClientCoderImpl,
  uStreamCoderSocket,
  utils_zipTools,
  uICoderSocket;

type
  PServerInfo = ^TServerInfo;
  TServerInfo = record
    IP: string;
    Port: Integer;
    ReadTimeOut: Integer;
  end;

  TGetHisInfoIntf = class
  private
    FSendStream: TMemoryStream;
    FRecvStream: TMemoryStream;
    FCoderSocket: TRawTcpClientCoderImpl;
    FResultCode: Integer;
    FResultMessage: string;
    FXMLNode: TQXML;
    FLogFile: TLogFileAppender;
    FServerInfo: PServerInfo;
    FTcpClient: TDiocpBlockTcpClient;
    function GetServerInfo: PServerInfo;
    procedure GetServerIPAddress;
    procedure ParseXML(var AXMLData: string);
    function GenerateXml: string;
    function SupplementXml(AXML: string): string;
    function SendRequest: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(ASendData: string;var ARecvData: string);
    property ServerInfo: PServerInfo read GetServerInfo;
  end;

implementation

procedure TGetHisInfoIntf.GetServerIPAddress;
var
  ServerIni: TIniFile;
  IniPath: string;
begin
  IniPath := ExtractFilePath(GetModuleName(HInstance));
  ServerIni := TIniFile.Create(IniPath + 'DIOCPTcpClient.ini');
  try
    FServerInfo^.IP := ServerIni.ReadString('ServerInfo','IP','127.0.0.1');
    FServerInfo^.Port := ServerIni.ReadInteger('ServerInfo','Port', 8080);
    FServerInfo^.ReadTimeOut := ServerIni.ReadInteger('ServerInfo','ReadTimeOut',5);
    sfLogger.logMessage(Format('【服务器信息】IP:%s;Port:%s;ReadTimeOut:%s',
      [FServerInfo^.IP, Inttostr(FServerInfo^.Port), InttoStr(FServerInfo^.ReadTimeOut)]));
  finally
    ServerIni.Free;
  end;
end;

procedure TGetHisInfoIntf.ParseXML(var AXMLData: string);
begin
  FXMLNode.Parse(AXMLData);
end;

function TGetHisInfoIntf.SendRequest: string;
begin
  FTcpClient.Host := FServerInfo^.IP;
  FTcpClient.Port := FserverInfo^.Port;
  FTcpClient.ReadTimeOut := 1000 * 60 * FServerInfo^.ReadTimeOut;
  FSendStream.Clear;
  FRecvStream.Clear;
  FXMLNode.SaveToStream(FSendStream);
  TZipTools.ZipStream(FSendStream, FSendStream);

  FTcpClient.Disconnect;
  FTcpClient.Connect;
  TStreamCoderSocket.SendObject(FCoderSocket as ICoderSocket, FSendStream);
  TStreamCoderSocket.RecvObject(FCoderSocket as ICoderSocket, FRecvStream);
  TZipTools.UnZipStream(FRecvStream, FRecvStream);
  FRecvStream.Position := 0;
  FXMLNode.LoadFromStream(FRecvStream);
  Result := SupplementXml(FXMLNode.AsXML);
end;

function TGetHisInfoIntf.SupplementXml(AXML: string): string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>' + #13+ #10 + AXML;
end;

{ TGetHisInfoIntf }

constructor TGetHisInfoIntf.Create;
begin
  inherited;
  FLogFile := TLogFileAppender.Create(False);
  sfLogger.setAppender(FLogFile);
  FTcpClient := TDiocpBlockTcpClient.Create(nil);
  FCoderSocket := TRawTcpClientCoderImpl.Create(FTcpClient);
  FXMLNode := TQXML.Create;
  New(FServerInfo);

  FSendStream := TMemoryStream.Create;
  FRecvStream := TMemoryStream.Create;
end;

destructor TGetHisInfoIntf.Destroy;
begin
  if Assigned(FCoderSocket) then
    FCoderSocket := nil;
  FTcpClient.Disconnect;
  FreeAndNil(FTcpClient);
  FreeAndNil(FXMLNode);
  FRecvStream.Free;
  FSendStream.Free;
  inherited;
end;

procedure TGetHisInfoIntf.Execute(ASendData: string; var ARecvData: string);
begin
  sfLogger.logMessage('【传入参数ASendData】' + ASendData);

  try
    ParseXML(ASendData);
    GetServerIPAddress;
    ARecvData := SendRequest;
    sfLogger.logMessage('【返回参数ARecvData】' + ARecvData);
  except
    on E: Exception do
    begin
      FResultCode := -1;
      FResultMessage := E.Message;
      ARecvData := GenerateXml;
      sfLogger.logMessage('【返回参数ARecvData】' + ARecvData);
      Exit;
    end;
  end;
end;

function TGetHisInfoIntf.GenerateXml: string;
var
  FChildNode: TQXMLNode;
begin
  FXMLNode.Clear(True);
  FXMLNode := FXMLNode.AddNode('root');
  FChildNode := FXMLNode.AddNode('resultcode');
  FChildNode.Text := IntToStr(FResultCode);
  FChildNode := FXMLNode.AddNode('resultmessage');
  FChildNode.Text := FResultMessage;
  FXMLNode.AddNode('results');
  Result := SupplementXml(FXMLNode.AsXML);
end;

function TGetHisInfoIntf.GetServerInfo: PServerInfo;
begin
  if FServerInfo <> nil then
    Result := FServerInfo
  else
    Result := nil;
end;

end.
