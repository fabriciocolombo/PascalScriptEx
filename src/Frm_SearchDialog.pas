unit Frm_SearchDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SynEditTypes, SearchUtils;

type
  TFrm_SearchDialog = class(TForm)
    Label1: TLabel;
    cbSearchText: TComboBox;
    rgSearchDirection: TRadioGroup;
    gbSearchOptions: TGroupBox;
    cbSearchCaseSensitive: TCheckBox;
    cbSearchWholeWords: TCheckBox;
    cbSearchFromCursor: TCheckBox;
    cbSearchSelectedOnly: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    cbRegularExpression: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOKClick(Sender: TObject);
  private
    function GetSearchBackwards: boolean;
    function GetSearchCaseSensitive: boolean;
    function GetSearchFromCursor: boolean;
    function GetSearchInSelection: boolean;
    function GetSearchText: string;
    function GetSearchTextHistory: string;
    function GetSearchWholeWords: boolean;
    procedure SetSearchBackwards(Value: boolean);
    procedure SetSearchCaseSensitive(Value: boolean);
    procedure SetSearchFromCursor(Value: boolean);
    procedure SetSearchInSelection(Value: boolean);
    procedure SetSearchText(Value: string);
    procedure SetSearchTextHistory(Value: string);
    procedure SetSearchWholeWords(Value: boolean);
    procedure SetSearchRegularExpression(const Value: boolean);
    function GetSearchRegularExpression: boolean;
  protected
    procedure BeforeExecute(AOptions: TSearchOptions);virtual;
    procedure AfterExecute(AOptions: TSearchOptions);virtual;
  public
    property SearchBackwards: boolean read GetSearchBackwards write SetSearchBackwards;
    property SearchCaseSensitive: boolean read GetSearchCaseSensitive write SetSearchCaseSensitive;
    property SearchFromCursor: boolean read GetSearchFromCursor write SetSearchFromCursor;
    property SearchInSelectionOnly: boolean read GetSearchInSelection write SetSearchInSelection;
    property SearchWholeWords: boolean read GetSearchWholeWords write SetSearchWholeWords;
    property SearchRegularExpression: boolean read GetSearchRegularExpression write SetSearchRegularExpression;
    property SearchText: string read GetSearchText write SetSearchText;
    property SearchTextHistory: string read GetSearchTextHistory write SetSearchTextHistory;

    function Execute(AOptions: TSearchOptions): Boolean;
  end;

implementation

{$R *.DFM}

{ TTextSearchDialog }

function TFrm_SearchDialog.GetSearchBackwards: boolean;
begin
  Result := rgSearchDirection.ItemIndex = 1;
end;

function TFrm_SearchDialog.GetSearchCaseSensitive: boolean;
begin
  Result := cbSearchCaseSensitive.Checked;
end;

function TFrm_SearchDialog.GetSearchFromCursor: boolean;
begin
  Result := cbSearchFromCursor.Checked;
end;

function TFrm_SearchDialog.GetSearchInSelection: boolean;
begin
  Result := cbSearchSelectedOnly.Checked;
end;

function TFrm_SearchDialog.GetSearchRegularExpression: boolean;
begin
  Result := cbRegularExpression.Checked;
end;

function TFrm_SearchDialog.GetSearchText: string;
begin
  Result := cbSearchText.Text;
end;

function TFrm_SearchDialog.GetSearchTextHistory: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to cbSearchText.Items.Count - 1 do
  begin
    if i >= 10 then
      break;
    if i > 0 then
      Result := Result + sLineBreak;

    Result := Result + cbSearchText.Items[i];
  end;
end;

function TFrm_SearchDialog.GetSearchWholeWords: boolean;
begin
  Result := cbSearchWholeWords.Checked;
end;

procedure TFrm_SearchDialog.SetSearchBackwards(Value: boolean);
begin
  rgSearchDirection.ItemIndex := Ord(Value);
end;

procedure TFrm_SearchDialog.SetSearchCaseSensitive(Value: boolean);
begin
  cbSearchCaseSensitive.Checked := Value;
end;

procedure TFrm_SearchDialog.SetSearchFromCursor(Value: boolean);
begin
  cbSearchFromCursor.Checked := Value;
end;

procedure TFrm_SearchDialog.SetSearchInSelection(Value: boolean);
begin
  cbSearchSelectedOnly.Checked := Value;
end;

procedure TFrm_SearchDialog.SetSearchText(Value: string);
begin
  cbSearchText.Text := Value;
end;

procedure TFrm_SearchDialog.SetSearchTextHistory(Value: string);
begin
  cbSearchText.Items.Text := Value;
end;

procedure TFrm_SearchDialog.SetSearchWholeWords(Value: boolean);
begin
  cbSearchWholeWords.Checked := Value;
end;

procedure TFrm_SearchDialog.SetSearchRegularExpression(
  const Value: boolean);
begin
  cbRegularExpression.Checked := Value;
end;

{ event handlers }

procedure TFrm_SearchDialog.AfterExecute(AOptions: TSearchOptions);
begin
  AOptions.Clear;
  AOptions.SearchBackwards := SearchBackwards;
  AOptions.SearchCaseSensitive := SearchCaseSensitive;
  AOptions.SearchFromCursor := SearchFromCursor;
  AOptions.SearchInSelectionOnly := SearchInSelectionOnly;
  AOptions.SearchWholeWords := SearchWholeWords;
  AOptions.SearchRegularExpression := SearchRegularExpression;
  AOptions.SearchText := SearchText;
  AOptions.SearchTextHistory := SearchTextHistory;
end;

procedure TFrm_SearchDialog.BeforeExecute(AOptions: TSearchOptions);
begin
  SearchBackwards := AOptions.SearchBackwards;
  SearchCaseSensitive := AOptions.SearchCaseSensitive;
  SearchFromCursor := AOptions.SearchFromCursor;
  SearchInSelectionOnly := AOptions.SearchInSelectionOnly;
  SearchWholeWords := AOptions.SearchWholeWords;
  SearchRegularExpression := AOptions.SearchRegularExpression;
  SearchText := AOptions.SearchText;
  SearchTextHistory := AOptions.SearchTextHistory;
end;

procedure TFrm_SearchDialog.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function TFrm_SearchDialog.Execute(AOptions: TSearchOptions): Boolean;
begin
  BeforeExecute(AOptions);

  Result := ShowModal = mrOk;

  if Result then
  begin
    AfterExecute(AOptions);
  end;
end;

procedure TFrm_SearchDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  s: string;
  i: integer;
begin
  if ModalResult = mrOK then begin
    s := cbSearchText.Text;
    if s <> '' then begin
      i := cbSearchText.Items.IndexOf(s);
      if i > -1 then begin
        cbSearchText.Items.Delete(i);
        cbSearchText.Items.Insert(0, s);
        cbSearchText.Text := s;
      end else
        cbSearchText.Items.Insert(0, s);
    end;
  end;
end;

end.

 