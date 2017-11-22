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
    /// 获取病人信息
    /// </summary>
    function GetPateintInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 医嘱回传接口
    /// </summary>
    function SendClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// 费用回传接口
    /// </summary>
    function SendPatientConsts(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 计费/退费接口
    /// </summary>
    function ChargeFees(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 医嘱删除接口
    /// </summary>
    function DeleteClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// 获取病人最近一次检验结果
    /// </summary>
    function GetTestItemResultInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取检验项目信息
    /// </summary>
    function GetTestItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取诊断信息
    /// </summary>
    function GetDiagnosesInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取手术信息
    /// </summary>
    function GetSurgeryInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取诊疗项目信息
    /// </summary>
    function GetTreatmentItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取收费项目信息
    /// </summary>
    function GetChargeItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取人员信息
    /// </summary>
    function GetStaffInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取病区信息
    /// </summary>
    function GetWardInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    /// <summary>
    /// 获取科室信息
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
  ATemp: string;
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

      if AMethod = 'gettestitemresultinfos' then
        ATemp := '<Root>' + AHisData.Encode(False) + ARecvXML.Encode(False) + '</Root>'
      else
        ATemp := AHisData.Encode(False);
      CnDebugger.LogMsgWithTag(ATemp, 'ResultOfMethod');
      AResult := FPythonEng.ResultOfMethod(AMethod, ATemp);

      AConvert.Parse(AResult);
      objDataBase.ConvertXMLToDB(AConvert);

      ANode := ASendXML.AddNode('root');
      ANode.AddNode('resultcode').Text := '0';
      ANode.AddNode('resultmessage').Text := '成功';
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
var
  AReqArray: TArray<string>;
  AMethod: string;
  ARequisitionIds: string;
  ARoot: TQXMLNode;
  ANode: TQXMLNode;
  AFieldNode: TQXMLNode;

  procedure SendReqOrderByOne(ARequistionId: string);
  var
    AParam: string;
    objDataBase: TdmDatabase;
    I: Integer;
    AData: TQXML;
    AError: string;
    AOrderNum: string;
  begin
    objDataBase := nil;
    AData := nil;
    try
      objDataBase := TdmDatabase.Create(nil);
      AData := TQXML.Create;
      with objDataBase do
      begin
        qryQuery.Connection := BISConnect;
        qryQuery.Open('select * from Clinical_Requisition_Order where RequisitionID = '''+ ARequistionId +''' ');

        if qryQuery.RecordCount <= 0 then
          raise Exception.Create('SendClinicalRequisitionOrder qryQuery Error not found Clinical_Requisition_Order:' + ARequistionId );

        ARoot := AData.AddNode('root');
        qryQuery.First;
        while not qryQuery.Eof do
        begin
          ANode := ARoot.AddNode('record');
          for I := 0 to qryQuery.FieldCount - 1 do
          begin
            AFieldNode := ANode.AddNode(qryQuery.Fields[I].FieldName);
            case qryQuery.Fields[I].DataType of
              ftFloat:
                AFieldNode.Text := FloatToStr(qryQuery.Fields[I].AsFloat);
              ftDateTime, ftTimeStamp:
                AFieldNode.Text := FormatDateTime('yyyy-mm-dd hh:mm:ss',qryQuery.Fields[I].AsDateTime);
              ftInteger:
                AFieldNode.Text := IntToStr(qryQuery.Fields[I].AsInteger);
              ftString:
                AFieldNode.Text := Trim(qryQuery.Fields[I].AsString);
              ftLargeint:
                AFieldNode.Text := IntToStr(qryQuery.Fields[I].AsLargeInt);
              ftBoolean:
                AFieldNode.Text := BoolToStr(qryQuery.Fields[I].AsBoolean);
            else
              AFieldNode.Text := Trim(qryQuery.Fields[I].AsString);
            end;
          end;
          AParam := FPythonEng.ParamOfMethod(AData, AMethod);
          AData.Parse(AParam);
          ARoot := AData.ItemByName('root');
          spHis.Connection := HISConnect;
          for I := 0 to ARoot.Count - 1 do
          begin
            ANode := ARoot.Items[I];
            spHis.ExecProc('YTHIS.PROC_HIS_DOC_ADVICE',[ANode.TextByPath('InPatientId', ''),
              ANode.TextByPath('vdoct_code', ''),
              ANode.TextByPath('vdept_code', ''),
              ANode.TextByPath('vitem_code', ''),
              ANode.TextByPath('doctor_advice', ''),
              strtoint(ANode.TextByPath('v_qty', '1')),
              ANode.TextByPath('apply_num', ''),'','','']);
            AError := spHis.ParamByName('err_msg').AsString;
            if AError <> '' then
              raise Exception.Create(ARequistionId + ' Excute YTHIS.PROC_HIS_DOC_ADVICE Error:' + AError);

            AOrderNum := spHis.ParamByName('Order_num').AsAnsiString;
            CnDebugger.LogMsg(AOrderNum);
            qryQuery.Edit;
            qryQuery.FindField('OrderNo').AsString := AOrderNum;
            qryQuery.FindField('OrderStatus').AsInteger := 2;
            qryQuery.Post;
          end;
          AData.Clear;
          ARoot := AData.AddNode('root');
          qryQuery.Next;
        end;

      end;
    finally
      FreeAndNil(AData);
      FreeAndNil(objDataBase);
    end;
  end;
var
  I: Integer;

begin

  AMethod := ARecvXML.TextByPath('interfacemessage.interfacename', '');
  ARequisitionIds :=  ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid', '');
  if Trim(ARequisitionIds) = '' then
    raise Exception.Create('SendClinicalRequisitionOrder Error requisitionid is null');

  AReqArray := ARequisitionIds.Split([',']);

  try
    for I := 0 to Length(AReqArray) - 1 do
    begin
      SendReqOrderByOne(AReqArray[I]);
    end;
  finally
    SetLength(AReqArray, 0);
  end;
  ANode := ASendXML.AddNode('root');
  ANode.AddNode('resultcode').Text := '0';
  ANode.AddNode('resultmessage').Text := '成功';
  ANode.AddNode('results');
  Result := True;
end;

function TZXHospitalInterfaceObject.SendPatientConsts(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [TZXHospitalInterfaceObject.Create(IHospitalBISService,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.
