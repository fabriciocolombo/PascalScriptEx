unit PSMethods;

interface

uses Classes, SysUtils;

function ListFiles(ADirectory, AFilter: string; AList: TStrings) : Boolean;
procedure InternalRaiseException(E: Exception);

implementation

function ListFiles(ADirectory, AFilter: string; AList: TStrings) : Boolean;
var
  S: TSearchRec;
  vDir: string;
begin
  Result := False;

  vDir := IncludeTrailingPathDelimiter(ADirectory);

  if not DirectoryExists(vDir) then
  begin
    raise Exception.CreateFmt('Directory "%s" does not exists.', [vDir]);
  end;

  try
    Result := FindFirst(vDir + AFilter, faAnyFile, S) = 0;
    repeat
      if (S.Name <> '.') and (S.Name <> '..') then
      begin
        AList.Add(vDir + S.name);
      end;
    until FindNext(S) <> 0;
  finally
    FindClose(S);
  end;
end;

procedure InternalRaiseException(E: Exception);
begin
  raise E;
end;

end.
