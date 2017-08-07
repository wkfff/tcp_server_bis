object frmVersionInfo: TfrmVersionInfo
  Left = 0
  Top = 0
  Caption = #29256#26412#21495
  ClientHeight = 431
  ClientWidth = 713
  Color = 15781299
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 713
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      713
      32)
    object btnChange: TButton
      Left = 640
      Top = 6
      Width = 73
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #36716#25442
      TabOrder = 0
      OnClick = btnChangeClick
    end
    object btnDIR: TRzButtonEdit
      Left = 0
      Top = 8
      Width = 639
      Height = 21
      Text = ''
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ButtonKind = bkFolder
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = btnDIRButtonClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 32
    Width = 713
    Height = 399
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlMain'
    TabOrder = 1
    ExplicitLeft = 64
    ExplicitTop = 80
    ExplicitWidth = 185
    ExplicitHeight = 41
    object sedtMain: TSynEdit
      Left = 0
      Top = 0
      Width = 713
      Height = 399
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 0
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 0
      Gutter.ShowLineNumbers = True
      Gutter.ShowModification = True
      FontSmoothing = fsmNone
      ExplicitLeft = 152
      ExplicitTop = 163
      ExplicitWidth = 321
      ExplicitHeight = 158
    end
  end
  object dlgOpenDEV: TOpenDialog
    Left = 360
    Top = 144
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 344
    Top = 216
  end
end
