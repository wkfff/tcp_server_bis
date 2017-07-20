object frmvirtualstringtree: Tfrmvirtualstringtree
  Left = 0
  Top = 0
  Width = 451
  Height = 305
  Align = alClient
  TabOrder = 0
  object vstMain: TVirtualStringTree
    Left = 0
    Top = 29
    Width = 451
    Height = 276
    Align = alClient
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
    OnBeforeCellPaint = vstMainBeforeCellPaint
    OnDrawText = vstMainDrawText
    OnGetText = vstMainGetText
    OnInitNode = vstMainInitNode
    Columns = <>
  end
  object tlbrFrame: TRzToolbar
    Left = 0
    Top = 0
    Width = 451
    Height = 29
    BorderInner = fsNone
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    BorderWidth = 0
    GradientColorStyle = gcsMSOffice
    TabOrder = 1
    VisualStyle = vsGradient
    ToolbarControls = (
      cmbCol)
    object cmbCol: TRzComboBox
      Left = 4
      Top = 4
      Width = 145
      Height = 21
      KeepSearchCase = True
      TabOrder = 0
      OnChange = cmbColChange
    end
  end
end
