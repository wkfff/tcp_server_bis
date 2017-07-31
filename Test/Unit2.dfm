object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 439
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 72
    Top = 224
    Width = 353
    Height = 28
    Progress = 0
  end
  object Panel1: TPanel
    Left = 104
    Top = 24
    Width = 185
    Height = 41
    Caption = 'Panel1'
    TabOrder = 0
  end
  object btn1: TButton
    Left = 368
    Top = 48
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 312
    Top = 104
  end
  object con1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 192
    Top = 144
  end
end
