program DemoGeoCoderSimple;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DelphiMaps.GeoCoder;

procedure Main;
var
  LAddressStr: String;
  Address    : TAddressRec;

begin
  WriteLn('DelphiMaps GeoCoder Demo');
  WriteLn('========================');
  WriteLn;
  Write('Address: ':15);
  ReadLn(LAddressStr);
  Address.FormattedName := LAddressStr;
  Address.GeoCode;
  WriteLn;
  WriteLn('FormattedName: ':15  , Address.FormattedName);
  WriteLn('Country: '      :15  , Address.Country);
  WriteLn('City: '         :15  , Address.City);
  WriteLn('ZipCode: '      :15  , Address.ZipCode);
  WriteLn('StreetName: '   :15  , Address.StreetName);
  WriteLn('HouseNumer: '   :15  , Address.HouseNumer);
  WriteLn('Lat: '          :15,   Address.Lat:7:5);
  WriteLn('Lon: '          :15,   Address.Lon:7:5);
  WriteLn;
  WriteLn(Address.XML);
  WriteLn('Press any key to quit . . .');

  ReadLn;

end;

begin
  try
    Main
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
