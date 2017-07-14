
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
  System.IniFiles,
  QPlugins,
  qplugins_params,
  qxml,
  uTCPServerIntf,
  uBaseIntf,
  uResource,
  uEwellMqExpts,
  EHSBdfrm;

type
  TEHSBInterfaceObject = class(TBaseIntf)
  private
    function GetTestItemResultInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    function GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetTreatmentItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    function GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
      override;
    function GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    /// <summary>
    /// 获取病区信息接口
    /// </summary>
    /// <param name="ARecvXML">接收的XML</param>
    /// <param name="ASendXML">发送的XML</param>
    /// <returns>Boolean</returns>
    function GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    function GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    procedure InsertDataIntoDataBase(AData: TQXMLNode);
  end;

implementation

const
  HospitalCode = '00001';
  MQSection = 'ESBEntry';

{ TEHSBInterfaceObject }

function TEHSBInterfaceObject.GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetDeptInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetPateintInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetStaffInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetTestItemResultInfos(ARecvXML, ASendXML:
  TQXMLNode): Boolean;
begin
  inherited;

end;

function TEHSBInterfaceObject.GetTreatmentItemInfos(ARecvXML, ASendXML:
  TQXMLNode): Boolean;
begin
  inherited;

end;

procedure TEHSBInterfaceObject.InsertDataIntoDataBase(AData: TQXMLNode);
var
  dtWard: TdfrmEHSB;
  AItemXML: TQXML;
  ACData: TQXML;
  I: Integer;
begin
  AItemXML := AData.ItemByPath('ESBEntry.MsgInfo');
  dtWard := nil;
  ACData := nil;
  try
    dtWard := TdfrmEHSB.Create(nil);
    ACData := TQXML.Create;
    with dtWard do
    begin
      conBIS.Connected := True;

      qryWard.Params.ArraySize := AItemXML.Count;
      for I := 0 to AItemXML.Count - 1 do
      begin
        ACData.Parse(AItemXML.Items[I].Items[0].Text);
        qryWard.Params.ParamByName('WardName').AsStrings[I] :=
          ACData.TextByPath('msg.body.row.WARD_NAME', '');
        qryWard.Params.ParamByName('WardCode').AsStrings[I] :=
          ACData.TextByPath('msg.body.row.WARD_CODE', '');
        qryWard.Params.ParamByName('SpellCode').AsStrings[I] :=
          ACData.TextByPath('msg.body.row.PINYIN_CODE', '');
        qryWard.Params.ParamByName('TelephoneNumber').AsStrings[I] :=
          '';
        qryWard.Params.ParamByName('Remark').AsStrings[I] :=
          ACData.TextByPath('msg.body.row.MEMO', '');;
        qryWard.Params.ParamByName('Registered').AsIntegers[I] := 0;
      end;
      qryWard.Execute(qryWard.Params.ArraySize);
    end;
  finally
    FreeAndNil(ACData);
    FreeAndNil(dtWard);
  end;
end;

function TEHSBInterfaceObject.GetWardInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
var
  AMQ: TMQClass;
  ServerIni: TIniFile;
  ASendItem: TQXML;
  AParam: TQParams;
begin
  AMQ := nil;
  ServerIni := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := 'MS02002';
    ServerIni := TIniFile.Create(DIOCP_TCP_SERVER_INI_FILE);
    AMQ.UserName := ServerIni.ReadString(MQSection, 'UserName', '');
    AMQ.PassWord := ServerIni.ReadString(MQSection, 'PassWord', '');
    AMQ.SourceSysCode := ServerIni.ReadString(MQSection, 'SourceSysCode', '');
    AMQ.TargetSysCode := ServerIni.ReadString(MQSection, 'TargetSysCode', '');

    AParam := TQParams.Create;
    AParam.Add('item', 'WARD_INDEX_NO');
    AParam.Add('compy', '=');
    AParam.Add('value', '400201 or 1=1');
    AParam.Add('splice', 'and');
    AMQ.QueryItems.Add(AParam);

    AParam := TQParams.Create;
    AParam.Add('item', '');
    AParam.Add('sort', '');
    AMQ.OrderItems.Add(AParam);

    AMQ.Connect;
    try
      AMQ.Query;

      if AMQ.respMsg.TextByPath('ESBEntry.MsgCount', '') = '0' then
      begin
        raise Exception.Create(Format('RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      InsertDataIntoDataBase(AMQ.respMsg);

      ASendItem := ASendXML.AddNode('root');
      ASendItem.AddNode('resultcode').Text := '0';
      ASendItem.AddNode('resultmessage').Text := '成功';
      ASendItem.AddNode('results').Text := '';
    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNil(ServerIni);
    FreeAndNil(AMQ);
  end;
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [TEHSBInterfaceObject.Create(ITCPServerInterface,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.

