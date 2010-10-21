{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.GoogleMaps.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}

{$M+}

unit DelphiMaps.GoogleMaps;

interface

uses
  Classes,
  Controls,
  SysUtils,
  Contnrs,
  Forms,
  StrUtils,
  Graphics,
  DelphiMaps.Browser,
  DelphiMaps.DouglasPeuckers
  ;

const
  GoogleMapsFileName = 'GoogleMaps.html';
  WGS84_MULT_FACT    = 100000; // multiply lat/lon values by this value in order to fit them into integers
  DEFAULT_SIMPLIFY_TOLERANCE = 0.5;

{$R DelphiMaps.GoogleMaps_html.res}

type
  TPointFloat2D = DelphiMaps.DouglasPeuckers.TPointFloat2D;
  TGoogleMapControlType = (MC_NONE=1,MC_SMALL,MC_LARGE);
  TGoogleMapType        = (MT_ROADMAP, MT_SATELLITE, MT_TERRAIN, MT_HYBRID);
  TStaticMapType        = (ST_ROADMAP, ST_SATELLITE, ST_TERRAIN, ST_HYBRID);

const
  cGoogleMapTypeStr : Array[TGoogleMapType]of String=('ROADMAP','SATELLITE','HYBRID','TERRAIN');
  cStaticMapTypeStr : Array[TStaticMapType]of String=('roadMap','satellite','terrain','hybrid');

