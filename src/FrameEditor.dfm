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
    ExplicitTop = 321
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
    ExplicitTop = -3
    ExplicitHeight = 318
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
    Top = 376
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ROPS'
    Filter = 'ROPS Files|*.ROPS|Compiled Files|*.Comp'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 128
    Top = 376
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 376
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        ShortCut = 16462
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        ShortCut = 16463
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
      end
      object Saveas1: TMenuItem
        Caption = 'Save &as...'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
      end
    end
    object Search1: TMenuItem
      Caption = '&Search'
      object Find1: TMenuItem
        Caption = '&Find...'
      end
      object Replace1: TMenuItem
        Caption = '&Replace...'
      end
      object Searchagain1: TMenuItem
        Caption = '&Search again'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Gotolinenumber1: TMenuItem
        Caption = '&Go to...'
      end
    end
    object Run1: TMenuItem
      Caption = '&Run'
      object Syntaxcheck1: TMenuItem
        Caption = 'Syntax &check'
      end
      object Compile1: TMenuItem
        Caption = 'Compile'
        ShortCut = 16504
        OnClick = Compile1Click
      end
      object Decompile1: TMenuItem
        Caption = '&Decompile...'
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object StepOver1: TMenuItem
        Caption = '&Step Over'
        ShortCut = 119
      end
      object StepInto1: TMenuItem
        Caption = 'Step &Into'
        ShortCut = 118
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Pause1: TMenuItem
        Caption = '&Pause'
      end
      object Reset1: TMenuItem
        Caption = 'R&eset'
        ShortCut = 16497
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Run: TMenuItem
        Caption = '&Run'
        ShortCut = 120
        OnClick = RunClick
      end
    end
    object este1: TMenuItem
      Caption = 'Teste'
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
    Top = 376
    object acSave: TAction
      Caption = 'Save'
      OnExecute = acSaveExecute
    end
  end
  object PSCustomPlugin: TPSCustomPlugin
    Left = 640
    Top = 264
  end
end
