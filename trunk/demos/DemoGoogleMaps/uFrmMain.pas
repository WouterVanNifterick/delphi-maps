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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, DelphiMaps.LayerList, DelphiMaps.GoogleMaps,
  ComCtrls, ExtCtrls, DelphiMaps.Browser;

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
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
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

procedure TfrmMain.Button2Click(Sender: TObject);
var
  SouthWest,NorthEast : TGLatLng;
  Bounds : TGLatLngBounds;
  latSpan,lngSpan:Double;
  Location:TGLatLng;
  Marker:TGMarker;
  i:Integer;
begin
  SouthWest := TGLatLng.Create(-31.203405,125.244141);
  NorthEast := TGLatLng.Create(-25.363882,131.044922);
  Bounds    := TGLatLngBounds.Create(SouthWest,NorthEast);
  GoogleMaps1.FitBounds(Bounds);

  lngSpan := NorthEast.lng - SouthWest.lng;
  latSpan := NorthEast.lat - SouthWest.lat;

  Randomize;
  for i := 0 to 4 do
  begin
    Location := TGLatLng.Create(SouthWest.lat + latSpan * Random,
                                southWest.lng + lngSpan * random);
    Marker := TGMarker.Create(Location, GoogleMaps1);
  end;
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