type
  TGoogleMaps       = class; // forward declaration

  GIcon             = class end; // to be implemented


  IGHidable=interface(IInterface)
    procedure hide;                         // Hides the object if the overlay is both currently visible and the overlay's supportsHide() method returns true. Note that this method will trigger the respective visibilitychanged event for each child overlay that fires that event (e.g. GMarker.visibilitychanged, GGroundOverlay.visibilitychanged, etc.). If no overlays are currently visible that return supportsHide() as true, this method has no effect. (Since 2.87)
    function  isHidden           : Boolean; // Returns true if the GGeoXml object is currently hidden, as changed by the GGeoXml.hide() method. Otherwise returns false. (Since 2.87)
    procedure show;                         // Shows the child overlays created by the GGeoXml object, if they are currently hidden. Note that this method will trigger the respective visibilitychanged event for each child overlay that fires that event (e.g. GMarker.visibilitychanged, GGroundOverlay.visibilitychanged). (Since 2.87)
    function  supportsHide       : Boolean; //
  end;


  TGEvent = class(TJsClassWrapper)

  end;

  // marker class
  TGMarkerOptions=record
    icon          : GIcon;    // Chooses the Icon for this class. If not specified, G_DEFAULT_ICON is used. (Since 2.50)
    dragCrossMove : Boolean;  // When dragging markers normally, the marker floats up and away from the cursor. Setting this value to true keeps the marker underneath the cursor, and moves the cross downwards instead. The default value for this option is false. (Since 2.63)
    title         : String;   // This string will appear as tooltip on the marker, i.e. it will work just as the title attribute on HTML elements. (Since 2.50)
    clickable     : Boolean;  // Toggles whether or not the marker is clickable. Markers that are not clickable or draggable are inert, consume less resources and do not respond to any events. The default value for this option is true, i.e. if the option is not specified, the marker will be clickable. (Since 2.50)
    draggable     : Boolean;  // Toggles whether or not the marker will be draggable by users. Markers set up to be dragged require more resources to set up than markers that are clickable. Any marker that is draggable is also clickable, bouncy and auto-pan enabled by default. The default value for this option is false. (Since 2.61)
    bouncy        : Boolean;  // Toggles whether or not the marker should bounce up and down after it finishes dragging. The default value for this option is false. (Since 2.61)
    bounceGravity : Integer;   // When finishing dragging, this number is used to define the acceleration rate of the marker during the bounce down to earth. The default value for this option is 1. (Since 2.61)
    autoPan       : Boolean;  // Auto-pan the map as you drag the marker near the edge. If the marker is draggable the default value for this option is true. (Since 2.87)
    // to implement:
    //    zIndexProcess : Function; // This function is used for changing the z-Index order of the markers when they are overlaid on the map and is also called when their infowindow is opened. The default order is that the more southerly markers are placed higher than more northerly markers. This function is passed in the GMarker object and returns a number indicating the new z-index. (Since 2.98)
  end;

  TGPoint=class(TPersistent)
  private
    FLat: Double;
    FLon: Double;
    procedure SetLat(const Value: Double);
    procedure SetLon(const Value: Double);
    function GetLat: Double;
    function GetLon: Double;
  public
    function ToString: string; override;
    function Equals(P:TGPoint):Boolean;reintroduce;
  published
    property Lat:Double read GetLat write SetLat;
    property Lon:Double read GetLon write SetLon;
  end;

  TGLatLng=class(TJsClassWrapper)
  private
    FLat,
    FLng:Double;
    FJsVarName: String;
    function GetJsVarName: String;
    procedure SetJsVarName(const Value: String);
  published
    constructor Create(aLat,aLng:Double);
    property Lat:Double read FLat write FLat;
    property Lng:Double read FLng write FLng;
    function ToJavaScript:String;override;
    function Equals(const AGLatLng:TGLatLng):Boolean;reintroduce;
    function ToString:String;override;
    function JsClassName:String;override;
    property JsVarName:String read GetJsVarName write SetJsVarName;
  end;

  TGBounds=class(TJsClassWrapper)
  private
    FJsVarName: String;
    FMinX, FMinY, FMaxX, FMaxY:Double;
    FMin,FMax,FMid:TGLatLng;
    function GetMax: TGLatLng;
    function GetMid: TGLatLng;
    function GetMin: TGLatLng;
    procedure SetJsVarName(const Value: String); reintroduce;
    function GetJsVarName: String;
  published
    destructor Destroy;override;
    property minX : Double read FMinX write FMinX;
    property minY : Double read FMinY write FMinY;
    property maxX : Double read FMaxX write FMaxX;
    property maxY : Double read FMaxY write FMaxY;
    function ToString:String;override;
    function Equals(aGBounds:TGBounds):Boolean;reintroduce;
    property Min:TGLatLng read GetMin;
    property Mid:TGLatLng read GetMid;
    property Max:TGLatLng read GetMax;
    function JsClassName:String;override;
    property JsVarName:String read GetJsVarName write SetJsVarName;
    function ToJavaScript:String;override;
  end;

  TGLatLngBounds=class(TJsClassWrapper)
  private
    FNorthEast:TGLatLng;
    FSouthWest:TGLatLng;
    procedure setNorthEast(const Value: TGLatLng);
    procedure setSouthWest(const Value: TGLatLng);
    function GetJsVarName: string;
    procedure SetJsVarName(const aVarName: string);
  public
    function JsClassName: string;override;
    function ToJavaScript: string;override;
  published
    constructor Create(sw,ne:TGLatLng);
    destructor Destroy;override;
    function contains(aLatLng:TGLatLng):Boolean; deprecated; // Returns true iff the geographical coordinates of the point lie within this rectangle. (Deprecated since 2.88)
    function containsLatLng(aLatLng:TGLatLng):Boolean; // Returns true iff the geographical coordinates of the point lie within this rectangle. (Since 2.88)
    function intersects(aGLatLngBounds:TGLatLngBounds):Boolean;
    function containsBounds(aGLatLngBounds:TGLatLngBounds):Boolean;
    procedure extend(aLatLng:TGLatLng); // Enlarges this rectangle such that it contains the given point. In longitude direction, it is enlarged in the smaller of the two possible ways. If both are equal, it is enlarged at the eastern boundary.

    function toSpan()       :	TGLatLng; //	Returns a GLatLng whose coordinates represent the size of this rectangle.
    function isFullLat()    :	Boolean ; //	Returns true if this rectangle extends from the south pole to the north pole.
    function isFullLng()    :	Boolean ; //	Returns true if this rectangle extends fully around the earth in the longitude direction.
    function isEmpty()      :	Boolean ; //	Returns true if this rectangle is empty.
    function getCenter()    :	TGLatLng; //	Returns the point at the center of the rectangle. (Since 2.52)

    function getSouthWest() :	TGLatLng; //	Returns the point at the south-west corner of the rectangle.
    function getNorthEast() :	TGLatLng; //	Returns the point at the north-east corner of the rectangle.
    property SouthWest : TGLatLng read getSouthWest write setSouthWest;
    property NorthEast : TGLatLng read getNorthEast write setNorthEast;

    property JsVarName: string read GetJsVarName write SetJsVarName;
    function ToString:String;override;
    function Equals(aGLatLngBounds:TGLatLngBounds):Boolean;reintroduce;
  end;

  // abstract class.. subclassed by TGMarker and TGPolygon and TGPolyLine..
  TGOverlay = class(TJsClassWrapper, IGHidable)
  strict private
    FID: Integer;
    FMap: TGoogleMaps;
    FName: String;
    FJsVarName: String;
    procedure SetID(const Value: Integer);
    procedure SetMap(const Value: TGoogleMaps);
    procedure SetName(const Value: String);
    function GetJsVarName: String;
    procedure SetJsVarName(const Value: String);
  public
    procedure hide; virtual;
    function isHidden: Boolean; virtual;
    procedure show; virtual;
    function supportsHide: Boolean; virtual;
  published
    property ID: Integer read FID write SetID;
    function ToJavaScript: String; override; abstract;
    property JsVarName: String read GetJsVarName write SetJsVarName;
    property Map: TGoogleMaps read FMap write SetMap;
    property Name: String read FName write SetName;
    function JsClassName: string; override;
  end;

  TOverlayList = class(TObjectList)
  private
    AutoIncrementID: Integer;
    function GetItems(Index: Integer): TGOverlay;
    procedure SetItems(Index: Integer; const Value: TGOverlay);
  public
    property Items[Index: Integer]: TGOverlay read GetItems write SetItems; default;
  published
    constructor Create;
    destructor Destroy; override;
    function Add(var aGOverlay: TGOverlay): Integer;
    procedure Clear; override;
    function ToString: String; override;
  end;


  TGInfoWindow = class(TGOverlay, IJsClassWrapper, IGHidable)
    procedure Maximize;
    procedure Restore;
  private
    FHTML: String;
    procedure SetHTML(const Value: String);
  public
    property HTML: String read FHTML write SetHTML;
    function JsClassName: String; override;
    constructor Create(const aCenter: TGLatLng);
    destructor Destroy; override;
    function ToJavaScript: String; override;
    function supportsHide: Boolean; override;
  end;


  // used to show a location on a map
  // can be dragged, can show a popup, can have custom colors and icon
  TGMarker=class(TGOverlay,IJsClassWrapper,IGHidable)
  strict private
    FPosition: TGLatLng;
    FDraggingEnabled: Boolean;
    procedure setLatLng(const Value: TGLatLng);
    procedure SetDraggingEnabled(const Value: Boolean);
  private
    FTitle: String;
    procedure SetTitle(const Value: String);
  public
    function supportsHide: Boolean;override;
  published
    function JsClassName:String;override;
    constructor Create(const aPosition:TGLatLng; aMap:TGoogleMaps; const aTitle:String='');
    destructor Destroy;override;
    property Position:TGLatLng read FPosition write setLatLng;
    property DraggingEnabled:Boolean read FDraggingEnabled write SetDraggingEnabled;
    function ToJavaScript:String;override;
   { TODO 3 -oWouter : implement all marker methods and events }

    procedure openInfoWindow(aContent:String); // Opens the map info window over the icon of the marker. The content of the info window is given as a DOM node. Only option GInfoWindowOptions.maxWidth is applicable.
    procedure openInfoWindowHtml(aContent:String); // Opens the map info window over the icon of the marker. The content of the info window is given as a string that contains HTML text. Only option GInfoWindowOptions.maxWidth is applicable.
{    procedure openInfoWindowTabs(tabs, opts?) : none; // Opens the tabbed map info window over the icon of the marker. The content of the info window is given as an array of tabs that contain the tab content as DOM nodes. Only options GInfoWindowOptions.maxWidth and InfoWindowOptions.selectedTab are applicable.
    procedure openInfoWindowTabsHtml(tabs, opts?) : none; // Opens the tabbed map info window over the icon of the marker. The content of the info window is given as an array of tabs that contain the tab content as Strings that contain HTML text. Only options InfoWindowOptions.maxWidth and InfoWindowOptions.selectedTab are applicable.
    procedure bindInfoWindow(content, opts?) : none; // Binds the given DOM node to this marker. The content within this node will be automatically displayed in the info window when the marker is clicked. Pass content as null to unbind. (Since 2.85)
    procedure bindInfoWindowHtml(content, opts?) : none; // Binds the given HTML to this marker. The HTML content will be automatically displayed in the info window when the marker is clicked. Pass content as null to unbind. (Since 2.85)
    procedure bindInfoWindowTabs(tabs, opts?) : none; // Binds the given GInfoWindowTabs (provided as DOM nodes) to this marker. The content within these tabs' nodes will be automatically displayed in the info window when the marker is clicked. Pass tabs as null to unbind. (Since 2.85)
    procedure bindInfoWindowTabsHtml(tabs, opts?) : none; // Binds the given GInfoWindowTabs (provided as strings of HTML) to this marker. The HTML content within these tabs will be automatically displayed in the info window when the marker is clicked. Pass tabs as null to unbind. (Since 2.85)
    procedure closeInfoWindow() : none; // Closes the info window only if it belongs to this marker. (Since 2.85)
    procedure showMapBlowup(opts?) : none; // Opens the map info window over the icon of the marker. The content of the info window is a closeup map around the marker position. Only options InfoWindowOptions.zoomLevel and InfoWindowOptions.mapType are applicable.
    procedure getIcon() : GIcon; // Returns the icon of this marker, as set by the constructor.
    procedure getTitle() : String; // Returns the title of this marker, as set by the constructor via the GMarkerOptions.title property. Returns undefined if no title is passed in. (Since 2.85)
    procedure getPoint() : GLatLng; // Returns the geographical coordinates at which this marker is anchored, as set by the constructor or by setPoint(). (Deprecated since 2.88)
    procedure getLatLng() : GLatLng; // Returns the geographical coordinates at which this marker is anchored, as set by the constructor or by setLatLng(). (Since 2.88)
    procedure setPoint(latlng) : none; // Sets the geographical coordinates of the point at which this marker is anchored. (Deprecated since 2.88)
    procedure setLatLng(latlng) : none; // Sets the geographical coordinates of the point at which this marker is anchored. (Since 2.88)
    procedure enableDragging() : none; // Enables the marker to be dragged and dropped around the map. To function, the marker must have been initialized with GMarkerOptions.draggable = true.
    procedure disableDragging() : none; // Disables the marker from being dragged and dropped around the map.
    procedure draggable() : Boolean; // Returns true if the marker has been initialized via the constructor using GMarkerOptions.draggable = true. Otherwise, returns false.
    procedure draggingEnabled() : Boolean; // Returns true if the marker is currently enabled for the user to drag on the map.
    procedure setImage(url) : none; // Requests the image specified by the url to be set as the foreground image for this marker. Note that neither the print image nor the shadow image are adjusted. Therefore this method is primarily intended to implement highlighting or dimming effects, rather than drastic changes in marker's appearances. (Since 2.75)
}
    property Title:String read FTitle write SetTitle;

  end;

  TGGeoXml = class(TGOverlay, IJsClassWrapper, IGHidable)
  private
    FUrlOfXml: String;
    procedure SetUrlOfXml(const Value: String);
  published

    // function  getTileLayerOverlay: GTileLayerOverlay; // GGeoXml objects may create a tile overlay for optimization purposes in certain cases. This method returns this tile layer overlay (if available). Note that the tile overlay may be null if not needed, or if the GGeoXml file has not yet finished loading. (Since 2.84)
    // function  getDefaultCenter   : GLatLng;           // Returns the center of the default viewport as a lat/lng. This function should only be called after the file has been loaded. (Since 2.84)
    // function  getDefaultSpan     : GLatLng;           // Returns the span of the default viewport as a lat/lng. This function should only be called after the file has been loaded. (Since 2.84)
    // function  getDefaultBounds   : GLatLngBounds;     // Returns the bounding box of the default viewport. This function should only be called after the file has been loaded. (Since 2.84)
    procedure gotoDefaultViewport(Map: TGoogleMaps); // Sets the map's viewport to the default viewport of the XML file. (Since 2.84)
    // function  hasLoaded          : Boolean; // Checks to see if the XML file has finished loading, in which case it returns true. If the XML file has not finished loading, this method returns false. (Since 2.84)
    // function  loadedCorrectly    : Boolean; // Checks to see if the XML file has loaded correctly, in which case it returns true. If the XML file has not loaded correctly, this method returns false. If the XML file has not finished loading, this method's return value is undefined. (Since 2.84)
    function supportsHide: Boolean; override; // Always returns true. (Since 2.87)

    function JsClassName: String; override;
    constructor Create(const aUrlOfXml: String);
    destructor Destroy; override;
    property UrlOfXml: String read FUrlOfXml write SetUrlOfXml;
    function ToJavaScript: String; override;
  end;


  // polygon class
  TGPolygon=class(TGOverlay,IJsClassWrapper,IGHidable)
  private
    FCoordinates:Array of TGLatLng;
    FStrokeOpacity: double;
    FStrokeWeight: double;
    FStrokeColor: TColor;
    FSimplified: TGPolygon;
    FIsDirty: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetOpacity(const Value: double);
    procedure SetWeightPx(const Value: Double);
    function GetCount: Integer;
    procedure SetSimplified(const Value: TGPolygon);
    function GetSimplified: TGPolygon;
  public
    constructor Create(const aPath: array of TGLatLng;aStrokeColor:TColor=clBlue;aStrokeOpacity:Double=1.0;aStrokeWeight:Double=2);overload;
    constructor Create(const aPoints:Array of TPointFloat2D);overload;
    function supportsHide: Boolean;override;
  published
    function JsClassName:String;override;
    procedure Clear;
    function ToJavaScript:String;override;
    function AddPoint(const aGLatLng:TGLatLng):integer;
    function AddPoints(const aGLatLngAr: Array of TGLatLng):integer;
    property StrokeColor:TColor read FStrokeColor write SetColor;
    property StrokeWeight:double read FStrokeWeight write SetWeightPx;
    property StrokeOpacity:double read FStrokeOpacity write SetOpacity;// number between 0 and 1
    property Count:Integer read GetCount;
    destructor Destroy;override;
    property IsDirty:Boolean read FIsDirty write FIsDirty;
    property Simplified:TGPolygon read GetSimplified write SetSimplified;
    function getSimplifiedVersion(Tolerance:Double=DEFAULT_SIMPLIFY_TOLERANCE):TGPolygon;
  end;

  TGPolyLine = class(TGPolygon, IJsClassWrapper, IGHidable)
  published
    function JsClassName: String; override;
  end;

  TGCopyright = class(TGOverlay, IJsClassWrapper, IGHidable)
  strict private
    FminZoom: Integer;
    FID: Integer;
    Fbounds: TGLatLngBounds;
    Ftext: String;
    procedure Setbounds(const Value: TGLatLngBounds);
    procedure SetID(const Value: Integer);
    procedure SetminZoom(const Value: Integer);
    procedure Settext(const Value: String);
  published
    property ID: Integer read FID write SetID; // A unique identifier for this copyright information.
    property minZoom: Integer read FminZoom write SetminZoom; // The lowest zoom level at which this information applies.
    property bounds: TGLatLngBounds read Fbounds write Setbounds; // The region to which this information applies.
    property text: String read Ftext write Settext; // The text of the copyright message.
    constructor Create(aId: Integer; aBounds: TGLatLngBounds; aMinZoom: Integer; aText: String);
  end;

  TGoogleMaps=class(TBrowserControl)
  strict private
    FBrowser:TBrowser;
    FOverlays: TOverlayList;
    FMapType: TGoogleMapType;
    FLatLngCenter: TGLatLng;
    FJsVarName: String;

    procedure Navigate(const URL:String);
    procedure SetOverlays(const Value: TOverlayList);
    procedure Init;
    procedure SetLatLngCenter(const Value: TGLatLng);
    function GetLatLngCenter: TGLatLng;
    procedure SetMapType(AMapType:TGoogleMapType);
    procedure SetJsVarName(const Value: String);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent);override;
    destructor Destroy;override;
    procedure SetCenter(Lat,Lng:Double;doPan:Boolean=false);overload;
    procedure SetCenter(LatLng:TGLatLng;doPan:Boolean=false);overload;
    procedure HandleOnResize(Sender:TObject);


    procedure CheckResize;
    property Browser : TBrowser read FBrowser write FBrowser;

  published
    property Overlays     : TOverlayList read FOverlays write SetOverlays;
    property LatLngCenter : TGLatLng read GetLatLngCenter write SetLatLngCenter;
    property MapType:TGoogleMapType read FMapType write SetMapType;
    property JsVarName:String read FJsVarName write SetJsVarName;
    procedure AddControl(ControlType:TGoogleMapControlType);
    function AddMarker(Lat,Lon:Double):TGMarker;
    procedure AddPolygon(GPolygon:TGPolygon);
    function AddOverlay(aOverlay:TGOverlay):Integer;
    procedure RemoveOverlay(aOverlay:TGOverlay);
    procedure RemoveOverlayByIndex(Index:Integer);
    procedure ClearOverlays;
    procedure ShowAddress(const Street,City,State,Country:String);
    procedure openInfoWindow(aLatlng : TGLatLng; aHTML:String);
    procedure closeInfoWindow;
    procedure FitBounds(const aBounds:TGLatLngBounds);
    procedure ExecJavaScript(const aScript:String);
    procedure WebBrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    property Align;
