{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.StaticMap.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit DelphiMaps.StaticMap;

interface

uses
  Classes,
  Graphics,
  Generics.Collections,
  DelphiMaps.WebImage,
  DelphiMaps.Location,
  DelphiMaps.GoogleMaps;

type
  TStaticMapProvider = (mpGoogleMaps, mpOpenStreetMap);
  TStaticMapAPIType = (apiGoogleMapsStatic);

  TMapProviderRec = record
    Name: String;
    ApiType: TStaticMapAPIType;
    RootURL: String;
  end;

const
  cMapProviders: Array [TStaticMapProvider] of TMapProviderRec =
  (
    (
      Name: 'Google Maps';
      ApiType: apiGoogleMapsStatic;
      RootURL: 'http://maps.google.com/maps/api/staticmap?'
    ),
    (
      Name: 'OpenStreetMap';
      ApiType: apiGoogleMapsStatic;
      RootURL: 'http://dev.openstreetmap.de/staticmap/staticmap.php?'
    )
  );

type
  TGStaticMapsFormat = (mfPng, // use default png format
    mfPng8, // (default) specifies the 8-bit PNG format.
    mfPng32, // specifies the 32-bit PNG format.
    mfGif, // specifies the GIF format.
    mfJpg, // specifies the JPEG compression format.
    mfJpg_baseline // specifies a non-progressive JPEG compression format.
    );

const
  GStaticMapsFormatStr: array [TGStaticMapsFormat] of String = ('Png', // use default png format
    'Png8', // (default) specifies the 8-bit PNG format.
    'Png32', // specifies the 32-bit PNG format.
    'Gif', // specifies the GIF format.
    'Jpg', // specifies the JPEG compression format.
    'Jpg-baseline' // specifies a non-progressive JPEG compression format.
    );

  GStaticMapsFormatExt: array [TGStaticMapsFormat] of String = ('png', // use default png format
    'png', // (default) specifies the 8-bit PNG format.
    'png', // specifies the 32-bit PNG format.
    'gif', // specifies the GIF format.
    'jpg', // specifies the JPEG compression format.
    'jpg' // specifies a non-progressive JPEG compression format.
    );

type

  TStaticPathStyle = class(TComponent)
  private
    FWeight: Integer;
    FColor: TColor;
    FTransparency: Byte;
    FFillColor: TColor;
    procedure SetWeight(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetTransparency(const Value: Byte);
    procedure SetFillColor(const Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
  published

    property Weight: Integer read FWeight write SetWeight default -1;
    property Color: TColor read FColor write SetColor default clBlue;
    property Transparency: Byte read FTransparency write SetTransparency;
    property FillColor: TColor read FFillColor write SetFillColor default clNone;
    function ToString: String; override;
  end;

  TStaticPath = class(TList<TLocation>)
  private
    FStyle: TStaticPathStyle;
    procedure SetStyle(const Value: TStaticPathStyle);
  public
    function ToString: String; override;
    procedure Simplify(Tolerance: Integer);
    property Style: TStaticPathStyle read FStyle write SetStyle;
  end;

  TStaticPaths = class(TList<TStaticPath>)
    function ToString: String; override;
  end;

  TStaticMap = class(TWebImage)
  private
    FCenter: TLocation;
    FMapType: TStaticMapType;
    FMarkers: TList<TGMarker>;
    FZoom: Integer;
    FFormat: TGStaticMapsFormat;
    FLanguage: String;
    FSensor: Boolean;
    FPaths: TStaticPaths;
    FUpdating:Boolean;
    procedure SetMapType(const Value: TStaticMapType);
    procedure SetMarkers(const Value: TList<TGMarker>);
    procedure SetZoom(const Value: Integer);
    procedure SetFormat(const Value: TGStaticMapsFormat);
    procedure SetLanguage(const Value: String);
    procedure SetSensor(const Value: Boolean);
  private
    FMapProvider: TStaticMapProvider;
    function GetMapURL: String;
    function GetPaths: TStaticPaths;
    procedure SetPaths(const Value: TStaticPaths);
    procedure SetMapProvider(const Value: TStaticMapProvider);
    function getProviderInfo: TMapProviderRec;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate;
    procedure Endupdate;
{
    property Action;
    property ActionLink;
    property Align;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BoundsRect;
    property Canvas;
    property Caption;
    property ClientHeight;
    property ClientOrigin;
    property ClientRect;
    property ClientWidth;
    property Color;
    property ComObject;
    property ComponentCount;
    property ComponentIndex;
    property ComponentState;
    property ComponentStyle;
    property Components;
    property Constraints;
    property ControlState;
    property ControlStyle;
    property DesignInfo;
    property DesktopFont;
    property DockOrientation;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExplicitHeight;
    property ExplicitLeft;
    property ExplicitTop;
    property ExplicitWidth;
    property Floating;
    property FloatingDockSiteClass;
    property Font;
    property HostDockSite;
    property IsControl;
    property LRDockWidth;
    property MouseCapture;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property Owner;
    property Parent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ScalingFlags;
    property ShowHint;
    property TBDockHeight;
    property Text;
    property Touch;
    property UndockHeight;
    property UndockWidth;
    property VCLComObject;
    property Visible;
    property WheelAccumulator;
    property WindowProc;
    property WindowText;
    property Stretch;
}
    procedure HandleOnCenterChange(Sender:TObject);

  published
    property Center: TLocation read FCenter;
    property Zoom: Integer read FZoom write SetZoom default 5;
    property MapType: TStaticMapType read FMapType write SetMapType;
    property Markers: TList<TGMarker>read FMarkers write SetMarkers;
    property Format: TGStaticMapsFormat read FFormat write SetFormat;
    property Language: String read FLanguage write SetLanguage;
    property Paths: TStaticPaths read GetPaths write SetPaths;
    property Sensor: Boolean read FSensor write SetSensor;
    property ProviderInfo: TMapProviderRec read getProviderInfo;
    property MapProvider: TStaticMapProvider read FMapProvider write SetMapProvider;
    procedure Refresh;override;
  end;

implementation

uses
  SysUtils,
  StrUtils;


function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := B Shl 16 Or G Shl 8 Or R;
end;


{ TStaticMap }

procedure TStaticMap.BeginUpdate;
begin
  FUpdating := True;
end;

constructor TStaticMap.Create(AOwner: TComponent);
begin
  inherited;
  FMarkers := TList<TGMarker>.Create;
  FPaths := TStaticPaths.Create;
  FCenter := TLocation.Create;
  FCenter.OnChange := HandleOnCenterChange;
  FUpdating := False;
end;

destructor TStaticMap.Destroy;
begin
  FreeAndNil(FMarkers);
  FreeAndNil(FPaths);
  FreeAndNil(FCenter);
  inherited;
end;

procedure TStaticMap.Endupdate;
begin
  FUpdating := False;
  Refresh;
end;

function TStaticMap.GetMapURL: String;
var
  LTolerance: Integer;
  SB: TStringBuilder;
  LPath:TStaticPath;
begin
  LTolerance := 0;
  SB := TStringBuilder.Create;

  try
    repeat
      for LPath in Paths do
        LPath.Simplify(LTolerance);
      SB.Clear;
      SB.Append(cMapProviders[MapProvider].RootURL);
      SB.Append('sensor=' + ifthen(Sensor, 'true', 'false'));
      SB.Append('&center=' + FCenter.ToString);
      SB.Append('&maptype=' + cStaticMapTypeStr[MapType]);
      SB.Append(Paths.ToString);
      SB.AppendFormat('&size=%dx%d', [Width, Height]);
      SB.Append('&zoom=');
      SB.Append(Zoom);
      Result := SB.ToString;
      Inc(LTolerance, 5);
    until (Length(Result) < 2000);
  finally
    SB.Free;
  end;
end;

function TStaticMap.GetPaths: TStaticPaths;
begin
  Result := FPaths;
end;

function TStaticMap.getProviderInfo: TMapProviderRec;
begin
  Result := cMapProviders[FMapProvider];
end;

procedure TStaticMap.HandleOnCenterChange(Sender:TObject);
begin
  Refresh;
end;

procedure TStaticMap.Refresh;
begin
  URL := GetMapURL;
end;


procedure TStaticMap.SetFormat(const Value: TGStaticMapsFormat);
begin
  FFormat := Value;
  Refresh;
end;

procedure TStaticMap.SetLanguage(const Value: String);
begin
  FLanguage := Value;
  Refresh;
end;

procedure TStaticMap.SetMapProvider(const Value: TStaticMapProvider);
begin
  FMapProvider := Value;
  Refresh;
end;

procedure TStaticMap.SetMapType(const Value: TStaticMapType);
begin
  FMapType := Value;
  Refresh;
end;

procedure TStaticMap.SetMarkers(const Value: TList<TGMarker>);
begin
  FMarkers := Value;
  Refresh;
end;

procedure TStaticMap.SetPaths(const Value: TStaticPaths);
begin
  FPaths := Value;
  Refresh;
end;

procedure TStaticMap.SetSensor(const Value: Boolean);
begin
  FSensor := Value;
  Refresh;
end;

procedure TStaticMap.SetZoom(const Value: Integer);
begin
  FZoom := Value;
  Refresh;
end;

{ TStaticPathStyle }

constructor TStaticPathStyle.Create(AOwner: TComponent);
begin
  inherited;
  FWeight := 1;
  FColor := clBlue;
  FTransparency := 127;
  FFillColor := clNone;
end;

procedure TStaticPathStyle.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TStaticPathStyle.SetFillColor(const Value: TColor);
begin
  FFillColor := Value;
end;

procedure TStaticPathStyle.SetTransparency(const Value: Byte);
begin
  FTransparency := Value;
end;

procedure TStaticPathStyle.SetWeight(const Value: Integer);
begin
  FWeight := Value;
end;

function TStaticPathStyle.ToString: String;
begin
  Result := Format('color:%.2x%.6x|weight:%f,fillcolor:%.8x', [FTransparency, FColor, FWeight, Self.FFillColor]);
end;

{ TStaticPath }

procedure TStaticPath.SetStyle(const Value: TStaticPathStyle);
begin
  FStyle := Value;
end;

procedure TStaticPath.Simplify(Tolerance: Integer);
begin
  //
end;

function TStaticPath.ToString: String;
var
  I: Integer;
begin
  Result := '';

  if Count = 0 then
    Exit;
  Result := Result + 'path=';
  Result := Result + FStyle.ToString;
  Result := Result + '|';
  for I := 0 to Count - 1 do
  begin
    Result := Result + Items[I].Point.ToString + '|';
  end;
  Result := Copy(Result, 1, Length(Result) - 1);
end;

{ TStaticPaths }

function TStaticPaths.ToString: String;
var
  Path: TStaticPath;
begin
  Result := '';
  for Path in Self do
    Result := Result + Path.ToString;
end;

end.
