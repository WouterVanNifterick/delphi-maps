{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.LayerList.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}

unit DelphiMaps.LayerList;

interface

uses
  Classes,
  Menus,
  CheckLst,
  DelphiMaps.GoogleMaps,
  ComCtrls,
  Controls;

type
  TGoogleMapsLayersList=class(TTreeView)
  private
    FGoogleMaps:TGoogleMaps;
    miZoomtoOverlay1:TMenuItem;
  public
    Constructor Create(AOwner:TComponent);override;
    procedure Update; override;
    procedure miDeleteoverlay1Click(Sender: TObject);
    procedure miZoomtoOverlay1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure OnDoubleClick(Sender: TObject);
  published
    property GoogleMaps:TGoogleMaps read FGoogleMaps write FGoogleMaps;
  end;

implementation


{ TGoogleMapsLayersList }

constructor TGoogleMapsLayersList.Create(AOwner: TComponent);
var
  Mi:TMenuItem;
begin
  inherited;

  PopupMenu := TPopupMenu.Create(self);
  PopupMenu.OnPopup := PopupMenu1Popup;

  Mi := TMenuItem.Create(PopupMenu);
  Mi.Caption := '&Delete overlay';
  Mi.OnClick := miDeleteoverlay1Click;
  PopupMenu.Items.Add(Mi);

  miZoomtoOverlay1 := TMenuItem.Create(PopupMenu);
  miZoomtoOverlay1 .Caption := '&Zoom to Overlay';
  miZoomtoOverlay1 .OnClick := miZoomtoOverlay1Click;
  miZoomtoOverlay1 .Name := 'miZoomtoOverlay1';

  self.OnDblClick := OnDoubleClick;
end;

procedure TGoogleMapsLayersList.OnDoubleClick(Sender: TObject);
begin
  miZoomtoOverlay1Click(Sender);
end;

procedure TGoogleMapsLayersList.miDeleteoverlay1Click(Sender: TObject);
begin
  inherited;
  if not Assigned(Selected) then
    Exit;



  if Selected.Index < 0 then Exit;

  if Selected.Index < FGoogleMaps.Overlays.Count then
  begin
    FGoogleMaps.RemoveOverlayByIndex(Selected.Index);
    Update;
  end;
end;

procedure TGoogleMapsLayersList.miZoomtoOverlay1Click(Sender: TObject);
begin
  if not Assigned(Selected) then
    Exit;

  if Selected.Index < 0 then
    Exit;

  if Selected.Index < FGoogleMaps.Overlays.Count then
  begin
    if FGoogleMaps.Overlays[Selected.Index].JsClassName='GGeoXml' then
      TGGeoXml(FGoogleMaps.Overlays[Selected.Index]).gotoDefaultViewport(FGoogleMaps);
  end;
end;

procedure TGoogleMapsLayersList.PopupMenu1Popup(Sender: TObject);
begin
  if not Assigned(Selected) then
    Exit;

  if Selected.Index < 0 then
    Exit;

  if Selected.Index < FGoogleMaps.Overlays.Count then
    miZoomtoOverlay1.Enabled := FGoogleMaps.Overlays[Selected.Index].JsClassName='GGeoXml';
end;

procedure TGoogleMapsLayersList.Update;
begin
  if not Assigned(FGoogleMaps) then
    Exit;


  Text := FGoogleMaps.Overlays.ToString;
end;

end.
