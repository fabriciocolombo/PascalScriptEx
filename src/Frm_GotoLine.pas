unit Frm_GotoLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SynEditTypes;

type
  TFrm_GoToLine = class(TForm)
    edtCharNumber: TEdit;
    edtLineNumber: TEdit;
    Button1: TButton;
    btnGoto: TButton;
    lblLineNumber: TLabel;
    lblCharNumber: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnGotoClick(Sender: TObject);
  private
    FLine: Integer;
    FColumn: Integer;
    function GetCaret: TBufferCoord;
  public
    property Column: Integer read FColumn;
    property Line: Integer read FLine;
    property CaretXY:TBufferCoord read GetCaret;

    constructor Create(AColumn, ALine: Integer);reintroduce;

    function Execute: Boolean;
  end;

implementation

{$R *.dfm}

{ TfrmGotoLine }

function TFrm_GoToLine.GetCaret: TBufferCoord;
begin
  Result.Char := FColumn;
  Result.Line := FLine;
end;

procedure TFrm_GoToLine.btnGotoClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

constructor TFrm_GoToLine.Create(AColumn, ALine: Integer);
begin
  inherited Create(nil);

  FColumn := AColumn;
  FLine := ALine;

  edtCharNumber.Text := IntToStr(AColumn);
  edtLineNumber.Text := IntToStr(FLine);
end;

function TFrm_GoToLine.Execute: Boolean;
begin
  Result := ShowModal = mrOk;

  if Result then
  begin
    FColumn := StrToInt(edtCharNumber.Text);
    FLine := StrToInt(edtLineNumber.Text);
  end;
end;

procedure TFrm_GoToLine.FormShow(Sender: TObject);
begin
  edtLineNumber.SetFocus;
end;

end.
