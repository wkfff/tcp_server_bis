{*------------------------------------------------------------------------------
  福州市二接口

  @author  YU
  @version 2017/09/05 1.0 Initial revision.
  @todo
  @comment
-------------------------------------------------------------------------------}
unit ServiceFZSE;

interface

uses
  System.SysUtils,
  System.Variants,
  Data.DB,
  System.TypInfo,
  qplugins_base,
  QPlugins,
  qxml,
  qstring,
  QWorker,
  CnDebug,
  IHospitalBISServiceIntf,
  YltShareVariable,
  EwellMqExpts,
  IPythonScriptServiceIntf;

type
  TFZSEInterfaceObject = class(TQService, IHospitalBISService)
  private
    function GetTableNameByClass(AClass: string): string;
    procedure DoGetChargeItemJob(AJob: PQJob);
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
    /// 医嘱删除接口
    /// </summary>
    function DeleteClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// 获取病人最近一次检验结果
    /// </summary>
    function GetTestItemResultInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
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
    function QueryHisInfos(const AClass: string; const ARecvXML: TQXML; var
      ASendXML: TQXML): Boolean;
  public
    constructor Create(const AId: TGUID; AName: QStringW); override;
    destructor Destroy; override;
  end;

implementation

uses
  DataBasedm;

const
  HospitalCode = '00001';

{ TFZSEInterfaceObject }

constructor TFZSEInterfaceObject.Create(const AId: TGUID; AName: QStringW);
begin
  inherited;

end;

function TFZSEInterfaceObject.DeleteClinicalRequisitionOrder(const ARecvXML:
  TQXML; var ASendXML: TQXML): Boolean;
var
  dmDB: TdmDatabase;
  ASql: string;
  RequisitionID: string;
  AFormatXml: TQXML;
  ANode: TQXMLNode;
  AChild: TQXMLNode;
  I: Integer;
  AValue: string;
  APy: IPythonScriptService;
  ATemp: UnicodeString;
  AMq: TMQClass;
  OrderId: string;
begin
  RequisitionID := ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid',
    '');
  if RequisitionID = '' then
    raise Exception.Create('DeleteClinicalRequisitionOrder Error Message: requisitionid is null');
  dmDB := nil;
  AFormatXml := nil;
  AMq := nil;
  try
    AMq := TMQClass.Create;
    dmDB := TdmDatabase.Create(nil);
    ASql :=
      'SELECT * FROM clinical_requisition_order WHERE RequisitionID  = ''%s'' order by OrderType';
    ASql := Format(ASql, [RequisitionID]);
    AFormatXml := TQXML.Create;

    with dmDB do
    begin
      qryExcute.Connection := BISConnect;
      qryExcute.Open(ASql);
      if qryExcute.RecordCount = 0 then
        raise Exception.Create('qryExcute.Open Error Message:not found requisition '
          + RequisitionID);
      qryExcute.First;
      APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
      while not qryExcute.Eof do
      begin
        ANode := AFormatXml.AddNode('root');
        AChild := ANode.AddNode('Requisition');
        for I := 0 to qryExcute.FieldCount - 1 do
        begin
          case qryExcute.Fields[I].DataType of
            ftInteger:
              AValue := IntToStr(qryExcute.Fields[I].AsInteger);
            ftString:
              AValue := qryExcute.Fields[I].AsString;
            ftDateTime:
              AValue := FormatDateTime('yyyy-mm-dd hh:mm:ss', qryExcute.Fields[I].AsDateTime);
            ftFloat:
              AValue := FloatToStr(qryExcute.Fields[I].AsFloat);
          else
            AValue := VarToStrDef(qryExcute.Fields[I].Value, '');
          end;
          AChild.AddNode(qryExcute.Fields[I].FieldName).Text := AValue;
          if qryExcute.Fields[I].FieldName = 'OrderID' then
            if OrderId = '' then
              OrderId := VarToStrDef(qryExcute.Fields[I].Value, '')
            else
              OrderId := OrderId + ';' + VarToStrDef(qryExcute.Fields[I].Value, '');
        end;

        ATemp := APy.ParamOfMethod(AFormatXml, ARecvXML.TextByPath('interfacemessage.interfacename',
          ''));

        AMq.Connect;
        AFormatXml.Parse(ATemp);
        AMq.ServiceId := AFormatXml.TextByPath('ESBEntry.AccessControl.Fid', '');
        AMq.QueryByParam(ATemp);

        ATemp := AMq.respMsg.TextByPath('ESBEntry.MsgInfo.Msg', '');
        AFormatXml.Parse(ATemp);
        if AFormatXml.TextByPath('msg.body.row.MsgInfo.Msg.ErrorCode', '') <> '0' then
        begin
          raise Exception.Create('MQService BS50001 Error:' + AFormatXml.TextByPath
            ('msg.body.row.MsgInfo.Msg.ErrorInfo', ''));
          Exit;
        end;

        ATemp := APy.ResultOfMethod('deleteclinicalrequisitionorder', OrderId);
        AFormatXml.Parse(ATemp);
        TableName := GetTableNameByClass('deleteclinicalrequisitionorder');
        ConvertXMLToDB(AFormatXml);

        OrderId := '';
        AFormatXml.Clear;

        qryExcute.Next;
      end;

      AChild := ASendXML.AddNode('root');
      AChild.AddNode('resultcode').Text := '0';
      AChild.AddNode('resultmessage').Text := '成功';
      AChild.AddNode('results');
    end;
  finally
    FreeAndNilObject(AFormatXml);
    FreeAndNilObject(dmDB);
    FreeAndNilObject(AMq);
  end;
