unit PSResources;

interface

uses SysUtils, uPSRunTime, uPSCompiler, Variants;

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
  TConstanstUtils = class
  public
    class function GetValue(AValue: PIfRVariant): Variant;
    class function GetAsString(AValue: PIfRVariant): string;
  end;

implementation

{ TConstanstUtils }

uses uPSUtils;

class function TConstanstUtils.GetAsString(AValue: PIfRVariant): string;
begin
  case AValue.FType.BaseType of
    btChar: Result := tbtWidestring(AValue^.tchar);
    btString: Result := tbtWidestring(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: result := tbtUnicodeString(AValue^.tunistring);
    btU8, btSet: Result := IntToStr(TbtU8(AValue^.tu8));
    btS8: Result := IntToStr(TbtS8(AValue^.tS8));
    btU16: Result := IntToStr(TbtU16(AValue^.tu16));
    btS16: Result := IntToStr(TbtS16(AValue^.ts16));
    btU32, btEnum: Result := IntToStr(TbtU32(AValue^.tu32));
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

class function TConstanstUtils.GetValue(AValue: PIfRVariant): Variant;
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
