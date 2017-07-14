unit uBaseIntf;

interface

uses
  System.SysUtils,
  QPlugins,
  qxml,
  uTCPServerIntf;

type
  TBaseIntf = class(TQService, ITCPServerInterface)
  protected
    function GetTestItemResultInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetTreatmentItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
    function GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
  public
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean; virtual;
  end;

implementation

{ TBaseIntf }

function TBaseIntf.ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean;
var
  intfName: string;
begin
  intfName := ARecvXML.TextByPath('interfacemessage.interfacename','');
  if intfName = '' then
    raise Exception.Create('interfacemessage.interfacename 为空，无法执行相应服务');
  if intfName = 'getwardinfos' then
    GetWardInfos(ARecvXML, ASendXML)
  else if intfName = 'getdeptinfos' then
    GetDeptInfos(ARecvXML, ASendXML)
  else if intfName = 'getstaffinfos' then
    GetStaffInfos(ARecvXML, ASendXML)
  else if intfName = 'getchargeiteminfos' then
    GetChargeItemInfos(ARecvXML, ASendXML)
  else if intfName = 'gettreatmentiteminfos' then
    GetTreatmentItemInfos(ARecvXML, ASendXML)
  else if intfName = 'getsurgeryinfos' then
    GetSurgeryInfos(ARecvXML, ASendXML)
  else if intfName = 'getdiagnosesinfos' then
    GetDiagnosesInfos(ARecvXML, ASendXML)
  else if intfName = 'gettestiteminfos' then
    GetTestItemInfos(ARecvXML, ASendXML)
  else if intfName = 'getpateintinfos' then
    GetPateintInfos(ARecvXML, ASendXML)
  else if intfName = 'gettestitemresultinfos' then
    GetTestItemResultInfos(ARecvXML, ASendXML);
end;

function TBaseIntf.GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetTestItemResultInfos(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetTreatmentItemInfos(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

function TBaseIntf.GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  ASendXML.Assign(ARecvXML);
end;

end.
