unit DataBasedm;

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
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  Data.SqlTimSt,
  Data.DB,
  FireDAC.Comp.Client,
  qxml,
  qstring,
  CnDebug, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle;

type
  TdmDatabase = class(TDataModule)
    msdlBIS: TFDPhysMSSQLDriverLink;
    qryExcute: TFDQuery;
    qryHis: TFDQuery;
    msdOra: TFDPhysOracleDriverLink;
  private
    FTableName: string;
    procedure ConvertXMLToDBByOne(AXML: TQXMLNode);
  public
    procedure ConvertXMLToDB(AXML: TQXML);
  public
    property TableName: string read FTableName write FTableName;
  end;

function BISConnect: TFDConnection;

function HISConnect: TFDConnection;

implementation

uses
  YltShareVariable;

var
  conBIS: TFDConnection;
  conHIS: TFDConnection;
  FDateTimeFormat: TFormatSettings;

procedure IniDBConnect(const AIni: TIniFile; const ASection: string);
var
  ibDef: IFDStanConnectionDef;
begin
  ibDef := FDManager.ConnectionDefs.FindConnectionDef(ASection);
  if not Assigned(ibDef) then
  begin
    ibDef := FDManager.ConnectionDefs.AddConnectionDef;
    ibDef.Name := ASection;
    with ibDef.Params do
    begin
      DriverID := AIni.ReadString(ASection, 'DriverName', '');
      Database := AIni.ReadString(ASection, 'DataBase', '');
      UserName := AIni.ReadString(ASection, 'User_Name', '');
      Password := AIni.ReadString(ASection, 'Password', '');
      Pooled := True;
      Values['Server'] := AIni.ReadString(ASection, 'Server', '');
    end;
    ibDef.Apply;
  end;
end;

procedure CreateBISConnect;
var
  AdbIni: TIniFile;
  ATemp: string;
begin
  if not Assigned(conBIS) then
    conBIS := TFDConnection.Create(nil);
  AdbIni := nil;
  try
    AdbIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + SERVER_INI_FILE_PATH);

    FDateTimeFormat.ShortDateFormat := AdbIni.ReadString('DateTime',
      'ShortDateFormat', 'yyyy-mm-dd');
    ATemp := AdbIni.ReadString('DateTime', 'DateSeparator', '-');
    FDateTimeFormat.DateSeparator := PChar(ATemp)^;
    FDateTimeFormat.LongTimeFormat := AdbIni.ReadString('DateTime',
      'LongTimeFormat', 'hh:nn:ss');
    ATemp := AdbIni.ReadString('DateTime', 'TimeSeparator', ':');
    FDateTimeFormat.TimeSeparator := PChar(ATemp)^;

    IniDBConnect(AdbIni, 'BISDataBase');
    conBIS.ConnectionDefName := 'BISDataBase';
    conBIS.Connected := True;
  finally
    FreeAndNilObject(AdbIni);
  end;
end;

procedure CreateHISConnect;
var
  AdbIni: TIniFile;
begin
  if not Assigned(conHIS) then
    conHIS := TFDConnection.Create(nil);
  AdbIni := nil;
  try
    AdbIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + SERVER_INI_FILE_PATH);
    try
      IniDBConnect(AdbIni, 'HISDataBase');
      conHIS.ConnectionDefName := 'HISDataBase';
      conHIS.Connected := True;
    except
      on E: Exception do
        CnDebugger.LogMsgWithTag(E.Message, 'Error');

    end;
  finally
    FreeAndNilObject(AdbIni);
  end;
end;

function BISConnect: TFDConnection;
begin
  if not Assigned(conBIS) then
    CreateBISConnect;
  Result := conBIS;
end;

function HISConnect: TFDConnection;
begin
  if not Assigned(conHIS) then
    CreateHISConnect;
  Result := conHIS;
end;


{$R *.dfm}

{ TdmDatabase }
procedure TdmDatabase.ConvertXMLToDBByOne(AXML: TQXMLNode);
var
  AField: TField;
  ASql: string;
  AWhere: string;
  I: Integer;
begin
  if Trim(TableName) = '' then
    raise Exception.Create('ConvertXMLToDB Error: TableName not set');

  ASql := 'select * from ' + TableName + ' where ';

  for I := 0 to AXML.Count - 1 do
  begin
    if AXML.Items[I].Attrs.ValueByName('key', '') = 'true' then
      if AWhere = '' then
        AWhere := AXML.Items[I].Name + ' = ''' + AXML.Items[I].Text + ''''
      else
        AWhere := AWhere + ' and ' + AXML.Items[I].Name + ' = ''' + AXML.Items[I].Text + '''';
  end;

  ASql := ASql + AWhere;

//  CnDebugger.LogMsgWithTag(ASql, 'SQLText');
  qryExcute.Connection := BISConnect;
  qryExcute.Open(ASql);
  if qryExcute.RecordCount > 0 then
    qryExcute.Edit
  else
    qryExcute.Append;

  for I := 0 to AXML.Count - 1 do
  begin
    if Trim(AXML.Items[I].Text) = '' then
      Continue;

    AField := qryExcute.FindField(AXML.Items[I].Name);
    if not Assigned(AField) then
      Continue;

    case AField.DataType of
      ftFloat:
        AField.AsFloat := StrToFloatDef(AXML.Items[I].Text, 0.00);
      ftDateTime, ftTimeStamp:
        AField.AsDateTime := StrToDateTime(AXML.Items[I].Text, FDateTimeFormat);
      ftInteger:
        AField.AsInteger := StrToIntDef(AXML.Items[I].Text, 0);
      ftString:
        AField.AsString := AXML.Items[I].Text;
      ftLargeint:
        AField.AsLargeInt := StrToInt64Def(AXML.Items[I].Text, 0);
      ftBoolean:
        AField.AsBoolean := StrToBoolDef(AXML.Items[I].Text, False);
    else
      AField.AsString := AXML.Items[I].Text;
    end;
  end;
  qryExcute.Post;
end;

procedure TdmDatabase.ConvertXMLToDB(AXML: TQXML);
var
  I: Integer;
begin
  for I := 0 to AXML.Items[0].Count - 1 do
  begin
    ConvertXMLToDBByOne(AXML.Items[0].Items[I]);
  end;
end;

initialization
  try
    if not Assigned(conBIS) then
      CreateBISConnect;
    if not Assigned(conHIS) then
      CreateHISConnect;
  except
    on E: Exception do
      CnDebugger.LogMsgWithTag(E.Message, 'Error');
  end;

finalization
  if Assigned(conBIS) then
  begin
    conBIS.Connected := False;
    FreeAndNilObject(conBIS);
  end;
  if Assigned(conHIS) then
  begin
    conHIS.Connected := False;
    FreeAndNilObject(conHIS);
  end;

end.

