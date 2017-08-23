unit EHSBdfrm;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  TypInfo,
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
  Data.SqlTimSt,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  qstring,
  qplugins_base,
  qplugins_params,
  CnDebug;

type
  TdfrmEHSB = class(TDataModule)
    msdlBIS: TFDPhysMSSQLDriverLink;
    conBIS: TFDConnection;
    qryBIS: TFDQuery;
    fdmBIS: TFDManager;
    qryUpdate: TFDQuery;
    spExecute: TFDStoredProc;
    conHIS: TFDConnection;
    spGetMaxNo: TFDStoredProc;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FDateTimeFormat: TFormatSettings;

    FFieldList: TQParams;
    FTableName: string;
    FConditionList: TQParams;
    procedure SetConditionList(const Value: TQParams);
    procedure SetFieldList(const Value: TQParams);
    function GetConditionList: TQParams;
    function GetFieldList: TQParams;
  public
    { Public declarations }
    procedure QueryData(const ASql: string);
    procedure PutDataIntoDatabase;
    property FieldList: TQParams read GetFieldList write SetFieldList;
    property TableName: string read FTableName write FTableName;
    property ConditionList: TQParams read GetConditionList write SetConditionList;
  end;

implementation

uses
  uResource;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdfrmEHSB.DataModuleCreate(Sender: TObject);
var
  AdbIni: TIniFile;
  ibDef: IFDStanConnectionDef;
  ATemp: string;
begin
  AdbIni := nil;
  try
    AdbIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DIOCP_TCP_SERVER_INI_FILE);

    FDateTimeFormat.ShortDateFormat := AdbIni.ReadString('DateTime', 'ShortDateFormat', 'yyyy-mm-dd');
    ATemp := AdbIni.ReadString('DateTime', 'DateSeparator', '-');
    FDateTimeFormat.DateSeparator := PChar(ATemp)^;
    FDateTimeFormat.LongTimeFormat := AdbIni.ReadString('DateTime', 'LongTimeFormat', 'hh:nn:ss');
    ATemp := AdbIni.ReadString('DateTime', 'TimeSeparator', ':');
    FDateTimeFormat.TimeSeparator := PChar(ATemp)^;

    ibDef := FDManager.ConnectionDefs.FindConnectionDef(CONNECTIONDEFNAME);
    if not Assigned(ibDef) then
    begin
      ibDef := FDManager.ConnectionDefs.AddConnectionDef;
      ibDef.Name := 'BIS_Pooled';
      with ibDef.Params do
      begin
        DriverID := AdbIni.ReadString(DATABASESECTION, 'DriverName', '');
        Database := AdbIni.ReadString(DATABASESECTION, 'DataBase', '');
        UserName := AdbIni.ReadString(DATABASESECTION, 'User_Name', '');
        Password := AdbIni.ReadString(DATABASESECTION, 'Password', '');
        Pooled := True;
        Values['Server'] := AdbIni.ReadString(DATABASESECTION, 'Server', '');
      end;
      ibDef.Apply;
    end;

    ibDef := FDManager.ConnectionDefs.FindConnectionDef('HIS_POOLED');
    if not Assigned(ibDef) then
    begin
      ibDef := FDManager.ConnectionDefs.AddConnectionDef;
      ibDef.Name := 'HIS_POOLED';
      with ibDef.Params do
      begin
        DriverID := AdbIni.ReadString('HIS_DATABASE', 'DriverName', '');
        Database := AdbIni.ReadString('HIS_DATABASE', 'DataBase', '');
        UserName := AdbIni.ReadString('HIS_DATABASE', 'User_Name', '');
        Password := AdbIni.ReadString('HIS_DATABASE', 'Password', '');
        Pooled := True;
        Values['Server'] := AdbIni.ReadString('HIS_DATABASE', 'Server', '');
      end;
      ibDef.Apply;
    end;
    conHIS.ConnectionDefName := 'HIS_POOLED';
    try
      conHIS.Connected := True;
    except
      on E: EFDException do
        raise Exception.Create('HIS_DATABASE Error.Connect false.');
    end;

    conBIS.ConnectionDefName := CONNECTIONDEFNAME;
    conBIS.Connected := False;
  finally
    FreeAndNilObject(AdbIni);
  end;
end;

procedure TdfrmEHSB.DataModuleDestroy(Sender: TObject);
begin
  if conHIS.Connected then
    conHIS.Connected := False;
  if conBIS.Connected then
    conBIS.Connected := False;
  FreeAndNilObject(FFieldList);
  FreeAndNilObject(FConditionList);
end;

function TdfrmEHSB.GetConditionList: TQParams;
begin
  if not Assigned(FConditionList) then
    FConditionList := TQParams.Create;
  Result := FConditionList;
