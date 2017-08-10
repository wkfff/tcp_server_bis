{*------------------------------------------------------------------------------
  福州市二与MQ平台接口

  @author  YU
  @version 2017/07/14 1.0 Initial revision.
  @todo
  @comment
-------------------------------------------------------------------------------}
unit uEHSBIntf;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.IniFiles,
  qplugins_base,
  QPlugins,
  qplugins_params,
  qxml,
  ITCPServerIntf,
  uBaseIntf,
  uResource,
  uEwellMqExpts,
  CnDebug,
  qstring,
  EHSBdfrm;

type
  TEHSBInterfaceObject = class(TBaseIntf)
  private
    FConfig: TQXML;
    FSourceSysCode: string;
    FPassword: string;
    FUserName: string;
    FTargetSysCode: string;
    procedure QueryInfo(ARecvXML, ASendXML: TQXMLNode);
  protected
    function GetTestItemResultInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    /// <summary>
    /// 获取病人信息
    /// </summary>
    function GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetTreatmentItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    function GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    /// <summary>
    /// 获取职员信息接口
    /// </summary>
    function GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    /// <summary>
    /// 获取病区信息接口
    /// </summary>
    function GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    /// <summary>
    /// 获取科室信息接口
    /// </summary>
    function GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property SourceSysCode: string read FSourceSysCode write FSourceSysCode;
    property TargetSysCode: string read FTargetSysCode write FTargetSysCode;
  public
    destructor Destroy; override;
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  end;

implementation

const
  HospitalCode = '00001';

destructor TEHSBInterfaceObject.Destroy;
begin
  FreeAndNilObject(FConfig);
  CnDebugger.LogMsg('InterFace.Destroy.00001');
  inherited;
end;

function TEHSBInterfaceObject.ExecuteIntf(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
var
  MQInifile: TIniFile;
begin
  Result := False;
  MQInifile := nil;
  if not Assigned(FConfig) then
    FConfig := TQXML.Create;

  try
    MQInifile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DIOCP_TCP_SERVER_INI_FILE);
    UserName := MQInifile.ReadString(MQSection, 'UserName', '');
    PassWord := MQInifile.ReadString(MQSection, 'PassWord', '');
    SourceSysCode := MQInifile.ReadString(MQSection, 'SourceSysCode', '');
    TargetSysCode := MQInifile.ReadString(MQSection, 'TargetSysCode', '');

    FConfig.LoadFromFile(ExtractFilePath(ParamStr(0))  + '\Config.xml');
    QueryInfo(ARecvXML, ASendXML);
  finally
    FreeAndNilObject(MQInifile);
  end;
  Result := True;
end;

function TEHSBInterfaceObject.GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

procedure TEHSBInterfaceObject.QueryInfo(ARecvXML, ASendXML: TQXMLNode);
var
  AMQ: TMQClass;
  AConfig: TQXMLNode;
  ASendItem: TQXMLNode;
  dtSQL: TdfrmEHSB;
  AItemXML: TQXMLNode;
  ACData: TQXML;
  I: Integer;
  AFieldList: TQXMLNodeList;
  ATemp: TQParams;
  AValue: TQXMLNode;
  AFieldCount: Integer;
  ACDataType: TQParams;
  AOperType: TQParams;
  k: Integer;

  procedure AddParams(AItemName: string; AList: TList<TQParams>);
  var
    ANodeList: TQXMLNodeList;
    I: Integer;
    k: Integer;
    AParams: TQParams;
    ACover: string;
    ATmpList: TQXMLNodeList;

  begin
    ANodeList := nil;
    ATmpList := nil;
    try
      ANodeList := TQXMLNodeList.Create;
      ATmpList := TQXMLNodeList.Create;
      AConfig.ItemByRegex(AItemName ,ANodeList, False);
      for I := 0 to ANodeList.Count - 1 do
      begin
        AParams := TQParams.Create;
        if (ANodeList.Items[I].Attrs.ItemByName('cover') <> nil) then
        begin
          ACover := ANodeList.Items[I].Attrs.ItemByName('cover').Value;
          ATmpList.Clear;
          ARecvXML.ItemByRegex(ACover, ATmpList, True);
          if (ATmpList.Count > 0 ) and (ATmpList[0].Text <> '') then
            AParams.Add('value', ATmpList[0].Text )
          else
          begin
            AParams.Free;
            Continue;
          end;
        end;
        for k := 0 to ANodeList.Items[I].Attrs.Count - 1 do
        begin
          AParams.Add(ANodeList.Items[I].Attrs[k].Name, ANodeList.Items[I].Attrs[k].Value);
        end;
        AList.Add(AParams);
      end;
    finally
      FreeAndNilObject(ATmpList);
      FreeAndNilObject(ANodeList);
    end;
  end;