//    property OnClick;
    property OnResize;
//    property OnEnter;
//    property OnExit;
//    property OnKeyDown;
//    property OnKeyPress;
//    property OnKeyUp;
//    property OnDblClick;
    property Anchors;
    property BoundsRect;
//    property ShowHint;
    property Visible;
    class function GetHTMLResourceName:String;override;
  end;

{$R DelphiMaps.GoogleMaps.dcr}

implementation

uses
  Math, Windows;

{ TGoogleMaps }

procedure TGoogleMaps.Init;
var
  LHtmlFileName : String;
begin
  Browser.OnDocumentComplete := WebBrowserDocumentComplete;
  LHtmlFileName := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+GoogleMapsFileName;
  SaveHtml(LHtmlFileName);
  if FileExists(LHtmlFileName) then
    Navigate('file://' + LHtmlFileName);

  FOverlays := TOverlayList.Create;
end;

constructor TGoogleMaps.Create(AOwner: TComponent);
begin
  inherited;

  Color := 0;
  FLatLngCenter := TGLatLng.Create(52,5);

  FBrowser := TBrowser.Create(self);
  FBrowser.Resizable := False;
  FBrowser.Silent := True;
  TWinControl(FBrowser).Parent := Self;
  FBrowser.Align := alClient;
  FBrowser.Show;
