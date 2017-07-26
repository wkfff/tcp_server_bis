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
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnDblClick]
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
      btnColumns)
    object btnColumns: TRzButtonEdit
      Left = 4
      Top = 4
      Width = 121
      Height = 21
      Text = ''
      TabOrder = 0
      OnChange = btnColumnsChange
      OnKeyDown = btnColumnsKeyDown
      AltBtnKind = bkDropDown
      ButtonKind = bkDropDown
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = btnColumnsButtonClick
    end
  end
  object vstColumns: TVirtualStringTree
    Left = 4
    Top = 26
    Width = 269
    Height = 183
    DragMode = dmAutomatic
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort, hoAutoColumnPopupMenu]
    Header.SortColumn = 0
    ScrollBarOptions.AlwaysVisible = True
    ScrollBarOptions.ScrollBars = ssVertical
    TabOrder = 2
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages, toFullVertGridLines]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Visible = False
    OnCompareNodes = vstColumnsCompareNodes
    OnDblClick = vstColumnsDblClick
    OnExit = vstColumnsExit
    OnFocusChanged = vstColumnsFocusChanged
    OnFreeNode = vstColumnsFreeNode
    OnGetText = vstColumnsGetText
    OnInitNode = vstColumnsInitNode
    OnKeyDown = vstColumnsKeyDown
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
        Position = 0
        Width = 194
        WideText = 'Column'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
        Position = 1
        WideText = 'Index'
      end>
  end
end