begin
  AConfig := FConfig.ItemByPath('root.' + (ARecvXML.ItemByPath('interfacemessage.interfacename').Text));
  AMQ := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := AConfig.TextByPath('serviceid', '');
    AMQ.UserName := UserName;
    AMQ.PassWord := Password;
    AMQ.SourceSysCode := SourceSysCode;
    AMQ.TargetSysCode := TargetSysCode;

    AddParams('query', AMQ.QueryItems);
    AddParams('order', AMQ.OrderItems);

    AMQ.Connect(AConfig.AttrValueByPath('MQInfo', 'servername', 'MQMGR1'));
    try
      AMQ.Query;
      if AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '') <> '1' then
      begin
        raise Exception.Create(Format('平台发生错误 - RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      dtSQL := nil;
      ACData := nil;
      AFieldList := nil;
      ACDataType := nil;
      AOperType := nil;
      ATemp := nil;
      try
        dtSQL:= TdfrmEHSB.Create(nil);
        ACData := TQXML.Create;
        dtSQL.TableName := AConfig.TextByPath('tablename', '');
        ACDataType := TQParams.Create;
        AOperType := TQParams.Create;
        ATemp := TQParams.Create;
        AFieldList := TQXMLNodeList.Create;

        AFieldCount := AConfig.ItemByRegex('correspond', AFieldList, False);
        if AFieldCount = 0  then
          raise Exception.Create('Config.xml 缺少correspond节点, 接口:'
            + ARecvXML.ItemByPath('interfacemessage.interfacename').Text);

        with dtSQL do
        begin
          try
            for I := 0 to AFieldCount - 1 do
            begin
              if AFieldList.Items[I].Attrs.ItemByName('flag') <> nil then
              begin
                ConditionList.Add(AFieldList.Items[I].Attrs.ItemByName('key').Value,
                  AFieldList.Items[I].Attrs.ItemByName('value').Value);

                ACDataType.Add(AFieldList.Items[I].Attrs.ItemByName('key').Value,
                  AFieldList.Items[I].Attrs.ItemByName('datatype').Value)
              end;

              FieldList.Add(AFieldList.Items[I].Attrs.ItemByName('key').Value,
                  AFieldList.Items[I].Attrs.ItemByName('value').Value);

              ATemp.Add(AFieldList.Items[I].Attrs.ItemByName('key').Value,
                  AFieldList.Items[I].Attrs.ItemByName('value').Value);

              if AFieldList.Items[I].Attrs.ItemByName('opertype') <> nil then
                AOperType.Add(AFieldList.Items[I].Attrs.ItemByName('key').Value,
                  AFieldList.Items[I].Attrs.ItemByName('opertype').Value)
            end;
          except
            raise Exception.Create('Config.xml 检查 correspond节点 key value 属性, 接口:' +
               ARecvXML.ItemByPath('interfacemessage.interfacename').Text);
          end;

          AItemXML := AMQ.respMsg.ItemByPath('ESBEntry.MsgInfo');
          for I := 0 to AItemXML.Count - 1 do
          begin
            ACData.Parse(AItemXML.Items[I].Text);
            for k := 0 to ATemp.Count - 1 do
            begin
              AValue := ACData.ItemByPath('msg.body.row.' + ATemp.Items[k].AsString);
              if (AValue = nil) and (AOperType.ByName(PChar(ATemp.Items[k].Name)) = nil) then
                raise Exception.Create('Config.xml 检查 correspond节点 value 属性, 接口:'
                  + ARecvXML.ItemByPath('interfacemessage.interfacename').Text
                  + ', key:' + ATemp.Items[k].AsString);

              if AOperType.ByName(PChar(ATemp.Items[k].Name)) = nil then
                FieldList.Items[k].AsString := AValue.Text;

              if ConditionList.ByName(ATemp.Items[k].Name) <> nil then
              begin
                if ACDataType.ByName(ATemp.Items[k].Name).AsString = 'string' then
                  ConditionList.ByName(ATemp.Items[k].Name).AsString := APOSTROPHE + AValue.Text + APOSTROPHE
                else
                  ConditionList.ByName(ATemp.Items[k].Name).AsString := AValue.Text;
              end;
            end;
            PutDataIntoDatabase;
          end;

          ASendItem := ASendXML.AddNode('root');
          ASendItem.AddNode('resultcode').Text := '0';
          ASendItem.AddNode('resultmessage').Text := '成功';
          ASendItem.AddNode('results').Text := '';
        end;

      finally
        FreeAndNilObject(ATemp);
        FreeAndNilObject(AOperType);
        FreeAndNilObject(ACDataType);
        FreeAndNilObject(AFieldList);
        FreeAndNilObject(dtSQL);
        FreeAndNilObject(ACData);
      end;

    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNilObject(AMQ);
  end;
end;

function TEHSBInterfaceObject.GetDeptInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetPateintInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetStaffInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetTestItemResultInfos(ARecvXML, ASendXML:
  TQXMLNode): Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetTreatmentItemInfos(ARecvXML, ASendXML:
  TQXMLNode): Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetWardInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [TEHSBInterfaceObject.Create(ITCPServerInterface,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.



