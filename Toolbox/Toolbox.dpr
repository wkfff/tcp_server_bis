program Toolbox;

{ Reduce EXE size by disabling as much of RTTI as possible (delphi XE10.1 }
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}
uses
  Vcl.Forms,
  Mainfrm in 'Main\Mainfrm.pas' {frmToolbox};

{$R *.res}

var
  frmToolbox: TfrmToolbox;

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmToolbox, frmToolbox);
  Application.Run;
end.
