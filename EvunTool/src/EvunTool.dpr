program EvunTool;

uses
  Vcl.Forms,
  toolMainForm in 'form\toolMainForm.pas' {toolMainFrm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  toolMainFrm: TtoolMainFrm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.CreateForm(TtoolMainFrm, toolMainFrm);
  Application.Run;
end.