//  JsVarName := Name;
  JsVarName := 'map';
  Init;
end;


destructor TGoogleMaps.Destroy;
begin
  FreeAndNil(FOverlays);
  FreeAndNil(FLatLngCenter);
  inherited;
end;

procedure TGoogleMaps.ExecJavaScript(const aScript: String);
begin
  Browser.ExecJavaScript(aScript);
end;

procedure TGoogleMaps.FitBounds(const aBounds: TGLatLngBounds);
begin
  ExecJavaScript(jsVarName+'.fitBounds('+aBounds.ToJavaScript+')');
end;

procedure TGoogleMaps.AddControl(ControlType: TGoogleMapControlType);
begin
  ExecJavaScript(Format('addControl(%d);',[Integer(ControlType)]));
end;

function TGoogleMaps.addMarker(Lat, Lon: Double):TGMarker;
begin
//  JavaScript(format('createMarker(%g,%g)',[Lat,Lon]));
  Result  := TGMarker.Create(TGLatLng.Create(Lat,Lon), Self);
  AddOverlay(Result);
end;

function TGoogleMaps.AddOverlay(aOverlay:TGOverlay):Integer;
begin
  aOverLay.Map := self;
  Result := FOverlays.Add(aOverlay);
  ExecJavaScript('var '+aOverlay.JsVarName + '=' + aOverlay.ToJavaScript+ ';');
