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
  DelphiMaps.WebImage;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    TrackBar1: TTrackBar;
    FlowPanel1: TFlowPanel;
    StaticMap1: TStaticMap;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    cmbProvider: TComboBox;
    LinkLabel1: TLinkLabel;
    procedure Panel1Resize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure cmbProviderChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses ShellAPI;

{$R *.dfm}

procedure TfrmMain.cmbProviderChange(Sender: TObject);
begin
  if cmbProvider.ItemIndex<0 then
    Exit;

  StaticMap1.MapProvider := TStaticMapProvider(cmbProvider.ItemIndex)
end;

procedure TfrmMain.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex>=0 then
    StaticMap1.MapType := TStaticMapType(ComboBox1.ItemIndex)
end;


procedure TfrmMain.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
        StaticMap1.Center.Text := Edit1.Text;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  S:String;
  MP : TMapProviderRec;

begin
  for S in cStaticMapTypeStr do
    ComboBox1.Items.Add(S);
  ComboBox1.ItemIndex := 1;

  for MP in cMapProviders  do
    cmbProvider.Items.Add(MP.Name);
  cmbProvider.ItemIndex := 0;


  Edit1.Text := 'Ypenburg, Den Haag';
  StaticMap1.Center.Text := Edit1.Text;
  StaticMap1.Zoom := TrackBar1.Position;

end;

procedure TfrmMain.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  case LinkType of
    sltURL: ShellExecute(self.WindowHandle,'open',PChar(StaticMap1.URL),nil,nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmMain.Panel1Resize(Sender: TObject);
begin
  StaticMap1.Refresh;
end;

procedure TfrmMain.TrackBar1Change(Sender: TObject);
begin
  StaticMap1.Zoom := TrackBar1.Position;
end;

end.
