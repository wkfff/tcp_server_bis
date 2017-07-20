program ToolKit;

{ Reduce EXE size by disabling as much of RTTI as possible (delphi XE10.1 }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}

uses
  Vcl.Forms,
  Mainfrm in 'form\Mainfrm.pas' {frmToolBox},
  Logfrm in 'form\Logfrm.pas' {frmLogger};

{$R *.res}

var
  frmToolBox: TfrmToolBox;

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmToolBox, frmToolBox);
  Application.CreateForm(TfrmLogger, frmLogger);
  frmLogger.Hide;
  Application.Run;
end.
