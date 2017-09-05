unit PythonScriptdm;

interface

uses
  System.SysUtils,
  System.Classes,
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
    function ParamOfMethod(const AXml: TQXML): string;
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

function TPythonScript.ParamOfMethod(const AXml: TQXML): string;
var
  __main: Variant;
begin
  PyExeFile('script\' + AXml.TextByPath('interfacemessage.interfacename','') + '.py',
    GetPythonEngine);
  __main := MainModule;
  Result := __main.param_of_method(AXml.Encode(False));
end;

function TPythonScript.ResultOfMethod(const AMethod, AData: string): string;
var
  __main: Variant;
begin
  PyExeFile('script\' + AMethod + '.py',
    GetPythonEngine);
  __main := MainModule;
  Result := __main.result_of_method(AData);
end;

initialization
// ע�� Services/Interface ����
  RegisterServices('Services', [TPythonScript.Create(IPythonScriptService,
    'PythonScript')]);

finalization
// ȡ������ע��
  UnregisterServices('Services', ['PythonScript']);

end.
