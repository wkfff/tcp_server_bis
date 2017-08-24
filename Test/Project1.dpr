program Project1;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  ICalculateService in 'ICalculateService.pas',
  CnDebug in '..\InterfaceObject\Server\src\lib\CnDebug.pas',
  CnPropSheetFrm in '..\InterfaceObject\Server\src\lib\CnPropSheetFrm.pas' {CnPropSheetForm},
  Unit5 in 'Unit5.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
