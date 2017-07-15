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
  utils_safeLogger;

type
  TdfrmEHSB = class(TDataModule)
    msdlBIS: TFDPhysMSSQLDriverLink;
    conBIS: TFDConnection;
    qryBIS: TFDQuery;
    fdmBIS: TFDManager;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FFieldList: TQParams;
    FTableName: string;
    FValueList: TQParams;
    FConditionList: TQParams;
    procedure SetConditionList(const Value: TQParams);
    procedure SetFieldList(const Value: TQParams);
    procedure SetValueList(const Value: TQParams);
  public
    { Public declarations }
    procedure PutDataIntoDatabase;
    property FieldList: TQParams read FFieldList write SetFieldList;
    property TableName: string read FTableName write FTableName;
    property ValueList: TQParams read FValueList write SetValueList;
    property ConditionList: TQParams read FConditionList write SetConditionList;
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
begin
  AdbIni := nil;
  try
    AdbIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + DIOCP_TCP_SERVER_INI_FILE);

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
    conBIS.ConnectionDefName := CONNECTIONDEFNAME;
    conBIS.Connected := False;
  finally
    FreeAndNilObject(AdbIni);
  end;
end;

procedure TdfrmEHSB.DataModuleDestroy(Sender: TObject);
begin
  if conBIS.Connected then
    conBIS.Connected := False;
  FreeAndNilObject(FFieldList);
  FreeAndNilObject(FConditionList);
  FreeAndNilObject(FValueList);
end;

procedure TdfrmEHSB.PutDataIntoDatabase;
var
  AParam: IQParam;
  AValueName: string;
  AFDField: TField;
  AField: string;
  AValue: string;
  I: Integer;
begin
  if (FieldList.Count <= 0) or (ConditionList.Count <= 0)
    or (Trim(TableName) = '') then
    raise Exception.Create('无法生成SQL语句');

  if FieldList.Count <> ValueList.Count then
    raise Exception.Create('无法生成SQL语句, 检查接口键值对');

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
  qryBIS.Open;
  if qryBIS.RecordCount > 0 then
    qryBIS.Edit
  else
    qryBIS.Append;
  sfLogger.logMessage('SQL语句:' + qryBIS.Command.SQLText);

  for I := 0 to FieldList.Count - 1 do
  begin
    AValueName := FieldList.Items[I].AsString;
    AField := FieldList.Items[I].Name;
    AFDField := qryBIS.FieldByName(AField);
    AParam := ValueList.ByName(PWideChar(AValueName));
    sfLogger.logMessage('FieldName:' + AField + ';FieldValue:'
      + AParam.AsString.Value + ';FieldType:'
      + GetEnumname(TypeInfo(TFieldType), Ord(AFDField.DataType)));
    case AFDField.DataType of
      ftFloat:
        AFDField.AsFloat := AParam.AsFloat;
      ftDateTime:
      begin
        if Pos('-', AParam.AsString.Value) > 0 then
          AFDField.AsDateTime := StrToDateTime(AParam.AsString.Value)
        else
          AFDField.AsDateTime := StrToDateTime((LeftStr(AParam.AsString.Value, 4)
            + '-' + MidStr(AParam.AsString.Value, 5, 2) + '-'
            + MidStr(AParam.AsString.Value, 7, 2) + ' '
            + MidStr(AParam.AsString.Value, 9, 2) + ':'
            + MidStr(AParam.AsString.Value, 11, 2) + ':'
            + RightStr(AParam.AsString.Value, 2)));
      end;
      ftInteger:
        AFDField.AsInteger := StrToInt(AParam.AsString.Value);
      ftString:
        AFDField.AsString := AParam.AsString.Value;
      ftLargeint:
        AFDField.AsLargeInt := StrToInt64(AParam.AsString.Value);
      ftBoolean:
        AFDField.AsBoolean := StrToBool(AParam.AsString.Value);
      ftTimeStamp:
      begin
        if Pos('-', AParam.AsString.Value) > 0 then
          AFDField.AsSQLTimeStamp := DateTimeToSQLTimeStamp(StrToDateTime(AParam.AsString.Value))
        else
          AFDField.AsSQLTimeStamp := DateTimeToSQLTimeStamp(
            StrToDateTime((LeftStr(AParam.AsString.Value, 4)
            + '-' + MidStr(AParam.AsString.Value, 5, 2) + '-'
            + MidStr(AParam.AsString.Value, 7, 2) + ' '
            + MidStr(AParam.AsString.Value, 9, 2) + ':'
            + MidStr(AParam.AsString.Value, 11, 2) + ':'
            + RightStr(AParam.AsString.Value, 2)))
            );
      end
    else
      AFDField.AsString := AParam.AsString.Value;
    end;
  end;
  qryBIS.Post;

  qryBIS.Close;
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

procedure TdfrmEHSB.SetValueList(const Value: TQParams);
begin
  FreeAndNilObject(FValueList);
  FValueList := Value;
end;

end.


