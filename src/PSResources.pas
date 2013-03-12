unit PSResources;

interface

uses Classes, SysUtils, uPSRunTime, uPSCompiler, uPSComponent, Variants, Types, TypInfo;

{$IFNDEF UNICODE}
type
  UnicodeString = WideString;
{$ENDIF}

resourcestring
  sBeginCompile = 'Compiling';
  sSuccessfullyCompiled = 'Succesfully compiled';
  sSuccessfullyExecuted = 'Succesfully executed';
  sRuntimeError = '[Runtime error] %s(%d:%d), bytecode(%d:%d): %s';
  sTextNotFound = 'Text not found';
  sUnnamed = 'Unnamed';
  sEditorTitle = 'Editor';
  sEditorTitleRunning = 'Editor - Running';
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
    class function GetAsString(APsScript: TPSScript; AValue: PIfRVariant): String;

    class function GetPSTypeName(APsScript: TPSScript; APSType: TPSType): String;
    class function GetMethodDeclaration(AMethodName: String; APSParametersDecl: TPSParametersDecl): String;
    class function GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): String;

    class function GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: String) : Boolean;
  end;

implementation

{ TConstanstUtils }

uses uPSUtils;

class function TPSUtils.GetAsString(APsScript: TPSScript; AValue: PIfRVariant): String;
begin
  case AValue.FType.BaseType of
    btChar: Result := tbtWidestring(AValue^.tchar);
    btString: Result := tbtWidestring(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: result := tbtUnicodeString(AValue^.tunistring);
    btU8: Result := IntToStr(TbtU8(AValue^.tu8));
    btS8: Result := IntToStr(TbtS8(AValue^.tS8));
    btU16: Result := IntToStr(TbtU16(AValue^.tu16));
    btS16: Result := IntToStr(TbtS16(AValue^.ts16));
    btSet: begin
             Result := 'set of ' + TPSSetType(AValue^.FType).SetType.OriginalName;
           end;
    btU32: Result := IntToStr(TbtU32(AValue^.tu32));
    btEnum: begin
             Result := Format('%s(%d)', [AValue^.FType.OriginalName, TbtU32(AValue^.tu32)]);
            end;
    btS32: Result := IntToStr(TbtS32(AValue^.ts32));
    btSingle: Result := FloatToStr(TbtSingle(AValue^.tsingle));
    btDouble: Result := FloatToStr(TbtDouble(AValue^.tdouble));
    btExtended: Result := FloatToStr(AValue^.textended);
    btCurrency: Result := CurrToStr(AValue^.tcurrency);
    {$IFNDEF PS_NOINT64}
      btS64: Result := IntToStr(AValue^.ts64);
    {$ENDIF}
  else
    Result := EmptyStr;
  end;
end;

class function TPSUtils.GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: String) : Boolean;
var
  i: Integer;
  vConst: TPSConstant;
begin
  ALow := EmptyStr;
  AHigh := EmptyStr;

  for i := 0 to APsScript.Comp.GetConstCount-1 do
  begin
    vConst := APsScript.Comp.GetConst(i);

    if (vConst.Value^.FType = AType) then
    begin
      if ALow = EmptyStr then
      begin
        ALow := vConst.OrgName;
      end;
      AHigh := vConst.OrgName;
    end;
  end;

  Result := (AHigh <> EmptyStr);
end;

class function TPSUtils.GetMethodDeclaration(AMethodName: String; APSParametersDecl: TPSParametersDecl): String;
begin
  if APSParametersDecl.Result <> nil then
  begin
    Result := 'function ' + AMethodName + GetMethodParametersDeclaration(APSParametersDecl);
  end
  else
  begin
    Result := 'procedure ' + AMethodName + GetMethodParametersDeclaration(APSParametersDecl);
  end;
end;

class function TPSUtils.GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): String;
var
  i: Integer;
  vDecl: string;
  vParam: TPSParameterDecl;
begin
  vDecl := EmptyStr;
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

  if (vDecl <> EmptyStr) then
  begin
    vDecl := '(' + vDecl + ')';
  end;

  Result := vDecl;

  if APSParametersDecl.Result <> nil then
  begin
    Result := Result + ':' + APSParametersDecl.Result.OriginalName;
  end;
end;

class function TPSUtils.GetPSTypeName(APsScript: TPSScript; APSType: TPSType): String;
var
  vLow, vHigh: String;
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
                   Result := Result + Format('(%s)', [ClassInheritsFrom.aType.OriginalName]);
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
                       Result := Result + Format('(%s)', [InheritedFrom.aType.OriginalName]);
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
