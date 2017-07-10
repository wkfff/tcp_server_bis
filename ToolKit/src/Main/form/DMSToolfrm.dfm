object frmDMSTool: TfrmDMSTool
  Left = 0
  Top = 0
  Caption = 'DMSTool'
  ClientHeight = 429
  ClientWidth = 624
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000096563B2E863C1CE1853B
    1BED935034480000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000094513532853A1AEB843818FF8438
    18FF843818F78D472A4600000000000000000000000000000000000000000000
    0000000000000000000000000000904B2E32853919ED843818FF843818FF8438
    18FF843818FF843919F5914D3044000000000000000000000000000000000000
    00000000000000000000E7D9D248853B1CED843818FF843818FF843818FF8438
    18FF843818FF843818FF843919F7935034440000000000000000000000000000
    00000000000096563A36955439EDC5A192FF8A4224FF843818FF843818FF8438
    18FF843818FF843818FF843818FF863C1DF5FBF8F74A00000000000000000000
    0000924F333A85391AEF843818FF883F20FFC19B8BFF9F644BFF833717FF8438
    18FF843818FF843818FF843818FF98583DFFFFFFFFF9F9F5F44C000000008F4A
    2C3A843919F1843818FF843818FF843818FF833616FFA9755FFFC19A8AFF8F4A
    2DFF833616FF843818FF833616FFD0B4A8FFFFFFFFFFAA755FF5904D3040873E
    1FDF843818FF843818FF843919FF97583DFF935135FF833717FF894122FFC19C
    8CFFD4B9AEFFC8A799FFE3D1CAFFFEFEFEFFC7A597FF833717FF853A1BE9883F
    20D3843818FF9E634AFFF0E7E3FFF7F2F0FFDAC3BAFFD7BEB3FFBF9888FF8A43
    25FF873D1EFFA26951FFAB7862FF97583DFF833716FF843818FF853B1BE79858
    3D268C4527E5F4EEEBFFEFE5E0FF8C4527FF833716FF823615FF924F33FFC5A1
    92FFAD7A65FF833616FF843818FF843818FF843818FF853A1AF19555393A0000
    0000E4D4CC2CFFFFFFEBBA8F7DFF843818FF843818FF843818FF843818FF8337
    16FF9E634AFFC19B8BFF894022FF843818FF843919F18E492C38000000000000
    000000000000FFFFFF30A0654DE9843818FF843818FF843818FF843818FF8438
    18FF843818FF883F20FFC19B8BFF97573CEF9250333800000000000000000000
    000000000000000000009A5C4128853A1BE7843818FF843818FF843818FF8438
    18FF843818FF843818FF85391AEFCEB0A4380000000000000000000000000000
    0000000000000000000000000000995A3F28853A1BE7843818FF843818FF8438
    18FF843818FF853A1AED98583D34000000000000000000000000000000000000
    0000000000000000000000000000000000009655392A853A1AE7843818FF8438
    18FF843919ED904C2F3400000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000924F322A863C1CD5863B
    1CD994523632000000000000000000000000000000000000000000000000FE7F
    0000FC3F0000F81F0000F00F0000E0070000C003000080010000000000000000
    000080010000C0030000E0070000F00F0000F81F0000FC3F0000FE7F0000}
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    624
    429)
  PixelsPerInch = 96
  TextHeight = 13
  object splMain: TJvNetscapeSplitter
    Left = 345
    Top = 0
    Height = 429
    Align = alLeft
    MinSize = 1
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ExplicitLeft = 288
    ExplicitTop = 32
    ExplicitHeight = 100
  end
  object pnlArgus: TPanel
    Left = 0
    Top = 0
    Width = 345
    Height = 429
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object sedtArgus: TSynEdit
      Left = 0
      Top = 29
      Width = 345
      Height = 371
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      PopupMenu = pmArgus
      TabOrder = 0
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LeftOffset = 8
      Gutter.ShowLineNumbers = True
      Gutter.ShowModification = True
      Highlighter = SynIniSyn1
      FontSmoothing = fsmNone
    end
    object pnlServer: TPanel
      Left = 0
      Top = 400
      Width = 345
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        345
        29)
      object lblServer: TLabel
        Left = 3
        Top = 8
        Width = 64
        Height = 13
        Caption = #26381#21153#22120#22320#22336':'
      end
      object RzButtonEdit1: TRzButtonEdit
        Left = 75
        Top = 5
        Width = 264
        Height = 21
        Text = ''
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 0
        ButtonKind = bkDropDown
        AltBtnWidth = 15
        ButtonWidth = 15
      end
    end
    object tbrExcute: TRzToolbar
      Left = 0
      Top = 0
      Width = 345
      Height = 29
      Images = ilMenu
      BorderInner = fsNone
      BorderOuter = fsGroove
      BorderSides = [sdTop]
      BorderWidth = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      VisualStyle = vsGradient
      ToolbarControls = (
        chkActive
        RzSpacer2
        btnLog
        RzSpacer1
        btnListVisible
        RzSpacer3
        btnExcute)
      object btnLog: TRzToolButton
        Left = 56
        Top = 2
        Hint = #32447#31243#20449#24687
        ImageIndex = 3
        Images = ilMenu
        OnClick = Button1Click
      end
      object btnListVisible: TRzToolButton
        Left = 89
        Top = 2
        Hint = #26174#31034#32467#26524#21015#34920
        ImageIndex = 1
        OnClick = btnListVisibleClick
      end
      object RzSpacer1: TRzSpacer
        Left = 81
        Top = 2
        Grooved = True
      end
      object RzSpacer2: TRzSpacer
        Left = 48
        Top = 2
        Grooved = True
      end
      object btnExcute: TRzToolButton
        Left = 122
        Top = 2
        Hint = #25191#34892#26041#27861
        ImageIndex = 5
      end
      object RzSpacer3: TRzSpacer
        Left = 114
        Top = 2
        Grooved = True
      end
      object chkActive: TCheckBox
        Left = 4
        Top = 6
        Width = 44
        Height = 17
        Hint = #24320#22987#30417#25511
        Caption = #24320#22987
        TabOrder = 0
        OnClick = chkActiveClick
      end
    end
  end
  object pnlReturn: TPanel
    Left = 355
    Top = 0
    Width = 269
    Height = 429
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object chrmtbReturn: TChromeTabs
      Left = 0
      Top = 0
      Width = 269
      Height = 29
      OnActiveTabChanging = chrmtbReturnActiveTabChanging
      OnChange = chrmtbReturnChange
      ActiveTabIndex = -1
      Options.Display.CloseButton.Offsets.Vertical = 6
      Options.Display.CloseButton.Offsets.Horizontal = 2
      Options.Display.CloseButton.Height = 14
      Options.Display.CloseButton.Width = 14
      Options.Display.CloseButton.AutoHide = True
      Options.Display.CloseButton.Visibility = bvActive
      Options.Display.CloseButton.AutoHideWidth = 20
      Options.Display.CloseButton.CrossRadialOffset = 4
      Options.Display.AddButton.Offsets.Vertical = 10
      Options.Display.AddButton.Offsets.Horizontal = 2
      Options.Display.AddButton.Height = 14
      Options.Display.AddButton.Width = 31
      Options.Display.AddButton.ShowPlusSign = False
      Options.Display.AddButton.Visibility = avNone
      Options.Display.AddButton.HorizontalOffsetFloating = -3
      Options.Display.ScrollButtonLeft.Offsets.Vertical = 10
      Options.Display.ScrollButtonLeft.Offsets.Horizontal = 1
      Options.Display.ScrollButtonLeft.Height = 15
      Options.Display.ScrollButtonLeft.Width = 15
      Options.Display.ScrollButtonRight.Offsets.Vertical = 10
      Options.Display.ScrollButtonRight.Offsets.Horizontal = 1
      Options.Display.ScrollButtonRight.Height = 15
      Options.Display.ScrollButtonRight.Width = 15
      Options.Display.TabModifiedGlow.Style = msRightToLeft
      Options.Display.TabModifiedGlow.VerticalOffset = -6
      Options.Display.TabModifiedGlow.Height = 30
      Options.Display.TabModifiedGlow.Width = 100
      Options.Display.TabModifiedGlow.AnimationPeriodMS = 4000
      Options.Display.TabModifiedGlow.EaseType = ttEaseInOutQuad
      Options.Display.TabModifiedGlow.AnimationUpdateMS = 50
      Options.Display.Tabs.SeeThroughTabs = False
      Options.Display.Tabs.TabOverlap = 15
      Options.Display.Tabs.ContentOffsetLeft = 18
      Options.Display.Tabs.ContentOffsetRight = 16
      Options.Display.Tabs.OffsetLeft = 0
      Options.Display.Tabs.OffsetTop = 4
      Options.Display.Tabs.OffsetRight = 0
      Options.Display.Tabs.OffsetBottom = 0
      Options.Display.Tabs.MinWidth = 25
      Options.Display.Tabs.MaxWidth = 200
      Options.Display.Tabs.TabWidthFromContent = True
      Options.Display.Tabs.PinnedWidth = 39
      Options.Display.Tabs.ImageOffsetLeft = 13
      Options.Display.Tabs.TextTrimType = tttFade
      Options.Display.Tabs.Orientation = toTop
      Options.Display.Tabs.BaseLineTabRegionOnly = False
      Options.Display.Tabs.WordWrap = False
      Options.Display.Tabs.TextAlignmentHorizontal = taLeftJustify
      Options.Display.Tabs.TextAlignmentVertical = taVerticalCenter
      Options.Display.Tabs.ShowImages = True
      Options.Display.Tabs.ShowPinnedTabText = False
      Options.Display.TabContainer.TransparentBackground = True
      Options.Display.TabContainer.OverlayButtons = True
      Options.Display.TabContainer.PaddingLeft = 0
      Options.Display.TabContainer.PaddingRight = 0
      Options.Display.TabMouseGlow.Offsets.Vertical = 0
      Options.Display.TabMouseGlow.Offsets.Horizontal = 0
      Options.Display.TabMouseGlow.Height = 200
      Options.Display.TabMouseGlow.Width = 200
      Options.Display.TabMouseGlow.Visible = True
      Options.Display.TabSpinners.Upload.ReverseDirection = True
      Options.Display.TabSpinners.Upload.RenderedAnimationStep = 2
      Options.Display.TabSpinners.Upload.Position.Offsets.Vertical = 0
      Options.Display.TabSpinners.Upload.Position.Offsets.Horizontal = 0
      Options.Display.TabSpinners.Upload.Position.Height = 16
      Options.Display.TabSpinners.Upload.Position.Width = 16
      Options.Display.TabSpinners.Upload.SweepAngle = 135
      Options.Display.TabSpinners.Download.ReverseDirection = False
      Options.Display.TabSpinners.Download.RenderedAnimationStep = 5
      Options.Display.TabSpinners.Download.Position.Offsets.Vertical = 0
      Options.Display.TabSpinners.Download.Position.Offsets.Horizontal = 0
      Options.Display.TabSpinners.Download.Position.Height = 16
      Options.Display.TabSpinners.Download.Position.Width = 16
      Options.Display.TabSpinners.Download.SweepAngle = 135
      Options.Display.TabSpinners.AnimationUpdateMS = 50
      Options.Display.TabSpinners.HideImagesWhenSpinnerVisible = True
      Options.DragDrop.DragType = dtBetweenContainers
      Options.DragDrop.DragOutsideImageAlpha = 220
      Options.DragDrop.DragOutsideDistancePixels = 30
      Options.DragDrop.DragStartPixels = 2
      Options.DragDrop.DragControlImageResizeFactor = 0.500000000000000000
      Options.DragDrop.DragCursor = crDefault
      Options.DragDrop.DragDisplay = ddTabAndControl
      Options.DragDrop.DragFormBorderWidth = 2
      Options.DragDrop.DragFormBorderColor = 8421504
      Options.DragDrop.ContrainDraggedTabWithinContainer = False
      Options.Animation.DefaultMovementAnimationTimeMS = 100
      Options.Animation.DefaultStyleAnimationTimeMS = 300
      Options.Animation.AnimationTimerInterval = 15
      Options.Animation.MinimumTabAnimationWidth = 40
      Options.Animation.DefaultMovementEaseType = ttLinearTween
      Options.Animation.DefaultStyleEaseType = ttLinearTween
      Options.Animation.MovementAnimations.TabAdd.UseDefaultEaseType = True
      Options.Animation.MovementAnimations.TabAdd.UseDefaultAnimationTime = True
      Options.Animation.MovementAnimations.TabAdd.EaseType = ttEaseOutExpo
      Options.Animation.MovementAnimations.TabAdd.AnimationTimeMS = 500
      Options.Animation.MovementAnimations.TabDelete.UseDefaultEaseType = True
      Options.Animation.MovementAnimations.TabDelete.UseDefaultAnimationTime = True
      Options.Animation.MovementAnimations.TabDelete.EaseType = ttEaseOutExpo
      Options.Animation.MovementAnimations.TabDelete.AnimationTimeMS = 500
      Options.Animation.MovementAnimations.TabMove.UseDefaultEaseType = False
      Options.Animation.MovementAnimations.TabMove.UseDefaultAnimationTime = False
      Options.Animation.MovementAnimations.TabMove.EaseType = ttEaseOutExpo
      Options.Animation.MovementAnimations.TabMove.AnimationTimeMS = 500
      Options.Behaviour.BackgroundDblClickMaximiseRestoreForm = True
      Options.Behaviour.BackgroundDragMovesForm = True
      Options.Behaviour.TabSmartDeleteResizing = True
      Options.Behaviour.TabSmartDeleteResizeCancelDelay = 700
      Options.Behaviour.UseBuiltInPopupMenu = True
      Options.Behaviour.TabRightClickSelect = True
      Options.Behaviour.ActivateNewTab = True
      Options.Behaviour.DebugMode = False
      Options.Behaviour.IgnoreDoubleClicksWhileAnimatingMovement = True
      Options.Scrolling.Enabled = True
      Options.Scrolling.ScrollButtons = csbRight
      Options.Scrolling.ScrollStep = 20
      Options.Scrolling.ScrollRepeatDelay = 20
      Options.Scrolling.AutoHideButtons = False
      Options.Scrolling.DragScroll = True
      Options.Scrolling.DragScrollOffset = 50
      Options.Scrolling.MouseWheelScroll = True
      Tabs = <>
      LookAndFeel.TabsContainer.StartColor = 14586466
      LookAndFeel.TabsContainer.StopColor = 13201730
      LookAndFeel.TabsContainer.StartAlpha = 255
      LookAndFeel.TabsContainer.StopAlpha = 255
      LookAndFeel.TabsContainer.OutlineColor = 14520930
      LookAndFeel.TabsContainer.OutlineAlpha = 0
      LookAndFeel.Tabs.BaseLine.Color = 11110509
      LookAndFeel.Tabs.BaseLine.Thickness = 1.000000000000000000
      LookAndFeel.Tabs.BaseLine.Alpha = 255
      LookAndFeel.Tabs.Modified.CentreColor = clWhite
      LookAndFeel.Tabs.Modified.OutsideColor = clWhite
      LookAndFeel.Tabs.Modified.CentreAlpha = 130
      LookAndFeel.Tabs.Modified.OutsideAlpha = 0
      LookAndFeel.Tabs.DefaultFont.Name = 'Segoe UI'
      LookAndFeel.Tabs.DefaultFont.Color = clBlack
      LookAndFeel.Tabs.DefaultFont.Size = 9
      LookAndFeel.Tabs.DefaultFont.Alpha = 255
      LookAndFeel.Tabs.DefaultFont.TextRendoringMode = TextRenderingHintClearTypeGridFit
      LookAndFeel.Tabs.MouseGlow.CentreColor = clWhite
      LookAndFeel.Tabs.MouseGlow.OutsideColor = clWhite
      LookAndFeel.Tabs.MouseGlow.CentreAlpha = 120
      LookAndFeel.Tabs.MouseGlow.OutsideAlpha = 0
      LookAndFeel.Tabs.Spinners.Upload.Color = 12759975
      LookAndFeel.Tabs.Spinners.Upload.Thickness = 2.500000000000000000
      LookAndFeel.Tabs.Spinners.Upload.Alpha = 255
      LookAndFeel.Tabs.Spinners.Download.Color = 14388040
      LookAndFeel.Tabs.Spinners.Download.Thickness = 2.500000000000000000
      LookAndFeel.Tabs.Spinners.Download.Alpha = 255
      LookAndFeel.Tabs.Active.Font.Name = 'Segoe UI'
      LookAndFeel.Tabs.Active.Font.Color = clOlive
      LookAndFeel.Tabs.Active.Font.Size = 9
      LookAndFeel.Tabs.Active.Font.Alpha = 100
      LookAndFeel.Tabs.Active.Font.TextRendoringMode = TextRenderingHintClearTypeGridFit
      LookAndFeel.Tabs.Active.Font.UseDefaultFont = True
      LookAndFeel.Tabs.Active.Style.StartColor = clWhite
      LookAndFeel.Tabs.Active.Style.StopColor = 16316920
      LookAndFeel.Tabs.Active.Style.StartAlpha = 255
      LookAndFeel.Tabs.Active.Style.StopAlpha = 255
      LookAndFeel.Tabs.Active.Style.OutlineColor = 10189918
      LookAndFeel.Tabs.Active.Style.OutlineSize = 1.000000000000000000
      LookAndFeel.Tabs.Active.Style.OutlineAlpha = 255
      LookAndFeel.Tabs.NotActive.Font.Name = 'Segoe UI'
      LookAndFeel.Tabs.NotActive.Font.Color = 4603477
      LookAndFeel.Tabs.NotActive.Font.Size = 9
      LookAndFeel.Tabs.NotActive.Font.Alpha = 215
      LookAndFeel.Tabs.NotActive.Font.TextRendoringMode = TextRenderingHintClearTypeGridFit
      LookAndFeel.Tabs.NotActive.Font.UseDefaultFont = False
      LookAndFeel.Tabs.NotActive.Style.StartColor = 15194573
      LookAndFeel.Tabs.NotActive.Style.StopColor = 15194573
      LookAndFeel.Tabs.NotActive.Style.StartAlpha = 210
      LookAndFeel.Tabs.NotActive.Style.StopAlpha = 210
      LookAndFeel.Tabs.NotActive.Style.OutlineColor = 13546390
      LookAndFeel.Tabs.NotActive.Style.OutlineSize = 1.000000000000000000
      LookAndFeel.Tabs.NotActive.Style.OutlineAlpha = 215
      LookAndFeel.Tabs.Hot.Font.Name = 'Segoe UI'
      LookAndFeel.Tabs.Hot.Font.Color = 4210752
      LookAndFeel.Tabs.Hot.Font.Size = 9
      LookAndFeel.Tabs.Hot.Font.Alpha = 215
      LookAndFeel.Tabs.Hot.Font.TextRendoringMode = TextRenderingHintClearTypeGridFit
      LookAndFeel.Tabs.Hot.Font.UseDefaultFont = False
      LookAndFeel.Tabs.Hot.Style.StartColor = 15721176
      LookAndFeel.Tabs.Hot.Style.StopColor = 15589847
      LookAndFeel.Tabs.Hot.Style.StartAlpha = 255
      LookAndFeel.Tabs.Hot.Style.StopAlpha = 255
      LookAndFeel.Tabs.Hot.Style.OutlineColor = 12423799
      LookAndFeel.Tabs.Hot.Style.OutlineSize = 1.000000000000000000
      LookAndFeel.Tabs.Hot.Style.OutlineAlpha = 235
      LookAndFeel.CloseButton.Cross.Normal.Color = 6643031
      LookAndFeel.CloseButton.Cross.Normal.Thickness = 1.500000000000000000
      LookAndFeel.CloseButton.Cross.Normal.Alpha = 255
      LookAndFeel.CloseButton.Cross.Down.Color = 15461369
      LookAndFeel.CloseButton.Cross.Down.Thickness = 2.000000000000000000
      LookAndFeel.CloseButton.Cross.Down.Alpha = 220
      LookAndFeel.CloseButton.Cross.Hot.Color = clWhite
      LookAndFeel.CloseButton.Cross.Hot.Thickness = 2.000000000000000000
      LookAndFeel.CloseButton.Cross.Hot.Alpha = 220
      LookAndFeel.CloseButton.Circle.Normal.StartColor = clGradientActiveCaption
      LookAndFeel.CloseButton.Circle.Normal.StopColor = clNone
      LookAndFeel.CloseButton.Circle.Normal.StartAlpha = 0
      LookAndFeel.CloseButton.Circle.Normal.StopAlpha = 0
      LookAndFeel.CloseButton.Circle.Normal.OutlineColor = clGray
      LookAndFeel.CloseButton.Circle.Normal.OutlineSize = 1.000000000000000000
      LookAndFeel.CloseButton.Circle.Normal.OutlineAlpha = 0
      LookAndFeel.CloseButton.Circle.Down.StartColor = 3487169
      LookAndFeel.CloseButton.Circle.Down.StopColor = 3487169
      LookAndFeel.CloseButton.Circle.Down.StartAlpha = 255
      LookAndFeel.CloseButton.Circle.Down.StopAlpha = 255
      LookAndFeel.CloseButton.Circle.Down.OutlineColor = clGray
      LookAndFeel.CloseButton.Circle.Down.OutlineSize = 1.000000000000000000
      LookAndFeel.CloseButton.Circle.Down.OutlineAlpha = 255
      LookAndFeel.CloseButton.Circle.Hot.StartColor = 9408475
      LookAndFeel.CloseButton.Circle.Hot.StopColor = 9803748
      LookAndFeel.CloseButton.Circle.Hot.StartAlpha = 255
      LookAndFeel.CloseButton.Circle.Hot.StopAlpha = 255
      LookAndFeel.CloseButton.Circle.Hot.OutlineColor = 6054595
      LookAndFeel.CloseButton.Circle.Hot.OutlineSize = 1.000000000000000000
      LookAndFeel.CloseButton.Circle.Hot.OutlineAlpha = 255
      LookAndFeel.AddButton.Button.Normal.StartColor = 14340292
      LookAndFeel.AddButton.Button.Normal.StopColor = 14340035
      LookAndFeel.AddButton.Button.Normal.StartAlpha = 255
      LookAndFeel.AddButton.Button.Normal.StopAlpha = 255
      LookAndFeel.AddButton.Button.Normal.OutlineColor = 13088421
      LookAndFeel.AddButton.Button.Normal.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.Button.Normal.OutlineAlpha = 255
      LookAndFeel.AddButton.Button.Down.StartColor = 13417645
      LookAndFeel.AddButton.Button.Down.StopColor = 13417644
      LookAndFeel.AddButton.Button.Down.StartAlpha = 255
      LookAndFeel.AddButton.Button.Down.StopAlpha = 255
      LookAndFeel.AddButton.Button.Down.OutlineColor = 10852748
      LookAndFeel.AddButton.Button.Down.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.Button.Down.OutlineAlpha = 255
      LookAndFeel.AddButton.Button.Hot.StartColor = 15524314
      LookAndFeel.AddButton.Button.Hot.StopColor = 15524314
      LookAndFeel.AddButton.Button.Hot.StartAlpha = 255
      LookAndFeel.AddButton.Button.Hot.StopAlpha = 255
      LookAndFeel.AddButton.Button.Hot.OutlineColor = 14927787
      LookAndFeel.AddButton.Button.Hot.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.Button.Hot.OutlineAlpha = 255
      LookAndFeel.AddButton.PlusSign.Normal.StartColor = clWhite
      LookAndFeel.AddButton.PlusSign.Normal.StopColor = clWhite
      LookAndFeel.AddButton.PlusSign.Normal.StartAlpha = 255
      LookAndFeel.AddButton.PlusSign.Normal.StopAlpha = 255
      LookAndFeel.AddButton.PlusSign.Normal.OutlineColor = clGray
      LookAndFeel.AddButton.PlusSign.Normal.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.PlusSign.Normal.OutlineAlpha = 255
      LookAndFeel.AddButton.PlusSign.Down.StartColor = clWhite
      LookAndFeel.AddButton.PlusSign.Down.StopColor = clWhite
      LookAndFeel.AddButton.PlusSign.Down.StartAlpha = 255
      LookAndFeel.AddButton.PlusSign.Down.StopAlpha = 255
      LookAndFeel.AddButton.PlusSign.Down.OutlineColor = clGray
      LookAndFeel.AddButton.PlusSign.Down.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.PlusSign.Down.OutlineAlpha = 255
      LookAndFeel.AddButton.PlusSign.Hot.StartColor = clWhite
      LookAndFeel.AddButton.PlusSign.Hot.StopColor = clWhite
      LookAndFeel.AddButton.PlusSign.Hot.StartAlpha = 255
      LookAndFeel.AddButton.PlusSign.Hot.StopAlpha = 255
      LookAndFeel.AddButton.PlusSign.Hot.OutlineColor = clGray
      LookAndFeel.AddButton.PlusSign.Hot.OutlineSize = 1.000000000000000000
      LookAndFeel.AddButton.PlusSign.Hot.OutlineAlpha = 255
      LookAndFeel.ScrollButtons.Button.Normal.StartColor = 14735310
      LookAndFeel.ScrollButtons.Button.Normal.StopColor = 14274499
      LookAndFeel.ScrollButtons.Button.Normal.StartAlpha = 255
      LookAndFeel.ScrollButtons.Button.Normal.StopAlpha = 255
      LookAndFeel.ScrollButtons.Button.Normal.OutlineColor = 11507842
      LookAndFeel.ScrollButtons.Button.Normal.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Button.Normal.OutlineAlpha = 255
      LookAndFeel.ScrollButtons.Button.Down.StartColor = 13417645
      LookAndFeel.ScrollButtons.Button.Down.StopColor = 13417644
      LookAndFeel.ScrollButtons.Button.Down.StartAlpha = 255
      LookAndFeel.ScrollButtons.Button.Down.StopAlpha = 255
      LookAndFeel.ScrollButtons.Button.Down.OutlineColor = 10852748
      LookAndFeel.ScrollButtons.Button.Down.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Button.Down.OutlineAlpha = 255
      LookAndFeel.ScrollButtons.Button.Hot.StartColor = 15524314
      LookAndFeel.ScrollButtons.Button.Hot.StopColor = 15524313
      LookAndFeel.ScrollButtons.Button.Hot.StartAlpha = 255
      LookAndFeel.ScrollButtons.Button.Hot.StopAlpha = 255
      LookAndFeel.ScrollButtons.Button.Hot.OutlineColor = 14927788
      LookAndFeel.ScrollButtons.Button.Hot.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Button.Hot.OutlineAlpha = 255
      LookAndFeel.ScrollButtons.Button.Disabled.StartColor = 14340036
      LookAndFeel.ScrollButtons.Button.Disabled.StopColor = 14274499
      LookAndFeel.ScrollButtons.Button.Disabled.StartAlpha = 150
      LookAndFeel.ScrollButtons.Button.Disabled.StopAlpha = 150
      LookAndFeel.ScrollButtons.Button.Disabled.OutlineColor = 11113341
      LookAndFeel.ScrollButtons.Button.Disabled.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Button.Disabled.OutlineAlpha = 100
      LookAndFeel.ScrollButtons.Arrow.Normal.StartColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Normal.StopColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Normal.StartAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Normal.StopAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Normal.OutlineColor = clGray
      LookAndFeel.ScrollButtons.Arrow.Normal.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Arrow.Normal.OutlineAlpha = 200
      LookAndFeel.ScrollButtons.Arrow.Down.StartColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Down.StopColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Down.StartAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Down.StopAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Down.OutlineColor = clGray
      LookAndFeel.ScrollButtons.Arrow.Down.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Arrow.Down.OutlineAlpha = 200
      LookAndFeel.ScrollButtons.Arrow.Hot.StartColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Hot.StopColor = clWhite
      LookAndFeel.ScrollButtons.Arrow.Hot.StartAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Hot.StopAlpha = 255
      LookAndFeel.ScrollButtons.Arrow.Hot.OutlineColor = clGray
      LookAndFeel.ScrollButtons.Arrow.Hot.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Arrow.Hot.OutlineAlpha = 200
      LookAndFeel.ScrollButtons.Arrow.Disabled.StartColor = clSilver
      LookAndFeel.ScrollButtons.Arrow.Disabled.StopColor = clSilver
      LookAndFeel.ScrollButtons.Arrow.Disabled.StartAlpha = 150
      LookAndFeel.ScrollButtons.Arrow.Disabled.StopAlpha = 150
      LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineColor = clGray
      LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineSize = 1.000000000000000000
      LookAndFeel.ScrollButtons.Arrow.Disabled.OutlineAlpha = 200
      Align = alTop
      TabOrder = 0
    end
    object lstReturn: TJvPageList
      Left = 0
      Top = 29
      Width = 269
      Height = 400
      PropagateEnable = False
      Align = alClient
    end
  end
  object pnlList: TPanel
    Left = -49
    Top = 223
    Width = 394
    Height = 177
    Cursor = crArrow
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 2
    OnMouseDown = pnlListMouseDown
    OnMouseMove = pnlListMouseMove
    OnMouseUp = pnlListMouseUp
    DesignSize = (
      394
      177)
    object vstMethodList: TVirtualStringTree
      Left = 0
      Top = 16
      Width = 394
      Height = 161
      Anchors = [akLeft, akTop, akRight, akBottom]
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoVisible]
      PopupMenu = pmList
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnFocusChanged = vstMethodListFocusChanged
      OnFreeNode = vstMethodListFreeNode
      OnGetText = vstMethodListGetText
      OnInitChildren = vstMethodListInitChildren
      OnInitNode = vstMethodListInitNode
      Columns = <
        item
          Alignment = taCenter
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
          Position = 0
          Width = 77
          WideText = 'Client'
        end
        item
          CaptionAlignment = taCenter
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable]
          Position = 1
          Width = 312
          WideText = #26041#27861
        end>
    end
    object btnClosePanel: TJvXPToolButton
      Left = 379
      Top = 1
      ImageIndex = 0
      OnClick = btnClosePanelClick
    end
  end
  object sedtXML: TSynEdit
    Left = 377
    Top = 192
    Width = 393
    Height = 209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    PopupMenu = pmXML
    TabOrder = 3
    BorderStyle = bsNone
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 8
    Gutter.ShowLineNumbers = True
    Gutter.ShowModification = True
    Highlighter = SynXMLSyn1
    FontSmoothing = fsmNone
  end
  object SynIniSyn1: TSynIniSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    TextAttri.Foreground = clMaroon
    SectionAttri.Foreground = clNavy
    KeyAttri.Foreground = clBlue
    NumberAttri.Foreground = clHighlight
    NumberAttri.Style = [fsBold]
    Left = 521
    Top = 213
  end
  object SynXMLSyn1: TSynXMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    WantBracesParsed = False
    Left = 289
    Top = 271
  end
  object pmXML: TPopupMenu
    Images = ilMenu
    Left = 463
    Top = 213
    object mniXML1: TMenuItem
      Caption = #35299#26512'XML'
      ImageIndex = 0
      OnClick = mniXML1Click
    end
    object mniN5: TMenuItem
      Caption = '-'
    end
    object mniN1: TMenuItem
      Caption = #28165#31354
      ImageIndex = 2
      OnClick = mniN1Click
    end
  end
  object ilMenu: TImageList
    Left = 289
    Top = 213
    Bitmap = {
      494C01010A002400A40010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000993300009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009933
      0000CC660000CC66000099330000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900CCCCCC00CCCCCC0099999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099330000CC66
      0000CC660000CC660000CC660000993300000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099999900CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00999999000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000CC660000CC66
      0000CC660000CC660000CC660000CC6600009933000000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC009999990000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000CC660000CC66
      00009933000099330000CC660000CC660000CC66000099330000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC009999990099999900CCCCCC00CCCCCC00CCCCCC0099999900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000CC6600009933
      0000000000000000000099330000CC660000CC660000CC660000993300000000
      0000000000000000000000000000000000000000000099999900CCCCCC009999
      9900000000000000000099999900CCCCCC00CCCCCC00CCCCCC00999999000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000993300000000
      000000000000000000000000000099330000CC660000CC660000CC6600009933
      0000000000000000000000000000000000000000000099999900999999000000
      000000000000000000000000000099999900CCCCCC00CCCCCC00CCCCCC009999
      9900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000099330000CC660000CC660000CC66
      0000993300000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000099999900CCCCCC00CCCCCC00CCCC
      CC00999999000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099330000CC660000CC66
      0000CC6600009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099999900CCCCCC00CCCC
      CC00CCCCCC009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099330000CC66
      0000CC6600009933000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000099999900CCCC
      CC00CCCCCC009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009933
      0000CC6600009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009999
      9900CCCCCC009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000993300009933000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000999999009999990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B4C1EF004463D800DAE0F700FFFF
      FF00FFFFFF00DAE0F7004463D800B4C1EF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00848484008484
      8400848484008484840084848400FFFFFF004463D8004463D8004463D800DAE0
      F700DAE0F7004463D8004463D8004463D800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DAE0F7004463D8004463D8004463
      D8004463D8004463D8004463D800DAE0F700FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000CC00000066000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B2B2B2008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DAE0F7004463D8004463
      D8004463D8004463D800DAE0F700FFFFFF00CCA57F00B8824D00B8824D00B882
      4D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B882
      4D00B8824D00B8824D00CCA57F00FFFFFF0000000000000000000000000000CC
      0000009900000099000000660000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B200999999009999990080808000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DAE0F7004463D8004463
      D8004463D8004463D800DAE0F700FFFFFF00B8824D00FFFFFF00DCC1A700B882
      4D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B882
      4D00DCC1A700FFFFFF00B8824D00FFFFFF00000000000000000000CC00000099
      0000009900000099000000990000006600000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B2B2B2009999
      9900999999009999990099999900808080000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00B8824D00B8824D00B8824D00FFFFFF00DAE0F7004463D8004463D8004463
      D8004463D8004463D8004463D800DAE0F700B8824D00DBC0A500FFFFFF00DCC1
      A700B8824D00B8824D00B8824D00DCC1A700B8824D00B8824D00B8824D00DCC1
      A700FFFFFF00DBC0A500B8824D00FFFFFF000000000000CC0000009900000099
      0000009900000099000000990000009900000066000000000000000000000000
      00000000000000000000000000000000000000000000B2B2B200999999009999
      9900999999009999990099999900999999008080800000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463D8004463D8004463D800DAE0
      F700DAE0F7004463D8004463D8004463D800B8824D00B8824D00DBC0A500FFFF
      FF00DCC1A700B8824D00DCC1A700FFFFFF00DCC1A700B8824D00DCC1A700FFFF
      FF00DBC0A500B8824D00B8824D00FFFFFF000000000000CC0000009900000099
      00000066000000CC000000990000009900000099000000660000000000000000
      00000000000000000000000000000000000000000000B2B2B200999999009999
      990080808000B2B2B20099999900999999009999990080808000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00B8824D00B8824D00B8824D00FFFFFF00B4C1EF004463D800DAE0F700FFFF
      FF00FFFFFF00DAE0F7004463D800B4C1EF00B8824D00B8824D00B8824D00DBC0
      A500FFFFFF00DCC1A700FFFFFF00DBC0A500FFFFFF00DCC1A700FFFFFF00DBC0
      A500B8824D00B8824D00B8824D00FFFFFF000000000000CC0000009900000066
      0000000000000000000000CC0000009900000099000000990000006600000000
      00000000000000000000000000000000000000000000B2B2B200999999008080
      80000000000000000000B2B2B200999999009999990099999900808080000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B8824D00B8824D00B8824D00B882
      4D00DCC1A700FFFFFF00DBC0A500B8824D00DBC0A500FFFFFF00DCC1A700B882
      4D00B8824D00B8824D00B8824D00FFFFFF000000000000CC0000006600000000
      000000000000000000000000000000CC00000099000000990000009900000066
      00000000000000000000000000000000000000000000B2B2B200808080000000
      0000000000000000000000000000B2B2B2009999990099999900999999008080
      800000000000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B882
      4D00FFFFFF0084848400FFFFFF00FFFFFF00B8824D00B8824D00B8824D00DCC1
      A700FFFFFF00DBC0A500B8824D00B8824D00B8824D00DBC0A500FFFFFF00DCC1
      A700B8824D00B8824D00B8824D00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000CC000000990000009900000099
      0000006600000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B2B2B20099999900999999009999
      990080808000000000000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00B8824D00B8824D00DCC1A700FFFF
      FF00DBC0A500B8824D00B8824D00B8824D00B8824D00B8824D00DBC0A500FFFF
      FF00DCC1A700B8824D00B8824D00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000CC0000009900000099
      0000009900000066000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B2B2B200999999009999
      990099999900808080000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00B8824D00B8824D00B8824D00B8824D00B8824D00FFFFFF00848484008484
      84008484840084848400FFFFFF00FFFFFF00B8824D00DCC1A700FFFFFF00DBC0
      A500B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00DBC0
      A500FFFFFF00DCC1A700B8824D00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000CC00000099
      0000009900000066000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B2B2B2009999
      990099999900808080000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF009D9D9D00E6E6E600FFFFFF00FFFFFF00B8824D00FFFFFF00DBC0A500B882
      4D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B882
      4D00DBC0A500FFFFFF00B8824D00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000CC
      0000009900000066000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B20099999900808080000000000000000000FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484009D9D
      9D00E6E6E600FFFFFF00FFFFFF00FFFFFF00CAA27B00B8824D00B8824D00B882
      4D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B8824D00B882
      4D00B8824D00B8824D00CAA27B00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000CC00000066000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B2B2B200808080000000000000000000FFFFFF00FFFFFF00848484008484
      840084848400848484008484840084848400848484008484840084848400E6E6
      E600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F1E6DB00B882
      4D00B8824D00B8824D00B8824D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463D800FFFF
      FF00FFFFFF00FBFBFE009DAEEB007F95E4007F95E4009DAEEB00FBFBFE00FFFF
      FF00FFFFFF004463D800FFFFFF00FFFFFF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F1E6DB00B8824D00B882
      4D00B8824D00B8824D00F1E6DB00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463D800BFCA
      F200FEFEFF007D93E4004463D8004463D8004463D8004463D8007D93E400FEFE
      FF00BFCAF2004463D800FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00C1916300B8824D00C191
      6300FFFFFF00FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00FFFFFF00F1E6DB00B8824D00B8824D00B882
      4D00B8824D00F1E6DB00C7D0F3004463D8004463D800C7D0F300FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFCAF2004463
      D80091A3E8004463D8004463D8004463D8004463D8004463D8004463D80090A3
      E8004463D800BFCAF200FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B8824D00B8824D00B8824D00B882
      4D00F1E6DB00C7D0F3004463D8004463D8004463D8004463D800C7D0F300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFCA
      F2004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D800BFCAF200FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B8824D00B8824D00B8824D00F1E6
      DB00C7D0F3004463D8004463D8004463D8004463D8004463D8004463D800C7D0
      F300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463D800FFFFFF00EEF1
      FB004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D800EEF1FB00FFFFFF004463D800FFFFFF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F1E6DB00B8824D00F1E6DB00C7D0
      F3004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D800C7D0F300FFFFFF00FFFFFF00FFFFFF00FFFFFF004463D800F1E6DB00D8DF
      F7004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D800D8DFF700F1E6DB004463D800FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463
      D8004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D8004463D800C7D0F300FFFFFF00FFFFFF00FFFFFF004463D8004463D8004463
      D8004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D8004463D8005B69BC004463D800FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00C1916300B8824D00C191
      6300FFFFFF00FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463
      D8004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D8004463D8004463D800C7D0F300FFFFFF00FFFFFF00F1E6DB004463D8004463
      D8004A68D9004463D8004463D8004463D8004463D8004463D8004463D8004A68
      D9004463D8004463D800F1E6DB00FFFFFF0084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7D0
      F3004463D8004463D8004463D8004463D8004463D8004463D8004463D8004463
      D8004463D8004463D8004463D800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008A9DE7004463D8004463D8004463D8004463D8004463D8004463D8008A9D
      E700FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C7D0F3004463D8004463D8004463D8004463D8004463D8004463D8004463
      D8004463D8004463D8004463D800FFFFFF00FFFFFF00FFFFFF00FFFFFF00BFCA
      F2004463D8005672DC004463D8004463D8004463D8004463D8005672DC004463
      D800BFCAF200FFFFFF00FFFFFF00FFFFFF0084848400DBC0A600DBC0A600DBC0
      A600DBC0A60084848400DBC0A600DBC0A600DBC0A600DBC0A60084848400DBC0
      A600DBC0A600DBC0A600DBC0A60084848400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C7D0F3004463D8004463D8004463D8004463D8004463D8004463
      D8004463D8004463D800C7D0F300FFFFFF00FFFFFF00FFFFFF00FFFFFF004463
      D800BFCAF200E4E8F9005D78DD004463D8004463D8005C77DD00E4E8F900BFCA
      F2004463D800FFFFFF00FFFFFF00FFFFFF0084848400DBC0A600DBC0A600DBC0
      A600DBC0A60084848400DBC0A600DBC0A600DBC0A600DBC0A60084848400DBC0
      A600DBC0A600DBC0A600DBC0A60084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C7D0F3004463D8004463D8004463D8004463D8004463
      D8004463D800C7D0F300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004463
      D800FFFFFF00FFFFFF00506DDB004463D8004463D800516EDB00FFFFFF00FFFF
      FF004463D800FFFFFF00FFFFFF00FFFFFF0084848400DBC0A600DBC0A600DBC0
      A600DBC0A60084848400DBC0A600DBC0A600DBC0A600DBC0A60084848400DBC0
      A600DBC0A600DBC0A600DBC0A60084848400FFFFFF00C1916300B8824D00C191
      6300FFFFFF00FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C7D0F3004463D8004463D8004463D8004463
      D800C7D0F300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004665D800748BE200748BE2004665D800FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840084848400FFFFFF00E0C8B100C1916300E0C8
      B100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C7D0F3004463D8004463D800C7D0
      F300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00728AE200DFE5F800DFE5F800728AE200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00DBE1F800F3F5FC00F3F5FC00DAE0F700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      F3FFF3FF00000000E1FFE1FF00000000C0FFC0FF00000000807F807F00000000
      803F803F000000008C1F8C1F000000009E0F9E0F00000000FF07FF0700000000
      FF83FF8300000000FFC3FFC300000000FFE3FFE300000000FFF3FFF300000000
      FFFFFFFF00000000FFFFFFFF0000000000000000FFFFFFFF00000000FFFFFFFF
      00000000F3FFF3FF00000000E1FFE1FF00000000C0FFC0FF00000000807F807F
      00000000803F803F000000008C1F8C1F000000009E0F9E0F00000000FF07FF07
      00000000FF83FF8300000000FFC3FFC300000000FFE3FFE300000000FFF3FFF3
      00000000FFFFFFFF00000000FFFFFFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object pmArgus: TPopupMenu
    Images = ilMenu
    Left = 347
    Top = 213
    object mniClear: TMenuItem
      Caption = #28165#31354
      ImageIndex = 2
      OnClick = mniClearClick
    end
    object mniN4: TMenuItem
      Caption = '-'
    end
    object mniN2: TMenuItem
      Caption = #28165#31354#25968#25454
      ImageIndex = 4
      Visible = False
      OnClick = mniN2Click
    end
  end
  object pmList: TPopupMenu
    Images = ilMenu
    Left = 405
    Top = 213
    object mniN3: TMenuItem
      Caption = #28165#31354#30417#25511
      ImageIndex = 4
      OnClick = mniN3Click
    end
  end
end
