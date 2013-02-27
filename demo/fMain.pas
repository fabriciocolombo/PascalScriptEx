{
   ====================================================================
   Sistema Exemplo dos componentes do pacote REMOBJECTS - Script Pascal
   ====================================================================
   Escrito por:
      Murilo Cunha         - murilo_cunha @ ig.com.br
      Fabricio Colombo     - fabricio.colombo.mva @ gmail.com
   Data: 24/02/2013

   Objetivo:
      - Mostrar como usar os componentes de uma forma mais aprofundada

   Mudancas no codigo:
   -------------------
   Data - Autor - Descricao breve da mudanca


}

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, uPSComponent, uPSCompiler, Menus, uPSRuntime, Variants, uPSComponent_StdCtrls,
  uPSComponent_Controls, uPSComponent_Forms, uPSComponent_DB, uPSComponent_COM, uPSComponent_Default,
  SynEditHighlighter, SynHighlighterPas, SynEdit;

type
  TForm1 = class(TForm)
    Memo2: TMemo;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    Program1: TMenuItem;
    Compile1: TMenuItem;
    PSScript: TPSScript;
    mnpN1: TMenuItem;
    mnpSair1: TMenuItem;
    psi_std_1: TPSImport_StdCtrls;
    psmprt_cls1: TPSImport_Classes;
    psmprt_dtls1: TPSImport_DateUtils;
    psmprt_cntrls1: TPSImport_Controls;
    psdlplgn_DLL: TPSDllPlugin;
    Memo1: TSynEdit;
    synpsyn1: TSynPasSyn;
    procedure PSScriptCompile(Sender: TPSScript);
    procedure Compile1Click(Sender: TObject);
    procedure PSScriptExecute(Sender: TPSScript);
    procedure PSScriptCompImport(Sender: TObject; x: TPSPascalCompiler);
    procedure PSScriptExecImport(Sender: TObject; se: TPSExec; x: TPSRuntimeClassImporter);
    procedure mnpSair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1        : TForm1;

implementation
uses
  uPSR_std,
  uPSC_std,
  uPSR_stdctrls,
  uPSC_stdctrls,
  uPSR_forms,
  uPSC_forms,
  uPSC_graphics,
  uPSC_controls,
  uPSC_classes,
  uPSR_graphics,
  uPSR_controls,
  uPSR_classes,
  uPSC_comobj,
  uPSR_comobj;

{$R *.DFM}

function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;
begin
  Result := s1 + ' ' + IntToStr(s2) + ' ' + IntToStr(s3) + ' ' + IntToStr(s4) + ' - OK!';
  S5 := s5 + ' '+ result + ' -   OK2!';
end;

procedure MyWriteln(const s: string);
begin
  Form1.Memo2.Lines.Add(s);
end;

function MyReadln(const question: string): string;
begin
  Result := InputBox(question, '', '');
end;

function MyListarArquivos(strDiretorio, strFiltro: string): TStrings;
var
   S              : TSearchRec;
   strDirComBarra : string;
begin
   try
      Result := TStringList.Create;
      strDirComBarra := IncludeTrailingPathDelimiter( strDiretorio );
      FindFirst(strDirComBarra + strFiltro, faAnyFile, S);
      repeat
         if (S.Name <> '.') and (S.Name <> '..') then
         begin
          Result.Add(Pchar(strDirComBarra + S.name));
         end;
      until
         FindNext(S) <> 0;
   finally
      FindClose(S);
   end;
end;

procedure MyRaiseException(E: Exception);
begin
  raise E;
end;

procedure TForm1.mnpSair1Click(Sender: TObject);
begin
   Close;
end;

