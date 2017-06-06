unit U_TCPServerInterface;

interface

uses
  System.SysUtils,
  qxml;

type
  ITCPServerInterface = interface
    ['{3D51EED1-BEFB-465E-B606-6EE383BD52D7}']
    function ExecuteIntf(ARecvXML, ASendXML: TQXMLNode):Boolean;
  end;

implementation

end.
