{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.GoogleMaps.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit DelphiMaps.Register;

interface

uses Classes;

procedure Register;

implementation

uses
  DelphiMaps.Googlemaps,
  DelphiMaps.StreetView,
  DelphiMaps.LayerList,
  DelphiMaps.StaticMap,
  DelphiMaps.WebImage;

procedure Register;
begin
  RegisterComponents('DelphiMaps', [
    TGoogleMaps,
    TStreetView,
    TGoogleMapsLayersList,
    TStaticMap,
    TWebImage
    ]);
end;


end.
