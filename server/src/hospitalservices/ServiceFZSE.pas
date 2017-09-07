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
    /// 医嘱删除接口
    /// </summary>
    function DeleteClinicalRequisitionOrder(const ARecvXML: TQXML; var ASendXML:
      TQXML): Boolean;
    /// <summary>
    /// 获取病人最近一次检验结果
    /// </summary>
    function GetTestItemResultInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetTestItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetDiagnosesInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetSurgeryInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetTreatmentItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetChargeItemInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetStaffInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetWardInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
    function GetDeptInfos(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;

    function QueryHisInfos(const AClass: string; const ARecvXML: TQXML; var ASendXML: TQXML):Boolean;
  public
    constructor Create(const AId: TGuid; AName: QStringW); override;
    destructor Destroy; override;
  end;

implementation

uses
  DataBasedm;

const
  HospitalCode = '00001';

{ TFZSEInterfaceObject }

constructor TFZSEInterfaceObject.Create(const AId: TGuid; AName: QStringW);
begin
  inherited;

end;

function TFZSEInterfaceObject.DeleteClinicalRequisitionOrder(const ARecvXML:
  TQXML; var ASendXML: TQXML): Boolean;
begin

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
      ATemp := APy.ParamOfMethod(ARecvXML);

      AXml.Parse(ATemp);
      CnDebug.CnDebugger.LogMsg('TMQClass Connect');
      AMq.Connect;
      AMq.ServiceId := AXml.TextByPath('ESBEntry.AccessControl.Fid','');
      CnDebugger.LogMsg(ATemp);
      AMq.QueryByParam(ATemp);
      AReturn := APy.ResultOfMethod(ARecvXML.TextByPath('interfacemessage.interfacename', ''),
        AMq.respMsg.Encode(False));

      AReturnXML := TQXML.Create;
      AReturnXML.Parse(AReturn);

      ADB := TdmDatabase.Create(nil);
      ADB.TableName := GetTableNameByClass('getchargeiteminfos');
      ADB.ConvertXMLToDB(AReturnXML);

      Workers.Post(procedure(AJob: PQJob)
                   begin
                     CnDebug.CnDebugger.LogMsg('chargeitem complate');
                   end, nil, True);
    except
      on E:Exception do
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
  AXml := ARecvXML.Copy;
  Workers.Post(DoGetChargeItemJob, Pointer(AXml), False, jdfFreeAsObject);
  ASendItem := ASendXML.AddNode('root');
  ASendItem.AddNode('resultcode').Text := '0';
  ASendItem.AddNode('resultmessage').Text := '开始执行';
  ASendItem.AddNode('results');
//  Result := QueryHisInfos('getchargeiteminfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetDeptInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin
  Result := QueryHisInfos('getdeptinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetDiagnosesInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetPateintInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('getpateintinfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetStaffInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetSurgeryInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetTestItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetTestItemResultInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetTreatmentItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin
  Result := QueryHisInfos('gettreatmentiteminfos', ARecvXML, ASendXML);
end;

function TFZSEInterfaceObject.GetWardInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetTableNameByClass(AClass: string): string;
begin
  if AClass = 'getpateintinfos' then
    Result := 'Patient_GetInterface_List_Info'
  else if AClass = 'gettreatmentiteminfos' then
    Result := 'His_TreatmentItem_Info'
  else if AClass = 'getchargeiteminfos' then
    Result := 'His_ChargeItem_Info'
  else if AClass = 'getdeptinfos' then
    Result := 'His_Dept_Info'
end;

function TFZSEInterfaceObject.QueryHisInfos(const AClass: string;
  const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
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
    ATemp := APy.ParamOfMethod(ARecvXML);

    AXml.Parse(ATemp);
    AMq.Connect;
    AMq.ServiceId := AXml.TextByPath('ESBEntry.AccessControl.Fid','');
    AMq.QueryByParam(ATemp);
    AReturn := APy.ResultOfMethod(ARecvXML.TextByPath('interfacemessage.interfacename', ''),
      AMq.respMsg.Encode(False));

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
begin

end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services/Interface', [TFZSEInterfaceObject.Create(IHospitalBISService,
    HospitalCode)]);

finalization
// 取消服务注册
  UnregisterServices('Services/Interface', [HospitalCode]);

end.

