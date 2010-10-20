unit DelphiMaps.GeoCoder;

interface

uses
  Classes,
  SysUtils,
  Generics.Collections,
  DelphiMaps.GeoCoderXML,
  DelphiMaps.GoogleMaps;

type
  EGeoCoding = Exception;

  TAddressRec=record
    StreetName:String;
    HouseNumer:String;
    City:String;
    ZipCode:string;
    Province:String;
    Country:String;
    Lat:Double;
    Lon:Double;
    FormattedName:string;
    procedure ReverseGeoCode;
    procedure GeoCode(aFormattedName:String='');
  private
    procedure LoadFromXML(XMLGeocodeResponseType: IXMLGeocodeResponseType);
    procedure LoadFromXMLFile(aFileName: string);
  public
    procedure init;
  end;

  TGeocoderStatus=
  (
    ERROR           ,	// There was a problem contacting the Google servers.
    INVALID_REQUEST ,	// This GeocoderRequest was invalid.
    OK	            , // The response contains a valid GeocoderResponse.
    OVER_QUERY_LIMIT,	// The webpage has gone over the requests limit in too short a period of time.
    REQUEST_DENIED	, // The webpage is not allowed to use the geocoder.
    UNKNOWN_ERROR	  , // A geocoding request could not be processed due to a server error. The request may succeed if you try again.
    ZERO_RESULTS	    // No result was found for this GeocoderRequest.
  );

  TGeocoderRequest=record
    Address  : string	      ; // Address. Optional.
    Bounds	 : TGLatLngBounds; // LatLngBounds within which to search. Optional.
    Language : string        ; // Preferred language for results. Optional.
    Location : TGLatLng      ; // LatLng about which to search. Optional.
    Region	 : string	      ; // Country code top-level domain within which to search. Optional.
  end;

  TGeocoderAddressComponent = record
    long_name	 : string	     ; // The full text of the address component
    short_name : string	     ; // The abbreviated, short text of the given address component
    types	     : TStringList ; //	An array of strings denoting the type of this address component
  end;

  TGeocoderGeometry = record

  end;

  TGeocoderResult=record
    address_components : Array of TGeocoderAddressComponent; //	An array of GeocoderAddressComponents
    geometry           : TGeocoderGeometry; // A GeocoderGeometry object
    types              : TStringList;
  end;

  TGeoCoderCallBack = reference to procedure(Results:Array of TGeoCoderResult;Status:TGeocoderStatus);

  TGeoCoder=class
    class procedure GeoCode(const Request:TGeocoderRequest;const CallBack:TGeoCoderCallBack);
  end;

  function AddressToLatLon(const aAddress:string):TGLatLng;

implementation

uses
  IoUtils, StrUtils, ExtActns;

resourcestring
  GeoCodingBaseURL='http://maps.google.com/maps/geo?q=';

function AddressToLatLon(const aAddress:string):TGLatLng;
var
  LocalURL,
  LocalURLAddress:String;
  SL:TStringList;
  Accuracy:Integer;
  Download:TDownLoadURL;
const
  GeoCodingBaseURL='http://maps.google.com/maps/geo?q=';
  // GeoCodingBaseURL='http://maps.google.com/maps/api/geocode/json?address=';
begin
  Result := nil;
  LocalURLAddress := Trim(aAddress);
  LocalURLAddress := ReplaceStr(LocalURLAddress,' ','+');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#13,',');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#10,'');
  LocalURL := GeoCodingBaseURL + LocalURLAddress + '&output=csv&sensor=false';
  Download := TDownLoadURL.Create(nil);
  try
    Download.URL := LocalURL;
    Download.Filename := TPath.GetTempPath + 'GeoCodingResult.xml';
    Download.ExecuteTarget(nil);

    Assert(FileExists(Download.Filename));
    SL       := TStringList.Create;
    try
      SL.Delimiter       := ',';
      SL.StrictDelimiter := True;
      SL.DelimitedText   := TFile.ReadAllText(Download.Filename);

      if(SL[0]<>'200') then
        raise EGeoCoding.Create('Geocoding: server reported error #'+SL[0]);

      if SL.Count<4 then
        raise EGeoCoding.Create('Geocoding: unexpected number of fields in result');

      Accuracy := StrToInt(SL[1]);
      Result := TGLatLng.Create(StrToFloat(SL[2]),StrToFloat(SL[3]));
    finally
      FreeAndNil(SL);
    end;
  finally
    FreeAndNil(Download);
  end;

end;


{ TGeoCoder }

class procedure TGeoCoder.GeoCode(const Request: TGeocoderRequest;
  const CallBack: TGeoCoderCallBack);
var
  GeocoderResult:TGeocoderresult;
  AddressRec:TAddressrec;
