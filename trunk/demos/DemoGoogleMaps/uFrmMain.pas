{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls, Classes,

  DelphiMaps.LayerList,
  DelphiMaps.GoogleMaps,
  DelphiMaps.Browser ;

type
  TfrmMain = class(TForm)
    GoogleMapsLayersList1: TGoogleMapsLayersList;
    Splitter1: TSplitter;
    GoogleMaps1: TGoogleMaps;
    FlowPanel1: TFlowPanel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    LinkLabel1: TLinkLabel;
    pnlLeft: TPanel;
    btnTestPolygon1: TButton;
    btnTestMarkers: TButton;
    btnMarker: TButton;
    btnTestPolyGon2: TButton;
    Button1: TButton;
    btnGetBounds: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTestPolygon1Click(Sender: TObject);
    procedure btnTestMarkersClick(Sender: TObject);
    procedure btnMarkerClick(Sender: TObject);
    procedure btnTestPolyGon2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnGetBoundsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Graphics, Dialogs;

{$R *.dfm}

procedure TfrmMain.btnTestPolygon1Click(Sender: TObject);
var
  LPolygon:TGPolyLine;
begin
  LPolygon := TGPolyLine.Create;
  LPolygon.StrokeColor   := clRed;
  LPolygon.StrokeWeight  := 4;
  LPolygon.StrokeOpacity := 0.7;
  LPolygon.AddPoint( TGLatLng.Create(52.3,5.3) );
  LPolygon.AddPoint( TGLatLng.Create(52.2,5.2) );
  LPolygon.AddPoint( TGLatLng.Create(52.1,5.3) );
  LPolygon.AddPoint( TGLatLng.Create(52.0,5.4) );
  LPolygon.AddPoint( TGLatLng.Create(52.1,5.5) );
  LPolygon.AddPoint( TGLatLng.Create(52.2,5.6) );
  LPolygon.AddPoint( TGLatLng.Create(52.3,5.5) );
  LPolygon.Map := GoogleMaps1;

  // don't free Poly here. It will be destroyed by GoogleMaps1
end;

procedure TfrmMain.btnTestPolyGon2Click(Sender: TObject);
var
  SouthWest,NorthEast : TGLatLng;
  Bounds : TGLatLngBounds;
  latSpan,lngSpan:Double;
  Location:TGLatLng;
  PolyLine:TGPolyLine;
  i:Integer;
  Marker: TGMarker;
begin
  SouthWest := TGLatLng.Create(-31.203405,125.244141);
  NorthEast := TGLatLng.Create(-25.363882,131.044922);
  Bounds    := TGLatLngBounds.Create(SouthWest,NorthEast);
  try
    lngSpan := NorthEast.lng - SouthWest.lng;
    latSpan := NorthEast.lat - SouthWest.lat;
    GoogleMaps1.FitBounds(Bounds);
    Randomize;

    PolyLine := TGPolyLine.Create;
    for i := 0 to 4 do
    begin
      Location := TGLatLng.Create(SouthWest.lat + latSpan * Random,
                                  southWest.lng + lngSpan * random);
      PolyLine.AddPoint(Location);

      Marker := TGMarker.Create(
                  Location,
                  GoogleMaps1,
                  'This is point '+IntToStr(I),
                  'http://google-maps-icons.googlecode.com/files/nav-media.gif'
                );
    end;
    PolyLine.Map := GoogleMaps1;
  finally
    Bounds.Free;
  end;

end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
  ShowMessage(GoogleMaps1.Browser.Eval('map.getCenter().lat()'));
end;

procedure TfrmMain.btnGetBoundsClick(Sender: TObject);
begin
  ShowMessage(GoogleMaps1.Bounds.ToString);
end;

procedure TfrmMain.btnMarkerClick(Sender: TObject);
var
  Bounds : TGLatLngBounds;
  SouthWest: TGLatLng;
  NorthEast: TGLatLng;
  Marker   : TGMarker;
begin
  SouthWest := TGLatLng.Create(-31.203405,125.244141);
  NorthEast := TGLatLng.Create(-25.363882,131.044922);
  Bounds    := TGLatLngBounds.Create(SouthWest,NorthEast);
  try
    // You can create an icon like this:

    TGMarker.Create(
      Bounds.getCenter,
      GoogleMaps1,
      'Hello, World!',
      'http://google-maps-icons.googlecode.com/files/snow.png'
    );

    // or keep a reference, and set its properties later on
    Marker := TGMarker.Create(
      TGLatLng.Create(-31.213405,127)
    );
    Marker.Map   := GoogleMaps1;
    Marker.Title := 'Test';
    Marker.Icon  := 'http://google-maps-icons.googlecode.com/files/sun.png';

    GoogleMaps1.FitBounds( Bounds );

  finally
    Bounds.Free;
  end;
end;

procedure TfrmMain.btnTestMarkersClick(Sender: TObject);
var
  SouthWest,NorthEast : TGLatLng;
  Bounds : TGLatLngBounds;
  latSpan,lngSpan:Double;
  Location:TGLatLng;
  i:Integer;
begin
  SouthWest := TGLatLng.Create(-31.203405,125.244141);
  NorthEast := TGLatLng.Create(-25.363882,131.044922);
  Bounds    := TGLatLngBounds.Create(SouthWest,NorthEast);
  lngSpan := NorthEast.lng - SouthWest.lng;
  latSpan := NorthEast.lat - SouthWest.lat;
  GoogleMaps1.FitBounds(Bounds);
  Randomize;
  for i := 0 to 4 do
  begin
    Location := TGLatLng.Create(SouthWest.lat + latSpan * Random,
                                southWest.lng + lngSpan * random);
    TGMarker.Create(Location, GoogleMaps1);
  end;
  Bounds.Free;

end;

procedure TfrmMain.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex<0 then
    Exit;

  GoogleMaps1.MapType := TGoogleMapType(ComboBox1.ItemIndex);
end;

procedure TfrmMain.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
//        GoogleMaps1.SetCenter(  );
      end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var S:String;
begin
  for S in cGoogleMapTypeStr do
    ComboBox1.Items.Add(S);

  ComboBox1.ItemIndex := 0;
end;

end.
