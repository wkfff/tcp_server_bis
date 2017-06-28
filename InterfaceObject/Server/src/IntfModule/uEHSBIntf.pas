unit uEHSBIntf;

interface

uses
  System.SysUtils,
  QPlugins,
  qxml,
  uTCPServerIntf,
  uEwellMqExpts;

type
  TEHSBInterfaceObject = class(TQService, ITCPServerInterface)
  private

  public
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean;
  end;

implementation

const
  HospitalCode = '00001';

{ EHSBInterface }

function TEHSBInterfaceObject.ExecuteIntf(ARecvXML, ASendXML: TQXMLNode):
  Boolean;
begin
  Result := False;
  ASendXML.Assign(ARecvXML);
  Result := True;
end;

initialization
// ע�� Services/Interface ����
  RegisterServices('Services/Interface', [TEHSBInterfaceObject.Create(ITCPServerInterface,
    HospitalCode)]);

finalization
// ȡ������ע��
  UnregisterServices('Services/Interface', [HospitalCode]);

end.
