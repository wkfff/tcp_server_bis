unit uBaseIntf;

interface

uses
  System.SysUtils,
  QPlugins,
  qxml,
  uTCPServerIntf,
  uResource;

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
  Result := False;
  intfName := ARecvXML.TextByPath('interfacemessage.interfacename','');
  if intfName = '' then
    raise Exception.Create('interfacemessage.interfacename 为空，无法执行相应服务');
  if intfName = 'getwardinfos' then
    Result := GetWardInfos(ARecvXML, ASendXML)
  else if intfName = 'getdeptinfos' then
    Result := GetDeptInfos(ARecvXML, ASendXML)
  else if intfName = 'getstaffinfos' then
    Result := GetStaffInfos(ARecvXML, ASendXML)
  else if intfName = 'getchargeiteminfos' then
    Result := GetChargeItemInfos(ARecvXML, ASendXML)
  else if intfName = 'gettreatmentiteminfos' then
    Result := GetTreatmentItemInfos(ARecvXML, ASendXML)
  else if intfName = 'getsurgeryinfos' then
    Result := GetSurgeryInfos(ARecvXML, ASendXML)
  else if intfName = 'getdiagnosesinfos' then
    Result := GetDiagnosesInfos(ARecvXML, ASendXML)
  else if intfName = 'gettestiteminfos' then
    Result := GetTestItemInfos(ARecvXML, ASendXML)
  else if intfName = 'getpateintinfos' then
    Result := GetPateintInfos(ARecvXML, ASendXML)
  else if intfName = 'gettestitemresultinfos' then
    Result := GetTestItemResultInfos(ARecvXML, ASendXML);
end;

function TBaseIntf.GetChargeItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetDeptInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetDiagnosesInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetPateintInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetStaffInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetSurgeryInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetTestItemInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetTestItemResultInfos(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetTreatmentItemInfos(ARecvXML,
  ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

function TBaseIntf.GetWardInfos(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
end;

end.
