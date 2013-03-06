object Frm_Main: TFrm_Main
  Left = 292
  Top = 240
  Caption = 'RemObjects Pascal Script - Test Application'
  ClientHeight = 419
  ClientWidth = 795
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 327
    Width = 795
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 234
    ExplicitWidth = 577
  end
  object Messages: TMemo
    Left = 0
    Top = 330
    Width = 795
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
    Width = 795
    Height = 327
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
  object MainMenu1: TMainMenu
    Left = 240
    Top = 8
    object Program1: TMenuItem
      Caption = '&Program'
      object Compile1: TMenuItem
        Caption = '&Compile'
        ShortCut = 120
        OnClick = Compile1Click
      end
      object mnpN1: TMenuItem
        Caption = '-'
      end
      object mnpSair1: TMenuItem
        Caption = 'Sair'
        OnClick = mnpSair1Click
      end
    end
  end
  object PSScript: TPSScript
    CompilerOptions = []
    OnCompile = PSScriptCompile
    OnExecute = PSScriptExecute
    OnExecImport = PSScriptExecImport
    Plugins = <
      item
        Plugin = PSImport_Classes
      end
      item
        Plugin = PSImport_DateUtils
      end
      item
        Plugin = PSImport_ComObj
      end
      item
        Plugin = PSImport_DB
      end
      item
        Plugin = PSImport_Forms
      end
      item
        Plugin = PSImport_Controls
      end
      item
        Plugin = PSImport_StdCtrls
      end
      item
        Plugin = PSCustomPlugin
      end
      item
        Plugin = PSDllPlugin
      end>
    UsePreProcessor = False
    Left = 712
    Top = 16
  end
  object SynPasSyn: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 240
    Top = 56
  end
  object SynCompletionProposal: TSynCompletionProposal
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    ShortCut = 16416
    Left = 240
    Top = 112
  end
  object SynAutoComplete: TSynAutoComplete
    EndOfTokenChr = '()[]. '
    ShortCut = 8224
    Options = []
    Left = 240
    Top = 168
  end
  object SynMacroRecorder: TSynMacroRecorder
    RecordShortCut = 24658
    PlaybackShortCut = 24656
    Left = 240
    Top = 224
  end
  object PSScriptDebugger: TPSScriptDebugger
    CompilerOptions = []
    Plugins = <
      item
        Plugin = PSImport_Classes
      end
      item
        Plugin = PSImport_DateUtils
      end
      item
        Plugin = PSImport_ComObj
      end
      item
        Plugin = PSImport_DB
      end
      item
        Plugin = PSImport_Forms
      end
      item
        Plugin = PSImport_Controls
      end
      item
        Plugin = PSImport_StdCtrls
      end
      item
        Plugin = PSCustomPlugin
      end
      item
        Plugin = PSDllPlugin
      end>
    UsePreProcessor = False
    Left = 712
    Top = 72
  end
  object PSImport_Classes: TPSImport_Classes
    EnableStreams = True
    EnableClasses = True
    Left = 456
    Top = 16
  end
  object PSImport_DateUtils: TPSImport_DateUtils
    Left = 456
    Top = 72
  end
  object PSImport_ComObj: TPSImport_ComObj
    Left = 456
    Top = 120
  end
  object PSImport_DB: TPSImport_DB
    Left = 456
    Top = 176
  end
  object PSImport_Forms: TPSImport_Forms
    EnableForms = True
    EnableMenus = False
    Left = 456
    Top = 232
  end
  object PSImport_Controls: TPSImport_Controls
    EnableStreams = True
    EnableGraphics = True
    EnableControls = True
    Left = 560
    Top = 16
  end
  object PSImport_StdCtrls: TPSImport_StdCtrls
    EnableExtCtrls = True
    EnableButtons = True
    Left = 560
    Top = 72
  end
  object PSCustomPlugin: TPSCustomPlugin
    Left = 560
    Top = 128
  end
  object PSDllPlugin: TPSDllPlugin
    Left = 560
    Top = 184
  end
end
