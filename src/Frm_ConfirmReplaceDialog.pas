unit Frm_ConfirmReplaceDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFrm_ConfirmReplaceDialog = class(TForm)
    btnReplace: TButton;
    lblConfirmation: TLabel;
    btnSkip: TButton;
    btnCancel: TButton;
    btnReplaceAll: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  public
    procedure PrepareShow(AEditorRect: TRect; X, Y1, Y2: integer; AReplaceText: string);
  end;

implementation

{$R *.DFM}

resourcestring
  SAskReplaceText = 'Replace this occurence of "%s"?';

{ TConfirmReplaceDialog }

procedure TFrm_ConfirmReplaceDialog.FormCreate(Sender: TObject);
begin
  Image1.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
end;

procedure TFrm_ConfirmReplaceDialog.PrepareShow(AEditorRect: TRect;
  X, Y1, Y2: integer; AReplaceText: string);
var
  nW, nH: integer;
begin
  lblConfirmation.Caption := Format(SAskReplaceText, [AReplaceText]);
  nW := AEditorRect.Right - AEditorRect.Left;
  nH := AEditorRect.Bottom - AEditorRect.Top;

  if nW <= Width then
    X := AEditorRect.Left - (Width - nW) div 2
  else begin
    if X + Width > AEditorRect.Right then
      X := AEditorRect.Right - Width;
  end;
  if Y2 > AEditorRect.Top + MulDiv(nH, 2, 3) then
    Y2 := Y1 - Height - 4
  else
    Inc(Y2, 4);
  SetBounds(X, Y2, Width, Height);
end;

end.

