unit U_EHSBInterface;

interface

uses
  System.SysUtils,
  QPlugins,
  Qxml,
  U_TCPServerInterface;

type
  TEHSBInterfaceObject = class(TQService, ITCPServerInterface)

  public
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode):Boolean;
  end;

implementation

const
  HospitalCode = '00001';

{ EHSBInterface }

function TEHSBInterfaceObject.ExecuteIntf(ARecvXML, ASendXML: TQXMLNode): Boolean;
begin
  Result := False;
  ASendXML.Assign(ARecvXML);
  Result := True;
end;

initialization
// 注册 Services/Interface 服务
RegisterServices('Services/Interface',
  [TEHSBInterfaceObject.Create(ITCPServerInterface, HospitalCode)]);

finalization
// 取消服务注册
UnregisterServices('Services/Interface', [HospitalCode]);

end.
