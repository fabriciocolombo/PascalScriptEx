object Form1: TForm1
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
  object Memo2: TMemo
    Left = 0
    Top = 330
    Width = 795
    Height = 89
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
    ExplicitTop = 225
    ExplicitWidth = 569
  end
  object Memo1: TSynEdit
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
    Highlighter = synpsyn1
    Lines.Strings = (
      'program Test;'
      ''
      'const'
      '        ALTURA_BARRA_TITULO '#9'= 20;'
      '        ESPACAMENTO '#9#9'= 10;'
      '        TAMANHO_BORDA '#9#9'= 4;'
      
        '        AMOSTRAGEM_ARQUIVO '#9'= '#39'Resources\Plantio_13_2_20137_28_5' +
        '7.txt'#39';'
      '  '
      'var'
      #9't '#9#9#9': TForm;'
      #9'l '#9#9#9': TLabel;'
      #9'b '#9#9#9': TButton;'
      ' '#9'btnListarArquivos'#9': TButton;'
      #9'btnCarregarArquivo  : TButton;'
      #9'p '#9#9#9': TPanel;'
      #9'mmO '#9#9#9': TMemo;'
      #9'files: TListBox;'
      #9'mmR '#9#9#9': TMemo;'
      ''
      'procedure ExibirListaArquivos(Sender: TObject);'
      'var'
      '   i : Integer;'
      '   str : string;'
      '   strArquivo : string;'
      '   stlLista   : TStrings;'
      'begin'
      '     str := ExtractFilePath(AMOSTRAGEM_ARQUIVO);'
      
        '     strArquivo := StringReplace(AMOSTRAGEM_ARQUIVO, str, '#39'---> ' +
        #39', [rfReplaceAll]);'
      ''
      '     ShowMessageFmt('#39'Diretorio selecionado: %s'#39', [str]);'
      '     '
      '     stlLista := ListarArquivos(str, '#39'*.*'#39');'
      '     try'
      '       files.Items.Clear;'
      '       for i := 0 to stlLista.Count - 1 do'
      '       begin'
      '          files.Items.Add(stlLista[i]);'
      '       end;'
      '     '
      
        '       ShowMessage('#39'Numero de arquivos: '#39' + IntToStr(stlLista.Co' +
        'unt));'
      '     finally'
      '       stlLista.Free;'
      '     end;'
      'end;'
      ''
      'procedure SepararDados(Sender: TObject);'
      'var'
      #9'intLinha    '#9': Integer;'
      '    sl'#9'        : TStringList;'
      #9'vField, vValue: String;'
      'begin'
      '  sl := TStringList.Create;'
      '  try'
      #9'mmR.Lines.Clear;'
      #9
      #9'for intLinha := 0 to mmO.Lines.Count - 1 do'
      #9'begin'
      #9#9'if Pos('#39':'#39', mmO.Lines[intLinha]) > 0 then'
      #9#9'begin'
      
        #9#9'    vField := copy( mmO.Lines[intLinha], 0, Pos('#39':'#39', mmO.Lines' +
        '[intLinha])-1 );        '#9
      
        #9#9#9'vValue := copy( mmO.Lines[intLinha], Pos('#39':'#39', mmO.Lines[intLi' +
        'nha])+1, length(mmO.Lines[intLinha]));'
      #9#9#9
      #9#9#9'if SameText(vField, '#39'DATA'#39') then'
      #9#9#9'begin'
      
        #9#9#9'     vValue := formatdatetime('#39'DD/MM/YYYY'#39', strtodate(vValue)' +
        ');'
      #9#9#9'end;'
      ''
      #9#9#9'if SameText(vField, '#39'HORA'#39') then'
      #9#9#9'begin'
      
        '                 vValue := formatdatetime('#39'HH:MM:SS'#39', strtotime(' +
        'vValue));'
      #9#9#9'end;'
      ''
      '            mmR.Lines.Add(vField + '#39'-->'#39' + vValue);'
      #9#9'end;'
      #9'end;'
      '  finally'
      #9'sl.Free;'
      '  end;'
      'end;'
      ''
      'procedure CarregarArquivo(Sender: TObject);'
      'var'
      #9'vFileName: String;'
      'begin'
      #9'if files.ItemIndex >= 0 then'
      #9'begin'
      #9#9'vFileName := files.items[files.ItemIndex];'
      #9#9'ShowMessageFmt('#39'Carregando arquivo: %s'#39', [vFileName]);'
      #9#9'mmO.Lines.LoadFromFile(vFileName);'
      #9'end'
      #9'else'
      #9'  RaiseException(Exception.Create('#39'Selecione um arquivo.'#39'));'
      'end;'
      ''
      'procedure CreateForm;'
      'begin'
      '    t := TForm.Create(Self);'
      #9't.Caption := '#39'Titulo Novo'#39';'
      #9't.left := (Application.MainForm.ClientWidth div 2);'
      #9't.Position := poScreenCenter;'
      #9't.Height := 550;'
      #9't.Width := 600;'
      ''
      #9'l := TLabel.Create(t);'
      #9'l.Parent := t;'
      #9'l.caption := '#39'E'#39';'
      #9'l.Left := ESPACAMENTO;'
      #9'l.Top := ESPACAMENTO;'
      ''
      #9'// Criar um PANEL'
      #9'p := TPanel.Create(t);'
      #9'p.parent := t;'
      #9'p.Top := l.Top + l.Height + ESPACAMENTO; //Abaixo do label;'
      #9'p.Width := t.Width - ESPACAMENTO - TAMANHO_BORDA;'
      
        #9'p.Height := (t.Height - p.Top - ALTURA_BARRA_TITULO - ESPACAMEN' +
        'TO);'
      #9'p.Left := ((t.Width - p.Width) div 2) - TAMANHO_BORDA;'
      ''
      #9'// Um BOTAO no centro do panel'
      #9'b := TButton.Create(t);'
      #9'b.Parent := p;'
      #9'b.width := 150;'
      #9'b.height := 30;'
      #9'b.left := p.width - ESPACAMENTO - b.width;'
      #9'b.top := p.height - ALTURA_BARRA_TITULO - b.Height + 5;'
      #9'b.visible := True;'
      #9'b.caption := '#39'Separar os Dados'#39';'
      
        #9'b.enabled := not (UpperCase(l.Caption) = '#39'D'#39'); // Quero desabil' +
        'itar este botao caso o LABEL acima seja "D"'
      #9'b.OnClick := @SepararDados;'
      ''
      #9'// Um BOTAO no centro do panel'
      #9'btnListarArquivos '#9#9':= TButton.Create(t);'
      #9'btnListarArquivos.Parent '#9':= p;'
      #9'btnListarArquivos.width '#9':= 100;'
      #9'btnListarArquivos.height '#9':= 30;'
      #9'btnListarArquivos.left '#9#9':= ESPACAMENTO;'
      
        #9'btnListarArquivos.top '#9#9':= p.height - ALTURA_BARRA_TITULO - b.H' +
        'eight + 5;'
      #9'btnListarArquivos.visible '#9':= True;'
      #9'btnListarArquivos.caption '#9':= '#39'Listar Arquivos'#39';'
      
        #9'btnListarArquivos.enabled '#9':= True; // Quero desabilitar este b' +
        'otao caso o LABEL acima seja "D"'
      #9'btnListarArquivos.OnClick '#9':= @ExibirListaArquivos;'
      #9
      #9'btnCarregarArquivo := TButton.Create(t);'
      #9'btnCarregarArquivo.Parent '#9':= p;'
      #9'btnCarregarArquivo.width '#9':= 100;'
      #9'btnCarregarArquivo.height '#9':= 30;'
      
        #9'btnCarregarArquivo.left '#9#9':= btnListarArquivos.left + btnListar' +
        'Arquivos.width + ESPACAMENTO;'
      
        #9'btnCarregarArquivo.top '#9#9':= p.height - ALTURA_BARRA_TITULO - b.' +
        'Height + 5;'
      #9'btnCarregarArquivo.visible '#9':= True;'
      #9'btnCarregarArquivo.caption '#9':= '#39'Carregar Arquivo'#39';'
      #9'btnCarregarArquivo.enabled '#9':= True; '
      #9'btnCarregarArquivo.OnClick '#9':= @CarregarArquivo;'
      #9
      #9'mmO := TMemo.Create(p);'
      #9'mmO.Parent := p;'
      #9'mmO.ScrollBars := ssVertical;'
      #9'mmO.Left := ESPACAMENTO;'
      #9'mmO.Top := ESPACAMENTO;'
      
        #9'mmO.Height := (p.height div 2) - ALTURA_BARRA_TITULO - b.height' +
        ' - ESPACAMENTO;'
      #9'mmO.Width := p.width - ESPACAMENTO - 15;'
      ''
      #9'files := TListBox.Create(p);'
      #9'files.Parent := p;'
      #9'files.Left := ESPACAMENTO;'
      #9'files.Top := ESPACAMENTO + mmo.height + 10;'
      
        #9'files.Height := (p.height div 2) - ALTURA_BARRA_TITULO - b.heig' +
        'ht - ESPACAMENTO;'
      #9'files.Width := (p.width div 2) - ESPACAMENTO - 15;'
      ''
      #9'mmR := TMemo.Create(p);'
      #9'mmR.Parent := p;'
      #9'mmR.ScrollBars := ssVertical;'
      #9'mmR.Left := files.width + ESPACAMENTO + 15;'
      #9'mmR.Top := ESPACAMENTO + mmo.height + 10;'
      
        #9'mmR.Height := (p.height div 2) - ALTURA_BARRA_TITULO - b.height' +
        ' - ESPACAMENTO;'
      
        #9'mmR.Width := mmO.width - ((p.width div 2) - ESPACAMENTO - 15) -' +
        ' 15;'
      'end;'
      ''
      'begin'
      
        #9'if messagedlg('#39'Continuar a aplica'#231#227'o?'#39', mtConfirmation, [mbYes,' +
        ' mbNo], 0) = mrNo then'
      #9'begin'
      #9'   ShowMessage('#39'Aplica'#231#227'o encerrada.'#39');'
      #9'   Exit;'
      #9'end;   '
      #9
      #9'CreateForm;'
      #9'try'
      #9'  t.ShowModal;'
      '    finally'
      #9'  t.Free;'
      #9'end;'
      'end.')
    WantTabs = True
    FontSmoothing = fsmNone
    ExplicitWidth = 569
    ExplicitHeight = 222
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
    OnCompImport = PSScriptCompImport
    OnExecImport = PSScriptExecImport
    Plugins = <
      item
        Plugin = psmprt_cls1
      end
      item
        Plugin = psmprt_dtls1
      end
      item
        Plugin = psmprt_cntrls1
      end
      item
        Plugin = psi_std_1
      end
      item
        Plugin = psdlplgn_DLL
      end>
    UsePreProcessor = False
    Left = 312
    Top = 8
  end
  object psi_std_1: TPSImport_StdCtrls
    EnableExtCtrls = True
    EnableButtons = True
    Left = 368
    Top = 168
  end
  object psmprt_cls1: TPSImport_Classes
    EnableStreams = True
    EnableClasses = True
    Left = 368
    Top = 8
  end
  object psmprt_dtls1: TPSImport_DateUtils
    Left = 368
    Top = 56
  end
  object psmprt_cntrls1: TPSImport_Controls
    EnableStreams = True
    EnableGraphics = True
    EnableControls = True
    Left = 368
    Top = 112
  end
  object psdlplgn_DLL: TPSDllPlugin
    Left = 368
    Top = 232
  end
  object synpsyn1: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 240
    Top = 56
  end
end