procedure TForm1.PSScriptCompile(Sender: TPSScript);
begin
//
// Para funcoes mais complicadas (dificeis de registrar),
// deve-se montar o script no Delphi e registrar sua chamada no PascalScript
//
   Sender.AddFunction(@MyWriteln,         'procedure MyWriteln(s: string);');
   Sender.AddFunction(@MyReadln,          'function MyReadln(question: string): string;');
   Sender.AddFunction(@ImportTest,        'function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;');
   Sender.AddFunction(@MyListarArquivos,  'function ListarArquivos(strDiretorio: string; strFiltro: string): TStrings;');
   Sender.AddFunction(@MyRaiseException, 'procedure RaiseException(E: Exception);');

//
// FIM
//

//
// Para manipulacao dos FORMS, VARIAVEIS e COMPONENTES da aplicacao Delphi,
//    deve-se declarar estes componentes como variaveis dentro do PascalScript
// Tambem deve-se declarar estas variaveis na secao "EXECUTE" do ScriptPascal
   Sender.AddRegisteredVariable('vars',         'Variant'      );
   Sender.AddRegisteredVariable('Application',  'TApplication' );
   Sender.AddRegisteredVariable('Self',         'TForm'        );
   Sender.AddRegisteredVariable('Memo1',        'TMemo'        );
   Sender.AddRegisteredVariable('Memo2',        'TMemo'        );
   Sender.AddRegisteredVariable('AName',        'string'       );
   Sender.AddRegisteredVariable('TTime',        'TDateTime'    );
//
// FIM
//

//
// AINDA NAO CONSEGUI DEFINIR O USO DESTE COMANDOS ABAIXO
//
//   with Sender.Comp.AddClass(Sender.comp.FindClass('TPersistent'), TComponent) do
//      RegisterMethod('function FindComponent(const AName: string): TComponent;');
//   PSScript.AddRegisteredPTRVariable('pnlObs', 'TPan');
//   PSScript.Comp.AddClass(PSScript.Comp.FindClass('TObject'), TPanel);
//
// FIM
//
end;

procedure TForm1.PSScriptExecute(Sender: TPSScript);
begin
//
// Declaracao das variaveis preparadas na secao "COMPILE" do PascalScript
//
   PSScript.SetVarToInstance('APPLICATION', Application);
   PSScript.SetVarToInstance('SELF', Self);
   PSScript.SetVarToInstance('MEMO1', Memo1);
   PSScript.SetVarToInstance('MEMO2', Memo2);
//
// FIM
//

//   PPSVariantVariant(PSScript.GetVariable('VARS'))^.Data := VarArrayCreate([0, 1], varShortInt);
//   PSScript.SetPointerToData('pnlObs', @pnl1, PSScript.FindNamedType('TCustomControl'));
//   PSScript.SetVarToInstance('pnlObs', pnl1);
end;

procedure TForm1.PSScriptCompImport(Sender: TObject; x: TPSPascalCompiler);
begin
   SIRegister_Std(x);
   SIRegister_Classes(x, true);
   SIRegister_Graphics(x, true);
   SIRegister_Controls(x);
   SIRegister_stdctrls(x);
   SIRegister_Forms(x);
   SIRegister_ComObj(x);


