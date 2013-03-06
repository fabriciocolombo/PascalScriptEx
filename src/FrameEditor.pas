unit FrameEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, SynEdit,
  Vcl.StdCtrls, Vcl.ExtCtrls, SynEditHighlighter, SynHighlighterPas,
  uPSComponent, uPSCompiler, Vcl.ActnList;

type
  TFrm_Editor = class(TForm)
    Splitter1: TSplitter;
    Messages: TMemo;
    Editor: TSynEdit;
    SynPasSyn: TSynPasSyn;
    PSScript: TPSScript;
    PSScriptDebugger: TPSScriptDebugger;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    N3: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N4: TMenuItem;
    Exit1: TMenuItem;
    Search1: TMenuItem;
    Find1: TMenuItem;
    Replace1: TMenuItem;
    Searchagain1: TMenuItem;
    N6: TMenuItem;
    Gotolinenumber1: TMenuItem;
    Run1: TMenuItem;
    Syntaxcheck1: TMenuItem;
    Compile1: TMenuItem;
    Decompile1: TMenuItem;
    N5: TMenuItem;
    StepOver1: TMenuItem;
    StepInto1: TMenuItem;
    N1: TMenuItem;
    Pause1: TMenuItem;
    Reset1: TMenuItem;
    N2: TMenuItem;
    Run: TMenuItem;
    este1: TMenuItem;
    SaveCompile1: TMenuItem;
    LoadCompiled1: TMenuItem;
    ActionList1: TActionList;
    acSave: TAction;
    PSCustomPlugin: TPSCustomPlugin;
    procedure Compile1Click(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure PSScriptCompile(Sender: TPSScript);
    procedure PSScriptExecute(Sender: TPSScript);
  private
    FActiveFile: TFileName;
    function Compile: Boolean;
    function SaveCheck: Boolean;

    procedure RegisterPlugins;
  public
    constructor Create(AOwner: TComponent); override;

    property ActiveFile: TFileName read FActiveFile;

  end;

var
  Frm_Editor: TFrm_Editor;

implementation

{$R *.dfm}

uses PSResources, RegisterPlugins;

{ TFrame1 }

procedure TFrm_Editor.Compile1Click(Sender: TObject);
begin
  Compile;
end;

procedure TFrm_Editor.acSaveExecute(Sender: TObject);
begin
//
end;

function TFrm_Editor.Compile: Boolean;
var
  i: Integer;
  vErrorFound: Boolean;
  vMessage: TPSPascalCompilerMessage;
begin
  Messages.Lines.Clear;

  PSScript.Script.Assign(Editor.Lines);

  Messages.Lines.Add(sBeginCompile);

  Result := PSScript.Compile;

  for i := 0 to PSScript.CompilerMessageCount - 1 do
  begin
    vMessage := PSScript.CompilerMessages[i];

    Messages.Lines.Add(vMessage.MessageToString);

    if not vErrorFound and (vMessage is TIFPSPascalCompilerError) then
    begin
      Editor.SelStart := vMessage.Pos;
    end;
  end;
end;

procedure TFrm_Editor.RegisterPlugins;
begin
  RegisterPSPlugins(PSScript);
  RegisterPSPlugins(PSScriptDebugger);

  //Custom Plugin to Handle events on form
  with TPSPluginItem(PSScript.Plugins.Add) do
  begin
    Plugin := PSCustomPlugin;
  end;
  with TPSPluginItem(PSScriptDebugger.Plugins.Add) do
  begin
    Plugin := PSCustomPlugin;
  end;
end;

procedure TFrm_Editor.RunClick(Sender: TObject);
begin
  if Compile then
  begin
    if PSScript.Execute then
    begin
      Messages.Lines.Add(sSuccessfullyExecuted);
    end else
    begin
      Messages.Lines.Add(Format(sRuntimeError,
                                ['[empty]', PSScript.ExecErrorRow, PSScript.ExecErrorCol,
                                 PSScript.ExecErrorProcNo, PSScript.ExecErrorByteCodePosition,
                                 PSScript.ExecErrorToString]));
    end;
  end;
end;

function TFrm_Editor.SaveCheck: Boolean;
begin
  if Editor.Modified then
  begin
    case MessageDlg(sFileNotSaved, mtConfirmation, mbYesNoCancel, 0) of
      mrYes:
        begin
          acSave.Execute;

          Result := FActiveFile <> EmptyStr;
        end;
      mrNo: Result := True;
      else
        Result := False;
    end;
  end
  else
    Result := True;
end;

constructor TFrm_Editor.Create(AOwner: TComponent);
begin
  inherited;

  Caption := sEditorTitle;

  RegisterPlugins;
end;

procedure TFrm_Editor.Open1Click(Sender: TObject);
begin
 if SaveCheck then
  begin
    if OpenDialog1.Execute then
    begin
      Editor.ClearAll;
      Editor.Lines.LoadFromFile(OpenDialog1.FileName);
      Editor.Modified := False;
      FActiveFile := OpenDialog1.FileName;
    end;
  end;
end;

procedure TFrm_Editor.PSScriptCompile(Sender: TPSScript);
begin
  Sender.AddRegisteredVariable('Application',  'TApplication' );
  Sender.AddRegisteredVariable('Self', 'TForm');
end;

procedure TFrm_Editor.PSScriptExecute(Sender: TPSScript);
begin
  Sender.SetVarToInstance('Application', Application);
  Sender.SetVarToInstance('Self', Self);
end;

end.
