{ ************************************************************************************************** }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the }
{ License at http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF }
{ ANY KIND, either express or implied. See the License for the specific language governing rights }
{ and limitations under the License. }
{ }
{ The Original Code is DelphiMaps.StaticMap.pas }
{ }
{ The Initial Developer of the Original Code is Wouter van Nifterick }
{ (wouter_van_nifterick@hotmail.com. }
{ ************************************************************************************************** }
unit DelphiMaps.WMS.Client;

interface

uses
  Types,
  SysUtils,
  Classes,
  Graphics,
  Contnrs,
  DelphiMaps.WebImage,
  DelphiMaps.Location,
  DelphiMaps.GoogleMaps;

type

{$SCOPEDENUMS ON}
  TGStaticMapsFormat = (mfPng, // use default png format
    mfPng8,                    // (default) specifies the 8-bit PNG format.
    mfPng32,                   // specifies the 32-bit PNG format.
    mfGif,                     // specifies the GIF format.
    mfJpg,                     // specifies the JPEG compression format.
    mfJpg_baseline             // specifies a non-progressive JPEG compression format.
    );

  EWmsException = Exception;

type
  TWmsParameters = class
    ServerURL: String;
    Version: String;
    SRS: String;
    CRS: String;
    ImageFormat: TGStaticMapsFormat;
    Transparent: Boolean;
    Layers: TStringList;
    Styles: TStringList;
    BoundingBox: TGLatLngBounds;
    Resolutions: TDoubleDynArray;
    Width: Integer;
    Height: Integer;
    BackgroundColor: TColor;
    SLD: String;
    Exceptions: String;
    CqlFilter: String;

    constructor Create;
    function ToURL: String;
  private
    function GetLayersString:string;
    function GetStylesString:string;
    procedure SetLayersString(const Value: String);
    procedure SetStylesString(const Value: String);
  public
    property LayersString:String read GetLayersString write SetLayersString;
    property StylesString:String read GetStylesString write SetStylesString;
    destructor Destroy; override;
  end;

const
  GStaticMapsFormatStr: array [TGStaticMapsFormat] of String = ('Png', // use default png format
    'Png8', // (default) specifies the 8-bit PNG format.
    'Png32',       // specifies the 32-bit PNG format.
    'Gif',         // specifies the GIF format.
    'Jpg',         // specifies the JPEG compression format.
    'Jpg-baseline' // specifies a non-progressive JPEG compression format.
    );

  GStaticMapsFormatExt: array [TGStaticMapsFormat] of String = ('png', // use default png format
    'png', // (default) specifies the 8-bit PNG format.
    'png', // specifies the 32-bit PNG format.
    'gif', // specifies the GIF format.
    'jpg', // specifies the JPEG compression format.
    'jpg'  // specifies a non-progressive JPEG compression format.
    );

type
  TWmsImage = class(TWebImage)
  private
    FUpdating  : Boolean;
    FParameters: TWmsParameters;
    function GetBackgroundColor: TColor;
    function GetBoundingBox: TGLatLngBounds;
    function GetCqlFilter: String;
    function GetCRS: String;
    function GetExceptions: String;
    function GetImageFormat: TGStaticMapsFormat;
    function GetLayers: TStringList ;
    function GetResolutions: TDoubleDynArray;
    function getServerURL: String;
    function GetSLD: String;
    function getSRS: String;
    function getStyles: TStringList;
    function getTransparent: Boolean;
    function GetVersion: String;
    function getWHeight: Integer;
    function getWWidth: Integer;
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetBoundingBox(const Value: TGLatLngBounds);
    procedure SetCqlFilter(const Value: String);
    procedure SetCRS(const Value: String);
    procedure SetExceptions(const Value: String);
    procedure SetImageFormat(const Value: TGStaticMapsFormat);
    procedure SetLayers(const Value: TStringList);
    procedure SetResolutions(const Value: TDoubleDynArray);
    procedure setServerURL(const Value: String);
    procedure SetSLD(const Value: String);
    procedure SetSRS(const Value: String);
    procedure setStyles(const Value: TStringList);
    procedure SetTransparent(const Value: Boolean);
    procedure SetVersion(const Value: String);
    procedure SetWHeight(const Value: Integer);
    procedure SetWWidth(const Value: Integer);
  protected
    function GetURL: string; override;
    function GetPropertyString: string; override;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    procedure BeginUpdate;
    procedure Endupdate;
  published
    property Parameters: TWmsParameters read FParameters write FParameters;

    property ServerURL      : String read getServerURL write setServerURL;
    property Version        : String read GetVersion write SetVersion;
    property SRS            : String read getSRS write SetSRS;
    property CRS            : String read GetCRS write SetCRS;
    property ImageFormat    : TGStaticMapsFormat read GetImageFormat write SetImageFormat;
    property Transparent    : Boolean read getTransparent write SetTransparent;
    property Layers         : TStringList read GetLayers write SetLayers;
    property Styles         : TStringList read getStyles write setStyles;
    property BoundingBox    : TGLatLngBounds read GetBoundingBox write setBoundingBox;
    property Resolutions    : TDoubleDynArray read GetResolutions write SetResolutions;
    property WWidth         : Integer read getWWidth write SetWWidth;
    property WHeight        : Integer read getWHeight write SetWHeight;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property SLD            : String read GetSLD write SetSLD;
    property Exceptions     : String read GetExceptions write SetExceptions;
    property CqlFilter      : String read GetCqlFilter write SetCqlFilter;

    procedure Refresh; override;
  end;

implementation

uses
  Windows,
  StrUtils;

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := B Shl 16 Or G Shl 8 Or R;
end;

{ TStaticMap }

procedure TWmsImage.BeginUpdate;
begin
  FUpdating := True;
end;

constructor TWmsImage.Create(AOwner: TComponent);
begin
  inherited;
  FParameters := TWmsParameters.Create;
  FUpdating := False;
  Self.Layers := TStringList.Create;
end;

destructor TWmsImage.Destroy;
begin
  FParameters.Free;
  inherited;
end;

procedure TWmsImage.Endupdate;
begin
  FUpdating := False;
  Refresh;
end;

function TWmsImage.GetBackgroundColor: TColor;
begin
  Result := FParameters.BackgroundColor
end;

function TWmsImage.GetBoundingBox: TGLatLngBounds;
begin
  Result := FParameters.BoundingBox
end;

function TWmsImage.GetCqlFilter: String;
begin
  Result := FParameters.CqlFilter
end;

function TWmsImage.GetCRS: String;
begin
  Result := FParameters.CRS
end;

function TWmsImage.GetExceptions: String;
begin
  Result := FParameters.Exceptions
end;

function TWmsImage.GetImageFormat: TGStaticMapsFormat;
begin
  Result := FParameters.ImageFormat
end;

function TWmsImage.GetLayers: TStringList;
begin
  Result := FParameters.Layers
end;

function TWmsImage.GetPropertyString: string;
begin
  result := inherited
end;

function TWmsImage.GetResolutions: TDoubleDynArray;
begin
  Result := FParameters.Resolutions
end;

function TWmsImage.getServerURL: String;
begin
  Result := FParameters.ServerURL
end;


function TWmsImage.GetSLD: String;
begin
  Result := FParameters.SLD
end;

function TWmsImage.getSRS: String;
begin
  Result := FParameters.SRS
end;

function TWmsImage.getStyles: TStringList;
begin
  Result := FParameters.Styles
end;

function TWmsImage.getTransparent: Boolean;
begin
  Result := FParameters.Transparent
end;

function TWmsImage.GetURL;
begin
  Result := FParameters.ToURL
end;

function TWmsImage.GetVersion: String;
begin
  Result := FParameters.Version
end;

function TWmsImage.getWHeight: Integer;
begin
  Result := FParameters.Height
end;

function TWmsImage.getWWidth: Integer;
begin
  Result := FParameters.Width
end;

procedure TWmsImage.Refresh;
begin
  URL := GetURL;
end;

procedure TWmsImage.setStyles(const Value: TStringList);
begin
  FParameters.Styles := Value
end;

procedure TWmsImage.SetBackgroundColor(const Value: TColor);
begin
  FParameters.BackgroundColor := Value
end;

procedure TWmsImage.SetBoundingBox(const Value: TGLatLngBounds);
begin
  FParameters.BoundingBox := Value
end;

procedure TWmsImage.SetCqlFilter(const Value: String);
begin
  FParameters.CqlFilter := Value
end;

procedure TWmsImage.SetCRS(const Value: String);
begin
  FParameters.CRS := Value
end;

procedure TWmsImage.SetExceptions(const Value: String);
begin
  FParameters.Exceptions := Value
end;

procedure TWmsImage.SetImageFormat(const Value: TGStaticMapsFormat);
begin
  FParameters.ImageFormat := Value
end;

procedure TWmsImage.SetLayers(const Value: TStringList);
begin
  FParameters.Layers := Value
end;

procedure TWmsImage.SetResolutions(const Value: TDoubleDynArray);
begin
  FParameters.Resolutions := Value
end;

procedure TWmsImage.setServerURL(const Value: String);
begin
  FParameters.ServerURL := Value
end;

procedure TWmsImage.SetSLD(const Value: String);
begin
  FParameters.SLD := Value
end;


procedure TWmsImage.SetSRS(const Value: String);
begin
  FParameters.SRS := Value
end;

procedure TWmsImage.SetTransparent(const Value: Boolean);
begin
  FParameters.Transparent := Value
end;

procedure TWmsImage.SetVersion(const Value: String);
begin
  FParameters.Version := Value

end;

procedure TWmsImage.SetWHeight(const Value: Integer);
begin
  FParameters.Height := Value

end;

procedure TWmsImage.SetWWidth(const Value: Integer);
begin
  FParameters.Width := Value
end;

{ TWmsParameters }

function Implode(const aSeparator: String; const aDynStringArray: TStringDynArray): String; overload;
var
  i: Integer;
begin
  Result   := '';
  for i    := 0 to Length(aDynStringArray) - 1 do
    Result := Result + aSeparator + aDynStringArray[i];
  System.Delete(Result, 1, Length(aSeparator));
end;

function Implode(const aSeparator: String; const aDynStringArray: TDoubleDynArray): String; overload;
var
  i: Integer;
begin
  Result   := '';
  for i    := 0 to Length(aDynStringArray) - 1 do
    Result := Result + aSeparator + FloatToStr(aDynStringArray[i]);
  System.Delete(Result, 1, Length(aSeparator));
end;

function ColorToHTML(const Color: TColor): string;
var
  ColorRGB: Integer;
begin
  ColorRGB := ColorToRGB(Color);
  Result   := Format('#%0.2X%0.2X%0.2X', [GetRValue(ColorRGB), GetGValue(ColorRGB), GetBValue(ColorRGB)]);
end;

constructor TWmsParameters.Create;
begin
  Version := '1.1.0';
  ImageFormat := TGStaticMapsFormat.mfPng32;
  Transparent := True;
  Width := 256;
  Height := 256;
  BackgroundColor := clWhite;
  SLD := '';
  SRS := '';
  CRS := '';
  BoundingBox := TGLatLngBounds.Create(0,0,0,0);
  Exceptions := 'application/vnd.ogc.se_inimage';
  BackgroundColor := clNone;
  Layers := TStringList.Create;
  Styles := TStringList.Create;
end;


destructor TWmsParameters.Destroy;
begin
  FreeAndNil(BoundingBox);
  FreeAndNil(Layers);
  FreeAndNil(Styles);

  inherited;
end;

function TWmsParameters.GetLayersString: string;
begin
  Result := Layers.CommaText
end;

function TWmsParameters.GetStylesString: string;
begin
  Result := Styles.CommaText
end;


procedure TWmsParameters.SetLayersString(const Value: String);
begin
  Layers.CommaText := Value
end;

procedure TWmsParameters.SetStylesString(const Value: String);
begin
  Styles.CommaText := Value
end;

function TWmsParameters.ToURL: String;
var
  SL: TStringList;
  function Escape(const S:String):String;
  begin
    Result := S;
    Result := ReplaceStr(Result,':','%3A');
    Result := ReplaceStr(Result,' ','%20');
    Result := ReplaceStr(Result,'=','%3D');
    Result := ReplaceStr(Result,'/','%2F');
  end;
begin
  Result := '';

  SL := TStringList.Create;
  try
    SL.Delimiter       := '&';
    SL.StrictDelimiter := True;

    // http://82.94.235.124:8080/geoserver/SMIB/wms?
    // LAYERS=SMIB%3Atrips_hi_ref&
    // STYLES=&FORMAT=image%2Fgif&
    // SERVICE=WMS&
    // VERSION=1.1.1&
    // REQUEST=GetMap&
    // EXCEPTIONS=application%2Fvnd.ogc.se_inimage&
    // SRS=EPSG%3A28992&
    // CQL_FILTER=trip_id%20%3D%2036145981&
    // BBOX=134551.17796199,398464.73917183,170944.79789607,420134.67600045&
    // WIDTH=1226&
    // HEIGHT=730

    // http://82.94.235.124:8080/geoserver/SMIB/wms?
    // service=WMS&version=1.1.0
    // &request=GetMap
    // &layers=SMIB:nldnld___________00
    // &styles=
    // &bbox=3.597,50.755,7.228,53.208
    // &width=512
    // &height=345
    // &srs=EPSG:4326
    // &format=image/png

    SL.Add('SERVICE=WMS');
    SL.Add('VERSION=' + Version);
    SL.Add('REQUEST=GetMap');
    SL.Add('LAYERS=' + Escape(LayersString));
    SL.Add('STYLES=' + Escape(StylesString));
    SL.Add('BBOX=' + BoundingBox.ToWmsBBox);
    SL.Add('WIDTH=' + IntToStr(Width));
    SL.Add('HEIGHT=' + IntToStr(Height));
    SL.Add('SRS=' + Escape(SRS));
    SL.Add('FORMAT=' + Escape('image/'+GStaticMapsFormatStr[ImageFormat]));

    // SL.Add('EXCEPTIONS=' + Escape(Exceptions));

    if CqlFilter<> '' then SL.Add('CQL_FILTER=' + Escape( CqlFilter ));
    if CRS      <> '' then SL.Add('CRS=' + CRS);
    if SLD      <> '' then SL.Add('SLD=' + SLD);
    SL.Add('TRANSPARENT=' + IfThen(Transparent, 'TRUE', 'FALSE'));
    if Length(Resolutions) > 0 then
      SL.Add('RESOLUTIONS=' + Implode(',', Resolutions));

    if BackgroundColor <> clNone then
      SL.Add('BGCOLOR=' + ColorToHTML(BackgroundColor));

    Result := ServerURL + '?' + SL.DelimitedText;
  finally
    SL.Free
  end;
end;


end.
