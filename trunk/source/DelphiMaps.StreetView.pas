{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.StreetView.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}
unit DelphiMaps.StreetView;

interface

uses
  DelphiMaps.Browser;

const
  StreetViewFileName = 'StreetView.html';

type
  TStreetView=class(TBrowserControl)
    procedure Init;
  published
    class function GetHTMLResourceName: String;

  end;

implementation

uses
  IoUtils,
  SysUtils;

{ TStreetMap }

class function TStreetView.GetHTMLResourceName: String;
begin
  Result := 'STREETVIEW_HTML';
end;

procedure TStreetView.Init;
var
  LHtmlFileName : String;
begin
  Browser.OnDocumentComplete := WebBrowserDocumentComplete;
  LHtmlFileName := TPath.GetTempPath+StreetViewFileName;
  SaveHtml(LHtmlFileName);
  if FileExists(LHtmlFileName) then
    Navigate('file://' + LHtmlFileName);
end;

end.
