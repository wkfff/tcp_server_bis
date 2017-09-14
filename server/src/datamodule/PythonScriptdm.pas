unit PythonScriptdm;

interface

uses
  System.SysUtils,
  System.Classes,
  CnDebug,
  PythonEngine,
  VarPyth,
  AndyDelphiPy,
  qplugins_base,
  QPlugins,
  qstring,
  qxml,
  IPythonScriptServiceIntf;

type
  TdmPythonScript = class(TDataModule)
    pyengExcute: TPythonEngine;
  private
    { Private declarations }

  public
    { Public declarations }

  end;

  TPythonScript = class(TQService, IPythonScriptService)
  private
    FPyEng: TdmPythonScript;
  public
    constructor Create(const AId: TGuid; AName: QStringW); override;
    destructor Destroy; override;
    function ParamOfMethod(const AXml: TQXML;const AMethod: string): string;
    function ResultOfMethod(const AMethod, AData: string): string;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TPythonScript.Create(const AId: TGuid; AName: QStringW);
begin
  inherited;
  FPyEng := TdmPythonScript.Create(nil);
end;

destructor TPythonScript.Destroy;
begin
  FreeAndNilObject(FPyEng);
  inherited;
end;

function TPythonScript.ParamOfMethod(const AXml: TQXML;const AMethod: string): string;
var
  __main: Variant;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'script\' + AMethod + '.py') then
    raise Exception.Create('ParamOfMethod Error not found python file ' + ExtractFilePath(ParamStr(0)) + 'script\' + AMethod + '.py');
  PyExeFile('script\' + AMethod + '.py',
    GetPythonEngine);
  __main := MainModule;
  Result := __main.param_of_method(AXml.Encode(False));
  CnDebugger.LogMsgWithTag(Result, 'param_of_method');
end;

function TPythonScript.ResultOfMethod(const AMethod, AData: string): string;
var
  __main: Variant;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'script\' + AMethod + '.py') then
    raise Exception.Create('ParamOfMethod Error not found python file ' + ExtractFilePath(ParamStr(0)) + 'script\' + AMethod + '.py');
  PyExeFile('script\' + AMethod + '.py',
    GetPythonEngine);
  __main := MainModule;
  Result := __main.result_of_method(AData);
  CnDebugger.LogMsgWithTag(Result, 'result_of_method');
end;

initialization
// 注册 Services/Interface 服务
  RegisterServices('Services', [TPythonScript.Create(IPythonScriptService,
    'PythonScript')]);

finalization
// 取消服务注册
  UnregisterServices('Services', ['PythonScript']);

end.

