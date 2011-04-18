unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DelphiMaps.WebImage, DelphiMaps.WMS.Client, StdCtrls,
  DelphiMaps.GoogleMaps;

type
  TfrmMain = class(TForm)
    wms: TWmsImage;
    procedure FormCreate(Sender: TObject);
    procedure WmsImage1Click(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  wms.ServerURL := 'http://82.94.235.124:8080/geoserver/SMIB/wms';
  wms.SRS := 'EPSG:4326';
  wms.BoundingBox.SouthWest.Lng := 3.597;
  wms.BoundingBox.SouthWest.Lat := 50.755;
  wms.BoundingBox.NorthEast.Lng := 7.228;
  wms.BoundingBox.NorthEast.Lat := 53.208;
  wms.Layers.Add('SMIB:nldnld___________00');
  wms.WWidth := Width;
  wms.WHeight := Height;
  wms.ImageFormat := TGStaticMapsFormat.mfPng;
  wms.Exceptions := 'application/vnd.ogc.se_inimage';
  wms.Refresh;
end;

procedure TfrmMain.WmsImage1Click(Sender: TObject);
begin
  wms.WWidth := Width;
  wms.WHeight := Height;
  wms.Width := Width;
  wms.Height := Height;
  wms.Refresh;
end;

end.
