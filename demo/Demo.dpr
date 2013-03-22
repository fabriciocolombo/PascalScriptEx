program Demo;

uses
  Forms,
  RegisterPlugins in '..\src\Plugins\RegisterPlugins.pas',
  uPSI_Dialogs in '..\src\Plugins\uPSI_Dialogs.pas',
  FrameEditor in '..\src\FrameEditor.pas' {Frm_Editor: TFrame},
  PSResources in '..\src\PSResources.pas',
  uPSI_SysUtils in '..\src\Plugins\uPSI_SysUtils.pas',
  uPSI_Utils in '..\src\Plugins\uPSI_Utils.pas',
  PSMethods in '..\src\PSMethods.pas',
  Frm_GotoLine in '..\src\Frm_GotoLine.pas' {Frm_GoToLine},
  Frm_ConfirmReplaceDialog in '..\src\Frm_ConfirmReplaceDialog.pas' {Frm_ConfirmReplaceDialog},
  Frm_SearchDialog in '..\src\Frm_SearchDialog.pas' {Frm_SearchDialog},
  SearchUtils in '..\src\SearchUtils.pas',
  Frm_ReplaceDialog in '..\src\Frm_ReplaceDialog.pas' {Frm_ReplaceDialog};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Test Application';
  //Application.CreateForm(TFrm_Main, Frm_Main);
  Application.CreateForm(TFrm_Editor, Frm_Editor);
  Application.Run;
end.
