unit DelphiMaps.GoogleDirections;

interface

uses
  Classes,
  Generics.Collections,
  DelphiMaps.GoogleMaps,
  DelphiMaps.GoogleDirectionsXML,
  DelphiMaps.Location;

type
  IDirections = DelphiMaps.GoogleDirectionsXML.IXMLDirectionsResponseType;

  // hen you calculate directions, you need to specify which transportation mode to use.
  // The following travel modes are currently supported:
  //
  // Note: Walking directions may sometimes not include clear pedestrian paths,
  // so walking directions will return warnings in the DirectionsResult which
  // you must display if you are not using the default DirectionsRenderer.
  TDirectionsTravelMode = (DRIVING, // Indicates standard driving directions using the road network.
    WALKING, // requests walking directions via pedestrian paths & sidewalks (where available).
    BICYCLING // BICYCLING requests bicycling directions via bicycle paths & preferred streets (currently only available in the US)
    );



  // By default, directions are calculated and displayed using the unit system of
  // the origin's country or region. (Note: origins expressed using
  // latitude/longitude coordinates rather than addresses always default to metric
  // units.) For example, a route from "Chicago, IL" to "Toronto, ONT" will
  // display results in miles, while the reverse route will display results
  // in kilometers. You may override this unit system by setting one explicitly
  // within the request using one of the following DirectionsUnitSystem values:
  //
  // Note: this unit system setting only affects the text displayed to the user.
  // The directions result also contains distance values, not shown to the user,
  // which are always expressed in meters.
  TDirectionsUnitSystem = (METRIC, // specifies usage of the metric system. Distances are shown using kilometers.
    IMPERIAL // specifies usage of the Imperial (English) system. Distances are shown using miles.
    );



  TDirectionsWaypoint = class
    Point:TLocation;
  end;

  TWayPoints=class(TList<TDirectionsWayPoint>)
    function ToString:string; override;
  end;

  TGoogleDirectionsRequest = class(TComponent)
  private
    Fdestination: TLocation;
    FprovideRouteAlternatives: Boolean;
    Forigin: TLocation;
    Fwaypoints: TWayPoints;
    FoptimizeWaypoints: Boolean;
    FtravelMode: TDirectionsTravelMode;
    FunitSystem: TDirectionsUnitSystem;
    FavoidHighways: Boolean;
    Fregion: String;
    FavoidTolls: Boolean;
    procedure SetavoidHighways(const Value: Boolean);
    procedure SetavoidTolls(const Value: Boolean);
    procedure Setdestination(const Value: TLocation);
    procedure SetoptimizeWaypoints(const Value: Boolean);
    procedure Setorigin(const Value: TLocation);
    procedure SetprovideRouteAlternatives(const Value: Boolean);
    procedure Setregion(const Value: String);
    procedure SettravelMode(const Value: TDirectionsTravelMode);
    procedure SetunitSystem(const Value: TDirectionsUnitSystem);
    procedure Setwaypoints(const Value: TWayPoints);
    function GetURL: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property Origin: TLocation read Forigin write Setorigin; // (required) specifies the start location from which to calculate directions. This value may either be specified as a String (e.g. "Chicago, IL") or as a LatLng value.
    property Destination: TLocation read Fdestination write Setdestination; // (required) specifies the end location to which to calculate directions. This value may either be specified as a String (e.g. "Chicago, IL") or as a LatLng value.
    property TravelMode: TDirectionsTravelMode read FtravelMode write SettravelMode; // (required) specifies what mode of transport to use when calculating directions. Valid values are specified in Travel Modes below.
    property UnitSystem: TDirectionsUnitSystem read FunitSystem write SetunitSystem; // (optional) specifies what unit system to use when displaying results. Valid values are specified in Unit Systems below.
    property Waypoints: TWayPoints read Fwaypoints write Setwaypoints; // (optional) specifies an array of DirectionsWaypoints. Waypoints alter a route by routing it through the specified location(s). A waypoint is specified as an object literal with fields shown below:
    property OptimizeWaypoints: Boolean read FoptimizeWaypoints write SetoptimizeWaypoints; // (optional) specifies that the route using the supplied waypoints may be optimized to provide the shortest possible route. If true, the Directions service will return the reordered waypoints in an waypoint_order field
    property ProvideRouteAlternatives: Boolean read FprovideRouteAlternatives write SetprovideRouteAlternatives; // (optional) when set to true specifies that the Directions service may provide more than one route alternative in the response. Note that providing route alternatives may increase the response time from the server.
    property AvoidHighways: Boolean read FavoidHighways write SetavoidHighways; // (optional) when set to true indicates that the calculated route(s) should avoid major highways, if possible.
    property AvoidTolls: Boolean read FavoidTolls write SetavoidTolls; // (optional) when set to true indicates that the calculated route(s) should avoid toll roads, if possible.
    property Region: String read Fregion write Setregion; // (optional) specifies the region code, specified as a ccTLD ("top-level domain") two-character value.

    property URL:String read GetURL;

    function GetResponse:IDirections;
  end;



implementation