//  V2 way to do it:
//  ExecJavaScript(JsVarName+'.addOverlay('+aOverlay.JsVarName+')');

//  V3 way to do it:
  ExecJavaScript(aOverlay.JsVarName+'.setMap('+JsVarName+');');
end;

procedure TGoogleMaps.AddPolygon(GPolygon: TGPolygon);
begin
  AddOverlay(GPolygon);
end;



procedure TGoogleMaps.Loaded;
begin
  inherited;
  JsVarName := 'map';
end;

procedure TGoogleMaps.Navigate(const URL: String);
begin
  Browser.Navigate(URL);
end;


procedure TGoogleMaps.SetCenter(Lat, Lng: Double;doPan:Boolean=False);
var
  Operation:String;
begin
  if (Lat=FLatLngCenter.Lat) and (FLatLngCenter.Lng = Lng)  then
    Exit;

  if DoPan then
    Operation := 'panTo'
  else
    Operation := 'setCenter';

  FormatSettings.DecimalSeparator := '.';
  FLatLngCenter.Lat := Lat;
  FLatLngCenter.Lng := Lng;
  ExecJavaScript(Format(jsVarName+'.'+Operation+'(new google.maps.LatLng(%g,%g));',[Lat,Lng]));
end;

procedure TGoogleMaps.SetLatLngCenter(const Value: TGLatLng);
begin
  FLatLngCenter := Value;
  SetCenter(FLatLngCenter.Lat,FLatLngCenter.Lng);
end;


procedure TGoogleMaps.SetMapType(AMapType: TGoogleMapType);
begin
  FMapType := AMapType;
  ExecJavaScript(jsVarName+'.setMapTypeId(google.maps.MapTypeId.'+cGoogleMapTypeStr[FMapType]+');');
end;


procedure TGoogleMaps.SetOverlays(const Value: TOverlayList);
begin
  FOverlays := Value;
end;

procedure TGoogleMaps.ShowAddress(const Street, City, State, Country: String);
begin
  ExecJavaScript(Format('showAddress("%s, %s, %s, %s");',[Street,City,State,Country]));
end;

procedure TGoogleMaps.WebBrowserDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin

end;


procedure TGoogleMaps.openInfoWindow(aLatlng: TGLatLng; aHTML: String);
begin
  ExecJavaScript(JsVarName + '.openInfoWindow('+aLatlng.ToJavaScript+', "'+aHTML+'")');
end;

procedure TGoogleMaps.RemoveOverlay(aOverlay: TGOverlay);
begin
  FOverlays.Remove(aOverlay);
  ExecJavaScript(JsVarName+'.removeOverlay('+aOverlay.JsVarName+');');
  ExecJavaScript('delete '+aOverlay.JsVarName+';');
end;

procedure TGoogleMaps.RemoveOverlayByIndex(Index: Integer);
begin
  if InRange(Index,0,Pred(Overlays.Count)) then
    RemoveOverlay(Overlays.Items[index]);
end;


class function TGoogleMaps.GetHTMLResourceName: String;
begin
  Result := 'GOOGLE_MAPS_HTML';
end;

function TGoogleMaps.GetLatLngCenter: TGLatLng;
begin
//  FLatLngCenter.Lat := GetJsValue(JsVarName+'.getCenter().lat()');
//  FLatLngCenter.Lng := GetJsValue(JsVarName+'.getCenter().lng()');
  Result            := FLatLngCenter;
end;

procedure TGoogleMaps.SetCenter(LatLng: TGLatLng; doPan: Boolean);
begin
  SetCenter(LatLng.Lat,LatLng.Lng,DoPan);
end;

procedure TGoogleMaps.CheckResize;
begin
  ExecJavaScript(JsVarName+'.checkResize();');
end;

procedure TGoogleMaps.HandleOnResize(Sender: TObject);
begin
  CheckResize;
end;

procedure TGoogleMaps.ClearOverlays;
begin
  FOverlays.Clear;
  ExecJavaScript(JsVarName+'.clearOverlays();');
end;

procedure TGoogleMaps.closeInfoWindow;
begin
  ExecJavaScript(JsVarName+'.closeInfoWindow();');
end;

procedure TGoogleMaps.SetJsVarName(const Value: String);
begin
  FJsVarName := Value;
end;

{ TGPolygon }

function TGPolygon.AddPoint(const aGLatLng: TGLatLng): integer;
begin
  Result := -1;
  if (Count>0) and (aGLatLng.Equals(FCoordinates[High(FCoordinates)])) then
    Exit;

  SetLength(FCoordinates,Length(FCoordinates)+1);
  FCoordinates[High(FCoordinates)] := aGLatLng;
end;

function TGPolygon.JsClassName: String;
begin
  Result := 'google.maps.Polygon';
end;

function TGPolygon.AddPoints(const aGLatLngAr: array of TGLatLng): integer;
var
  LGLatLng: TGLatLng;
  Index:Integer;
begin
  Index := Length(FCoordinates);
  SetLength(FCoordinates,Length(FCoordinates)+Length(aGLatLngAr));
  for LGLatLng in aGLatLngAr do
  begin
    FCoordinates[Index] := LGLatLng;
    Inc(Index);
  end;
  Result := High(FCoordinates);
end;

procedure TGPolygon.Clear;
begin
  FreeAndNil(FSimplified);
  SetLength(FCoordinates,0);
end;


destructor TGPolygon.Destroy;
var
  I : integer;
begin
  FreeAndNil(FSimplified);
  for I := 0 to High(FCoordinates) do
    FreeAndNil(FCoordinates[I]);
  inherited;