end;

destructor TFZSEInterfaceObject.Destroy;
begin

  inherited;
end;

procedure TFZSEInterfaceObject.DoGetChargeItemJob(AJob: PQJob);
var
  ARecvXML: TQXML;
  AMq: TMQClass;
  APy: IPythonScriptService;
  ADB: TdmDatabase;
  AReturn: string;
  AReturnXML: TQXML;
  AXml: TQXML;
  ASendItem: TQXMLNode;
  ATemp: string;
begin
  AMq := nil;
  APy := nil;
  ADB := nil;
  AXml := nil;
  AReturnXML := nil;
  ARecvXML := TQXML(AJob.Data);

  CnDebug.CnDebugger.LogMsg(ARecvXML.Encode(False));

  try
    try
      AMq := TMQClass.Create;

      AXml := TQXML.Create;

      APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
      CnDebug.CnDebugger.LogMsg('PythonScript ParamOfMethod');
      ATemp := APy.ParamOfMethod(ARecvXML, ARecvXML.TextByPath('interfacemessage.interfacename',
        ''));

      AXml.Parse(ATemp);
      CnDebug.CnDebugger.LogMsg('TMQClass Connect');
      AMq.Connect;
      AMq.ServiceId := AXml.TextByPath('ESBEntry.AccessControl.Fid', '');
      CnDebugger.LogMsg(ATemp);
      AMq.QueryByParam(ATemp);
      AReturn := APy.ResultOfMethod(ARecvXML.TextByPath('interfacemessage.interfacename',
        ''), AMq.respMsg.Encode(False));

      AReturnXML := TQXML.Create;
      AReturnXML.Parse(AReturn);

      ADB := TdmDatabase.Create(nil);
      ADB.TableName := GetTableNameByClass('getchargeiteminfos');
      ADB.ConvertXMLToDB(AReturnXML);

      Workers.Post(
        procedure(AJob: PQJob)
        begin
          CnDebug.CnDebugger.LogMsg('chargeitem complate');
        end, nil, True);
    except
      on E: Exception do
      begin
        CnDebug.CnDebugger.LogMsg('Error ' + E.Message);
      end;
    end;
  finally
    FreeAndNilObject(AXml);
    FreeAndNilObject(ADB);
    FreeAndNilObject(AReturnXML);
    FreeAndNilObject(AMq);
  end;
end;

function TFZSEInterfaceObject.GetChargeItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
var
  ASendItem: TQXMLNode;
  AXml: TQXML;
