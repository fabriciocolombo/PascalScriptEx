unit PSResources;

interface

uses Classes, SysUtils, uPSRunTime, uPSCompiler, uPSComponent, Variants, Types, TypInfo, uPSUtils;

resourcestring
  sBeginCompile = 'Compiling';
  sSuccessfullyCompiled = 'Succesfully compiled';
  sSuccessfullyExecuted = 'Succesfully executed';
  sRuntimeError = '[Runtime error] %s(%d:%d), bytecode(%d:%d): %s';
  sTextNotFound = 'Text not found';
  sUnnamed = 'Unnamed';
  sEditorTitle = 'Editor';
  sEditorTitleRunning = 'Editor - Running';
  sEditorTitlePaused = 'Editor - Paused';
  sEditorTitleStopped = 'Editor - Stopped';
  sInputBoxTiyle = 'Script';
  sFileNotSaved = 'File has not been saved, save now?';
  sEmptyProgram = 'Program myprogram;' + sLineBreak + sLineBreak +
                  'begin' + sLineBreak +
                  'end.';

const
  isRunningOrPaused = [isRunning, isPaused];

type
  TPSUtils = class
  public
    class function GetValue(AValue: PIfRVariant): Variant;
    class function GetAsString(APsScript: TPSScript; AValue: PIfRVariant): UnicodeString;

    class function GetPSTypeName(APsScript: TPSScript; APSType: TPSType): TbtString;
    class function GetMethodDeclaration(AMethodName: TbtString; APSParametersDecl: TPSParametersDecl): TbtString;
    class function GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): TbtString;

    class function GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: TbtString) : Boolean;
  end;

implementation

{ TConstanstUtils }

class function TPSUtils.GetAsString(APsScript: TPSScript; AValue: PIfRVariant): UnicodeString;
begin
  case AValue.FType.BaseType of
    btChar: Result := String(tbtChar(AValue^.tchar));
    btString: Result := String(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: Result := tbtUnicodeString(AValue^.tunistring);
    btU8: Result := SysUtils.IntToStr(TbtU8(AValue^.tu8));
    btS8: Result := SysUtils.IntToStr(TbtS8(AValue^.tS8));
    btU16: Result := SysUtils.IntToStr(TbtU16(AValue^.tu16));
    btS16: Result := SysUtils.IntToStr(TbtS16(AValue^.ts16));
    btSet: begin
             Result := 'set of ' + String(TPSSetType(AValue^.FType).SetType.OriginalName);
           end;
    btU32: Result := SysUtils.IntToStr(TbtU32(AValue^.tu32));
    btEnum: begin
             Result := Format('%s(%d)', [AValue^.FType.OriginalName, TbtU32(AValue^.tu32)]);
            end;
    btS32: Result := SysUtils.IntToStr(TbtS32(AValue^.ts32));
    btSingle: Result := SysUtils.FloatToStr(TbtSingle(AValue^.tsingle));
    btDouble: Result := SysUtils.FloatToStr(TbtDouble(AValue^.tdouble));
    btExtended: Result := SysUtils.FloatToStr(AValue^.textended);
    btCurrency: Result := SysUtils.CurrToStr(AValue^.tcurrency);
    {$IFNDEF PS_NOINT64}
      btS64: Result := SysUtils.IntToStr(AValue^.ts64);
    {$ENDIF}
  else
    Result := EmptyStr;
  end;
end;

class function TPSUtils.GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: TbtString) : Boolean;
var
  i: Integer;
  vConst: TPSConstant;
begin
  ALow := EmptyAnsiStr;
  AHigh := EmptyAnsiStr;

  for i := 0 to APsScript.Comp.GetConstCount-1 do
  begin
    vConst := APsScript.Comp.GetConst(i);

    if (vConst.Value^.FType = AType) then
    begin
      if ALow = EmptyAnsiStr then
      begin
        ALow := vConst.OrgName;
      end;
      AHigh := vConst.OrgName;
    end;
  end;

  Result := (AHigh <> '');
end;

class function TPSUtils.GetMethodDeclaration(AMethodName: TbtString; APSParametersDecl: TPSParametersDecl): TbtString;
var
  vDecl: TbtString;
