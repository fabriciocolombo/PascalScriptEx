unit uPSI_Utils;

interface

uses uPSComponent, uPSRuntime, uPSCompiler;

type
  TPSImport_Utils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

implementation

{ TPSImport_Utils }

uses PSMethods;

procedure TPSImport_Utils.CompileImport1(CompExec: TPSScript);
begin
  inherited;
  CompExec.AddFunction(@PSMethods.ListFiles,  'procedure ListFiles(ADirectory, AFilter: string; AList: TStrings);');
  CompExec.AddFunction(@PSMethods.InternalRaiseException, 'procedure RaiseException(E: Exception);');
end;

procedure TPSImport_Utils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  inherited;

end;

end.