end;

constructor TGPolygon.Create(const aPath: array of TGLatLng;aStrokeColor:TColor=clBlue;aStrokeOpacity:Double=1.0;aStrokeWeight:Double=2);
var
  I :integer;
begin
  FStrokeColor    := aStrokeColor;
  FStrokeOpacity  := aStrokeOpacity;
  FStrokeWeight   := aStrokeWeight;

  SetLength(FCoordinates,Length(aPath));

  for I := 0 to High(aPath) do
    FCoordinates[I] := aPath[I];
end;

constructor TGPolygon.Create(const aPoints: array of TPointFloat2D);
var
  I :integer;
begin
  StrokeColor := clYellow;
  SetLength(FCoordinates,Length(APoints));
  for I := 0 to High(APoints) do
    FCoordinates[I] := TGLatLng.Create(APoints[I].Y,APoints[I].X);
end;


function TGPolygon.GetCount: Integer;
begin
  Result := Length(FCoordinates);
end;

function TGPolygon.GetSimplified: TGPolygon;
begin
  if (not Assigned(FSimplified)) or  FSimplified.IsDirty then
    FSimplified := getSimplifiedVersion;

  Result := FSimplified;
end;

function TGPolygon.getSimplifiedVersion(Tolerance:Double): TGPolygon;
var
  OrigAr,
  SimplifiedAr:TFloat2DPointAr;
  I: Integer;
begin

  SetLength( OrigAr, Count );

  for I := 0 to Count - 1 do
  begin
    OrigAr[I].X := FCoordinates[I].Lng;
    OrigAr[I].Y := FCoordinates[I].Lat;
  end;

  PolySimplifyFloat2D( Tolerance, OrigAr, SimplifiedAr );

  for I := 0 to High(SimplifiedAr) do
  begin
    OrigAr[I].X := FCoordinates[I].Lng;
    OrigAr[I].Y := FCoordinates[I].Lat;
  end;

  Result := TGPolygon.Create(SimplifiedAr);
end;


procedure TGPolygon.SetColor(const Value: TColor);
begin
  FStrokeColor := Value;
end;

procedure TGPolygon.SetOpacity(const Value: double);
begin
  FStrokeOpacity := Value;
end;

procedure TGPolygon.SetSimplified(const Value: TGPolygon);
begin
  FSimplified := Value;
end;

procedure TGPolygon.SetWeightPx(const Value: Double);
begin
  FStrokeWeight := Value;
end;

function TGPolygon.supportsHide: Boolean;
begin
  Result := True;
end;

function TGPolygon.ToJavaScript: String;
var
  I : Integer;
begin
  Result := ' new ' + JsClassName + '({path:['#13#10;
  for I := 0 to High(FCoordinates) do
  begin
    Result := Result +  FCoordinates[I].ToJavaScript;
    if I<High(FCoordinates) then
      Result := Result + ','#13#10;
  end;
  FormatSettings.DecimalSeparator := '.';
	Result := Result + '], strokeColor:"'+ColorToHtml(StrokeColor)+'", strokeOpacity:'+FloatToStr(FStrokeOpacity)+', strokeWeight:'+FloatToStr(StrokeWeight)+'})'#13#10;
end;

{ TGLatLng }

constructor TGLatLng.Create(aLat, aLng: Double);
begin
  FLat := aLat;
  Flng := aLng;
end;

function TGLatLng.Equals(const AGLatLng: TGLatLng): Boolean;
begin
  Result := (AGLatLng.Lat=Lat) and (AGLatLng.Lng=Lng);
end;

function TGLatLng.GetJsVarName: String;
begin
  Result := FJsVarName;
end;

function TGLatLng.JsClassName: String;
begin
  Result := 'google.maps.LatLng';
end;

procedure TGLatLng.SetJsVarName(const Value: String);
begin
  FJsVarName := Value;
end;

function TGLatLng.ToJavaScript: String;
begin
  FormatSettings.DecimalSeparator := '.';
  Result := Format(' new '+jsClassName+'(%g,%g)',[ Lat, Lng ]);
end;

function TGLatLng.ToString: String;
begin
  Result := Format('(Lat:%g,Lng:%g)',[Lat,Lng])
end;

{ TGPolyLine }

function TGPolyLine.JsClassName: String;
begin
  Result := 'google.maps.Polyline';
end;

{ TMarker }

destructor TGMarker.Destroy;
begin
  FreeAndNil(FPosition);
  inherited;
end;

function TGMarker.JsClassName: String;
begin
  Result := 'google.maps.Marker';
end;

procedure TGMarker.openInfoWindow(aContent:String);
begin
  Map.ExecJavaScript(JsVarName+'.openInfoWindow("'+aContent+'");');
end;

procedure TGMarker.openInfoWindowHtml(aContent:String);
begin
  Map.ExecJavaScript(JsVarName+'.openInfoWindowHtml("'+aContent+'");');
end;

procedure TGMarker.SetDraggingEnabled(const Value: Boolean);
begin
  FDraggingEnabled := Value;
end;

constructor TGMarker.Create(const aPosition: TGLatLng; aMap:TGoogleMaps;const aTitle:String='');
begin
  Position := aPosition;
  FTitle := aTitle;
  self.Map := aMap;
end;


procedure TGMarker.setLatLng(const Value: TGLatLng);
begin
  FPosition := Value;
end;

procedure TGMarker.SetTitle(const Value: String);
begin
  FTitle := Value;
  Map.ExecJavaScript(Format('%s.setTitle("%s");',[JsVarName,Value]));
end;

function TGMarker.SupportsHide: Boolean;
begin
  Result := True;
end;

function TGMarker.ToJavaScript: String;
var
  FormatStr:String;
begin
  if FTitle='' then
    FormatStr := ' new %s({Position:%s,map:%s,title:"%s"})'
  else
    FormatStr := ' new %s({Position:%s,map:%s})';

  Result := Format(
    FormatStr,
    [
      JsClassName,
      Position.ToJavaScript,
      Map.JsVarName,
      FTitle
     ]
  );
end;

{ TOverlayList }

