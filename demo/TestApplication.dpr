program TestApplication;

uses
  Forms,
  fMain in 'fMain.pas' {Frm_Main},
  RegisterPlugins in '..\src\Plugins\RegisterPlugins.pas',
  uPSI_Dialogs in '..\src\Plugins\uPSI_Dialogs.pas',
  FrameEditor in '..\src\FrameEditor.pas' {Frm_Editor: TFrame},
  PSResources in '..\src\PSResources.pas',
  uPSI_SysUtils in '..\src\Plugins\uPSI_SysUtils.pas',
  uPSI_Utils in '..\src\Plugins\uPSI_Utils.pas',
  PSMethods in '..\src\PSMethods.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Test Application';
  //Application.CreateForm(TFrm_Main, Frm_Main);
  Application.CreateForm(TFrm_Editor, Frm_Editor);
  Application.Run;
end.
