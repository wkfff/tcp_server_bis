unit uHBTMintf;

interface

uses
  System.SysUtils,
  System.IniFiles,
  qplugins_base,
  QPlugins,
  qxml,
  uTCPServerIntf,
  uBaseIntf,
  uResource,
  uEwellMqExpts,
  utils_safeLogger,
  qstring,
  ICalculateService,
  EHSBdfrm;

type
  THBTMInterfaceObject = class(TBaseIntf)
  private
    FService: ICalculateServicePortType;
  protected
//    function GetTestItemResultInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
//      override;
    /// <summary>
    /// 获取病人信息
    /// </summary>
    function GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    function GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    function GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    function GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    function GetTreatmentItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
//      override;
//    function GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
//      override;
//    /// <summary>
//    /// 获取职员信息接口
//    /// </summary>
//    function GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    /// <summary>
//    /// 获取病区信息接口
//    /// </summary>
//    function GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
//    /// <summary>
//    /// 获取科室信息接口
//    /// </summary>
//    function GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  public
    destructor Destroy; override;
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  end;

implementation

const
  HospitalCode = '00002';

{ THBTMInterfaceObject }

destructor THBTMInterfaceObject.Destroy;
begin
  inherited;
end;

function THBTMInterfaceObject.ExecuteIntf(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
begin
  if not Assigned(FService) then
    FService := GetICalculateServicePortType;
  inherited;
end;

function THBTMInterfaceObject.GetPateintInfos(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
var
  APatientId: string;
  ANums: Integer;
  AInput: TQXML;
  AOut: string;
  AOutPut: TQXML;
  ANode: TQXMLNode;
  dtSQL: TdfrmEHSB;
  I: Integer;
begin
  AInput := nil;
  AOutPut := nil;
  dtSQL := nil;

  APatientId := Trim(ARecvXML.TextByPath('interfacemessage.interfaceparms.patientid', ''));
  if APatientId = '' then
    raise Exception.Create('GetPateintInfos resolve patientid Error patientid is null');
  if not TryStrToInt(ARecvXML.TextByPath('interfacemessage.interfaceparms.patientnumber', ''), ANums) then
    raise Exception.Create('GetPateintInfos resolve Nums Error Can`t TryStrToInt()');

  try
    AInput := TQXML.Create;
    AOutPut := TQXML.Create;
    ANode := AInput.AddNode('funderService');
    ANode.Attrs.Add('functionName').Value := 'xk_queryPatInfo';
    ANode.AddNode('value').Text := APatientId;
    sfLogger.logMessage('webservice入参：' + AInput.Encode(False));
    AOut := FService.funInterFace(AInput.Encode(False));
    sfLogger.logMessage('webservice出参：' + AOut);
    AOutPut.Parse(PWideChar(AOut));

    dtSQL := TdfrmEHSB.Create(nil);
    with dtSQL do
    begin
      dtSQL.TableName := 'patient_getinterface_list_info';
      ANode := AOutPut.ItemByPath('root.result');
      for I := 0 to ANode.Count - 1 do
      begin
        FieldList.Add(ANode.Items[I].Name, ANode.Items[I].Text);
      end;
      FieldList.Add('GetId', ANode.TextByPath('PatientId', '') + '-' + ANode.TextByPath('PatientNumber', '') + '-'  + ANode.TextByPath('InPatientId', ''));
      ConditionList.Add('PatientId', APOSTROPHE + ANode.TextByPath('PatientId', '') + APOSTROPHE);
      ConditionList.Add('PatientNumber', APOSTROPHE + ANode.TextByPath('PatientNumber', '') + APOSTROPHE);
      ConditionList.Add('InPatientId', APOSTROPHE + ANode.TextByPath('InPatientId', '') + APOSTROPHE);
      PutDataIntoDatabase;
    end;

    ANode := ASendXML.AddNode('root');
    ANode.AddNode('resultcode').Text := '0';
    ANode.AddNode('resultmessage').Text := '成功';
    ANode.AddNode('results').Text := '';
  finally
    FreeAndNil(AInput);
    FreeAndNil(AOutPut);
    FreeAndNil(dtSQL);
  end;
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [THBTMInterfaceObject.Create(ITCPServerInterface,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.
