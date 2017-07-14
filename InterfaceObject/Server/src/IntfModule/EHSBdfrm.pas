unit EHSBdfrm;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  FireDAC.Phys.MSSQLDef,
  FireDAC.Stan.Intf,
  FireDAC.Phys,
  FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TdfrmEHSB = class(TDataModule)
    msdlBIS: TFDPhysMSSQLDriverLink;
    conBIS: TFDConnection;
    qryWard: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  uResource;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdfrmEHSB.DataModuleCreate(Sender: TObject);
var
  AdbIni: TIniFile;
begin
  //
  AdbIni := nil;
  try
    AdbIni := TIniFile.Create(DIOCP_TCP_SERVER_INI_FILE);
    conBIS.Connected := False;
    conBIS.Params.Clear;
    conBIS.DriverName := AdbIni.ReadString('DataBase', 'DriverName', '');
    with conBIS.Params do
    begin
      Values['Server'] := AdbIni.ReadString('DataBase', 'Server', '');
      Values['DataBase'] := AdbIni.ReadString('DataBase', 'DataBase', '');
      Values['User_Name'] := AdbIni.ReadString('DataBase', 'User_Name', '');
      Values['Password'] := AdbIni.ReadString('DataBase', 'Password', '');
      Values['Pooled'] := AdbIni.ReadString('DataBase', 'Pooled', '');
    end;
  finally
    FreeAndNil(AdbIni);
  end;
end;

procedure TdfrmEHSB.DataModuleDestroy(Sender: TObject);
begin
  if conBIS.Connected then
    conBIS.Connected := False;
end;

end.

