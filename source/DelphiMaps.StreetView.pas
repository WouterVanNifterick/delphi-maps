{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.StreetView.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit DelphiMaps.StreetView;

interface

uses
  Classes,
  DelphiMaps.Location,
  DelphiMaps.Browser;

  {$R DelphiMaps.StreetView_html.res}

type
  TPOV = class
  private
    FPitch: Double;
    FHeading: Double;
    FZoom: Double;
    FOnChange: TNotifyEvent;
    procedure SetHeading(const Value: Double);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetPitch(const Value: Double);
    procedure SetZoom(const Value: Double);

    procedure DoOnChange;
  public
    function Equals(Obj: TPOV): Boolean; reintroduce;
    property Heading:Double read FHeading write SetHeading;
    property Pitch:Double read FPitch write SetPitch;
    property Zoom:Double read FZoom write SetZoom;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    procedure SetAll(aHeading,aPitch,aZoom:Double);
  end;

  TStreetView=class(TBrowserControl)
    procedure Init;
  private
    FCenter: TLocation;
    FPOV: TPOV;
    procedure SetCenter(const Value: TLocation);
    procedure SetPOV(const Value: TPOV);
  protected
    procedure Resize; override;
  public
    procedure HandleOnCenterChange(Sender:TObject);
    procedure HandleOnPOVChange(Sender:TObject);
    destructor Destroy; override;
    property Center:TLocation read FCenter write SetCenter;
    property POV:TPOV read FPOV write SetPOV;
    class function GetHTMLResourceName: String;override;
    constructor Create(AOwner: TComponent); override;

  end;

implementation

uses
  IoUtils,
  SysUtils;

resourcestring
  StrSTREETVIEWHTML = 'STREETVIEW_HTML';
  StrStreetViewFileName = 'StreetView.html';

{ TStreetMap }

constructor TStreetView.Create(AOwner: TComponent);
begin
  inherited;

  FCenter := TLocation.Create;
  FCenter.OnChange := HandleOnCenterChange;

  FPov := TPOV.Create;
  FPov.OnChange := HandleOnPOVChange;

  Init;
end;


destructor TStreetView.Destroy;
begin
  FreeAndNil(FPOV);
  FreeAndNil(FCenter);
  inherited;
end;

class function TStreetView.GetHTMLResourceName: String;
begin
  Result := StrSTREETVIEWHTML;
end;

procedure TStreetView.HandleOnCenterChange(Sender: TObject);
begin
  {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  case FCenter.LocationType of
    ltCoordinates : ExecJavaScript(Format('%s.setPosition(new google.maps.LatLng(%g,%g));',[JsVarName,FCenter.Position.Lat,FCenter.Position.Lng]));
    ltText        : ExecJavaScript(Format('%s.setPosition( AddressToLatLng("%s") );',[JsVarName,FCenter.Text]));
  end;
end;

procedure TStreetView.HandleOnPOVChange(Sender: TObject);
begin
  {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  ExecJavaScript(Format('%s.setPov({heading:%f,pitch:%f,zoom:%f});',[JsVarName,FPOV.Heading,FPOV.Pitch,FPOV.Zoom]));
end;

procedure TStreetView.Init;
var
  LHtmlFileName : String;
begin
  Browser.OnDocumentComplete := WebBrowserDocumentComplete;
  LHtmlFileName := TPath.GetTempPath+StrStreetViewFileName;
  SaveHtml(LHtmlFileName);
  if FileExists(LHtmlFileName) then
    Browser.Navigate('file://' + LHtmlFileName);
end;

procedure TStreetView.Resize;
begin
  inherited;
  ExecJavaScript(Format('document.getElementById("StreetViewDiv").style.height="%dpx";',[Browser.Height-5 ]));
end;

procedure TStreetView.SetCenter(const Value: TLocation);
begin
  if FCenter.Equals(Value) then
    Exit;

  FCenter := Value;
  ExecJavaScript(Format('%s.setPosition(new google.maps.LatLng(%g,%g));',[JsVarName,FCenter.Position.Lat,FCenter.Position.Lng]));
end;

procedure TStreetView.SetPOV(const Value: TPOV);
begin
  if FPOV.Equals(Value) then
    Exit;

  FPOV := Value;
  FPOV.DoOnChange;
//  ExecJavaScript(Format('%s.setPov({heading:%g,pitch:0,zoom:1});',[JsVarName,FPOV.Heading,FPOV.Pitch,FPOV.Zoom]));
end;

{ TPov }

procedure TPOV.DoOnChange;
begin
  if Assigned(FOnChange) then
    OnChange(self);
end;

function TPOV.Equals(Obj: TPOV): Boolean;
begin
  Result := (FPitch  =Obj.Pitch  ) and
            (FHeading=Obj.Heading) and
            (FZoom   =Obj.Zoom   );
end;

procedure TPOV.SetAll(aHeading, aPitch, aZoom: Double);
begin
  FPitch   := aPitch;
  FHeading := aHeading;
  FZoom    := aZoom;
  DoOnChange;
end;

procedure TPOV.SetHeading(const Value: Double);
begin
  FHeading := Value;
  DoOnChange;
end;

procedure TPOV.SetPitch(const Value: Double);
begin
  FPitch := Value;
  DoOnChange;
end;

procedure TPOV.SetZoom(const Value: Double);
begin
  FZoom := Value;
  DoOnChange;
end;

procedure TPOV.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

end.
