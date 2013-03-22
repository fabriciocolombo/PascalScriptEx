inherited Frm_ReplaceDialog: TFrm_ReplaceDialog
  Caption = 'Replace text'
  ClientHeight = 210
  OldCreateOrder = True
  ExplicitHeight = 238
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [1]
    Left = 8
    Top = 41
    Width = 65
    Height = 13
    Caption = '&Replace with:'
  end
  inherited gbSearchOptions: TGroupBox
    Top = 70
    TabOrder = 2
    ExplicitTop = 70
  end
  inherited rgSearchDirection: TRadioGroup
    Top = 70
    TabOrder = 3
    ExplicitTop = 70
  end
  inherited btnOK: TButton
    Top = 179
    TabOrder = 4
    ExplicitTop = 179
  end
  inherited btnCancel: TButton
    Top = 179
    TabOrder = 5
    ExplicitTop = 179
  end
  object cbReplaceText: TComboBox
    Left = 96
    Top = 37
    Width = 228
    Height = 21
    TabOrder = 1
  end
end
