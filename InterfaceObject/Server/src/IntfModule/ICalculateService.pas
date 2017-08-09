// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// Encoding : UTF-8
// Version  : 1.0
// (2017-08-09 14:24:43 - - $Rev: 90173 $)
// ************************************************************************ //

unit ICalculateService;

interface

uses
  System.IniFiles,
  Soap.InvokeRegistry,
  Soap.SOAPHTTPClient,
  System.Types,
  Soap.XSBuiltIns;

const
  IS_NLBL = $0004;
  IS_REF = $0080;

type
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
    function funInterFace(const in0: string): string; stdcall;
  end;

function GetICalculateServicePortType(UseWSDL: Boolean = System.False; Addr:
  string = ''; HTTPRIO: THTTPRIO = nil): ICalculateServicePortType;

implementation

uses
  System.SysUtils;

function GetICalculateServicePortType(UseWSDL: Boolean; Addr: string; HTTPRIO:
  THTTPRIO): ICalculateServicePortType;
var
  defWSDL: string;
  defURL: string;
  defSvc: string;
  defPrt: string;
  APath: string;
  RIO: THTTPRIO;
  AWebServiceIni: TIniFile;
begin
  Result := nil;
  AWebServiceIni := nil;
  defSvc  := 'ICalculateService';
  defPrt  := 'ICalculateServiceHttpPort';
  APath := ExtractFilePath(ParamStr(0)) + 'webservice.ini';
  if FileExists(APath) then
  begin
    try
      AWebServiceIni := TIniFile.Create(APath);
      defURL := AWebServiceIni.ReadString('Service','url', 'http://192.168.1.201:8080/founderWebs/services/ICalculateService');
    finally
      FreeAndNil(AWebServiceIni);
    end;
  end
  else
  begin
    defURL  := 'http://192.168.1.201:8080/founderWebs/services/ICalculateService';
  end;
  defWSDL := defURL + '?wsdl';

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
    end
    else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;

initialization
  { ICalculateServicePortType }
  InvRegistry.RegisterInterface(TypeInfo(ICalculateServicePortType),
    'http://services.founder.com', 'UTF-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ICalculateServicePortType), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ICalculateServicePortType), ioDocument);
  { ICalculateServicePortType.funInterFace }
  InvRegistry.RegisterMethodInfo(TypeInfo(ICalculateServicePortType),
    'funInterFace', '', '[ReturnName="out"]', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(ICalculateServicePortType),
    'funInterFace', 'in0', '', '', IS_NLBL);
  InvRegistry.RegisterParamInfo(TypeInfo(ICalculateServicePortType),
    'funInterFace', 'out_', 'out', '', IS_NLBL);

end.