begin
  vDecl := AMethodName + GetMethodParametersDeclaration(APSParametersDecl);

  if APSParametersDecl.Result <> nil then
  begin
    Result := 'function ' + vDecl;
  end
  else
  begin
    Result := 'procedure ' + vDecl;
  end;
end;

class function TPSUtils.GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): TbtString;
var
  i: Integer;
  vDecl: TbtString;
  vParam: TPSParameterDecl;
begin
  vDecl := EmptyAnsiStr;
  for i := 0 to APSParametersDecl.ParamCount-1 do
  begin
    vParam := APSParametersDecl.Params[i];

    case vParam.Mode of
      pmOut: vDecl := vDecl + 'out ';
      pmInOut: vDecl := vDecl + 'var ';
    end;

    vDecl := vDecl + vParam.OrgName;

    if vParam.aType <> nil then
    begin
      vDecl := vDecl + ': ' + vParam.aType.OriginalName;
    end;

    if (i < APSParametersDecl.ParamCount-1) then
    begin
      vDecl := vDecl + '; ';
    end;
  end;

  if (vDecl <> EmptyAnsiStr) then
  begin
    vDecl := '(' + vDecl + ')';
  end;

  Result := vDecl;

  if APSParametersDecl.Result <> nil then
  begin
    Result := Result + ':' + APSParametersDecl.Result.OriginalName;
  end;
end;

class function TPSUtils.GetPSTypeName(APsScript: TPSScript; APSType: TPSType): TbtString;
var
  vLow, vHigh: TbtString;
begin
  case APSType.BaseType of
    btProcPtr: Result := GetMethodDeclaration(APSType.OriginalName, TPSProceduralType(APSType).ProcDef);
//    BtTypeCopy: Result := TPSTypeLink.Create;
    btRecord: Result := 'record';
    btArray: Result := 'array of ' + GetPSTypeName(APsScript, TPSArrayType(APSType).ArrayTypeNo);
//    btStaticArray: Result := 'array of ' + GetPSTypeName(TPSStaticArrayType(APSType).ArrayTypeNo);
    btEnum: begin
              if GetEnumBounds(APsScript, APSType, vLow, vHigh) then
              begin
                Result := vLow + '..' + vHigh;
              end
              else
              begin
                Result := '0..' + IntToStr(TPSEnumType(APSType).HighValue);
              end;
            end;
    btClass: begin
               Result := 'class';

               with TPSClassType(APSType).Cl do
               begin
                 if Assigned(ClassInheritsFrom) then
                 begin
                   Result := Result + '(' + ClassInheritsFrom.aType.OriginalName + ')';
                 end;
               end;
             end;
    btExtClass: REsult := TPSUndefinedClassType(APSType).ExtClass.SelfType.OriginalName;
    btNotificationVariant, btVariant: Result := TPSVariantType(APSType).OriginalName;
    {$IFNDEF PS_NOINTERFACES}
    btInterface: begin
                   Result := 'interface';

                   with TPSInterfaceType(APSType).Intf do
                   begin
                     if Assigned(InheritedFrom) then
                     begin
                       Result := Result + '(' + InheritedFrom.aType.OriginalName + ')';
                     end;
                   end;
                 end;
    {$ENDIF}
  else
    Result := APSType.OriginalName;
  end;
end;

class function TPSUtils.GetValue(AValue: PIfRVariant): Variant;
begin
  case AValue.FType.BaseType of
    btChar: Result := tbtWidestring(AValue^.tchar);
    btString: Result := tbtWidestring(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: result := tbtUnicodeString(AValue^.tunistring);
    btU8: Result := TbtU8(AValue^.tu8);
    btS8: Result := TbtS8(AValue^.tS8);
    btU16: Result := TbtU16(AValue^.tu16);
    btS16: Result := TbtS16(AValue^.ts16);
    btU32, btEnum: Result := TbtU32(AValue^.tu32);
    btS32: Result := TbtS32(AValue^.ts32);
    btSingle: Result := TbtSingle(AValue^.tsingle);
    btDouble: Result := TbtDouble(AValue^.tdouble);
    btExtended: Result := TbtExtended(AValue^.textended);
    btCurrency: Result := TbtCurrency(AValue^.tcurrency);
    {$IFNDEF PS_NOINT64}
      btS64: Result := TbtS64(AValue^.ts64);
    {$ENDIF}
  else
    Result := varUnknown;
  end;
end;

end.
