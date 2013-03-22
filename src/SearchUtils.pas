unit SearchUtils;

interface

uses SynEditTypes, SysUtils;

type
  TSearchOptions = class
  private
    FSearchOptions: TSynSearchOptions;
    FSearchRegularExpression: Boolean;
    FSearchText: string;
    FSearchTextHistory: string;
    FReplaceTextHistory: string;
    FReplaceText: string;

    procedure SetSearchBackwards(const Value: boolean);
    procedure SetSearchCaseSensitive(const Value: boolean);
    procedure SetSearchFromCursor(const Value: boolean);
    procedure SetSearchInSelectionOnly(const Value: boolean);
    procedure SetSearchWholeWords(const Value: boolean);

    function GetSearchBackwards: boolean;
    function GetSearchCaseSensitive: boolean;
    function GetSearchFromCursor: boolean;
    function GetSearchInSelectionOnly: boolean;
    function GetSearchWholeWords: boolean;
  public
    property SearchBackwards: boolean read GetSearchBackwards write SetSearchBackwards;
    property SearchCaseSensitive: boolean read GetSearchCaseSensitive write SetSearchCaseSensitive;
    property SearchFromCursor: boolean read GetSearchFromCursor write SetSearchFromCursor;
    property SearchInSelectionOnly: boolean read GetSearchInSelectionOnly write SetSearchInSelectionOnly;
    property SearchWholeWords: boolean read GetSearchWholeWords write SetSearchWholeWords;
    property SearchRegularExpression: boolean read FSearchRegularExpression write FSearchRegularExpression;
    property SynEditOptions: TSynSearchOptions read FSearchOptions write FSearchOptions;
    property SearchText: string read FSearchText write FSearchText;
    property SearchTextHistory: string read FSearchTextHistory write FSearchTextHistory;
    property ReplaceText: string read FReplaceText write FReplaceText;
    property ReplaceTextHistory: string read FReplaceTextHistory write FReplaceTextHistory;


    procedure Clear;
  end;

implementation

{ TSearchOptions }

procedure TSearchOptions.Clear;
begin
  FSearchOptions := [];
  FSearchRegularExpression := False;
  FSearchText := EmptyStr;
  FSearchTextHistory := EmptyStr;
end;

function TSearchOptions.GetSearchBackwards: boolean;
begin
  Result := (ssoBackwards in FSearchOptions);
end;

function TSearchOptions.GetSearchCaseSensitive: boolean;
begin
  Result := (ssoMatchCase in FSearchOptions);
end;

function TSearchOptions.GetSearchFromCursor: boolean;
begin
  Result := not (ssoEntireScope in FSearchOptions);
end;

function TSearchOptions.GetSearchInSelectionOnly: boolean;
begin
  Result := (ssoSelectedOnly in FSearchOptions);
end;

function TSearchOptions.GetSearchWholeWords: boolean;
begin
  Result := (ssoWholeWord in FSearchOptions);
end;

procedure TSearchOptions.SetSearchBackwards(const Value: boolean);
begin
  if Value then
    Include(FSearchOptions, ssoBackwards);
end;

procedure TSearchOptions.SetSearchCaseSensitive(const Value: boolean);
begin
  if Value then
    Include(FSearchOptions, ssoMatchCase);
end;

procedure TSearchOptions.SetSearchFromCursor(const Value: boolean);
begin
  if not Value then
    Include(FSearchOptions, ssoEntireScope);
end;

procedure TSearchOptions.SetSearchInSelectionOnly(const Value: boolean);
begin
  if Value then
    Include(FSearchOptions, ssoSelectedOnly);
end;

procedure TSearchOptions.SetSearchWholeWords(const Value: boolean);
begin
  if Value then
    Include(FSearchOptions, ssoWholeWord);
end;

end.
