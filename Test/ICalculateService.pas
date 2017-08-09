// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : C:\Users\YU\Desktop\ICalculateService.wsdl
//  >Import : C:\Users\YU\Desktop\ICalculateService.wsdl>0
// Encoding : UTF-8
// Version  : 1.0
// (2017-08-09 14:24:43 - - $Rev: 90173 $)
// ************************************************************************ //

unit ICalculateService;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]



  // ************************************************************************ //
  // Namespace : http://services.founder.com
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : ICalculateServiceHttpBinding
  // service   : ICalculateService
  // port      : ICalculateServiceHttpPort
  // URL       : http://192.168.1.201:8080/founderWebs/services/ICalculateService
  // ************************************************************************ //
  ICalculateServicePortType = interface(IInvokable)
  ['{756E8DEB-C172-B715-8842-43E163A4D890}']
    function  funInterFace(const in0: string): string; stdcall;
  end;

function GetICalculateServicePortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ICalculateServicePortType;


implementation
  uses System.SysUtils;

function GetICalculateServicePortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ICalculateServicePortType;
const
  defWSDL = 'C:\Users\YU\Desktop\ICalculateService.wsdl';
  defURL  = 'http://192.168.1.201:8080/founderWebs/services/ICalculateService';
  defSvc  = 'ICalculateService';
  defPrt  = 'ICalculateServiceHttpPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as ICalculateServicePortType);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { ICalculateServicePortType }
  InvRegistry.RegisterInterface(TypeInfo(ICalculateServicePortType), 'http://services.founder.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ICalculateServicePortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ICalculateServicePortType), ioDocument);
  { ICalculateServicePortType.funInterFace }
  InvRegistry.RegisterMethodInfo(TypeInfo(ICalculateServicePortType), 'funInterFace', '',
                                 '[ReturnName="out"]', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(ICalculateServicePortType), 'funInterFace', 'in0', '',
                                '', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(ICalculateServicePortType), 'funInterFace', 'out_', 'out',
                                '', IS_NLBL);

end.