object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 408
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  DesignSize = (
    608
    408)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSend: TButton
    Left = 525
    Top = 32
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnSend'
    TabOrder = 0
    OnClick = btnSendClick
    ExplicitLeft = 618
  end
  object btn1: TButton
    Left = 525
    Top = 80
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
    ExplicitLeft = 618
  end
  object pnl1: TPanel
    Left = 8
    Top = 8
    Width = 511
    Height = 394
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'pnl1'
    TabOrder = 2
    ExplicitWidth = 614
    ExplicitHeight = 457
    object spl1: TSplitter
      Left = 1
      Top = 201
      Width = 509
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 242
      ExplicitWidth = 214
    end
    object SynEdit1: TSynEdit
      Left = 580
      Top = 360
      Width = 24
      Height = 14
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
    object sedt1: TSynEdit
      Left = 1
      Top = 1
      Width = 509
      Height = 200
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 1
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
    object sedt2: TSynEdit
      Left = 1
      Top = 204
      Width = 509
      Height = 189
      Align = alClient
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
      Lines.Strings = (
        'sedt2')
      FontSmoothing = fsmNone
      ExplicitLeft = 56
      ExplicitTop = 264
      ExplicitWidth = 200
      ExplicitHeight = 150
    end
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
