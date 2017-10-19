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
  IHospitalBISServiceIntf,
  DataBasedm,
  YltShareVariable,
  IPythonScriptServiceIntf;

type
  TZXHospitalInterfaceObject = class(TQService, IHospitalBISService)
  private
    FPythonEng: IPythonScriptService;
    function GetDataFromTableView(const ARecvXML: TQXML; var ASendXML: TQXML): Boolean;
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

function TZXHospitalInterfaceObject.ChargeFees(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

constructor TZXHospitalInterfaceObject.Create(const AId: TGUID; AName: QStringW);
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
  FreeAndNilObject(FPythonEng);
  inherited;
end;

function TZXHospitalInterfaceObject.GetChargeItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetDataFromTableView(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
var
  AMethod: string;
  ASql: string;
  AResultXML: string;
  objDataBase: TdmDatabase;
  I: Integer;
  ADataXml: TQXML;
  ANode: TQXMLNode;
  AFieldNode: TQXMLNode;
  ARoot: TQXMLNode;
begin
  //
  AMethod := ARecvXML.TextByPath('interfacemessage.interfacename', '');
  ASql := FPythonEng.ParamOfMethod(ARecvXML, AMethod);

  objDataBase := nil;
  ADataXml := nil;

  try
    objDataBase := TdmDatabase.Create(nil);
    ADataXml := TQXML.Create;
    ARoot := ADataXml.AddNode('root');

    with objDataBase.qryQuery do
    begin
      Connection := HISConnect;
      Open(ASql);
      if RecordCount <= 0 then
        raise Exception.Create(AMethod + ' found`t HIS base data');
      First;
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
              AFieldNode.Text := FormatDateTime('yyyy-mm-dd hh:mm:ss',
                Fields[I].AsDateTime);
            ftInteger:
              AFieldNode.Text := IntToStr(Fields[I].AsInteger);
            ftString:
              AFieldNode.Text := (Fields[I].AsString);
            ftBoolean:
              AFieldNode.Text := BoolToStr(Fields[I].AsBoolean);
          else
            AFieldNode.Text := (Fields[I].AsString);
          end;
        end;
        Next;
      end;

      AResultXML := FPythonEng.ResultOfMethod(AMethod, ADataXml.Encode(False));

      ADataXml.Parse(AResultXML);
      objDataBase.ConvertXMLToDB(ADataXml);

      ANode := ASendXML.AddNode('root');
      ANode.AddNode('resultcode').Text := '0';
      ANode.AddNode('resultmessage').Text := '�ɹ�';
      ANode.AddNode('results');
    end;
  finally
    FreeAndNil(ADataXml);
    FreeAndNil(objDataBase);
  end;
  Result := True;
end;

function TZXHospitalInterfaceObject.GetDeptInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetDiagnosesInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetPateintInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

function TZXHospitalInterfaceObject.GetStaffInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetSurgeryInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetTestItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetTestItemResultInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := True;
end;

function TZXHospitalInterfaceObject.GetTreatmentItemInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
end;

function TZXHospitalInterfaceObject.GetWardInfos(const ARecvXML: TQXML;
  var ASendXML: TQXML): Boolean;
begin
  Result := GetDataFromTableView(ARecvXML, ASendXML);
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

end.
