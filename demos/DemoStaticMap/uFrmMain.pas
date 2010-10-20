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
  Dialogs, DelphiMaps.GoogleMaps, ExtCtrls, ComCtrls, ToolWin,
  Generics.Collections, DelphiMaps.StaticMap, pngimage, StdCtrls,
  DelphiMaps.WebImage, DelphiMaps.Location;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    FlowPanel1: TFlowPanel;
    Label1: TLabel;
    edCenter: TEdit;
    btnSetCenter: TButton;
    Label2: TLabel;
    cmbMapType: TComboBox;
    Label3: TLabel;
    cmbProvider: TComboBox;
    LinkLabel1: TLinkLabel;
    TrackBar1: TTrackBar;
    StaticMap1: TStaticMap;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbMapTypeChange(Sender: TObject);
    procedure edCenterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
    procedure cmbProviderChange(Sender: TObject);
    procedure btnSetCenterClick(Sender: TObject);
  private
    procedure GetMapTypes;
    procedure GetMapProviders;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses ShellAPI;

{$R *.dfm}

procedure TfrmMain.GetMapTypes;
var S: string;
begin // Fill MapTypes combobox
  for S in cStaticMapTypeStr do
    cmbMapType.Items.Add(S);
  cmbMapType.ItemIndex := 1;
end;

procedure TfrmMain.GetMapProviders;
var MP: TMapProviderRec;
begin // Fill MapProviders combobox
  for MP in cMapProviders do
    cmbProvider.Items.Add(MP.Name);
  cmbProvider.ItemIndex := 0;
end;

procedure TfrmMain.btnSetCenterClick(Sender: TObject);
begin
  StaticMap1.Center.Text := edCenter.Text;
end;

procedure TfrmMain.cmbMapTypeChange(Sender: TObject);
begin
  StaticMap1.MapType := TStaticMapType(cmbMapType.ItemIndex)
end;

procedure TfrmMain.cmbProviderChange(Sender: TObject);
begin
  StaticMap1.MapProvider := TStaticMapProvider(cmbProvider.ItemIndex)
end;

procedure TfrmMain.edCenterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      StaticMap1.Center.Text := edCenter.Text;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  GetMapTypes;
  GetMapProviders;
  edCenter.Text := 'Ypenburg, Den Haag';
  StaticMap1.Center.Text := edCenter.Text;
  StaticMap1.Zoom := TrackBar1.Position;

end;

procedure TfrmMain.LinkLabel1LinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  case LinkType of
    sltURL: StaticMap1.OpenURL;
  end;
end;

procedure TfrmMain.TrackBar1Change(Sender: TObject);
begin
  StaticMap1.Zoom := TrackBar1.Position;
end;

end.
