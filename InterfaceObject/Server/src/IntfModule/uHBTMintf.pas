{*------------------------------------------------------------------------------
  ��������Webservice�ӿ�

  @author  YU
  @version 2017/07/14 1.0 Initial revision.
  @todo
  @comment
-------------------------------------------------------------------------------}

unit uHBTMintf;

interface

uses
  System.SysUtils,
  System.IniFiles,
  Data.DB,
  qplugins_base,
  QPlugins,
  qxml,
  ITCPServerIntf,
  uBaseIntf,
  uResource,
  uEwellMqExpts,
  CnDebug,
  qstring,
  ICalculateServiceIntf,
  EHSBdfrm;

type
  THBTMInterfaceObject = class(TBaseIntf)
  private
    FService: ICalculateServicePortType;
  protected
    /// <summary>
    /// ��ȡ������Ϣ
    /// </summary>
    function GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    /// <summary>
    /// ҽ���ش��ӿ�
    /// </summary>
    function SendClinicalRequisitionOrder(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
    /// <summary>
    /// ҽ��ɾ���ӿ�
    /// </summary>
    function DeleteClinicalRequisitionOrder(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  public
    destructor Destroy; override;
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean; override;
  end;

implementation

const
  HospitalCode = '00002';

{ THBTMInterfaceObject }

function THBTMInterfaceObject.DeleteClinicalRequisitionOrder(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
var
  AInput: TQXML;
  AOut: TQXML;
  ATemp: string;
  ANode: TQXMLNode;
  ARequisitionId: string;
  sql: string;
  UpdateSql: string;
  dtSql: TdfrmEHSB;
  I: Integer;
begin
  ARequisitionId := ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid', '');
  if ARequisitionId = '' then
    raise Exception.Create('SendClinicalRequisitionOrder Error requisitionid is null');

  dtSql := nil;
  AInput := nil;
  AOut := nil;
  try
    dtSql := TdfrmEHSB.Create(nil);

    AInput := TQXML.Create;
    AOut := TQXML.Create;
    ANode := AInput.AddNode('funderService');
    ANode.Attrs.Add('functionName').Value := 'xk_delOrderInfo';
    ANode.AddNode('value').Text := ARequisitionId;
    ATemp := AInput.Encode(False);
    CnDebugger.TraceMsgWithTag(ATemp, 'xk_delOrderInfo webservice input');
    ATemp := FService.funInterFace(ATemp);
    CnDebugger.TraceMsgWithTag(ATemp, 'xk_delOrderInfo webservice output');

    AOut.Parse(PWideChar(ATemp));
    if AOut.TextByPath('root.result.ResultCode' ,'') <> '0' then
      raise Exception.Create('xk_delOrderInfo Error. Message is' + AOut.TextByPath('root.result.ErrorMsg' ,''));

    UpdateSql := 'UPDATE clinical_requisition_order ' + #10
     + 'SET   ' + #10
     + '       OrderStatus     = 3 ' + #10
     + 'WHERE  requisitionid         = '''+ ARequisitionId +'''';

    dtSql.qryUpdate.SQL.Clear;
    dtSql.qryUpdate.SQL.Add(UpdateSql);
    dtSql.qryUpdate.ExecSQL;

    ANode := ASendXML.AddNode('root');
    ANode.AddNode('resultcode').Text := '0';
    ANode.AddNode('resultmessage').Text := '�ɹ�';
    ANode.AddNode('results').Text := '';
  finally
    FreeAndNil(AOut);
    FreeAndNil(AInput);
    FreeAndNil(dtSql);
  end;
end;

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
    CnDebugger.TraceMsgWithTag(AInput.Encode(False), 'xk_queryPatInfo webservice input');
    AOut := FService.funInterFace(AInput.Encode(False));
    CnDebugger.TraceMsgWithTag(AOut, 'xk_queryPatInfo webservice output');
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
    ANode.AddNode('resultmessage').Text := '�ɹ�';
    ANode.AddNode('results').Text := '';
  finally
    FreeAndNil(AInput);
    FreeAndNil(AOutPut);
    FreeAndNil(dtSQL);
  end;
end;

function THBTMInterfaceObject.SendClinicalRequisitionOrder(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
var
  AInput: TQXML;
  AOut: TQXML;
  ATemp: string;
  ANode: TQXMLNode;
  ARequisitionId: string;
  sql: string;
  UpdateSql: string;
  dtSql: TdfrmEHSB;
  I: Integer;
begin
  ARequisitionId := ARecvXML.TextByPath('interfacemessage.interfaceparms.requisitionid', '');
  if ARequisitionId = '' then
    raise Exception.Create('SendClinicalRequisitionOrder Error requisitionid is null');

  sql := 'SELECT cro.InPatientId, ' + #10
       + '       ''1''                         AS ''1'', ' + #10
       + '       cro.HisItemCode, ' + #10
       + '       cro.RequisitionTime, ' + #10
       + '       cro.RequisitionDoctor, ' + #10
       + '       cro.ItemCount, ' + #10
       + '       cro.ExecUnit, ' + #10
       + '       cro.WardCode, ' + #10
       + '       cro.DeptCode, ' + #10
       + '       cro.RequisitionID, cro.OrderID ' + #10
       + 'FROM   clinical_requisition_order  AS cro ' + #10
       + 'WHERE  cro.RequisitionID = ''' + ARequisitionId + ''' '+ #10
       + '       AND cro.OrderStatus < 2;';

  dtSql := nil;
  AInput := nil;
  AOut := nil;
  try
    dtSql := TdfrmEHSB.Create(nil);
    dtSql.QueryData(sql);
    if dtSql.qryBIS.RecordCount = 0 then
      raise Exception.Create('Query requisition data Error data not found. requisition_id: ' + ARequisitionId);

    AInput := TQXML.Create;
    AOut := TQXML.Create;
    ANode := AInput.AddNode('funderService');
    ANode.Attrs.Add('functionName').Value := 'xk_saveOrderInfo';

    dtSql.qryBIS.First;
    while not dtSql.qryBIS.Eof do
    begin
      for I := 0 to dtSql.qryBIS.Fields.Count - 2 do
      begin
        case dtSql.qryBIS.Fields[I].DataType of
          ftString: ANode.AddNode('value').Text := dtSql.qryBIS.Fields[I].AsString;
          ftDateTime, ftTimeStamp: ANode.AddNode('value').Text := FormatDateTime('yyyy-mm-dd', dtSql.qryBIS.Fields[I].AsDateTime);
          ftInteger: ANode.AddNode('value').Text := IntToStr(dtSql.qryBIS.Fields[I].AsInteger);
        end;
      end;

      ATemp := AInput.Encode(False);
      CnDebugger.TraceMsgWithTag(ATemp, 'xk_saveOrderInfo webservice input');
      ATemp := FService.funInterFace(ATemp);
      CnDebugger.TraceMsgWithTag(ATemp, 'xk_saveOrderInfo webservice output');

      AOut.Parse(PWideChar(ATemp));
      if AOut.TextByPath('root.result.ResultCode' ,'') <> '0' then
        raise Exception.Create('xk_saveOrderInfo Error. Message is' + AOut.TextByPath('root.result.ErrorMsg' ,''));

      UpdateSql := 'UPDATE clinical_requisition_order ' + #10
       + 'SET    OrderNo         = '''+ AOut.TextByPath('root.result.order_sn','') +''', ' + #10
       + '       OrderStatus     = 2 ' + #10
       + 'WHERE  OrderID         = '''+ dtSql.qryBIS.FindField('OrderID').AsString +'''';

      dtSql.qryUpdate.SQL.Clear;
      dtSql.qryUpdate.SQL.Add(UpdateSql);
      dtSql.qryUpdate.ExecSQL;

      dtSql.qryBIS.Next;
    end;

    ANode := ASendXML.AddNode('root');
    ANode.AddNode('resultcode').Text := '0';
    ANode.AddNode('resultmessage').Text := '�ɹ�';
    ANode.AddNode('results').Text := '';
  finally
    FreeAndNil(AOut);
    FreeAndNil(AInput);
    FreeAndNil(dtSql);
  end;
end;

initialization
// ע�� Services/Interface ����
  RegisterServices('Services/Interface', [THBTMInterfaceObject.Create(ITCPServerInterface,
    HospitalCode)]);

finalization
// ȡ������ע��
  UnregisterServices('Services/Interface', [HospitalCode]);

end.