function TOverlayList.Add(var aGOverlay: TGOverlay): Integer;
begin
  aGOverlay.ID := AutoIncrementID;
  inc(AutoIncrementID);
  result := inherited Add(aGOverLay);
end;

procedure TOverlayList.Clear;
var
  i : integer;
begin
  for I := 0 to Count - 1 do
    if Assigned(GetItem(I)) then
      GetItem(I).Free;

  inherited;
end;

constructor TOverlayList.Create;
begin
end;

destructor TOverlayList.Destroy;
var
  i : integer;
begin
  for i:=0 to Count-1 do
    Items[I].Free;
end;

function TOverlayList.GetItems(Index: Integer): TGOverlay;
begin
  result := TGOverlay(inherited Items[Index]);
end;

procedure TOverlayList.SetItems(Index: Integer; const Value: TGOverlay);
begin
  inherited Items[Index] := Value;
end;

function TOverlayList.ToString: String;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Result := Result + Format('%d : %s (%s)',[I,Items[I].JsVarName,Items[I].JsClassName])+ #13#10;

  Result := inherited + Trim(Result);
end;

{ TGOverlay }

function TGOverlay.GetJsVarName: String;
begin
  FJsVarName := 'ovl_'+IntToStr(ID);
  Result := FJsVarName;
end;


procedure TGOverlay.hide;
begin
  inherited;
  if supportsHide then
    FMap.ExecJavaScript(JsVarName + '.hide();');
end;

function TGOverlay.isHidden: Boolean;
begin
  Result := FMap.Browser.GetJsValue(JsVarName + '.isHidden()');
end;

function TGOverlay.JsClassName: string;
begin
  Result := 'google.maps.Overlay';
end;

procedure TGOverlay.SetMap(const Value: TGoogleMaps);
begin
  FMap := Value;

  FMap.Overlays.Add(self);
  FMap.ExecJavaScript('var '+JsVarName+' = '+Self.ToJavaScript+';');
  FMap.ExecJavaScript(JsVarName+'.setMap('+FMap.JsVarName+');');
end;

procedure TGOverlay.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TGOverlay.SetJsVarName(const Value: String);
begin
  FJsVarName := Value;
end;

procedure TGOverlay.SetName(const Value: String);
begin
  FName := Value;
  FJsVarName := Value;
end;

procedure TGOverlay.show;
begin
  FMap.ExecJavaScript(JsVarName + '.show();');
end;

function TGOverlay.supportsHide: Boolean;
begin
  Result := false;
end;

{ TGBounds }

destructor TGBounds.Destroy;
begin
  FreeAndNil(FMin);
  FreeAndNil(FMid);
  FreeAndNil(FMax);
  inherited;
end;

function TGBounds.Equals(aGBounds: TGBounds): Boolean;
begin
  Result :=
  (
    (minX = aGBounds.minX) and
    (minY = aGBounds.minY) and
    (maxX = aGBounds.maxX) and
    (maxY = aGBounds.maxY)
  );
end;

function TGBounds.GetJsVarName: String;
begin
  Result := FJsVarName;
end;

function TGBounds.GetMax: TGLatLng;
begin
  Result := TGLatLng.Create(maxY,MaxX);
end;

function TGBounds.GetMid: TGLatLng;
begin
  if not Assigned(FMin) then
    FMid := TGLatLng.Create(minX+((maxX-minX)/2),minY+((maxY-minY)/2));

  Result := FMid;
end;

function TGBounds.GetMin: TGLatLng;
begin
  Result := TGLatLng.Create(minY,MinX);
end;

function TGBounds.JsClassName: String;
begin
  Result := 'google.maps.Bounds';
end;

procedure TGBounds.SetJsVarName(const Value: String);
begin
  FJsVarName := Value;
end;

function TGBounds.ToJavaScript: String;
begin
  Result := ' new '+JsClassName + '()';
  // @@@ not implemented
end;

function TGBounds.ToString: String;
begin
  // @@@ not yet implemented
end;

{ TGeoXML }

constructor TGGeoXml.Create(const aUrlOfXml: String);
begin
  FUrlOfXml:= aUrlOfXml;
end;

destructor TGGeoXml.Destroy;
begin
  // @@@ nothing to clean up
  inherited;
end;

procedure TGGeoXml.gotoDefaultViewport(Map: TGoogleMaps);
begin
  Map.ExecJavaScript(JsVarName + '.gotoDefaultViewport('+ Map.JsVarName +');');
end;

function TGGeoXml.JsClassName: String;
begin
  Result := 'google.maps.GeoXml';
end;

procedure TGGeoXml.SetUrlOfXml(const Value: String);
begin
  FUrlOfXml := Value;
end;

function TGGeoXml.supportsHide: Boolean;
begin
  Result := True;
end;

function TGGeoXml.ToJavaScript: String;
begin
  Map.ExecJavaScript('var '+JsVarName+' = new '+JsClassName+'("'+FUrlOfXml+'", function() { if ('+JsVarName+'.loadedCorrectly()) {'+JsVarName+'.gotoDefaultViewport('+Map.JsVarName+');}})');
  Result := JsVarName;
end;

{ TGCopyright }

constructor TGCopyright.Create(aId: Integer; aBounds: TGLatLngBounds;
  aMinZoom: Integer; aText: String);
begin
  Fid      := aID;
  FBounds  := aBounds;
  FMinZoom := aMinZoom;
  FText    := aText;
end;

procedure TGCopyright.Setbounds(const Value: TGLatLngBounds);
begin
  Fbounds := Value;
end;

procedure TGCopyright.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TGCopyright.SetminZoom(const Value: Integer);
begin
  FminZoom := Value;
end;

procedure TGCopyright.Settext(const Value: String);
begin
  Ftext := Value;
end;

{ TGLatLngBounds }


function TGLatLngBounds.contains(aLatLng: TGLatLng): Boolean;
begin
  Result :=
    (aLatLng.FLat > Self.FNorthEast.FLat) and
    (aLatLng.FLat < Self.FSouthWest.FLat) and
    (aLatLng.FLng > Self.FNorthEast.FLng) and
    (aLatLng.FLng < Self.FSouthWest.FLng);
