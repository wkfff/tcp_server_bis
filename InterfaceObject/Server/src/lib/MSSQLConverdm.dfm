object dmMSSQLConver: TdmMSSQLConver
  OldCreateOrder = False
  Height = 201
  Width = 287
  object msdlLink: TFDPhysMSSQLDriverLink
    Left = 145
    Top = 86
  end
  object conMSSQL: TFDConnection
    Left = 81
    Top = 86
  end
  object fdmMSSQL: TFDManager
    WaitCursor = gcrHourGlass
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 113
    Top = 86
  end
  object qryMSSQL: TFDQuery
    Connection = conMSSQL
    Left = 177
    Top = 86
  end
end