begin
  AddressRec.FormattedName := Request.Address;
  AddressRec.GeoCode;

  SetLength(GeocoderResult.address_components,1);
  GeocoderResult.address_components[0].long_name := AddressRec.FormattedName;
  GeocoderResult.address_components[0].short_name := AddressRec.FormattedName;


  CallBack([GeocoderResult],OK);
end;

{ TAddressRec }

procedure TAddressRec.GeoCode(aFormattedName:String='');
var
  LocalURL,
  LocalURLAddress:String;
  LFileName:String;
  LDownload:TDownLoadURL;
const
  GeoCodingBaseURL='http://maps.google.com/maps/api/geocode/xml?address=%s&sensor=false';
begin
  if aFormattedName<>'' then
    FormattedName := aFormattedName;

  LocalURLAddress := Trim(FormattedName);
  LocalURLAddress := ReplaceStr(LocalURLAddress,' ','+');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#13,',');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#10,'');
  LocalURL := Format(   GeoCodingBaseURL, [LocalURLAddress]);

//  ForceDirectories(ExpandFileName('GeoCoding'));
//  LFileName:='Geocoding\'+ReplaceStr(ReplaceStr(LocalURLAddress,'+','_'),',','_')+'.xml';
  LFileName := TPath.GetTempFileName;
  TFile.Delete(LFileName);
  LDownload := TDownLoadURL.Create(nil);
  try
    LDownload.URL := LocalURL;
    ForceDirectories( ExtractFilePath(LFileName) );
    LDownload.Filename := LFileName;
    LDownload.ExecuteTarget(nil);
  finally
    FreeAndNil(LDownload);
  end;
  LoadFromXMLFile(LFileName);

end;

procedure TAddressRec.init;
begin
  Initialize(Self);
end;

procedure TAddressRec.LoadFromXML(XMLGeocodeResponseType: IXMLGeocodeResponseType);
begin
  if XMLGeocodeResponseType.Result.Count=0 then
    Exit;


  FormattedName := XMLGeocodeResponseType.Result[0].Formatted_address;
  Lat           := XMLGeocodeResponseType.Result[0].Geometry.Location.Lat / 10000000;
  Lon           := XMLGeocodeResponseType.Result[0].Geometry.Location.Lng / 10000000;

//  if XMLGeocodeResponseType.Result[0].Address_component.Count>0 then
//  HouseNumer    := XMLGeocodeResponseType.Result[0].Address_component[0].Long_name;
//  if XMLGeocodeResponseType.Result[0].Address_component.Count>1 then
//  StreetName    := XMLGeocodeResponseType.Result[0].Address_component[1].Long_name;
//  if XMLGeocodeResponseType.Result[0].Address_component.Count>2 then
//  City          := XMLGeocodeResponseType.Result[0].Address_component[3].Long_name;
//  if XMLGeocodeResponseType.Result[0].Address_component.Count>3 then
//  Province      := XMLGeocodeResponseType.Result[0].Address_component[4].Long_name;
//  if XMLGeocodeResponseType.Result[0].Address_component.Count>4 then
//  Country       := XMLGeocodeResponseType.Result[0].Address_component[5].Long_name;
//  if XMLGeocodeResponseType.Result[0].Address_component.Count>5 then
//  ZipCode       := XMLGeocodeResponseType.Result[0].Address_component[6].Long_name;
end;

procedure TAddressRec.LoadFromXMLFile(aFileName: string);
var
  XMLGeocodeResponseType: IXMLGeocodeResponseType;
begin
  XMLGeocodeResponseType := LoadGeocodeResponse(aFileName);
  LoadFromXML(XMLGeocodeResponseType);
  TFile.Delete(aFileName);
end;



procedure TAddressRec.ReverseGeoCode;
var
  LocalURL,
  LocalURLAddress:String;
  LFileName:String;
  LDownload:TDownLoadURL;
const
  GeoCodingBaseURL='http://maps.google.com/maps/api/geocode/xml?latlng=%.8f,%.8f&sensor=false';
begin
  LocalURLAddress := Trim(FormattedName);
  LocalURLAddress := ReplaceStr(LocalURLAddress,' ','+');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#13,',');
  LocalURLAddress := ReplaceStr(LocalURLAddress,#10,'');
  {$IFDEF VER220}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  LocalURL := Format(   GeoCodingBaseURL, [Lat,Lon]);

  ForceDirectories('GeoCoding');
  LFileName:='Geocoding\'+ReplaceStr(ReplaceStr(LocalURLAddress,'+','_'),',','_')+'.xml';
  if not FileExists(LFileName) then
  begin
    LDownload := TDownLoadURL.Create(nil);
    try
      LDownload.URL := LFileName;
      LDownload.Filename := LocalURL;
      LDownload.ExecuteTarget(nil);
    finally
      FreeAndNil(LDownload);
    end;
  end;
  LoadFromXMLFile(LFileName);

end;

end.
