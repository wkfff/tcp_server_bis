unit AndyDelphiPy;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  PythonEngine,
  VarPyth,
  ComCtrls;

procedure PyExe(cmds: string; engine: TPythonEngine);

procedure PyExeFile(fp: string; engine: TPythonEngine);

function PyClass(pyclass: string; pydelphivar: TPythonDelphiVar; engine:
  TPythonEngine): OleVariant;

function PyVarToAtom(pydelphivar: TPythonDelphiVar; engine: TPythonEngine): OleVariant;

procedure PyConsoleOut(const Data: string);

implementation

procedure PyExe(cmds: string; engine: TPythonEngine);
var
  s: TStringList;
begin
  s := TStringList.create;
  try
    s.text := cmds;
    engine.ExecStrings(s);
  finally
    s.free;
  end;
end;

procedure PyExeFile(fp: string; engine: TPythonEngine);
var
  s: TStringList;
begin
  s := TStringList.create;
  try
    if pos(':\', fp) = 0 then
      fp := ExtractFilePath(Application.ExeName) + fp;
    s.LoadFromFile(fp);
    engine.ExecStrings(s);
  finally
    s.free;
  end;
end;

function PyVarToAtom(pydelphivar: TPythonDelphiVar; engine: TPythonEngine): OleVariant;
var
  v: PPyObject;
begin
  v := pydelphivar.ValueObject;
  result := getAtom(v);
  GetPythonEngine.Py_XDECREF(v);
end;

function PyClass(pyclass: string; pydelphivar: TPythonDelphiVar; engine:
  TPythonEngine): OleVariant;
begin
  PyExe(pydelphivar.VarName + '.Value = ' + pyclass, engine);
  result := PyVarToAtom(pydelphivar, engine);
end;

procedure PyConsoleOut(const Data: string);
begin
  OutputDebugString(PChar(Data));
end;

end.

