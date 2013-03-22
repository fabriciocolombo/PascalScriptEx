unit Frm_ReplaceDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Frm_SearchDialog, StdCtrls, ExtCtrls, SearchUtils, SynEditTypes;

type
  TFrm_ReplaceDialog = class(TFrm_SearchDialog)
    Label2: TLabel;
    cbReplaceText: TComboBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function GetReplaceText: string;
    function GetReplaceTextHistory: string;
    procedure SetReplaceText(Value: string);
    procedure SetReplaceTextHistory(Value: string);
  protected
    procedure BeforeExecute(AOptions: TSearchOptions); override;
    procedure AfterExecute(AOptions: TSearchOptions); override;
  public
    property ReplaceText: string read GetReplaceText write SetReplaceText;
    property ReplaceTextHistory: string read GetReplaceTextHistory write SetReplaceTextHistory;
  end;

implementation

{$R *.DFM}

{ TTextReplaceDialog }

function TFrm_ReplaceDialog.GetReplaceText: string;
begin
  Result := cbReplaceText.Text;
end;

function TFrm_ReplaceDialog.GetReplaceTextHistory: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to cbReplaceText.Items.Count - 1 do begin
    if i >= 10 then
      break;
    if i > 0 then
      Result := Result + #13#10;
    Result := Result + cbReplaceText.Items[i];
  end;
end;

procedure TFrm_ReplaceDialog.SetReplaceText(Value: string);
begin
  cbReplaceText.Text := Value;
end;

procedure TFrm_ReplaceDialog.SetReplaceTextHistory(Value: string);
begin
  cbReplaceText.Items.Text := Value;
end;

procedure TFrm_ReplaceDialog.AfterExecute(AOptions: TSearchOptions);
begin
  inherited;
  AOptions.SynEditOptions := AOptions.SynEditOptions + [ssoPrompt, ssoReplace, ssoReplaceAll];

  AOptions.ReplaceText := ReplaceText;
  AOptions.ReplaceTextHistory := ReplaceTextHistory;
end;

procedure TFrm_ReplaceDialog.BeforeExecute(AOptions: TSearchOptions);
begin
  inherited;
  ReplaceText := AOptions.ReplaceText;
  ReplaceTextHistory := AOptions.ReplaceTextHistory;
end;

procedure TFrm_ReplaceDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  s: string;
  i: integer;
begin
  inherited;
  if ModalResult = mrOK then begin
    s := cbReplaceText.Text;
    if s <> '' then begin
      i := cbReplaceText.Items.IndexOf(s);
      if i > -1 then begin
        cbReplaceText.Items.Delete(i);
        cbReplaceText.Items.Insert(0, s);
        cbReplaceText.Text := s;
      end else
        cbReplaceText.Items.Insert(0, s);
    end;
  end;
end;

end.

 