// As intrucoes com "ADDDELPHIFUNCTION" devem ser declaradas na secao EXECIMPORT do componente PascalScript
// As funcoes com tipos especiais de variaveis, devem ser inseridas com o "ADDTYPES" do PascalScript
//
   PSScript.Comp.AddTypeS('TMsgDlgType', '(mtWarning, mtError, mtInformation, mtConfirmation, mtCustom)');
   PSScript.Comp.AddTypeS('TMsgDlgBtn', '(mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose)');
   PSScript.Comp.AddTypeS('TMsgDlgButtons', 'set of TMsgDlgBtn');
   PSScript.Comp.AddDelphiFunction('function MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;');
   // O Script Pascal nao aceita criacao de vetores diretamente, tem-se que criar um grupo e depois referenciar este grupo para criar o vetor
   PSScript.Comp.AddTypeS('TRepFlag', '(rfReplaceAll, rfIgnoreCase)');
   PSScript.Comp.AddTypeS('TReplaceFlags', 'set of TRepFlag');
   PSScript.Comp.AddDelphiFunction('function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;');
   // Funcoes mais simples nao precisam de declaracao de Tipos
   PSScript.Comp.AddDelphiFunction('function ExtractFilePath(const FileName: string): string;');
   PSScript.Comp.AddDelphiFunction('function ExtractFileName(const FileName: string): string;');
   PSScript.Comp.AddDelphiFunction('function StrToTime(const S: string): TDateTime;');
   PSScript.Comp.AddDelphiFunction('procedure ShowMessage(const Msg: string);');
   PSScript.Comp.AddDelphiFunction('procedure ShowMessageFmt(const Msg: string; Params: array of const);');
   PSScript.Comp.AddDelphiFunction('function SameText(const S1, S2: string): Boolean;');

   with PSScript.Comp.AddClassN(PSScript.Comp.FindClass('TObject'), 'EXCEPTION') do
   begin
      RegisterMethod('constructor Create(const Msg: string)');
      RegisterProperty('Message', 'String', iptR);
   end;
//
// FIM
//
end;

procedure ExceptionMessageR(Self: Exception; var S: String);
begin
  S := Self.Message;
end;

procedure TForm1.PSScriptExecImport(Sender: TObject; se: TPSExec; x: TPSRuntimeClassImporter);
begin
  RIRegister_Std(x);
  RIRegister_Classes(x, True);
  RIRegister_Graphics(x, True);
  RIRegister_Controls(x);
  RIRegister_stdctrls(x);
  RIRegister_Forms(x);
//  RIRegister_ComObj(exec);

//
// Registro das funcoes declaradas na secao COMPIMPORT
//
   PSScript.Exec.RegisterDelphiFunction(@ExtractFilePath,   'EXTRACTFILEPATH',   cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@ExtractFileName,   'EXTRACTFILENAME',   cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@StrToTime,         'STRTOTIME',         cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@StringReplace,     'STRINGREPLACE',     cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@ShowMessage,       'SHOWMESSAGE',       cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@ShowMessageFmt, 'ShowMessageFmt', cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@MessageDlg,        'MESSAGEDLG',        cdRegister);
   PSScript.Exec.RegisterDelphiFunction(@SameText,        'SameText',        cdRegister);
//
// FIM
//

   with x.Add(Exception) do
   begin
      RegisterConstructor(@Exception.Create, 'Create');
      RegisterPropertyHelper(@ExceptionMessageR, nil, 'Message');
   end;
end;

procedure TForm1.Compile1Click(Sender: TObject);
  procedure OutputMessages;
  var
    l: Longint;
    b: Boolean;
  begin
    b := False;

    for l := 0 to PSScript.CompilerMessageCount - 1 do
    begin
      Memo2.Lines.Add('Compilador: '+ PSScript.CompilerErrorToStr(l));
      if (not b) and (PSScript.CompilerMessages[l] is TIFPSPascalCompilerError) then
      begin
        b := True;
        Memo1.SelStart := PSScript.CompilerMessages[l].Pos;
      end;
    end;
  end;
begin
   Memo2.Lines.Clear;
   PSScript.Script.Assign(Memo1.Lines);
   Memo2.Lines.Add('Compilando');
   if PSScript.Compile then
   begin
      OutputMessages;
      Memo2.Lines.Add('Compilado corretamente');
      if not PSScript.Execute then
      begin
         Memo1.SelStart := PSScript.ExecErrorPosition;
         Memo2.Lines.Add(PSScript.ExecErrorToString +' em '+Inttostr(PSScript.ExecErrorProcNo)+'.'+Inttostr(PSScript.ExecErrorByteCodePosition));
      end
      else
      begin
         Memo2.Lines.Add('Executado corretamente');
      end;
   end
   else
   begin
      OutputMessages;
      Memo2.Lines.Add('Compilação com erro');
   end;
end;

end.
