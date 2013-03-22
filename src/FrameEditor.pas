unit FrameEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, Menus, SynEdit,
  StdCtrls, ExtCtrls, SynEditHighlighter, SynHighlighterPas,
  uPSComponent, uPSCompiler, ActnList, ComCtrls, SynEditKeyCmds,
  SynCompletionProposal, uPSUtils, PSResources, uPSDebugger, uPSRunTime,
  SynEditMiscClasses, SynEditSearch, SynEditRegexSearch, SynEditTypes, SearchUtils;

type
  TFrm_Editor = class(TForm)
    Splitter1: TSplitter;
    Messages: TMemo;
    Editor: TSynEdit;
    SynPasSyn: TSynPasSyn;
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
    acSaveAs: TAction;
    acNew: TAction;
    acOpen: TAction;
    acExit: TAction;
    acReset: TAction;
    acFind: TAction;
    acReplace: TAction;
    acFindNext: TAction;
    acGoToLine: TAction;
    acCompile: TAction;
    acDecompile: TAction;
    acStepOver: TAction;
    acStepInto: TAction;
    acPause: TAction;
    acRun: TAction;
    StatusBar: TStatusBar;
    SynCompletionProposal: TSynCompletionProposal;
    SynEditSearch: TSynEditSearch;
    SynEditRegexSearch: TSynEditRegexSearch;
    procedure PSScript_Compile(Sender: TPSScript);
    procedure PSScript_Execute(Sender: TPSScript);
    procedure acSaveExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acResetExecute(Sender: TObject);
    procedure acCompileExecute(Sender: TObject);
    procedure acRunExecute(Sender: TObject);
    procedure acGoToLineExecute(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure SynCompletionProposalAfterCodeCompletion(Sender: TObject; const Value: string; Shift: TShiftState; Index: Integer; EndToken: Char);
    procedure EditorDropFiles(Sender: TObject; X, Y: Integer; AFiles: TStrings);
    procedure EditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure PSScriptDebuggerLineInfo(Sender: TObject;
      const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PSScriptDebuggerIdle(Sender: TObject);
    procedure PSScriptDebuggerAfterExecute(Sender: TPSScript);
    procedure PSScriptDebuggerBreakpoint(Sender: TObject;
      const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure EditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y,
      Line: Integer; Mark: TSynEditMark);
    procedure EditorGutterPaint(Sender: TObject; aLine, X, Y: Integer);
    procedure acStepOverExecute(Sender: TObject);
    procedure acStepIntoExecute(Sender: TObject);
    procedure acPauseExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acReplaceExecute(Sender: TObject);
    procedure EditorReplaceText(Sender: TObject; const ASearch,
      AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
  private
    FActiveFile: TFileName;
    FActiveLine: LongInt;
    FResume: Boolean;
    FSearchOptions: TSearchOptions;

    function Compile: Boolean;
    function SaveCheck: Boolean;

    procedure RegisterPlugins;

    procedure UpdateStatusBar;

    procedure LoadAutoComplete;

    procedure LoadFromFile(AFileName: string);

    procedure ExecuteSearch(AReplace: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ActiveFile: TFileName read FActiveFile;
  end;

var
  Frm_Editor: TFrm_Editor;

implementation

{$R *.dfm}

uses RegisterPlugins, Frm_GotoLine, StrUtils, Frm_SearchDialog,
  Frm_ReplaceDialog, Frm_ConfirmReplaceDialog;

{ TFrame1 }

procedure TFrm_Editor.acCompileExecute(Sender: TObject);
begin
  Compile;
end;

procedure TFrm_Editor.acExitExecute(Sender: TObject);
begin
  acReset.Execute;

  if SaveCheck then
  begin
    Close;
  end;
end;

procedure TFrm_Editor.acFindExecute(Sender: TObject);
var
  vSearch: TFrm_SearchDialog;
begin
  vSearch := TFrm_SearchDialog.Create(nil);
  try
    if Editor.SelAvail and (Editor.BlockBegin.Line = Editor.BlockEnd.Line) then
      FSearchOptions.SearchText := Editor.SelText
    else
      FSearchOptions.SearchText := Editor.GetWordAtRowCol(Editor.CaretXY);

    if vSearch.Execute(FSearchOptions) then
    begin
      ExecuteSearch(False);
    end;
  finally
    vSearch.Free;
  end;
end;

procedure TFrm_Editor.acFindNextExecute(Sender: TObject);
begin
  FSearchOptions.SearchFromCursor := True;

  if FSearchOptions.SearchText <> EmptyStr then
  begin
    ExecuteSearch(False);
  end
  else
    acFind.Execute;
end;

procedure TFrm_Editor.acGoToLineExecute(Sender: TObject);
begin
  with TFrm_GoToLine.Create(Editor.CaretX, Editor.CaretY) do
  try
    if Execute then
    begin
      Editor.CaretXY := CaretXY;
    end;
  finally
    Free;
    Editor.SetFocus;
  end;
end;

procedure TFrm_Editor.acNewExecute(Sender: TObject);
begin
  if SaveCheck then
  begin
    Editor.ClearAll;
    Editor.Lines.Text := sEmptyProgram;
    Editor.Modified := False;
    FActiveFile := EmptyStr;
  end;
end;

procedure TFrm_Editor.acOpenExecute(Sender: TObject);
begin
 if SaveCheck and OpenDialog1.Execute then
  begin
    LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFrm_Editor.acPauseExecute(Sender: TObject);
begin
  if PSScriptDebugger.Exec.Status = isRunning then
  begin
    PSScriptDebugger.Pause;
//    PSScriptDebugger.StepInto;
  end;
end;

procedure TFrm_Editor.acReplaceExecute(Sender: TObject);
var
  vSearch: TFrm_ReplaceDialog;
begin
  vSearch := TFrm_ReplaceDialog.Create(nil);
  try
    if vSearch.Execute(FSearchOptions) then
    begin
      ExecuteSearch(True);
    end;
  finally
    vSearch.Free;
  end;
end;

procedure TFrm_Editor.acResetExecute(Sender: TObject);
begin
  if PSScriptDebugger.Exec.Status in isRunningOrPaused then
  begin
    PSScriptDebugger.Stop;
  end;
end;

procedure TFrm_Editor.acRunExecute(Sender: TObject);
begin
  if PSScriptDebugger.Running then
  begin
    FResume := True;
  end
  else if Compile then
  begin
    if PSScriptDebugger.Execute then
    begin
      Messages.Lines.Add(sSuccessfullyExecuted);
    end else
    begin
      Messages.Lines.Add(Format(sRuntimeError,
                                ['[empty]', PSScriptDebugger.ExecErrorRow, PSScriptDebugger.ExecErrorCol,
                                 PSScriptDebugger.ExecErrorProcNo, PSScriptDebugger.ExecErrorByteCodePosition,
                                 PSScriptDebugger.ExecErrorToString]));
    end;
  end;
end;

procedure TFrm_Editor.acSaveAsExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    FActiveFile := SaveDialog1.FileName;
    Editor.Lines.SaveToFile(FActiveFile);
    Editor.Modified := False;
  end;
end;

procedure TFrm_Editor.acSaveExecute(Sender: TObject);
begin
  if FActiveFile <> EmptyStr then
  begin
    Editor.Lines.SaveToFile(FActiveFile);
    Editor.Modified := False;
  end
  else
  begin
    acSaveAs.Execute;
  end;
end;

procedure TFrm_Editor.acStepIntoExecute(Sender: TObject);
begin
  if PSScriptDebugger.Exec.Status in isRunningOrPaused then
  begin
    PSScriptDebugger.StepInto;
  end
  else
  begin
    if Compile then
    begin
      PSScriptDebugger.StepInto;
      PSScriptDebugger.Execute;
    end;
  end;
end;

procedure TFrm_Editor.acStepOverExecute(Sender: TObject);
begin
  if PSScriptDebugger.Exec.Status in isRunningOrPaused then
  begin
    PSScriptDebugger.StepOver;
  end
  else
  begin
    if Compile then
    begin
      PSScriptDebugger.StepInto;
      PSScriptDebugger.Execute;
    end;
  end;
end;

function TFrm_Editor.Compile: Boolean;
var
  i: Integer;
  vErrorFound: Boolean;
  vMessage: TPSPascalCompilerMessage;
begin
  Messages.Lines.Clear;

  PSScriptDebugger.Script.Assign(Editor.Lines);

  Messages.Lines.Add(sBeginCompile);

  Result := PSScriptDebugger.Compile;

  vErrorFound := False;

  for i := 0 to PSScriptDebugger.CompilerMessageCount - 1 do
  begin
    vMessage := PSScriptDebugger.CompilerMessages[i];

    Messages.Lines.Add(String(vMessage.MessageToString));

    if not vErrorFound and (vMessage is TIFPSPascalCompilerError) then
    begin
      Editor.SelStart := vMessage.Pos;

      vErrorFound := True;
    end;
  end;
end;

procedure TFrm_Editor.RegisterPlugins;
begin
  RegisterPSPlugins(PSScriptDebugger);

  //Custom Plugin to Handle events on form
  with TPSPluginItem(PSScriptDebugger.Plugins.Add) do
  begin
    Plugin := PSCustomPlugin;
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

procedure TFrm_Editor.SynCompletionProposalAfterCodeCompletion(Sender: TObject;
  const Value: string; Shift: TShiftState; Index: Integer; EndToken: Char);
begin
  if RightStr(Value, 1) = ')' then
  begin
    Editor.CaretX := Editor.CaretX - 1;
  end;
end;

procedure TFrm_Editor.UpdateStatusBar;
const
  spCaretPos = 0;
  spInsertMode = 1;
  spModified = 2;
  spFile = 3;
const
  InsertText: array[Boolean] of String = ('Overwrite', 'Insert');
begin
  StatusBar.Panels[spCaretPos].Text := Format('%d:%d', [Editor.CaretY, Editor.CaretX]);

  if Editor.ReadOnly then
    StatusBar.Panels[spInsertMode].Text := 'Read only'
  else
    StatusBar.Panels[spInsertMode].Text := InsertText[Editor.InsertMode];

  StatusBar.Panels[spModified].Text := IfThen(Editor.Modified, 'Modified');
  StatusBar.Panels[spFile].Text := FActiveFile;
end;

constructor TFrm_Editor.Create(AOwner: TComponent);
begin
  inherited;
  FSearchOptions := TSearchOptions.Create;

  Caption := sEditorTitle;

  RegisterPlugins;

  acNew.Execute;

  acCompile.Execute;

  UpdateStatusBar;
end;

destructor TFrm_Editor.Destroy;
begin
  FSearchOptions.Free;
  inherited;
end;

procedure TFrm_Editor.EditorDropFiles(Sender: TObject; X, Y: Integer; AFiles: TStrings);
begin
  if (AFiles.Count > 0) and SaveCheck then
  begin
    LoadFromFile(AFiles[0]);
  end;
end;

procedure TFrm_Editor.EditorGutterClick(Sender: TObject; Button: TMouseButton;
  X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if PSScriptDebugger.HasBreakPoint(PSScriptDebugger.MainFileName, Line) then
    PSScriptDebugger.ClearBreakPoint(PSScriptDebugger.MainFileName, Line)
  else
    PSScriptDebugger.SetBreakPoint(PSScriptDebugger.MainFileName, Line);
  Editor.Refresh;
end;

procedure TFrm_Editor.EditorGutterPaint(Sender: TObject; aLine, X, Y: Integer);
var
  vSize: Integer;
  vSpacer: Integer;
begin
  if PSScriptDebugger.HasBreakPoint(PSScriptDebugger.MainFileName, aLine) then
  begin
    Editor.Canvas.Brush.Style := bsSolid;
    Editor.Canvas.Brush.Color := clRed;
    Editor.Canvas.Pen.Color := clBlack;

    vSize := (Editor.Gutter.Width div 2) - 2;
    vSpacer := (Editor.Gutter.Width - vSize) div 2;

    Editor.Canvas.Ellipse(x + vSpacer, y + vSize, x + vSize + vSpacer, y);
  end;
end;

procedure TFrm_Editor.EditorReplaceText(Sender: TObject; const ASearch,
  AReplace: string; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
  vConfirmDialog: TFrm_ConfirmReplaceDialog;
begin
  vConfirmDialog := TFrm_ConfirmReplaceDialog.Create(nil);
  try
    if ASearch = AReplace then
      Action := raSkip
    else begin
      APos := Editor.ClientToScreen(
        Editor.RowColumnToPixels(
        Editor.BufferToDisplayPos(
          BufferCoord(Column, Line) ) ) );

      EditRect := ClientRect;
      EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
      EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

      vConfirmDialog.PrepareShow(EditRect, APos.X, APos.Y, APos.Y + Editor.LineHeight, ASearch);
      case vConfirmDialog.ShowModal of
        mrYes: Action := raReplace;
        mrYesToAll: Action := raReplaceAll;
        mrNo: Action := raSkip;
        else Action := raCancel;
      end;
    end;
  finally
    vConfirmDialog.Free;
  end;
end;

procedure TFrm_Editor.EditorSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
begin
  Special := False;

  if PSScriptDebugger.HasBreakPoint(PSScriptDebugger.MainFileName, Line) then
  begin
    Special := True;
    if Line = FActiveLine then
    begin
      BG := clWhite;
      FG := clRed;
    end else
    begin
      FG := clWhite;
      BG := clRed;
    end;
  end
  else if Line = FActiveLine then
  begin
    Special := True;
    FG := clWindowText;
    BG := clGradientActiveCaption;
  end;
end;

procedure TFrm_Editor.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
begin
  UpdateStatusBar;
end;

procedure TFrm_Editor.ExecuteSearch(AReplace: Boolean);
var
  vOptions: TSynSearchOptions;
  vReplaceText: string;
begin
  if FSearchOptions.SearchRegularExpression then
    Editor.SearchEngine := SynEditRegexSearch
  else
    Editor.SearchEngine := SynEditSearch;

  vOptions := FSearchOptions.SynEditOptions;

  vReplaceText := EmptyStr;
  if (ssoReplace in vOptions) then
  begin
    vReplaceText := FSearchOptions.ReplaceText;
  end;

  if Editor.SearchReplace(FSearchOptions.SearchText, vReplaceText, vOptions) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    Statusbar.SimpleText := sTextNotFound;
    if FSearchOptions.SearchBackwards then
      Editor.BlockEnd := Editor.BlockBegin
    else
      Editor.BlockBegin := Editor.BlockEnd;

    Editor.CaretXY := Editor.BlockBegin;
  end;
end;

procedure TFrm_Editor.LoadAutoComplete;
const
  sFunctionStyle  = '\COLOR{clNavy}function \COLOR{clBlack}\STYLE{+B}%s\STYLE{-B}%s;';
  sProcedureStyle = '\COLOR{clNavy}procedure \COLOR{clBlack}\STYLE{+B}%s\STYLE{-B}%s;';
  sVariableStyle = '\COLOR{clNavy}var \COLOR{clBlack}\STYLE{+B}%s: \STYLE{-B}%s;';
  sConstStyle = '\COLOR{clNavy}const \COLOR{clBlack}\STYLE{+B}%s: \COLOR{clBlue}\STYLE{-B}%s;';
  sTypeStyle = '\COLOR{clNavy}type \COLOR{clBlack}\STYLE{+B}%s: \COLOR{clBlue}\STYLE{-B}%s;';
var
  i: Integer;
  obj: TPSRegProc;
  obj_var: TPSVar;
  obj_const: TPSConstant;
  obj_type: TPSType;
  vTemplate: string;
begin
  SynCompletionProposal.ItemList.Clear;

  for i:= 0 to PSScriptDebugger.Comp.GetRegProcCount-1 do
  begin
    obj := PSScriptDebugger.Comp.GetRegProc(i);

    vTemplate := sProcedureStyle;
    if obj.Decl.Result <> nil then
    begin
      vTemplate := sFunctionStyle;
    end;

    SynCompletionProposal.AddItem(Format(vTemplate, [obj.OrgName, TPsUtils.GetMethodParametersDeclaration(obj.Decl)]), UnicodeString(obj.OrgName + '()'));
  end;

  for i:= 0 to PSScriptDebugger.Comp.GetVarCount-1 do
  begin
    obj_var := PSScriptDebugger.Comp.GetVar(i);

    SynCompletionProposal.AddItem(Format(sVariableStyle, [obj_var.OrgName, obj_var.aType.OriginalName]), UnicodeString(obj_var.OrgName));
  end;

  for i := 0 to PSScriptDebugger.Comp.GetConstCount-1 do
  begin
   obj_const := PSScriptDebugger.Comp.GetConst(i);

   SynCompletionProposal.AddItem(Format(sConstStyle, [obj_const.OrgName, TPSUtils.GetAsString(PSScriptDebugger, obj_const.Value)]), UnicodeString(obj_const.OrgName));
  end;

  for i := 0 to PSScriptDebugger.Comp.GetTypeCount-1 do
  begin
    obj_type := PSScriptDebugger.Comp.GetType(i);

    SynCompletionProposal.AddItem(Format(sTypeStyle, [obj_type.OriginalName, TPSUtils.GetPSTypeName(PSScriptDebugger, obj_type)]), UnicodeString(obj_type.OriginalName));
  end;
end;

procedure TFrm_Editor.LoadFromFile(AFileName: string);
var
  vRelativePath: string;
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));

  vRelativePath := ExtractRelativePath(IncludeTrailingPathDelimiter(GetCurrentDir), ExtractFilePath(AFileName));

  Editor.ClearAll;
  Editor.Lines.LoadFromFile(vRelativePath + ExtractFileName(AFileName));
  Editor.Modified := False;
  FActiveFile := AFileName;

  UpdateStatusBar;
end;

procedure TFrm_Editor.PSScript_Compile(Sender: TPSScript);
begin
  Sender.AddRegisteredVariable('Application',  'TApplication' );
  Sender.AddRegisteredVariable('Self', 'TForm');

  LoadAutoComplete;
end;

procedure TFrm_Editor.PSScriptDebuggerAfterExecute(Sender: TPSScript);
begin
  Caption := sEditorTitle;
  FActiveLine := 0;
  Editor.Refresh;
end;

procedure TFrm_Editor.PSScriptDebuggerBreakpoint(Sender: TObject;
  const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  FActiveLine := Row;
  if (FActiveLine < Editor.TopLine+2) or (FActiveLine > Editor.TopLine + Editor.LinesInWindow-2) then
  begin
    Editor.TopLine := FActiveLine - (Editor.LinesInWindow div 2);
  end;
  Editor.CaretY := FActiveLine;
  Editor.CaretX := 1;

  Editor.Refresh;
end;

procedure TFrm_Editor.PSScriptDebuggerIdle(Sender: TObject);
begin
  Application.ProcessMessages;
  //Birb: don't use Application.HandleMessage here,
  //else GUI will be unrensponsive if you have a tight loop
  //and won't be able to use Run/Reset menu action
  if FResume then
  begin
    FResume := False;
    PSScriptDebugger.Resume;
    FActiveLine := 0;
    Editor.Refresh;
  end
  else
  begin
    if (PSScriptDebugger.Exec.DebugMode = dmPaused) then
      Caption := sEditorTitleStopped
    else if (PSScriptDebugger.Exec.Status = isPaused) then
      Caption := sEditorTitlePaused
    else
      Caption := sEditorTitleRunning;
  end;
end;

procedure TFrm_Editor.PSScriptDebuggerLineInfo(Sender: TObject;
  const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  if (PSScriptDebugger.Exec.DebugMode <> dmRun) and (PSScriptDebugger.Exec.DebugMode <> dmStepOver) then
  begin
    FActiveLine := Row;
    if (FActiveLine < Editor.TopLine +2) or (FActiveLine > Editor.TopLine + Editor.LinesInWindow-2) then
    begin
      Editor.TopLine := FActiveLine - (Editor.LinesInWindow div 2);
    end;

    Editor.CaretY := FActiveLine;
    Editor.CaretX := 1;

    Editor.Refresh;
  end
  else
    Application.ProcessMessages;
end;

procedure TFrm_Editor.PSScript_Execute(Sender: TPSScript);
begin
  Sender.SetVarToInstance('Application', Application);
  Sender.SetVarToInstance('Self', Self);
end;

end.
