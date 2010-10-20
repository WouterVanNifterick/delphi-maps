unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DelphiMaps.Browser, DelphiMaps.StreetView, ExtCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    StreetView1: TStreetView;
    FlowPanel1: TFlowPanel;
    Label1: TLabel;
    edCenter: TEdit;
    btnSetCenter: TButton;
    LinkLabel1: TLinkLabel;
    pnlLeft: TPanel;
    lblHeading: TLabel;
    sbHeading: TScrollBar;
    lblPitch: TLabel;
    sbPitch: TScrollBar;
    lblZoom: TLabel;
    sbZoom: TScrollBar;
    Splitter1: TSplitter;
    procedure OnPovChange(Sender: TObject);
    procedure btnSetCenterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnSetCenterClick(Sender: TObject);
begin
  StreetView1.Center.Text := edCenter.Text;
end;

procedure TfrmMain.OnPovChange(Sender: TObject);
begin
  StreetView1.POV.SetAll(
    sbHeading.Position / 10,
    sbPitch.Position / 10,
    sbZoom.Position / 10
  );
end;

end.
