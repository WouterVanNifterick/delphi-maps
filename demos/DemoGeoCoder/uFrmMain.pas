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
    Timer1: TTimer;
    procedure edSearchChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    Ad:TAddressRec;
    ChangeDateTime:TDateTime;
  end;

var
  frmMain: TfrmMain;

implementation

uses DateUtils;

{$R *.dfm}

procedure TfrmMain.edSearchChange(Sender: TObject);
begin
  Ad.GeoCode(edSearch.Text);

  edFound.Text := Ad.FormattedName;
  edLat.Text   := FloatToSTr(Ad.Lat);
  edLon.Text   := FloatToSTr(Ad.Lon);

  ChangeDateTime := Now;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
const
  MinMapUpdateDelay=500; // milliseconds
begin
  // JScript.dll doesn't like your fast typing :)
  // so let's limit map movement to twice per second
  if MilliSecondsBetween(Now,ChangeDateTime)>MinMapUpdateDelay then
  begin
    if edSearch.Text<>'' then
      GoogleMaps1.SetCenter(Ad.Lat, Ad.Lon);
  end;
end;

end.
