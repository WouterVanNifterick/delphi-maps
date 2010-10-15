{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DelphiMaps.GoogleDirectionsXML.pas                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Wouter van Nifterick                               }
{                                              (wouter_van_nifterick@hotmail.com.                  }
{**************************************************************************************************}

unit DelphiMaps.GoogleDirectionsXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDirectionsResponseType = interface;
  IXMLRouteType = interface;
  IXMLLegType = interface;
  IXMLStepType = interface;
  IXMLStepTypeList = interface;
  IXMLStart_locationType = interface;
  IXMLEnd_locationType = interface;
  IXMLPolylineType = interface;
  IXMLDurationType = interface;
  IXMLDistanceType = interface;
  IXMLOverview_polylineType = interface;

{ IXMLDirectionsResponseType }

  IXMLDirectionsResponseType = interface(IXMLNode)
    ['{10B0DBA5-DC6C-4123-BF34-3B50392EAE3B}']
    { Property Accessors }
    function Get_Status: UnicodeString;
    function Get_Route: IXMLRouteType;
    procedure Set_Status(Value: UnicodeString);
    { Methods & Properties }
    property Status: UnicodeString read Get_Status write Set_Status;
    property Route: IXMLRouteType read Get_Route;
  end;

{ IXMLRouteType }

  IXMLRouteType = interface(IXMLNode)
    ['{05EC829A-25E4-4469-AA5B-DC46232E3936}']
    { Property Accessors }
    function Get_Summary: UnicodeString;
    function Get_Leg: IXMLLegType;
    function Get_Copyrights: UnicodeString;
    function Get_Overview_polyline: IXMLOverview_polylineType;
    procedure Set_Summary(Value: UnicodeString);
    procedure Set_Copyrights(Value: UnicodeString);
    { Methods & Properties }
    property Summary: UnicodeString read Get_Summary write Set_Summary;
    property Leg: IXMLLegType read Get_Leg;
    property Copyrights: UnicodeString read Get_Copyrights write Set_Copyrights;
    property Overview_polyline: IXMLOverview_polylineType read Get_Overview_polyline;
  end;

{ IXMLLegType }

  IXMLLegType = interface(IXMLNode)
    ['{59316BDE-30FE-4727-B4F3-A2D9326FC5C6}']
    { Property Accessors }
    function Get_Step: IXMLStepTypeList;
    function Get_Duration: IXMLDurationType;
    function Get_Distance: IXMLDistanceType;
    function Get_Start_location: IXMLStart_locationType;
    function Get_End_location: IXMLEnd_locationType;
    function Get_Start_address: UnicodeString;
    function Get_End_address: UnicodeString;
    procedure Set_Start_address(Value: UnicodeString);
    procedure Set_End_address(Value: UnicodeString);
    { Methods & Properties }
    property Step: IXMLStepTypeList read Get_Step;
    property Duration: IXMLDurationType read Get_Duration;
    property Distance: IXMLDistanceType read Get_Distance;
    property Start_location: IXMLStart_locationType read Get_Start_location;
    property End_location: IXMLEnd_locationType read Get_End_location;
    property Start_address: UnicodeString read Get_Start_address write Set_Start_address;
    property End_address: UnicodeString read Get_End_address write Set_End_address;
  end;

{ IXMLStepType }

  IXMLStepType = interface(IXMLNode)
    ['{F526E66B-71CE-4577-9C16-E8E7A55E5979}']
    { Property Accessors }
    function Get_Travel_mode: UnicodeString;
    function Get_Start_location: IXMLStart_locationType;
    function Get_End_location: IXMLEnd_locationType;
    function Get_Polyline: IXMLPolylineType;
    function Get_Duration: IXMLDurationType;
    function Get_Html_instructions: UnicodeString;
    function Get_Distance: IXMLDistanceType;
    procedure Set_Travel_mode(Value: UnicodeString);
    procedure Set_Html_instructions(Value: UnicodeString);
    { Methods & Properties }
    property Travel_mode: UnicodeString read Get_Travel_mode write Set_Travel_mode;
    property Start_location: IXMLStart_locationType read Get_Start_location;
    property End_location: IXMLEnd_locationType read Get_End_location;
    property Polyline: IXMLPolylineType read Get_Polyline;
    property Duration: IXMLDurationType read Get_Duration;
    property Html_instructions: UnicodeString read Get_Html_instructions write Set_Html_instructions;
    property Distance: IXMLDistanceType read Get_Distance;
  end;

{ IXMLStepTypeList }

  IXMLStepTypeList = interface(IXMLNodeCollection)
    ['{37A6CCE7-405B-42BF-83F2-B0B42CE55EEB}']
    { Methods & Properties }
    function Add: IXMLStepType;
    function Insert(const Index: Integer): IXMLStepType;

    function Get_Item(Index: Integer): IXMLStepType;
    property Items[Index: Integer]: IXMLStepType read Get_Item; default;
  end;

{ IXMLStart_locationType }

  IXMLStart_locationType = interface(IXMLNode)
    ['{71CDF84A-9C74-4A6E-BE67-B60A7E956FCC}']
    { Property Accessors }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
    { Methods & Properties }
    property Lat: UnicodeString read Get_Lat write Set_Lat;
    property Lng: UnicodeString read Get_Lng write Set_Lng;
  end;

{ IXMLEnd_locationType }

  IXMLEnd_locationType = interface(IXMLNode)
    ['{C03A738F-6D9F-4C40-9815-5C73D5835D3D}']
    { Property Accessors }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
    { Methods & Properties }
    property Lat: UnicodeString read Get_Lat write Set_Lat;
    property Lng: UnicodeString read Get_Lng write Set_Lng;
  end;

{ IXMLPolylineType }

  IXMLPolylineType = interface(IXMLNode)
    ['{0913AA01-9971-44B2-B59C-9BC26B70F5EA}']
    { Property Accessors }
    function Get_Points: UnicodeString;
    function Get_Levels: UnicodeString;
    procedure Set_Points(Value: UnicodeString);
    procedure Set_Levels(Value: UnicodeString);
    { Methods & Properties }
    property Points: UnicodeString read Get_Points write Set_Points;
    property Levels: UnicodeString read Get_Levels write Set_Levels;
  end;

{ IXMLDurationType }

  IXMLDurationType = interface(IXMLNode)
    ['{072BEE2D-5ECC-44C1-B63A-F0E3010D0949}']
    { Property Accessors }
    function Get_Value: Integer;
    function Get_Text: UnicodeString;
    procedure Set_Value(Value: Integer);
    procedure Set_Text(Value: UnicodeString);
    { Methods & Properties }
    property Value: Integer read Get_Value write Set_Value;
    property Text: UnicodeString read Get_Text write Set_Text;
  end;

{ IXMLDistanceType }

  IXMLDistanceType = interface(IXMLNode)
    ['{EB182994-D3A5-43E4-A9AB-285A0E6E224E}']
    { Property Accessors }
    function Get_Value: Integer;
    function Get_Text: UnicodeString;
    procedure Set_Value(Value: Integer);
    procedure Set_Text(Value: UnicodeString);
    { Methods & Properties }
    property Value: Integer read Get_Value write Set_Value;
    property Text: UnicodeString read Get_Text write Set_Text;
  end;

{ IXMLOverview_polylineType }

  IXMLOverview_polylineType = interface(IXMLNode)
    ['{DD070AF2-C3EA-49F3-8862-5046357E4FE5}']
    { Property Accessors }
    function Get_Points: UnicodeString;
    function Get_Levels: UnicodeString;
    procedure Set_Points(Value: UnicodeString);
    procedure Set_Levels(Value: UnicodeString);
    { Methods & Properties }
    property Points: UnicodeString read Get_Points write Set_Points;
    property Levels: UnicodeString read Get_Levels write Set_Levels;
  end;

{ Forward Decls }

  TXMLDirectionsResponseType = class;
  TXMLRouteType = class;
  TXMLLegType = class;
  TXMLStepType = class;
  TXMLStepTypeList = class;
  TXMLStart_locationType = class;
  TXMLEnd_locationType = class;
  TXMLPolylineType = class;
  TXMLDurationType = class;
  TXMLDistanceType = class;
  TXMLOverview_polylineType = class;

{ TXMLDirectionsResponseType }

  TXMLDirectionsResponseType = class(TXMLNode, IXMLDirectionsResponseType)
  protected
    { IXMLDirectionsResponseType }
    function Get_Status: UnicodeString;
    function Get_Route: IXMLRouteType;
    procedure Set_Status(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRouteType }

  TXMLRouteType = class(TXMLNode, IXMLRouteType)
  protected
    { IXMLRouteType }
    function Get_Summary: UnicodeString;
    function Get_Leg: IXMLLegType;
    function Get_Copyrights: UnicodeString;
    function Get_Overview_polyline: IXMLOverview_polylineType;
    procedure Set_Summary(Value: UnicodeString);
    procedure Set_Copyrights(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLegType }

  TXMLLegType = class(TXMLNode, IXMLLegType)
  private
    FStep: IXMLStepTypeList;
  protected
    { IXMLLegType }
    function Get_Step: IXMLStepTypeList;
    function Get_Duration: IXMLDurationType;
    function Get_Distance: IXMLDistanceType;
    function Get_Start_location: IXMLStart_locationType;
    function Get_End_location: IXMLEnd_locationType;
    function Get_Start_address: UnicodeString;
    function Get_End_address: UnicodeString;
    procedure Set_Start_address(Value: UnicodeString);
    procedure Set_End_address(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLStepType }

  TXMLStepType = class(TXMLNode, IXMLStepType)
  protected
    { IXMLStepType }
    function Get_Travel_mode: UnicodeString;
    function Get_Start_location: IXMLStart_locationType;
    function Get_End_location: IXMLEnd_locationType;
    function Get_Polyline: IXMLPolylineType;
    function Get_Duration: IXMLDurationType;
    function Get_Html_instructions: UnicodeString;
    function Get_Distance: IXMLDistanceType;
    procedure Set_Travel_mode(Value: UnicodeString);
    procedure Set_Html_instructions(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLStepTypeList }

  TXMLStepTypeList = class(TXMLNodeCollection, IXMLStepTypeList)
  protected
    { IXMLStepTypeList }
    function Add: IXMLStepType;
    function Insert(const Index: Integer): IXMLStepType;

    function Get_Item(Index: Integer): IXMLStepType;
  end;

{ TXMLStart_locationType }

  TXMLStart_locationType = class(TXMLNode, IXMLStart_locationType)
  protected
    { IXMLStart_locationType }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
  end;

{ TXMLEnd_locationType }

  TXMLEnd_locationType = class(TXMLNode, IXMLEnd_locationType)
  protected
    { IXMLEnd_locationType }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
  end;

{ TXMLPolylineType }

  TXMLPolylineType = class(TXMLNode, IXMLPolylineType)
  protected
    { IXMLPolylineType }
    function Get_Points: UnicodeString;
    function Get_Levels: UnicodeString;
    procedure Set_Points(Value: UnicodeString);
    procedure Set_Levels(Value: UnicodeString);
  end;

{ TXMLDurationType }

  TXMLDurationType = class(TXMLNode, IXMLDurationType)
  protected
    { IXMLDurationType }
    function Get_Value: Integer;
    function Get_Text: UnicodeString;
    procedure Set_Value(Value: Integer);
    procedure Set_Text(Value: UnicodeString);
  end;

{ TXMLDistanceType }

  TXMLDistanceType = class(TXMLNode, IXMLDistanceType)
  protected
    { IXMLDistanceType }
    function Get_Value: Integer;
    function Get_Text: UnicodeString;
    procedure Set_Value(Value: Integer);
    procedure Set_Text(Value: UnicodeString);
  end;

{ TXMLOverview_polylineType }

  TXMLOverview_polylineType = class(TXMLNode, IXMLOverview_polylineType)
  protected
    { IXMLOverview_polylineType }
    function Get_Points: UnicodeString;
    function Get_Levels: UnicodeString;
    procedure Set_Points(Value: UnicodeString);
    procedure Set_Levels(Value: UnicodeString);
  end;

{ Global Functions }

function GetDirectionsResponse(Doc: IXMLDocument): IXMLDirectionsResponseType;
function LoadDirectionsResponse(const FileName: string): IXMLDirectionsResponseType;
function NewDirectionsResponse: IXMLDirectionsResponseType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDirectionsResponse(Doc: IXMLDocument): IXMLDirectionsResponseType;
begin
  Result := Doc.GetDocBinding('DirectionsResponse', TXMLDirectionsResponseType, TargetNamespace) as IXMLDirectionsResponseType;
end;

function LoadDirectionsResponse(const FileName: string): IXMLDirectionsResponseType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DirectionsResponse', TXMLDirectionsResponseType, TargetNamespace) as IXMLDirectionsResponseType;
end;

function NewDirectionsResponse: IXMLDirectionsResponseType;
begin
  Result := NewXMLDocument.GetDocBinding('DirectionsResponse', TXMLDirectionsResponseType, TargetNamespace) as IXMLDirectionsResponseType;
end;

{ TXMLDirectionsResponseType }

procedure TXMLDirectionsResponseType.AfterConstruction;
begin
  RegisterChildNode('route', TXMLRouteType);
  inherited;
end;

function TXMLDirectionsResponseType.Get_Status: UnicodeString;
begin
  Result := ChildNodes['status'].Text;
end;

procedure TXMLDirectionsResponseType.Set_Status(Value: UnicodeString);
begin
  ChildNodes['status'].NodeValue := Value;
end;

function TXMLDirectionsResponseType.Get_Route: IXMLRouteType;
begin
  Result := ChildNodes['route'] as IXMLRouteType;
end;

{ TXMLRouteType }

procedure TXMLRouteType.AfterConstruction;
begin
  RegisterChildNode('leg', TXMLLegType);
  RegisterChildNode('overview_polyline', TXMLOverview_polylineType);
  inherited;
end;

function TXMLRouteType.Get_Summary: UnicodeString;
begin
  Result := ChildNodes['summary'].Text;
end;

procedure TXMLRouteType.Set_Summary(Value: UnicodeString);
begin
  ChildNodes['summary'].NodeValue := Value;
end;

function TXMLRouteType.Get_Leg: IXMLLegType;
begin
  Result := ChildNodes['leg'] as IXMLLegType;
end;

function TXMLRouteType.Get_Copyrights: UnicodeString;
begin
  Result := ChildNodes['copyrights'].Text;
end;

procedure TXMLRouteType.Set_Copyrights(Value: UnicodeString);
begin
  ChildNodes['copyrights'].NodeValue := Value;
end;

function TXMLRouteType.Get_Overview_polyline: IXMLOverview_polylineType;
begin
  Result := ChildNodes['overview_polyline'] as IXMLOverview_polylineType;
end;

{ TXMLLegType }

procedure TXMLLegType.AfterConstruction;
begin
  RegisterChildNode('step', TXMLStepType);
  RegisterChildNode('duration', TXMLDurationType);
  RegisterChildNode('distance', TXMLDistanceType);
  RegisterChildNode('start_location', TXMLStart_locationType);
  RegisterChildNode('end_location', TXMLEnd_locationType);
  FStep := CreateCollection(TXMLStepTypeList, IXMLStepType, 'step') as IXMLStepTypeList;
  inherited;
end;

function TXMLLegType.Get_Step: IXMLStepTypeList;
begin
  Result := FStep;
end;

function TXMLLegType.Get_Duration: IXMLDurationType;
begin
  Result := ChildNodes['duration'] as IXMLDurationType;
end;

function TXMLLegType.Get_Distance: IXMLDistanceType;
begin
  Result := ChildNodes['distance'] as IXMLDistanceType;
end;

function TXMLLegType.Get_Start_location: IXMLStart_locationType;
begin
  Result := ChildNodes['start_location'] as IXMLStart_locationType;
end;

function TXMLLegType.Get_End_location: IXMLEnd_locationType;
begin
  Result := ChildNodes['end_location'] as IXMLEnd_locationType;
end;

function TXMLLegType.Get_Start_address: UnicodeString;
begin
  Result := ChildNodes['start_address'].Text;
end;

procedure TXMLLegType.Set_Start_address(Value: UnicodeString);
begin
  ChildNodes['start_address'].NodeValue := Value;
end;

function TXMLLegType.Get_End_address: UnicodeString;
begin
  Result := ChildNodes['end_address'].Text;
end;

procedure TXMLLegType.Set_End_address(Value: UnicodeString);
begin
  ChildNodes['end_address'].NodeValue := Value;
end;

{ TXMLStepType }

procedure TXMLStepType.AfterConstruction;
begin
  RegisterChildNode('start_location', TXMLStart_locationType);
  RegisterChildNode('end_location', TXMLEnd_locationType);
  RegisterChildNode('polyline', TXMLPolylineType);
  RegisterChildNode('duration', TXMLDurationType);
  RegisterChildNode('distance', TXMLDistanceType);
  inherited;
end;

function TXMLStepType.Get_Travel_mode: UnicodeString;
begin
  Result := ChildNodes['travel_mode'].Text;
end;

procedure TXMLStepType.Set_Travel_mode(Value: UnicodeString);
begin
  ChildNodes['travel_mode'].NodeValue := Value;
end;

function TXMLStepType.Get_Start_location: IXMLStart_locationType;
begin
  Result := ChildNodes['start_location'] as IXMLStart_locationType;
end;

function TXMLStepType.Get_End_location: IXMLEnd_locationType;
begin
  Result := ChildNodes['end_location'] as IXMLEnd_locationType;
end;

function TXMLStepType.Get_Polyline: IXMLPolylineType;
begin
  Result := ChildNodes['polyline'] as IXMLPolylineType;
end;

function TXMLStepType.Get_Duration: IXMLDurationType;
begin
  Result := ChildNodes['duration'] as IXMLDurationType;
end;

function TXMLStepType.Get_Html_instructions: UnicodeString;
begin
  Result := ChildNodes['html_instructions'].Text;
end;

procedure TXMLStepType.Set_Html_instructions(Value: UnicodeString);
begin
  ChildNodes['html_instructions'].NodeValue := Value;
end;

function TXMLStepType.Get_Distance: IXMLDistanceType;
begin
  Result := ChildNodes['distance'] as IXMLDistanceType;
end;

{ TXMLStepTypeList }

function TXMLStepTypeList.Add: IXMLStepType;
begin
  Result := AddItem(-1) as IXMLStepType;
end;

function TXMLStepTypeList.Insert(const Index: Integer): IXMLStepType;
begin
  Result := AddItem(Index) as IXMLStepType;
end;

function TXMLStepTypeList.Get_Item(Index: Integer): IXMLStepType;
begin
  Result := List[Index] as IXMLStepType;
end;

{ TXMLStart_locationType }

function TXMLStart_locationType.Get_Lat: UnicodeString;
begin
  Result := ChildNodes['lat'].Text;
end;

procedure TXMLStart_locationType.Set_Lat(Value: UnicodeString);
begin
  ChildNodes['lat'].NodeValue := Value;
end;

function TXMLStart_locationType.Get_Lng: UnicodeString;
begin
  Result := ChildNodes['lng'].Text;
end;

procedure TXMLStart_locationType.Set_Lng(Value: UnicodeString);
begin
  ChildNodes['lng'].NodeValue := Value;
end;

{ TXMLEnd_locationType }

function TXMLEnd_locationType.Get_Lat: UnicodeString;
begin
  Result := ChildNodes['lat'].Text;
end;

procedure TXMLEnd_locationType.Set_Lat(Value: UnicodeString);
begin
  ChildNodes['lat'].NodeValue := Value;
end;

function TXMLEnd_locationType.Get_Lng: UnicodeString;
begin
  Result := ChildNodes['lng'].Text;
end;

procedure TXMLEnd_locationType.Set_Lng(Value: UnicodeString);
begin
  ChildNodes['lng'].NodeValue := Value;
end;

{ TXMLPolylineType }

function TXMLPolylineType.Get_Points: UnicodeString;
begin
  Result := ChildNodes['points'].Text;
end;

procedure TXMLPolylineType.Set_Points(Value: UnicodeString);
begin
  ChildNodes['points'].NodeValue := Value;
end;

function TXMLPolylineType.Get_Levels: UnicodeString;
begin
  Result := ChildNodes['levels'].Text;
end;

procedure TXMLPolylineType.Set_Levels(Value: UnicodeString);
begin
  ChildNodes['levels'].NodeValue := Value;
end;

{ TXMLDurationType }

function TXMLDurationType.Get_Value: Integer;
begin
  Result := ChildNodes['value'].NodeValue;
end;

procedure TXMLDurationType.Set_Value(Value: Integer);
begin
  ChildNodes['value'].NodeValue := Value;
end;

function TXMLDurationType.Get_Text: UnicodeString;
begin
  Result := ChildNodes['text'].Text;
end;

procedure TXMLDurationType.Set_Text(Value: UnicodeString);
begin
  ChildNodes['text'].NodeValue := Value;
end;

{ TXMLDistanceType }

function TXMLDistanceType.Get_Value: Integer;
begin
  Result := ChildNodes['value'].NodeValue;
end;

procedure TXMLDistanceType.Set_Value(Value: Integer);
begin
  ChildNodes['value'].NodeValue := Value;
end;

function TXMLDistanceType.Get_Text: UnicodeString;
begin
  Result := ChildNodes['text'].Text;
end;

procedure TXMLDistanceType.Set_Text(Value: UnicodeString);
begin
  ChildNodes['text'].NodeValue := Value;
end;

{ TXMLOverview_polylineType }

function TXMLOverview_polylineType.Get_Points: UnicodeString;
begin
  Result := ChildNodes['points'].Text;
end;

procedure TXMLOverview_polylineType.Set_Points(Value: UnicodeString);
begin
  ChildNodes['points'].NodeValue := Value;
end;

function TXMLOverview_polylineType.Get_Levels: UnicodeString;
begin
  Result := ChildNodes['levels'].Text;
end;

procedure TXMLOverview_polylineType.Set_Levels(Value: UnicodeString);
begin
  ChildNodes['levels'].NodeValue := Value;
end;

end.
