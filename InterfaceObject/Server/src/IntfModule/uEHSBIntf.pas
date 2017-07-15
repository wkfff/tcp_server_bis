
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
    function AddParams(AName, AValue: array of string): TQParams;
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
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  end;

implementation

const
  HospitalCode = '00001';

{ TEHSBInterfaceObject }

function TEHSBInterfaceObject.ExecuteIntf(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
var
  MQInifile: TIniFile;
begin
  Result := False;
  MQInifile := nil;
  try
    MQInifile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DIOCP_TCP_SERVER_INI_FILE);
    UserName := MQInifile.ReadString(MQSection, 'UserName', '');
    PassWord := MQInifile.ReadString(MQSection, 'PassWord', '');
    SourceSysCode := MQInifile.ReadString(MQSection, 'SourceSysCode', '');
    TargetSysCode := MQInifile.ReadString(MQSection, 'TargetSysCode', '');
  finally
    FreeAndNilObject(MQInifile);
  end;
  Result := True;
  inherited;
end;

function TEHSBInterfaceObject.GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

procedure TEHSBInterfaceObject.QueryInfo(ARecvXML, ASendXML: TQXMLNode);
var
  AMQ: TMQClass;
begin

end;

function TEHSBInterfaceObject.GetDeptInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
var
  AMQ: TMQClass;
  ASendItem: TQXML;

  dtSQL: TdfrmEHSB;
  AItemXML: TQXML;
  ACData: TQXML;
  I: Integer;
