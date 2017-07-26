object framDBGridData: TframDBGridData
  Left = 0
  Top = 0
  Width = 591
  Height = 345
  TabOrder = 0
  OnExit = FrameExit
  object grdData: TRzDBGrid
    Left = 0
    Top = 29
    Width = 591
    Height = 316
    Align = alClient
    DataSource = dsData
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object tbControl: TRzToolbar
    Left = 0
    Top = 0
    Width = 591
    Height = 29
    BorderInner = fsNone
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    BorderWidth = 0
    GradientColorStyle = gcsMSOffice
    TabOrder = 1
    VisualStyle = vsGradient
    ToolbarControls = (
      nvData)
    object nvData: TRzDBNavigator
      Left = 4
      Top = 5
      Width = 280
      Height = 18
      DataSource = dsData
      BorderOuter = fsNone
      TabOrder = 0
    end
  end
  object dsData: TDataSource
    DataSet = qryData
    Left = 164
    Top = 158
  end
  object SQLiteDLData: TFDPhysSQLiteDriverLink
    Left = 228
    Top = 158
  end
  object conData: TFDConnection
    Params.Strings = (
      'Database=E:\WHTX\ToolKit\debug\config.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 196
    Top = 158
  end
  object qryData: TFDQuery
    Connection = conData
    Left = 260
    Top = 158
  end
end
