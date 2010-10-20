unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  DelphiMaps.GeoCoder, ExtCtrls, DelphiMaps.GoogleMaps, DelphiMaps.Browser ;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    edSearch: TEdit;
    edFound: TEdit;
    GroupBox1: TGroupBox;
    edLat: TLabeledEdit;
    edLon: TLabeledEdit;
    GoogleMaps1: TGoogleMaps;
    procedure edSearchChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.edSearchChange(Sender: TObject);
var
  Req:TGeocoderRequest;
  Ad:TAddressRec;
begin
  Ad.Init;
  Ad.FormattedName := edSearch.Text;
  Ad.GeoCode;
  edFound.Text := Ad.FormattedName;
  edLat.Text := FloatToSTr(Ad.Lat);
  edLon.Text := FloatToSTr(Ad.Lon);

  GoogleMaps1.SetCenter(Ad.Lat, Ad.Lon);
  {
  Req.Address := Edit1.Text;
  TGeoCoder.GeoCode(Req,procedure(Results:Array of TGeoCoderResult;Status:TGeocoderStatus)
  begin
    Edit2.Text := IntToStr(ord(Status));
    Edit3.Text := Results[0].address_components[0].long_name;
  end
  );}
end;


end.
