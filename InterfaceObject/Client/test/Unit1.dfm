object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 473
  ClientWidth = 701
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    701
    473)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSend: TButton
    Left = 618
    Top = 32
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnSend'
    TabOrder = 0
    OnClick = btnSendClick
  end
  object btn1: TButton
    Left = 618
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object BCEditor1: TBCEditor
    Left = 8
    Top = 8
    Width = 585
    Height = 457
    ActiveLine.Indicator.Visible = False
    CompletionProposal.CloseChars = '()[]. '
    CompletionProposal.Columns = <
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Items = <>
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'Courier New'
        Title.Font.Style = []
      end>
    CompletionProposal.Trigger.Chars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    LeftMargin.Font.Charset = DEFAULT_CHARSET
    LeftMargin.Font.Color = 13408665
    LeftMargin.Font.Height = -11
    LeftMargin.Font.Name = 'Courier New'
    LeftMargin.Font.Style = []
    TabOrder = 2
  end
end
