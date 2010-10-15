unit DelphiMaps.Location;

interface

uses
  DelphiMaps.GoogleMaps,
  Classes;

type

  TLocationType = (ltCoordinates,ltText);

  TLocation = class(TComponent)
  private
    FText: String;
    FPoint: TGPoint;
    FOnChange: TNotifyEvent;
    FLocationType: TLocationType;
    procedure SetText(const Value: String);
    procedure SetPoint(const Value: TGPoint);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetLocationType(const Value: TLocationType);
    procedure DoOnChange;
  public
    function ToString: String; override;
    constructor Create(const aText: String); reintroduce; overload;
    constructor Create(Point: TGPoint); reintroduce; overload;
  published
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property Text: String read FText write SetText;
    property Point: TGPoint read FPoint write SetPoint;
    property LocationType:TLocationType read FLocationType write SetLocationType default ltText;
  end;


implementation

uses
  SysUtils;

{ TLocation }

constructor TLocation.Create(const aText: String);
begin
  inherited Create(nil);
  FPoint := TGPoint.Create;
  FText := aText;
  FLocationType := ltText;
end;

constructor TLocation.Create(Point: TGPoint);
begin
  inherited Create(nil);
  FreeAndNil(FPoint);
  FPoint := Point;
  FLocationType := ltCoordinates;
end;

procedure TLocation.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TLocation.SetLocationType(const Value: TLocationType);
begin
  FLocationType := Value;
end;

procedure TLocation.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TLocation.SetPoint(const Value: TGPoint);
begin
  FPoint := Value;
  FLocationType := ltCoordinates;
  DoOnChange;
end;

procedure TLocation.SetText(const Value: String);
begin
  FText := Value;
  FLocationType := ltText;
  DoOnChange;
end;

function TLocation.ToString: String;
begin
  Result := '';

  if (FPoint=nil) or (FPoint.ToString='') then
  begin
    LocationType := ltText;
    Exit(Text);
  end;

  Exit(FPoint.ToString);
end;


end.
