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
  CnDebug,
  IHospitalBISServiceIntf,
  YltShareVariable,
  EwellMqExpts,
  IPythonScriptServiceIntf;

type
  TFZSEInterfaceObject = class(TQService, IHospitalBISService)
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

function TFZSEInterfaceObject.GetChargeItemInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetDeptInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetDiagnosesInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
begin

end;

function TFZSEInterfaceObject.GetPateintInfos(const ARecvXML: TQXML; var
  ASendXML: TQXML): Boolean;
var
  AMq: TMQClass;
  APy: IPythonScriptService;
  ADB: TdmDatabase;
  AReturn: string;
  AReturnXML: TQXML;
  ATemp: string;
begin
  AMq := nil;
  APy := nil;
  ADB := nil;
  AReturnXML := nil;
  try
    AMq := TMQClass.Create;

    APy := PluginsManager.ByPath('Services/PythonScript') as IPythonScriptService;
    ATemp := APy.ParamOfMethod(ARecvXML);
    CnDebugger.LogMsgWithTag(ATemp, 'ParamOfMethod');
    AMq.QueryByParam(ATemp);
    AReturn := APy.ResultOfMethod('getpateintinfos', AMq.respMsg.Encode(False));

    AReturnXML := TQXML.Create;
    AReturnXML.Parse(AReturn);

    ADB := TdmDatabase.Create(nil);
    ADB.TableName := 'Patient_GetInterface_List_Info';
    ADB.ConvertXMLToDB(AReturnXML);

  finally
    FreeAndNilObject(ADB);
    FreeAndNilObject(AReturnXML);
    FreeAndNilObject(AMq);
    FreeAndNilObject(APy);
  end;
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

end;

function TFZSEInterfaceObject.GetWardInfos(const ARecvXML: TQXML; var ASendXML:
  TQXML): Boolean;
begin

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