end;

function TGLatLngBounds.containsBounds(aGLatLngBounds: TGLatLngBounds): Boolean;
begin
  Result := containsLatLng( aGLatLngBounds.FNorthEast ) and containsLatLng( aGLatLngBounds.FSouthWest )
end;

function TGLatLngBounds.containsLatLng(aLatLng: TGLatLng): Boolean;
begin
  Result :=
    InRange(aLatLng.FLat,Self.FNorthEast.FLat,Self.FSouthWest.FLat) and
    InRange(aLatLng.FLng,Self.FNorthEast.FLng,Self.FSouthWest.FLng)
end;

constructor TGLatLngBounds.Create(sw, ne: TGLatLng);
begin
  FSouthWest := sw;
  FNorthEast := ne;
end;

destructor TGLatLngBounds.Destroy;
begin
  FreeAndNil(FNorthEast);
  FreeAndNil(FSouthWest);
  inherited;
end;

function TGLatLngBounds.Equals(aGLatLngBounds: TGLatLngBounds): Boolean;
begin
  Result :=
    NorthEast.Equals(aGLatLngBounds.NorthEast) and
    SouthWest.Equals(aGLatLngBounds.SouthWest);
end;

procedure TGLatLngBounds.extend(aLatLng: TGLatLng);
begin
{
  NorthEast. va.extend(a.pd());
  SouthWest.Extend(
  this.fa.extend(aLatLng.qd())
  }
end;

function TGLatLngBounds.getCenter: TGLatLng;
begin
  Result := TGLatLng.Create(
    (FNorthEast.Lat + FSouthWest.FLat) / 2,
    (FNorthEast.Lng + FSouthWest.Lng ) / 2
  );
end;

function TGLatLngBounds.GetJsVarName: string;
begin
end;

function TGLatLngBounds.getNorthEast: TGLatLng;
begin
  Result := FNorthEast;
  //TGLatLngBounds.getNorthEast=function(){return K.fromRadians(this.va.hi,this.fa.hi)}
end;

function TGLatLngBounds.getSouthWest: TGLatLng;
begin
  Result := SouthWest;

  //TGLatLngBounds.getSouthWest=function(){return K.fromRadians(this.va.lo,this.fa.lo)}
end;

function TGLatLngBounds.intersects(aGLatLngBounds: TGLatLngBounds): Boolean;
begin
  //TGLatLngBounds.intersects=function(a){return this.va.intersects(a.va)&&this.fa.intersects(a.fa)}
  raise ENotImplemented.CreateFmt('function %s not implemented',['TGLatLngBounds.intersects()']);
end;

function TGLatLngBounds.isEmpty: Boolean;
begin
  //TGLatLngBounds.isEmpty=function(){return this.va.$()||this.fa.$()}
  raise ENotImplemented.CreateFmt('function %s not implemented',['TGLatLngBounds.isEmpty)']);
end;

function TGLatLngBounds.isFullLat: Boolean;
begin
  //TGLatLngBounds.isFullLat=function(){return this.va.hi>=Bc/2&&this.va.lo<=-Bc/2}
//  Result := FNorthEast.FLat=-90 and FSouthWest.FLat==90;
  raise ENotImplemented.CreateFmt('function %s not implemented',['TGLatLngBounds.isFullLat)']);
end;

function TGLatLngBounds.isFullLng: Boolean;
begin
  //TGLatLngBounds.isFullLng=function(){return this.fa.Yh()}
  raise ENotImplemented.CreateFmt('function %s not implemented',['TGLatLngBounds.isFullLng)']);
end;

function TGLatLngBounds.JsClassName: string;
begin
  Result := 'google.maps.LatLngBounds';
end;

procedure TGLatLngBounds.SetJsVarName(const aVarName: string);
begin
  JsVarName := aVarName;
end;

procedure TGLatLngBounds.setNorthEast(const Value: TGLatLng);
begin
  FNorthEast := Value;
end;

procedure TGLatLngBounds.setSouthWest(const Value: TGLatLng);
begin
  FSouthWest := Value;
end;

function TGLatLngBounds.ToJavaScript: string;
begin
  Result := ' new '+JsClassName + '('+ FSouthWest.ToJavaScript + ',' + FNorthEast.ToJavaScript + ')';
end;

function TGLatLngBounds.toSpan: TGLatLng;
begin
//  Result := K.fromRadians(this.va.span(),this.fa.span(),true)}
  raise ENotImplemented.CreateFmt('function %s not implemented',['TGLatLngBounds.toSpan)']);
end;

function TGLatLngBounds.ToString: String;
begin

end;

{ TGInfoWindow }

constructor TGInfoWindow.Create(const aCenter: TGLatLng);
begin
end;

destructor TGInfoWindow.Destroy;
begin

  inherited;
end;


function TGInfoWindow.JsClassName: String;
begin
  Result := 'google.maps.InfoWindow';
end;

procedure TGInfoWindow.Maximize;
begin
  //
end;

procedure TGInfoWindow.Restore;
begin
  //
end;


procedure TGInfoWindow.SetHTML(const Value: String);
begin
  FHTML := Value;
end;

function TGInfoWindow.supportsHide: Boolean;
begin
  Result := True;
end;

function TGInfoWindow.ToJavaScript: String;
begin
  Result := Map.JsVarName + '.getInfoWindowHtml();';
end;


{ TGPoint }

function TGPoint.Equals(P: TGPoint): Boolean;
begin
  Result:= (Self.FLat = p.Lat)and (self.Lon = p.Lon);
end;

function TGPoint.GetLat: Double;
begin
  Result := FLat;
end;

function TGPoint.GetLon: Double;
begin
  Result := FLon;
end;

procedure TGPoint.SetLat(const Value: Double);
begin
  FLat := Value;
end;

procedure TGPoint.SetLon(const Value: Double);
begin
  FLon := Value;
end;

function TGPoint.ToSTring: string;
begin
  Result := Format('%g,%g',[Lat,Lon]);
end;

end.
