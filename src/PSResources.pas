unit PSResources;

interface

uses SysUtils, uPSRunTime;

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
  sEmptyProgram = 'Program myprogram;' + sLineBreak +
                  'begin' + sLineBreak +
                  'end.';

const
  isRunningOrPaused = [isRunning, isPaused];

implementation

end.