end;

function TdfrmEHSB.GetFieldList: TQParams;
begin
  if not Assigned(FFieldList) then
    FFieldList := TQParams.Create;
  Result := FFieldList;
end;

procedure TdfrmEHSB.PutDataIntoDatabase;
var
  AParam: TQParam;
  AFieldName: string;
  AFDField: TField;
  AField: string;
  AValue: string;
  I: Integer;
begin
  if (FieldList.Count <= 0) or (ConditionList.Count <= 0)
    or (Trim(TableName) = '') then
    raise Exception.Create('无法生成SQL语句');

  qryBIS.Macros.MacroByName('table_name').AsRaw := TableName;

  for I := 0 to FieldList.Count - 1 do
  begin
    if AField = '' then
      AField := FieldList.Items[I].Name
    else
      AField := AField + ',' + FieldList.Items[I].Name;
  end;
  qryBIS.Macros.MacroByName('field_list').AsRaw := AField;

  for I := 0 to ConditionList.Count - 1 do
  begin
    if AValue = '' then
      AValue := ConditionList.Items[I].Name + ' = ' + ConditionList.Items[I].AsString
    else
      AValue := AValue + ' and ' + ConditionList.Items[I].Name + ' = ' + ConditionList.Items[I].AsString;
  end;
  qryBIS.Macros.MacroByName('condition_list').AsRaw := AValue;

  if not conBIS.Connected then
    conBIS.Connected := True;
  CnDebugger.LogMsg('SQL语句:' + qryBIS.Command.SQLText);
  qryBIS.Open;
  if qryBIS.RecordCount > 0 then
    qryBIS.Edit
  else
    qryBIS.Append;

  for I := 0 to FieldList.Count - 1 do
  begin
    AFieldName := FieldList.Items[I].Name;
    AFDField := qryBIS.FieldByName(AFieldName);
    AParam := FieldList.Items[I];
//    CnDebugger.LogMsg('FieldName:' + AFieldName + ';FieldValue:'
//      + AParam.AsString + ';FieldType:'
//      + GetEnumname(TypeInfo(TFieldType), Ord(AFDField.DataType)));
    case AFDField.DataType of
      ftFloat:
        AFDField.AsFloat := AParam.AsFloat;
      ftDateTime:
      begin
        if Pos('-', AParam.AsString) > 0 then
          AFDField.AsDateTime := StrToDateTime(AParam.AsString, FDateTimeFormat)
        else
          AFDField.AsDateTime := StrToDateTime((LeftStr(AParam.AsString, 4)
            + '-' + MidStr(AParam.AsString, 5, 2) + '-'
            + MidStr(AParam.AsString, 7, 2) + ' '
            + MidStr(AParam.AsString, 9, 2) + ':'
            + MidStr(AParam.AsString, 11, 2) + ':'
            + RightStr(AParam.AsString, 2)));
      end;
      ftInteger:
        AFDField.AsInteger := StrToIntDef(AParam.AsString, 0);
      ftString:
        AFDField.AsString := AParam.AsString;
      ftLargeint:
        AFDField.AsLargeInt := StrToInt64Def(AParam.AsString, 0);
      ftBoolean:
        AFDField.AsBoolean := StrToBoolDef(AParam.AsString, False);
      ftTimeStamp:
      begin
        if AParam.AsString = '' then
          Exit;
        if Pos('-', AParam.AsString) > 0 then
          AFDField.AsSQLTimeStamp := DateTimeToSQLTimeStamp(StrToDateTime(AParam.AsString, FDateTimeFormat))
        else
          AFDField.AsSQLTimeStamp := DateTimeToSQLTimeStamp(
            StrToDateTime((LeftStr(AParam.AsString, 4)
            + '-' + MidStr(AParam.AsString, 5, 2) + '-'
            + MidStr(AParam.AsString, 7, 2) + ' '
            + MidStr(AParam.AsString, 9, 2) + ':'
            + MidStr(AParam.AsString, 11, 2) + ':'
            + RightStr(AParam.AsString, 2)))
            );
      end
    else
      AFDField.AsString := AParam.AsString;
    end;
  end;
  qryBIS.Post;

  qryBIS.Close;
end;

procedure TdfrmEHSB.QueryData(const ASql: string);
begin
  qryBIS.Open(ASql);
end;

procedure TdfrmEHSB.SetConditionList(const Value: TQParams);
begin
  FreeAndNilObject(FConditionList);
  FConditionList := Value;
end;

procedure TdfrmEHSB.SetFieldList(const Value: TQParams);
begin
  FreeAndNilObject(FFieldList);
  FFieldList := Value;
end;

end.