begin
//  AXml := ARecvXML.Copy;
//  Workers.Post(DoGetChargeItemJob, Pointer(AXml), False, jdfFreeAsObject);
//  ASendItem := ASendXML.AddNode('root');
//  ASendItem.AddNode('resultcode').Text := '0';
//  ASendItem.AddNode('resultmessage').Text := '开始执行';
//  ASendItem.AddNode('results');
  Result := QueryHisInfos('getchargeiteminfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetDeptInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin
  Result := QueryHisInfos('getdeptinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetDiagnosesInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('getdiagnosesinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetPateintInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('getpateintinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetStaffInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin
  Result := QueryHisInfos('getstaffinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetSurgeryInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('getsurgeryinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetTestItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetTestItemResultInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
var
  AMq: TMQClass;
  APy: IPythonScriptService;
  ADB: TdmDatabase;
  AClone: TQXML;
  ASendItem: TQXMLNode;
  ATestItem: TArray<string>;
  I: Integer;

  procedure GetTestItemResultByOne(const AXMLByOne: TQXML);
  var
    ATempXML: TQXML;
    ATemp: string;
    AReturn: string;
    AReturnXML: TQXML;
    AXML: TQXML;
  begin
    ATempXML := nil;
    AReturnXML := nil;
    AXML := nil;
    try
      ATempXML := TQXML.Create;
      AReturnXML := TQXML.Create;
      AXML := TQXML.Create;

      ATemp := APy.ParamOfMethod(AXMLByOne, AXMLByOne.TextByPath('interfacemessage.interfacename',
        ''));

      AXML.Parse(ATemp);

      AMq.Connect;
      AMq.ServiceId := AXML.TextByPath('ESBEntry.AccessControl.Fid', '');
      AMq.QueryByParam(ATemp);

      if AMq.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '0') <> '1' then
        raise Exception.Create('AMq.QueryByParam Error Message:' + AMq.respMsg.TextByPath
          ('ESBEntry.RetInfo.RetCon', ''));

      AReturn := APy.ResultOfMethod(AXMLByOne.TextByPath('interfacemessage.interfacename',
        ''), AMq.respMsg.Encode(False));

      AReturnXML.Parse(AReturn);

      ADB.ConvertXMLToDB(AReturnXML);
    finally
      FreeAndNilObject(AXML);
      FreeAndNilObject(AReturnXML);
      FreeAndNilObject(ATempXML);
    end;
  end;

begin
  AMq := nil;
  APy := nil;
  ADB := nil;
  try
    AMq := TMQClass.Create;
    APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
    ADB := TdmDatabase.Create(nil);
    ADB.TableName := GetTableNameByClass('gettestitemresultinfos');

    AClone := ARecvXML.Copy;

    ATestItem := ARecvXML.TextByPath('interfacemessage.interfaceparms.testitemid',
      '').Split([',']);

    for I := 0 to High(ATestItem) do
    begin
      AClone.ItemByPath('interfacemessage.interfaceparms.testitemid').Text :=
        ATestItem[I];
      GetTestItemResultByOne(AClone);
    end;

    ASendItem := ASendXML.AddNode('root');
    ASendItem.AddNode('resultcode').Text := '0';
    ASendItem.AddNode('resultmessage').Text := '成功';
    ASendItem.AddNode('results');
  finally
    FreeAndNilObject(AClone);
    FreeAndNilObject(ADB);
    FreeAndNilObject(AMq);
  end;
end;

function TFZSEInterfaceObject.GetTreatmentItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('gettreatmentiteminfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetWardInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin
  Result := QueryHisInfos('getwardinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetTableNameByClass(AClass: string): string;
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
  else if AClass = 'sendpatientconsts' then
    Result := 'clinical_requisition_order'
  else if AClass = 'deleteclinicalrequisitionorder' then
    Result := 'clinical_requisition_order'

end;

function TFZSEInterfaceObject.QueryHisInfos(const AClass: string; const ARecvXML:
  TQXML; var ASendXML: TQXML): Boolean;
var
  AMq: TMQClass;
  APy: IPythonScriptService;
  ADB: TdmDatabase;
  AReturn: string;
  AReturnXML: TQXML;
  AXml: TQXML;
  ASendItem: TQXMLNode;
  ATemp: string;
begin
  AMq := nil;
  APy := nil;
  ADB := nil;
  AXml := nil;
  AReturnXML := nil;
  try
    AMq := TMQClass.Create;

    AXml := TQXML.Create;

    APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
    ATemp := APy.ParamOfMethod(ARecvXML, ARecvXML.TextByPath('interfacemessage.interfacename',
      ''));

    AXml.Parse(ATemp);

    AMq.Connect;
    AMq.ServiceId := AXml.TextByPath('ESBEntry.AccessControl.Fid', '');
    AMq.QueryByParam(ATemp);
    if AMq.respMsg.TextByPath('ESBEntry.RetInfo.RetCode', '0') <> '1' then
      raise Exception.Create('AMq.QueryByParam Error Message:' + AMq.respMsg.TextByPath
        ('ESBEntry.RetInfo.RetCon', ''));

    AReturn := APy.ResultOfMethod(ARecvXML.TextByPath('interfacemessage.interfacename',
      ''), AMq.respMsg.Encode(False));

    AReturnXML := TQXML.Create;
    AReturnXML.Parse(AReturn);

    ADB := TdmDatabase.Create(nil);
    ADB.TableName := GetTableNameByClass(AClass);
    ADB.ConvertXMLToDB(AReturnXML);

    ASendItem := ASendXML.AddNode('root');
    ASendItem.AddNode('resultcode').Text := '0';
    ASendItem.AddNode('resultmessage').Text := '成功';
    ASendItem.AddNode('results');
  finally
    FreeAndNilObject(AXml);
    FreeAndNilObject(ADB);
    FreeAndNilObject(AReturnXML);
    FreeAndNilObject(AMq);
  end;
end;

function TFZSEInterfaceObject.SendClinicalRequisitionOrder(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
var
  dmDB: TdmDatabase;
  ASql: string;
  RequisitionID: string;
  AFormatXml: TQXML;
  ANode: TQXMLNode;
  AChild: TQXMLNode;
  I: Integer;
  AValue: string;
  APy: IPythonScriptService;
  ATemp: UnicodeString;
  AMq: TMQClass;
  OrderId: string;
begin
  RequisitionID := ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid',
    '');
  if RequisitionID = '' then
    raise Exception.Create('SendClinicalRequisitionOrder Error Message: requisitionid is null');
  dmDB := nil;
  AFormatXml := nil;
  AMq := nil;
  try
    AMq := TMQClass.Create;
    dmDB := TdmDatabase.Create(nil);
    ASql :=
      'SELECT * FROM clinical_requisition_order WHERE RequisitionID  = ''%s'' order by OrderType';
    ASql := Format(ASql, [RequisitionID]);
    AFormatXml := TQXML.Create;
    ANode := AFormatXml.AddNode('root');
    with dmDB do
    begin
      qryExcute.Connection := BISConnect;
      qryExcute.Open(ASql);
      if qryExcute.RecordCount = 0 then
        raise Exception.Create('qryExcute.Open Error Message:not found requisition '
          + RequisitionID);

      qryExcute.First;
      while not qryExcute.Eof do
      begin
        AChild := ANode.AddNode('Requisition');
        for I := 0 to qryExcute.FieldCount - 1 do
        begin
          case qryExcute.Fields[I].DataType of
            ftInteger:
              AValue := IntToStr(qryExcute.Fields[I].AsInteger);
            ftString:
              AValue := qryExcute.Fields[I].AsString;
            ftDateTime:
              AValue := FormatDateTime('yyyy-mm-dd hh:mm:ss', qryExcute.Fields[I].AsDateTime);
            ftFloat:
              AValue := FloatToStr(qryExcute.Fields[I].AsFloat);
          else
            AValue := VarToStrDef(qryExcute.Fields[I].Value, '');
          end;
          AChild.AddNode(qryExcute.Fields[I].FieldName).Text := AValue;
          if qryExcute.Fields[I].FieldName = 'OrderID' then
            if OrderId = '' then
              OrderId := VarToStrDef(qryExcute.Fields[I].Value, '')
            else
              OrderId := OrderId + ';' + VarToStrDef(qryExcute.Fields[I].Value, '');
        end;
        qryExcute.Next;
      end;

      APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
      ATemp := APy.ParamOfMethod(AFormatXml, ARecvXML.TextByPath('interfacemessage.interfacename',
        ''));

      AMq.Connect;
      AFormatXml.Parse(ATemp);
      AMq.ServiceId := AFormatXml.TextByPath('ESBEntry.AccessControl.Fid', '');
      AMq.QueryByParam(ATemp);

      ATemp := AMq.respMsg.TextByPath('ESBEntry.MsgInfo.Msg', '');
      AFormatXml.Parse(ATemp);
      if AFormatXml.TextByPath('msg.body.row.MsgInfo.Msg.ErrorCode', '') <> '0' then
      begin
        raise Exception.Create('MQService BS35006 Error:' + AFormatXml.TextByPath
          ('msg.body.row.MsgInfo.Msg.ErrorInfo', ''));
        Exit;
      end;

      ATemp := APy.ResultOfMethod('sendclinicalrequisitionorder', OrderId);
      AFormatXml.Parse(ATemp);
      TableName := GetTableNameByClass('sendclinicalrequisitionorder');
      ConvertXMLToDB(AFormatXml);

      AChild := ASendXML.AddNode('root');
      AChild.AddNode('resultcode').Text := '0';
      AChild.AddNode('resultmessage').Text := '成功';
      AChild.AddNode('results');
    end;
  finally
    FreeAndNilObject(AFormatXml);
    FreeAndNilObject(dmDB);
    FreeAndNilObject(AMq);
  end;
end;

function TFZSEInterfaceObject.SendPatientConsts(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
var
  dmDB: TdmDatabase;
  ASql: string;
  RequisitionID: string;
  AFormatXml: TQXML;
  ANode: TQXMLNode;
  AChild: TQXMLNode;
  I: Integer;
  AValue: string;
  APy: IPythonScriptService;
  ATemp: UnicodeString;
  AMq: TMQClass;
  OrderId: string;
begin
  RequisitionID := ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid',
    '');
  if RequisitionID = '' then
    raise Exception.Create('SendPatientConsts Error Message: requisitionid is null');
  dmDB := nil;
  AFormatXml := nil;
  AMq := nil;
  try
    AMq := TMQClass.Create;
    dmDB := TdmDatabase.Create(nil);
    ASql :=
      'SELECT * FROM clinical_requisition_order WHERE RequisitionID  = ''%s'' order by OrderType';
    ASql := Format(ASql, [RequisitionID]);
    AFormatXml := TQXML.Create;
    ANode := AFormatXml.AddNode('root');
    with dmDB do
    begin
      qryExcute.Connection := BISConnect;
      qryExcute.Open(ASql);
      if qryExcute.RecordCount = 0 then
        raise Exception.Create('qryExcute.Open Error Message:not found requisition '
          + RequisitionID);

      qryExcute.First;
      while not qryExcute.Eof do
      begin
        AChild := ANode.AddNode('Requisition');
        for I := 0 to qryExcute.FieldCount - 1 do
        begin
          case qryExcute.Fields[I].DataType of
            ftInteger:
              AValue := IntToStr(qryExcute.Fields[I].AsInteger);
            ftString:
              AValue := qryExcute.Fields[I].AsString;
            ftDateTime, ftTimeStamp:
              AValue := FormatDateTime('yyyy-mm-dd hh:mm:ss', qryExcute.Fields[I].AsDateTime);
            ftFloat:
              AValue := FloatToStr(qryExcute.Fields[I].AsFloat);
          else
            AValue := VarToStrDef(qryExcute.Fields[I].Value, '');
          end;
          AChild.AddNode(qryExcute.Fields[I].FieldName).Text := AValue;
          if qryExcute.Fields[I].FieldName = 'OrderID' then
            if OrderId = '' then
              OrderId := VarToStrDef(qryExcute.Fields[I].Value, '')
            else
              OrderId := OrderId + ';' + VarToStrDef(qryExcute.Fields[I].Value, '');
        end;
        qryExcute.Next;
      end;

      APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
      ATemp := APy.ParamOfMethod(AFormatXml, ARecvXML.TextByPath('interfacemessage.interfacename',
        ''));

      AMq.Connect;
      AFormatXml.Parse(ATemp);
      AMq.ServiceId := AFormatXml.TextByPath('ESBEntry.AccessControl.Fid', '');
      AMq.QueryByParam(ATemp);

      ATemp := AMq.respMsg.TextByPath('ESBEntry.MsgInfo.Msg', '');
      AFormatXml.Parse(ATemp);
      if AFormatXml.TextByPath('msg.body.row.MsgInfo.Msg.ErrorCode', '') <> '0' then
      begin
        raise Exception.Create('MQService BS15030 Error:' + AFormatXml.TextByPath
          ('msg.body.row.MsgInfo.Msg.ErrorInfo', ''));
        Exit;
      end;

      ATemp := APy.ResultOfMethod('sendpatientconsts', OrderId);
      AFormatXml.Parse(ATemp);
      TableName := GetTableNameByClass('sendpatientconsts');
      ConvertXMLToDB(AFormatXml);

      AChild := ASendXML.AddNode('root');
      AChild.AddNode('resultcode').Text := '0';
      AChild.AddNode('resultmessage').Text := '成功';
      AChild.AddNode('results');
    end;
  finally
    FreeAndNilObject(AFormatXml);
    FreeAndNilObject(dmDB);
    FreeAndNilObject(AMq);
  end;
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [TFZSEInterfaceObject.Create(IHospitalBISService,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.

