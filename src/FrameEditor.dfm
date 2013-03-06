object Frm_Editor: TFrm_Editor
  Left = 0
  Top = 0
  ClientHeight = 390
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 298
    Width = 724
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = -55
    ExplicitTop = 327
    ExplicitWidth = 795
  end
  object Messages: TMemo
    Left = 0
    Top = 301
    Width = 724
    Height = 89
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object Editor: TSynEdit
    Left = 0
    Top = 0
    Width = 724
    Height = 298
    Align = alClient
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
    Gutter.ShowLineNumbers = True
    Highlighter = SynPasSyn
    Lines.Strings = (
      'program Demo;'
      ''
      'begin'
      
        '  if MessageDlg('#39'You are ready?'#39', mtConfirmation, [mbYes, mbNo],' +
        ' 0) = mrYes then'
      '  begin'
      '    ShowMessage('#39'Hello Pascal Script'#39');'
      '  end;'
      'end.')
    Options = [eoAutoIndent, eoDragDropEditing, eoDropFiles, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    WantTabs = True
    FontSmoothing = fsmNone
  end
  object SynPasSyn: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 48
    Top = 152
  end
  object PSScript: TPSScript
    CompilerOptions = []
    OnCompile = PSScriptCompile
    OnExecute = PSScriptExecute
    Plugins = <>
    UsePreProcessor = False
    Left = 640
    Top = 152
  end
  object PSScriptDebugger: TPSScriptDebugger
    CompilerOptions = []
    OnCompile = PSScriptCompile
    OnExecute = PSScriptExecute
    Plugins = <>
    UsePreProcessor = False
    Left = 640
    Top = 208
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ROPS'
    Filter = 'ROPS Files|*.ROPS|Compiled Files|*.Comp'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 96
    Top = 336
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ROPS'
    Filter = 'ROPS Files|*.ROPS|Compiled Files|*.Comp'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 128
    Top = 336
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 336
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Action = acNew
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Open1: TMenuItem
        Action = acOpen
      end
      object Save1: TMenuItem
        Action = acSave
      end
      object Saveas1: TMenuItem
        Action = acSaveAs
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object Search1: TMenuItem
      Caption = '&Search'
      object Find1: TMenuItem
        Action = acFind
      end
      object Searchagain1: TMenuItem
        Action = acFindNext
      end
      object Replace1: TMenuItem
        Action = acReplace
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Gotolinenumber1: TMenuItem
        Action = acGoToLine
      end
    end
    object Run1: TMenuItem
      Caption = '&Run'
      object Compile1: TMenuItem
        Action = acCompile
      end
      object Decompile1: TMenuItem
        Action = acDecompile
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object StepOver1: TMenuItem
        Action = acStepOver
      end
      object StepInto1: TMenuItem
        Action = acStepInto
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Pause1: TMenuItem
        Action = acPause
      end
      object Reset1: TMenuItem
        Action = acReset
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Run: TMenuItem
        Action = acRun
      end
    end
    object este1: TMenuItem
      Caption = 'Teste'
      Visible = False
      object SaveCompile1: TMenuItem
        Caption = 'Save Compiled'
      end
      object LoadCompiled1: TMenuItem
        Caption = 'Load Compiled'
      end
    end
  end
  object ActionList1: TActionList
    Left = 208
    Top = 336
    object acNew: TAction
      Category = 'File'
      Caption = '&New'
      ShortCut = 16462
      OnExecute = acNewExecute
    end
    object acOpen: TAction
      Category = 'File'
      Caption = '&Open...'
      ShortCut = 16463
      OnExecute = acOpenExecute
    end
    object acSave: TAction
      Category = 'File'
      Caption = '&Save'
      ShortCut = 16467
      OnExecute = acSaveExecute
    end
    object acSaveAs: TAction
      Category = 'File'
      Caption = 'Save &as...'
      OnExecute = acSaveAsExecute
    end
    object acExit: TAction
      Category = 'File'
      Caption = '&Exit'
      OnExecute = acExitExecute
    end
    object acFind: TAction
      Category = 'Search'
      Caption = '&Find'
      Visible = False
    end
    object acReplace: TAction
      Category = 'Search'
      Caption = '&Replace'
      Visible = False
    end
    object acFindNext: TAction
      Category = 'Search'
      Caption = 'Find &Next'
      Visible = False
    end
    object acGoToLine: TAction
      Category = 'Search'
      Caption = '&Goto Line'
      OnExecute = acGoToLineExecute
    end
    object acCompile: TAction
      Category = 'Run'
      Caption = '&Compile'
      ShortCut = 16504
      OnExecute = acCompileExecute
    end
    object acDecompile: TAction
      Category = 'Run'
      Caption = '&Decompile'
      Visible = False
    end
    object acStepOver: TAction
      Category = 'Run'
      Caption = '&Step Over'
      ShortCut = 119
      Visible = False
    end
    object acStepInto: TAction
      Category = 'Run'
      Caption = 'Step &Into'
      ShortCut = 118
      Visible = False
    end
    object acPause: TAction
      Category = 'Run'
      Caption = '&Pause'
      Visible = False
    end
    object acReset: TAction
      Category = 'Run'
      Caption = 'R&eset'
      ShortCut = 16497
      OnExecute = acResetExecute
    end
    object acRun: TAction
      Category = 'Run'
      Caption = '&Run'
      ShortCut = 120
      OnExecute = acRunExecute
    end
  end
  object PSCustomPlugin: TPSCustomPlugin
    Left = 640
    Top = 264
  end
end
