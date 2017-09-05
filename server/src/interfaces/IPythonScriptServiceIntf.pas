unit IPythonScriptServiceIntf;

interface

uses
  qxml;

type
  IPythonScriptService = interface
    ['{CDFF2DC9-4C77-43F9-A7A9-CBACFEBE559C}']
    function ParamOfMethod(const AXml: TQXML): string;
    function ResultOfMethod(const AMethod, AData: string): string;
  end;

implementation

end.