uses
  WinInet,
  XmlDoc,
  XmlIntf,
  TypInfo,
  SysUtils;

function HttpGet(url:string):String;
var
  databuffer : array[0..4095] of AnsiChar;
  ResStr : AnsiString;
  hSession, hfile: hInternet;
  dwindex,dwcodelen,dwread,dwNumber:cardinal;
  dwcode : array[1..20] of Ansichar;
  res    : pChar;
  Str    : pAnsiChar;
begin
  ResStr := '';
  if pos('http://',lowercase(url))=0 then
     url := 'http://'+url;

  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG,nil, nil, 0);
  try
    if assigned(hsession) then
      begin
        hfile := InternetOpenUrl(hsession,pchar(url),nil,0,INTERNET_FLAG_RELOAD,0);
        dwIndex  := 0;
        dwCodeLen := 10;
        HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodeLen, dwIndex);
        res := pChar(@dwcode);
        dwNumber := sizeof(databuffer)-1;

        // res=200 means that everything went ok..
        // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html

        if (res ='200') or (res ='302') then
          begin
            while (InternetReadfile(hfile,@databuffer,dwNumber,DwRead)) do
              begin
                if dwRead =0 then
                  break;
                databuffer[dwread]:=#0;
                Str := pAnsiChar(@databuffer);
                resStr := resStr + Str;
              end;
          end
        else
          raise Exception.CreateFmt('Http error %s',[Res]);

        if assigned(hfile) then
          InternetCloseHandle(hfile);
      end;
  finally
    InternetCloseHandle(hsession);
  end;
  Result := String(resStr);
end;


{ TGoogleDirectionsRequest }

constructor TGoogleDirectionsRequest.Create(AOwner: TComponent);
begin
  inherited;
  Forigin := TLocation.Create;
  Fdestination := TLocation.Create;
  Fwaypoints := TWayPoints.Create;

end;

destructor TGoogleDirectionsRequest.Destroy;
begin
  FreeAndNil(Forigin);
  FreeAndNil(Fdestination);
  FreeAndNil(Fwaypoints);
  inherited;
end;

function TGoogleDirectionsRequest.GetResponse: IDirections;
var
  doc:IXMLDocument;
  LURL:string;
  XML : String;
begin
  doc := TXMLDocument.Create(nil);
  LURL := GetURL;
  XML := HttpGet(LURL);
  doc.XML.Text := XML;
  Result :=  GetDirectionsResponse(doc);
end;

function TGoogleDirectionsRequest.GetURL: String;
var
  SB:TStringBuilder;
begin
  SB := TStringBuilder.Create;
  try
    SB.Append('http://maps.googleapis.com/maps/api/directions/xml?sensor=false');
    SB.Append('&origin=');              SB.Append(Forigin.ToString);
    SB.Append('&destination=');        SB.Append(Fdestination.ToString);
    SB.Append('&travelMode=');         SB.Append(GetEnumName(TypeInfo(TDirectionsTravelMode),ord(TravelMode)));
    SB.Append('&unitSystem=');         SB.Append(GetEnumName(TypeInfo(TDirectionsUnitSystem),ord(UnitSystem)));
    SB.Append('&waypoints=');          SB.Append(Waypoints);
    SB.Append('&optimizeWaypoints=');  SB.Append(OptimizeWaypoints);
    SB.Append('&provideRouteAlternatives='); SB.Append(ProvideRouteAlternatives);
    SB.Append('&avoidHighways=');      SB.Append(AvoidHighways);
    SB.Append('&avoidTolls=');         SB.Append(AvoidTolls);
    SB.Append('&region=');             SB.Append(Region);
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

procedure TGoogleDirectionsRequest.SetavoidHighways(const Value: Boolean);
begin
  FavoidHighways := Value;
end;

procedure TGoogleDirectionsRequest.SetavoidTolls(const Value: Boolean);
begin
  FavoidTolls := Value;
end;

procedure TGoogleDirectionsRequest.Setdestination(const Value: TLocation);
begin
  Fdestination := Value;
end;

procedure TGoogleDirectionsRequest.SetoptimizeWaypoints(const Value: Boolean);
begin
  FoptimizeWaypoints := Value;
end;

procedure TGoogleDirectionsRequest.Setorigin(const Value: TLocation);
begin
  Forigin := Value;
end;

procedure TGoogleDirectionsRequest.SetprovideRouteAlternatives(const Value: Boolean);
begin
  FprovideRouteAlternatives := Value;
end;

procedure TGoogleDirectionsRequest.Setregion(const Value: String);
begin
  Fregion := Value;
end;

procedure TGoogleDirectionsRequest.SettravelMode(const Value: TDirectionsTravelMode);
begin
  FtravelMode := Value;
end;

procedure TGoogleDirectionsRequest.SetunitSystem(const Value: TDirectionsUnitSystem);
begin
  FunitSystem := Value;
end;

procedure TGoogleDirectionsRequest.Setwaypoints(const Value: TWayPoints);
begin
  Fwaypoints := Value;
end;

{ TWayPoints }

function TWayPoints.ToString: string;
begin
  Result := '';
end;

end.

