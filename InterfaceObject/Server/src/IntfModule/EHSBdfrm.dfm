object dfrmEHSB: TdfrmEHSB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 278
  Width = 371
  object msdlBIS: TFDPhysMSSQLDriverLink
    Left = 112
    Top = 16
  end
  object conBIS: TFDConnection
    Params.Strings = (
      'Pooled=False'
      'DriverID=MSSQL')
    LoginPrompt = False
    Left = 16
    Top = 16
  end
  object qryBIS: TFDQuery
    Connection = conBIS
    SQL.Strings = (
      'select &field_list from &table_name where &condition_list')
    Left = 160
    Top = 16
    MacroData = <
      item
        Value = Null
        Name = 'FIELD_LIST'
        DataType = mdIdentifier
      end
      item
        Value = Null
        Name = 'TABLE_NAME'
        DataType = mdIdentifier
      end
      item
        Value = Null
        Name = 'CONDITION_LIST'
        DataType = mdIdentifier
      end>
  end
  object fdmBIS: TFDManager
    WaitCursor = gcrHourGlass
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 64
    Top = 16
  end
  object qryUpdate: TFDQuery
    Connection = conBIS
    Left = 208
    Top = 16
  end
  object spExecute: TFDStoredProc
    Connection = conBIS
    Left = 264
    Top = 16
  end
end
