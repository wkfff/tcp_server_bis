object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 444
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 539
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        ActionBar = ActionMainMenuBar1
      end>
    Left = 192
    Top = 168
    StyleName = 'Platform Default'
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 3
      ShortCut = 16474
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 5
      ShortCut = 46
    end
    object FileOpen1: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      BeforeExecute = FileOpen1BeforeExecute
    end
    object FileOpenWith1: TFileOpenWith
      Category = 'File'
      Caption = 'Open with...'
      FileName = ''
      AfterOpen = FileOpenWith1AfterOpen
    end
    object FileSaveAs1: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
      BeforeExecute = FileSaveAs1BeforeExecute
    end
    object FilePrintSetup1: TFilePrintSetup
      Category = 'File'
      Caption = 'Print Set&up...'
      Hint = 'Print Setup'
      BeforeExecute = FilePrintSetup1BeforeExecute
    end
    object FilePageSetup1: TFilePageSetup
      Category = 'File'
      Caption = 'Page Set&up...'
      Dialog.MinMarginLeft = 0
      Dialog.MinMarginTop = 0
      Dialog.MinMarginRight = 0
      Dialog.MinMarginBottom = 0
      Dialog.MarginLeft = 2500
      Dialog.MarginTop = 2500
      Dialog.MarginRight = 2500
      Dialog.MarginBottom = 2500
      Dialog.PageWidth = 21000
      Dialog.PageHeight = 29700
      BeforeExecute = FilePageSetup1BeforeExecute
    end
    object FileRun1: TFileRun
      Category = 'File'
      Browse = False
      BrowseDlg.Title = 'Run'
      Caption = '&Run...'
      Hint = 'Run|Runs an application'
      Operation = 'open'
      ShowCmd = scShowNormal
      OnHint = FileRun1Hint
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 43
      OnHint = FileExit1Hint
    end
    object BrowseForFolder1: TBrowseForFolder
      Category = 'File'
      Caption = 'BrowseForFolder1'
      DialogCaption = 'BrowseForFolder1'
      BrowseOptions = []
      BrowseOptionsEx = []
      BeforeExecute = BrowseForFolder1BeforeExecute
    end
  end
end
