unit DelphiMaps.Location;

interface

uses
  DelphiMaps.GoogleMaps,
  Classes;

type

  TLocationType = (ltCoordinates, ltText);

  TLocation = class
  private
    FText: String;
    FPosition: TGLatLng;
    FOnChange: TNotifyEvent;
    FLocationType: TLocationType;
    procedure SetText(const Value: String);
    procedure SetPosition(const Value: TGLatLng);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetLocationType(const Value: TLocationType);
    procedure DoOnChange;
  public
    function ToString: String; override;
    constructor Create;overload;
    constructor Create(const aText: String); reintroduce; overload;
    constructor Create(aPosition: TGLatLng); reintroduce; overload;
  public
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property Text: String read FText write SetText;
    property Position: TGLatLng read FPosition write SetPosition;
    property LocationType: TLocationType read FLocationType write SetLocationType default ltText;
  end;

implementation

uses
  SysUtils;

{ TLocation }

constructor TLocation.Create(const aText: String);
begin
  Create;
  FLocationType := ltText;
  FText := aText;
end;

constructor TLocation.Create(aPosition: TGLatLng);
begin
  Create;
  FreeAndNil(FPosition);
  FPosition := aPosition;
  FLocationType := ltCoordinates;
end;

constructor TLocation.Create;
begin
  inherited;
  FPosition := TGLatLng.Create(0,0);
end;

procedure TLocation.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TLocation.SetLocationType(const Value: TLocationType);
begin
  if Value = FLocationType then
    Exit;

  FLocationType := Value;
  DoOnChange;
end;

procedure TLocation.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TLocation.SetPosition(const Value: TGLatLng);
begin
  if Value.Equals(FPosition) and (FLocationType = ltCoordinates) then
    Exit;

  FPosition := Value;
  FLocationType := ltCoordinates;
  DoOnChange;
end;

procedure TLocation.SetText(const Value: String);
begin
  if (Value = FText) and (FLocationType = ltText) then
    Exit;

  FText := Value;
  FLocationType := ltText;
  DoOnChange;
end;

function TLocation.ToString: String;
begin
  Result := '';

  if (Text <> '') then
  begin
    LocationType := ltText;
    Exit(Text);
  end;

  LocationType := ltCoordinates;
  FormatSettings.DecimalSeparator := '.';
  Exit(Format('%g,%g',[FPosition.Lat, FPosition.Lng]);
end;

end.
