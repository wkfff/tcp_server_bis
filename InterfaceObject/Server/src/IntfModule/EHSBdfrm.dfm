object dfrmEHSB: TdfrmEHSB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 278
  Width = 371
  object msdlBIS: TFDPhysMSSQLDriverLink
    Left = 94
    Top = 16
  end
  object conBIS: TFDConnection
    LoginPrompt = False
    Left = 16
    Top = 16
  end
  object qryWard: TFDQuery
    Connection = conBIS
    SQL.Strings = (
      
        'INSERT INTO His_Ward_Info(WardCode, WardName, SpellCode, Telepho' +
        'neNumber, Remark, Registered) VALUES (:WardCode, :WardName, :Spe' +
        'llCode, :TelephoneNumber, :Remark, :Registered'
      ');')
    Left = 172
    Top = 16
    ParamData = <
      item
        Name = 'WARDCODE'
        ParamType = ptInput
      end
      item
        Name = 'WARDNAME'
        ParamType = ptInput
      end
      item
        Name = 'SPELLCODE'
        ParamType = ptInput
      end
      item
        Name = 'TELEPHONENUMBER'
        ParamType = ptInput
      end
      item
        Name = 'REMARK'
        ParamType = ptInput
      end
      item
        Name = 'REGISTERED'
        ParamType = ptInput
      end>
  end
end
