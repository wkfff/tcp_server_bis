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
  object sedt1: TSynEdit
    Left = 8
    Top = 8
    Width = 604
    Height = 457
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 2
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = SynXMLSyn1
    Lines.Strings = (
      'sedt1')
    WordWrap = True
    FontSmoothing = fsmNone
  end
  object SynEdit1: TSynEdit
    Left = 669
    Top = 360
    Width = 24
    Height = 14
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 3
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Lines.Strings = (
      '<?xml version="1.0" encoding="utf-8"?>'
      '<interfacemessage>'
      '    <hospitalcode>00001</hospitalcode>'
      '    <interfacename>getpateintinfos</interfacename>'
      '    <interfaceparms>'
      '        <patienttype></patienttype>'
      '        <patientid></patientid>'
      '        <patientnumber></patientnumber>'
      '        <inpatientid>10002971001</inpatientid>'
      '    </interfaceparms>'
      '</interfacemessage>')
    FontSmoothing = fsmNone
  end
  object SynXMLSyn1: TSynXMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    WantBracesParsed = False
    Left = 200
    Top = 120
  end
end
