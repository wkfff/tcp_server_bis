unit ServiceZXHospital;

interface

uses
  System.SysUtils,
  System.Variants,
  Data.DB,
  System.TypInfo,
  System.DateUtils,
  qplugins_base,
  QPlugins,
  qxml,
  qstring,
  QWorker,
  CnDebug,
  DataBasedm,
  IHospitalBISServiceIntf,
  YltShareVariable,
  IPythonScriptServiceIntf;

type
  TZXHospitalInterfaceObject = class(TQService, IHospitalBISService)
  private
    FPythonEng: IPythonScriptService;
    function GetBaseDataFromTableView(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetTableNameByClass(AClass: string): string;
  protected
    /// <summary>
    /// ��ȡ������Ϣ
    /// </summary>
    function GetPateintInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ҽ���ش��ӿ�
    /// </summary>
    function SendClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// ���ûش��ӿ�
    /// </summary>
    function SendPatientConsts(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// �Ʒ�/�˷ѽӿ�
    /// </summary>
    function ChargeFees(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ҽ��ɾ���ӿ�
    /// </summary>
    function DeleteClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// ��ȡ�������һ�μ�����
    /// </summary>
    function GetTestItemResultInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ������Ŀ��Ϣ
    /// </summary>
    function GetTestItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ�����Ϣ
    /// </summary>
    function GetDiagnosesInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ������Ϣ
    /// </summary>
    function GetSurgeryInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ������Ŀ��Ϣ
    /// </summary>
    function GetTreatmentItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ�շ���Ŀ��Ϣ
    /// </summary>
    function GetChargeItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ��Ա��Ϣ
    /// </summary>
    function GetStaffInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ������Ϣ
    /// </summary>
    function GetWardInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// ��ȡ������Ϣ
    /// </summary>
    function GetDeptInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
  public
    constructor Create(const AId: TGUID; AName: QStringW); override;
    destructor Destroy; override;
  end;

implementation

const
  HospitalCode = '00003';

function TZXHospitalInterfaceObject.ChargeFees(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

constructor TZXHospitalInterfaceObject.Create(const AId: TGUID;
  AName: QStringW);
begin
  inherited;
  FPythonEng := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
end;

function TZXHospitalInterfaceObject.DeleteClinicalRequisitionOrder(
  const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

destructor TZXHospitalInterfaceObject.Destroy;
begin
  FPythonEng := nil;
  inherited;
end;

function TZXHospitalInterfaceObject.GetTableNameByClass(AClass: string): string;
begin
  if AClass = 'getpateintinfos' then
    Result := 'patient_getinterface_list_info'
  else if AClass = 'gettreatmentiteminfos' then
    Result := 'his_treatmentitem_info'
  else if AClass = 'getchargeiteminfos' then
    Result := 'his_chargeitem_info'
  else if AClass = 'getdeptinfos' then
    Result := 'his_dept_info'
  else if AClass = 'gettestitemresultinfos' then
    Result := 'patient_getinterface_result_info'
  else if AClass = 'getstaffinfos' then
    Result := 'his_staff_info'
  else if AClass = 'getwardinfos' then
    Result := 'his_ward_info'
  else if AClass = 'getsurgeryinfos' then
    Result := 'his_surgery_info'
  else if AClass = 'getdiagnosesinfos' then
    Result := 'his_diagnoses_info'
  else if AClass = 'sendclinicalrequisitionorder' then
    Result := 'clinical_requisition_order'
  else if AClass = 'chargefees' then
    Result := 'ins_charge_list_infos'
  else if AClass = 'deleteclinicalrequisitionorder' then
    Result := 'clinical_requisition_order'

end;

function TZXHospitalInterfaceObject.GetBaseDataFromTableView(
  const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
var
  AMethod: string;
  ASql: string;
  AResult: string;
  objDataBase: TdmDatabase;
  AHisData: TQXML;
  AConvert: TQXML;
  ARoot: TQXMLNode;
  ANode: TQXMLNode;
  AFieldNode: TQXMLNode;
  I: Integer;
  ARowNum: Integer;
begin
  AMethod := ARecvXML.TextByPath('interfacemessage.interfacename', '');
  objDataBase := nil;
  AHisData := nil;
  AConvert := nil;
  try
    ASql := FPythonEng.ParamOfMethod(ARecvXML, AMethod);
    objDataBase := TdmDatabase.Create(nil);
    objDataBase.TableName := GetTableNameByClass(AMethod);
    AHisData := TQXML.Create;
    AConvert := TQXML.Create;
    ARoot := AHisData.AddNode('root');

    with objDataBase.qryHis do
    begin
      Connection := HISConnect;
      Open(ASql);

      if RecordCount <= 0 then
        raise Exception.Create('GetBaseDataFromTableView Error: not found his base data');
      First;
      ARowNum := 0;
      while not Eof do
      begin
        ANode := ARoot.AddNode('record');
        for I := 0 to FieldCount - 1 do
        begin
          AFieldNode := ANode.AddNode(Fields[I].FieldName);
          case Fields[I].DataType of
            ftFloat:
              AFieldNode.Text := FloatToStr(Fields[I].AsFloat);
            ftDateTime, ftTimeStamp:
              AFieldNode.Text := FormatDateTime('yyyy-mm-dd hh:mm:ss',Fields[I].AsDateTime);
            ftInteger:
              AFieldNode.Text := IntToStr(Fields[I].AsInteger);
            ftString:
              AFieldNode.Text := Trim(Fields[I].AsString);
            ftLargeint:
              AFieldNode.Text := IntToStr(Fields[I].AsLargeInt);
            ftBoolean:
              AFieldNode.Text := BoolToStr(Fields[I].AsBoolean);
          else
            AFieldNode.Text := Trim(Fields[I].AsString);
          end;
        end;
        Inc(ARowNum);
        if ARowNum > 100 then
        begin
          ARowNum := 0;
          AResult := FPythonEng.ResultOfMethod(AMethod, AHisData.Encode(False));
          AConvert.Parse(AResult);
          objDataBase.ConvertXMLToDB(AConvert);
          AHisData.Clear;
          ARoot := AHisData.AddNode('root');
        end;
        Next;
      end;

      AResult := FPythonEng.ResultOfMethod(AMethod, AHisData.Encode(False));

      AConvert.Parse(AResult);
      objDataBase.ConvertXMLToDB(AConvert);

      ANode := ASendXML.AddNode('root');
      ANode.AddNode('resultcode').Text := '0';
      ANode.AddNode('resultmessage').Text := '�ɹ�';
      ANode.AddNode('results');
    end;
  finally
    FreeAndNil(AConvert);
    FreeAndNil(AHisData);
    FreeAndNil(objDataBase);
  end;
  Result := True;
end;

function TZXHospitalInterfaceObject.GetChargeItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetDeptInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetDiagnosesInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetPateintInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetStaffInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetSurgeryInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetTestItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetTestItemResultInfos(
  const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetTreatmentItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetWardInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetBaseDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.SendClinicalRequisitionOrder(
  const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

function TZXHospitalInterfaceObject.SendPatientConsts(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

initialization
// ע�� Services/Interface ����
  RegisterServices('Services/Interface', [TZXHospitalInterfaceObject.Create(IHospitalBISService,
    HospitalCode)]);

finalization
// ȡ������ע��
  UnregisterServices('Services/Interface', [HospitalCode]);

end.