begin
  AMQ := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := 'MS02001';
    AMQ.UserName := UserName;
    AMQ.PassWord := Password;
    AMQ.SourceSysCode := SourceSysCode;
    AMQ.TargetSysCode := TargetSysCode;

    AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['DEPT_INDEX_NO','=','100 or 1= 1','and']));

    AMQ.OrderItems.Add(AddParams(['item', 'sort'],[]));

    AMQ.Connect;
    try
      AMQ.Query;

      if AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '') <> '1' then
      begin
        raise Exception.Create(Format('平台错误 RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      dtSQL := nil;
      ACData := nil;
      try
        dtSQL:= TdfrmEHSB.Create(nil);
        ACData := TQXML.Create;
        AItemXML := AMQ.respMsg.ItemByPath('ESBEntry.MsgInfo');

        with dtSQL do
        begin
          FieldList := AddParams(['DeptCode','DeptName','SpellCode','TelephoneNumber','Remark','Registered'],
                                       ['DeptCode','DeptName','SpellCode','TelephoneNumber','Remark','Registered']);
          TableName := 'His_Dept_Info';
          for I := 0 to AItemXML.Count - 1 do
          begin
            ACData.Parse(AItemXML.Items[I].Items[0].Text);

            ConditionList := AddParams(['DeptCode'],
              [ APOSTROPHE + ACData.TextByPath('msg.body.row.DEPT_CODE', '') + APOSTROPHE]);

            ValueList := AddParams(['DeptCode','DeptName','SpellCode','TelephoneNumber','Remark','Registered'],
              [
                ACData.TextByPath('msg.body.row.DEPT_CODE', ''),
                ACData.TextByPath('msg.body.row.DEPT_NAME', ''),
                ACData.TextByPath('msg.body.row.PINYIN_CODE', ''),
                ACData.TextByPath('msg.body.row.DEPT_PHONE_NO', ''),
                ACData.TextByPath('msg.body.row.NOTE', ''),
                '0'
              ]);
            PutDataIntoDatabase;
          end;
        end;

      finally
        FreeAndNilObject(ACData);
        FreeAndNilObject(dtSQL);
      end;
      ASendItem := ASendXML.AddNode('root');
      ASendItem.AddNode('resultcode').Text := '0';
      ASendItem.AddNode('resultmessage').Text := '成功';
      ASendItem.AddNode('results').Text := '';
    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNilObject(AMQ);
  end;
  Result := True;
end;

function TEHSBInterfaceObject.GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := True;
end;

function TEHSBInterfaceObject.GetPateintInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
var
  AMQ: TMQClass;
  ASendItem: TQXML;
  AParams: TQParams;
  AValue: string;

  dtSQL: TdfrmEHSB;
  AItemXML: TQXML;
  ACData: TQXML;
  I: Integer;
begin
  AMQ := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := 'BS10001';
    AMQ.UserName := UserName;
    AMQ.PassWord := Password;
    AMQ.SourceSysCode := SourceSysCode;
    AMQ.TargetSysCode := TargetSysCode;

    AValue := ARecvXML.TextByPath('interfacemessage.interfaceparms.patientid','');
    if AValue <> '' then
      AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['MR_NO','=',APOSTROPHE + AValue + APOSTROPHE,'and']));

    AValue := ARecvXML.TextByPath('interfacemessage.interfaceparms.inpatientid','');
    if AValue <> '' then
      AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['INHOSP_INDEX_NO','=',APOSTROPHE + AValue + APOSTROPHE,'and']));

    AValue := ARecvXML.TextByPath('interfacemessage.interfaceparms.patientnumber','');
    if AValue <> '' then
      AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['VISIT_CARD_NO','=',APOSTROPHE + AValue + APOSTROPHE,'and']));


    AMQ.OrderItems.Add(AddParams(['item', 'sort'],[]));

    AMQ.Connect;
    try
      AMQ.Query;

      if AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '') <> '1' then
      begin
        raise Exception.Create(Format('平台错误 RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      dtSQL := nil;
      ACData := nil;
      try
        dtSQL:= TdfrmEHSB.Create(nil);
        ACData := TQXML.Create;
        AItemXML := AMQ.respMsg.ItemByPath('ESBEntry.MsgInfo');

        with dtSQL do
        begin
          FieldList := AddParams(['PatientId','GetId','PatientNumber','PatientName',
            'PatientSex','PatientAge','IdCardNo','Address','MobilePhoneNo','TelePhoneNo',
            'CompanyName','DiagnosesID','Diagnoses','InHospitalTime','DeptCode',
            'DeptName','WardCode','WardName','BedNo','InPatientId','GetTime'],
            ['PatientId','GetId','PatientNumber','PatientName',
            'PatientSex','PatientAge','IdCardNo','Address','MobilePhoneNo','TelePhoneNo',
            'CompanyName','DiagnosesID','Diagnoses','InHospitalTime','DeptCode',
            'DeptName','WardCode','WardName','BedNo','InPatientId','GetTime']);

          TableName := 'Patient_GetInterface_List_Info';

          for I := 0 to AItemXML.Count - 1 do
          begin
            ACData.Parse(AItemXML.Items[I].Items[0].Text);

            ConditionList := AddParams(['GetId'],
              [ APOSTROPHE + ACData.TextByPath('msg.body.row.INHOSP_NO', '') + APOSTROPHE]);

            ValueList := AddParams(['PatientId','GetId','PatientNumber','PatientName',
            'PatientSex','PatientAge','IdCardNo','Address','MobilePhoneNo','TelePhoneNo',
            'CompanyName','DiagnosesID','Diagnoses','InHospitalTime','DeptCode',
            'DeptName','WardCode','WardName','BedNo','InPatientId','GetTime'],
              [
                ACData.TextByPath('msg.body.row.MR_NO', ''),
                ACData.TextByPath('msg.body.row.INHOSP_NO', ''),
                ACData.TextByPath('msg.body.row.PAT_INDEX_NO', ''),
                ACData.TextByPath('msg.body.row.PAT_NAME', ''),
                ACData.TextByPath('msg.body.row.PHYSI_SEX_CODE', ''),
                ACData.TextByPath('msg.body.row.AGE', ''),
                ACData.TextByPath('msg.body.row.ID_NUMBER', ''),
                ACData.TextByPath('msg.body.row.CONTACT_ADDR', ''),
                ACData.TextByPath('msg.body.row.PHONE_NO', ''),
                ACData.TextByPath('msg.body.row.PHONE_NO_HOME', ''),
                ACData.TextByPath('msg.body.row.COMPANY', ''),
                ACData.TextByPath('msg.body.row.ADMIT_DIAG_CODE', ''),
                ACData.TextByPath('msg.body.row.ADMIT_DIAG_NAME', ''),
                ACData.TextByPath('msg.body.row.ADMIT_DATE', ''),
                ACData.TextByPath('msg.body.row.CURR_DEPT_CODE', ''),
                ACData.TextByPath('msg.body.row.CURR_DEPT_NAME', ''),
                ACData.TextByPath('msg.body.row.CURR_WARD_CODE', ''),
                ACData.TextByPath('msg.body.row.CURR_WARD_NAME', ''),
                ACData.TextByPath('msg.body.row.CURR_BED_INDEX_NO', ''),
                ACData.TextByPath('msg.body.row.INHOSP_INDEX_NO', ''),
                FormatDateTime('yyyymmddhhmmss', Now)
              ]);
            PutDataIntoDatabase;
          end;
        end;

      finally
        FreeAndNilObject(ACData);
        FreeAndNilObject(dtSQL);
      end;

      ASendItem := ASendXML.AddNode('root');
      ASendItem.AddNode('resultcode').Text := '0';
      ASendItem.AddNode('resultmessage').Text := '成功';
      ASendItem.AddNode('results').Text := '';
    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNilObject(AMQ);
  end;
  Result := True;
end;

function TEHSBInterfaceObject.GetStaffInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
var
  AMQ: TMQClass;
  ASendItem: TQXML;

  dtSQL: TdfrmEHSB;
  AItemXML: TQXML;
  ACData: TQXML;
  I: Integer;
begin
  AMQ := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := 'MS02003';
    AMQ.UserName := UserName;
    AMQ.PassWord := Password;
    AMQ.SourceSysCode := SourceSysCode;
    AMQ.TargetSysCode := TargetSysCode;

    AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['STAFF_INDEX_NO','=','''jp'' or 1= 1','and']));

    AMQ.OrderItems.Add(AddParams(['item', 'sort'],[]));

    AMQ.Connect;
    try
      AMQ.Query;

      if AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '') <> '1' then
      begin
        raise Exception.Create(Format('平台错误 RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      dtSQL := nil;
      ACData := nil;
      try
        dtSQL:= TdfrmEHSB.Create(nil);
        ACData := TQXML.Create;
        AItemXML := AMQ.respMsg.ItemByPath('ESBEntry.MsgInfo');

        with dtSQL do
        begin
          FieldList := AddParams(['User_Name','SpellCode','User_Sex','User_Phone','User_Email','User_Ward',
                          'User_Dept','User_Level','User_Type','User_Id'
                          ,'User_No'],
                          ['STAFF_NAME','PINYIN_CODE','PHYSI_SEX_CODE','PHONE_NO','EMAIL','WARD_CODE',
                          'SUBOR_DEPT_CODE','TITLE_LEVEL_CODE','STAFF_CATEG_CODE','LOGIN_NAME'
                          ,'STAFF_CODE']);

          TableName := 'His_Staff_Info';

          for I := 0 to AItemXML.Count - 1 do
          begin
            ACData.Parse(AItemXML.Items[I].Items[0].Text);

            ConditionList := AddParams(['User_No', 'User_Id'],
              [ APOSTROPHE + ACData.TextByPath('msg.body.row.STAFF_CODE', '') + APOSTROPHE,
                APOSTROPHE + ACData.TextByPath('msg.body.row.LOGIN_NAME', '') + APOSTROPHE]);

            ValueList := AddParams(['STAFF_NAME','PINYIN_CODE','PHYSI_SEX_CODE','PHONE_NO','EMAIL','WARD_CODE',
                          'SUBOR_DEPT_CODE','TITLE_LEVEL_CODE','STAFF_CATEG_CODE','LOGIN_NAME'
                          ,'STAFF_CODE'],
              [
                ACData.TextByPath('msg.body.row.STAFF_NAME', ''),
                ACData.TextByPath('msg.body.row.PINYIN_CODE', ''),
                ACData.TextByPath('msg.body.row.PHYSI_SEX_CODE', ''),
                ACData.TextByPath('msg.body.row.PHONE_NO', ''),
                ACData.TextByPath('msg.body.row.EMAIL', ''),
                ACData.TextByPath('msg.body.row.WARD_CODE', ''),
                ACData.TextByPath('msg.body.row.SUBOR_DEPT_CODE', ''),
                ACData.TextByPath('msg.body.row.TITLE_LEVEL_CODE', ''),
                ACData.TextByPath('msg.body.row.STAFF_CATEG_CODE', ''),
                ACData.TextByPath('msg.body.row.LOGIN_NAME', ''),
                ACData.TextByPath('msg.body.row.STAFF_CODE', '')
              ]);
            PutDataIntoDatabase;
          end;
        end;

      finally
        FreeAndNilObject(ACData);
        FreeAndNilObject(dtSQL);
      end;
      ASendItem := ASendXML.AddNode('root');
      ASendItem.AddNode('resultcode').Text := '0';
      ASendItem.AddNode('resultmessage').Text := '成功';
      ASendItem.AddNode('results').Text := '';
    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNilObject(AMQ);
  end;
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

function TEHSBInterfaceObject.AddParams(AName, AValue: array of string): TQParams;
var
  AParams: TQParams;
  I: Integer;
begin
  AParams := TQParams.Create;
  for I := 0 to High(AName) do
  begin
    if I <= High(AValue) then
      AParams.Add(AName[I], AValue[I])
    else
      AParams.Add(AName[I], '');
  end;
  Result := AParams;
end;

function TEHSBInterfaceObject.GetWardInfos(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
var
  AMQ: TMQClass;
  ASendItem: TQXML;

  dtSQL: TdfrmEHSB;
  AItemXML: TQXML;
  ACData: TQXML;
  I: Integer;
begin
  AMQ := nil;
  try
    AMQ := TMQClass.Create;
    AMQ.ServiceId := 'MS02002';
    AMQ.UserName := UserName;
    AMQ.PassWord := Password;
    AMQ.SourceSysCode := SourceSysCode;
    AMQ.TargetSysCode := TargetSysCode;

    AMQ.QueryItems.Add(AddParams(['item', 'compy', 'value', 'splice'],
                                ['WARD_INDEX_NO','=','400201 or 1= 1','and']));

    AMQ.OrderItems.Add(AddParams(['item', 'sort'],[]));

    AMQ.Connect;
    try
      AMQ.Query;

      if AMQ.respMsg.TextByPath('ESBEntry.MsgCount', '') = '0' then
      begin
        raise Exception.Create(Format('平台错误 RetCode：%s，RetCon：%s',
          [AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCode','0'),
            AMQ.respMsg.TextByPath('ESBEntry.RetInfo.RetCon','错误')]));
      end;

      dtSQL := nil;
      ACData := nil;
      try
        dtSQL:= TdfrmEHSB.Create(nil);
        ACData := TQXML.Create;
        AItemXML := AMQ.respMsg.ItemByPath('ESBEntry.MsgInfo');

        with dtSQL do
        begin
          FieldList := AddParams(['WardName','WardCode','SpellCode','Remark','Registered'],
                                       ['WardName','WardCode','SpellCode','Remark','Registered']);
          TableName := 'His_Ward_Info';

          for I := 0 to AItemXML.Count - 1 do
          begin
            ACData.Parse(AItemXML.Items[I].Items[0].Text);
            ConditionList := AddParams(['WardCode'],
              [ APOSTROPHE + ACData.TextByPath('msg.body.row.WARD_CODE', '') + APOSTROPHE]);
            ValueList := AddParams(['WardName','WardCode','SpellCode','Remark','Registered'],
              [
                ACData.TextByPath('msg.body.row.WARD_NAME', ''),
                ACData.TextByPath('msg.body.row.WARD_CODE', ''),
                ACData.TextByPath('msg.body.row.PINYIN_CODE', ''),
                ACData.TextByPath('msg.body.row.MEMO', ''),
                '0'
              ]);
            PutDataIntoDatabase;
          end;
        end;

      finally
        FreeAndNilObject(ACData);
        FreeAndNilObject(dtSQL);
      end;
      ASendItem := ASendXML.AddNode('root');
      ASendItem.AddNode('resultcode').Text := '0';
      ASendItem.AddNode('resultmessage').Text := '成功';
      ASendItem.AddNode('results').Text := '';
    finally
      AMQ.DisConnect;
    end;
  finally
    FreeAndNilObject(AMQ);
  end;
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


