unit DelphiMaps.GeoCoderXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLGeocodeResponseType = interface;
  IXMLResultType = interface;
  IXMLResultTypeList = interface;
  IXMLAddress_componentType = interface;
  IXMLAddress_componentTypeList = interface;
  IXMLGeometryType = interface;
  IXMLLocationType = interface;
  IXMLViewportType = interface;
  IXMLSouthwestType = interface;
  IXMLNortheastType = interface;
  IXMLBoundsType = interface;
  IXMLString_List = interface;

{ IXMLGeocodeResponseType }

  IXMLGeocodeResponseType = interface(IXMLNode)
    ['{FD5E89B4-3ACC-48F9-AB4E-A9861A172223}']
    { Property Accessors }
    function Get_Status: UnicodeString;
    function Get_Result: IXMLResultTypeList;
    procedure Set_Status(Value: UnicodeString);
    { Methods & Properties }
    property Status: UnicodeString read Get_Status write Set_Status;
    property Result: IXMLResultTypeList read Get_Result;
  end;

{ IXMLResultType }

  IXMLResultType = interface(IXMLNode)
    ['{CDDA1F90-DAD9-45A5-B714-E76DD9855600}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Formatted_address: UnicodeString;
    function Get_Address_component: IXMLAddress_componentTypeList;
    function Get_Geometry: IXMLGeometryType;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Formatted_address(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Formatted_address: UnicodeString read Get_Formatted_address write Set_Formatted_address;
    property Address_component: IXMLAddress_componentTypeList read Get_Address_component;
    property Geometry: IXMLGeometryType read Get_Geometry;
  end;

{ IXMLResultTypeList }

  IXMLResultTypeList = interface(IXMLNodeCollection)
    ['{41364655-093F-4A08-AA76-1EFA72304A98}']
    { Methods & Properties }
    function Add: IXMLResultType;
    function Insert(const Index: Integer): IXMLResultType;

    function Get_Item(Index: Integer): IXMLResultType;
    property Items[Index: Integer]: IXMLResultType read Get_Item; default;
  end;

{ IXMLAddress_componentType }

  IXMLAddress_componentType = interface(IXMLNode)
    ['{7EAB5BA8-1D30-40DE-81D6-2DB6DA036B03}']
    { Property Accessors }
    function Get_Long_name: UnicodeString;
    function Get_Short_name: UnicodeString;
    function Get_Type_: IXMLString_List;
    procedure Set_Long_name(Value: UnicodeString);
    procedure Set_Short_name(Value: UnicodeString);
    { Methods & Properties }
    property Long_name: UnicodeString read Get_Long_name write Set_Long_name;
    property Short_name: UnicodeString read Get_Short_name write Set_Short_name;
    property Type_: IXMLString_List read Get_Type_;
  end;

{ IXMLAddress_componentTypeList }

  IXMLAddress_componentTypeList = interface(IXMLNodeCollection)
    ['{39894DDA-6FA4-4337-9F7B-7564918A03FD}']
    { Methods & Properties }
    function Add: IXMLAddress_componentType;
    function Insert(const Index: Integer): IXMLAddress_componentType;

    function Get_Item(Index: Integer): IXMLAddress_componentType;
    property Items[Index: Integer]: IXMLAddress_componentType read Get_Item; default;
  end;

{ IXMLGeometryType }

  IXMLGeometryType = interface(IXMLNode)
    ['{A25E197B-745F-476D-B287-8EB308C18B04}']
    { Property Accessors }
    function Get_Location: IXMLLocationType;
    function Get_Location_type: UnicodeString;
    function Get_Viewport: IXMLViewportType;
    function Get_Bounds: IXMLBoundsType;
    procedure Set_Location_type(Value: UnicodeString);
    { Methods & Properties }
    property Location: IXMLLocationType read Get_Location;
    property Location_type: UnicodeString read Get_Location_type write Set_Location_type;
    property Viewport: IXMLViewportType read Get_Viewport;
    property Bounds: IXMLBoundsType read Get_Bounds;
  end;

{ IXMLLocationType }

  IXMLLocationType = interface(IXMLNode)
    ['{BB8789E6-93F7-4810-844E-41D06DDE386F}']
    { Property Accessors }
    function Get_Lat: Double;
    function Get_Lng: Double;
    procedure Set_Lat(Value: Double);
    procedure Set_Lng(Value: Double);
    { Methods & Properties }
    property Lat: Double read Get_Lat write Set_Lat;
    property Lng: Double read Get_Lng write Set_Lng;
  end;

{ IXMLViewportType }

  IXMLViewportType = interface(IXMLNode)
    ['{C9281249-1655-4A6D-B8E6-DCB622925E55}']
    { Property Accessors }
    function Get_Southwest: IXMLSouthwestType;
    function Get_Northeast: IXMLNortheastType;
    { Methods & Properties }
    property Southwest: IXMLSouthwestType read Get_Southwest;
    property Northeast: IXMLNortheastType read Get_Northeast;
  end;

{ IXMLSouthwestType }

  IXMLSouthwestType = interface(IXMLNode)
    ['{22FC6626-129E-497B-AF8D-D9A3DD8F78BD}']
    { Property Accessors }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
    { Methods & Properties }
    property Lat: UnicodeString read Get_Lat write Set_Lat;
    property Lng: UnicodeString read Get_Lng write Set_Lng;
  end;

{ IXMLNortheastType }

  IXMLNortheastType = interface(IXMLNode)
    ['{A80A96A8-BC8E-4263-A8BB-3882267BE2B3}']
    { Property Accessors }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
    { Methods & Properties }
    property Lat: UnicodeString read Get_Lat write Set_Lat;
    property Lng: UnicodeString read Get_Lng write Set_Lng;
  end;

{ IXMLBoundsType }

  IXMLBoundsType = interface(IXMLNode)
    ['{07484601-F81C-4BF6-B91B-BBFE130C7FB5}']
    { Property Accessors }
    function Get_Southwest: IXMLSouthwestType;
    function Get_Northeast: IXMLNortheastType;
    { Methods & Properties }
    property Southwest: IXMLSouthwestType read Get_Southwest;
    property Northeast: IXMLNortheastType read Get_Northeast;
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{C9664892-AA7D-4038-AF5C-AF332300EB67}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLGeocodeResponseType = class;
  TXMLResultType = class;
  TXMLResultTypeList = class;
  TXMLAddress_componentType = class;
  TXMLAddress_componentTypeList = class;
  TXMLGeometryType = class;
  TXMLLocationType = class;
  TXMLViewportType = class;
  TXMLSouthwestType = class;
  TXMLNortheastType = class;
  TXMLBoundsType = class;
  TXMLString_List = class;

{ TXMLGeocodeResponseType }

  TXMLGeocodeResponseType = class(TXMLNode, IXMLGeocodeResponseType)
  private
    FResult: IXMLResultTypeList;
  protected
    { IXMLGeocodeResponseType }
    function Get_Status: UnicodeString;
    function Get_Result: IXMLResultTypeList;
    procedure Set_Status(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLResultType }

  TXMLResultType = class(TXMLNode, IXMLResultType)
  private
    FAddress_component: IXMLAddress_componentTypeList;
  protected
    { IXMLResultType }
    function Get_Type_: UnicodeString;
    function Get_Formatted_address: UnicodeString;
    function Get_Address_component: IXMLAddress_componentTypeList;
    function Get_Geometry: IXMLGeometryType;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Formatted_address(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLResultTypeList }

  TXMLResultTypeList = class(TXMLNodeCollection, IXMLResultTypeList)
  protected
    { IXMLResultTypeList }
    function Add: IXMLResultType;
    function Insert(const Index: Integer): IXMLResultType;

    function Get_Item(Index: Integer): IXMLResultType;
  end;

{ TXMLAddress_componentType }

  TXMLAddress_componentType = class(TXMLNode, IXMLAddress_componentType)
  private
    FType_: IXMLString_List;
  protected
    { IXMLAddress_componentType }
    function Get_Long_name: UnicodeString;
    function Get_Short_name: UnicodeString;
    function Get_Type_: IXMLString_List;
    procedure Set_Long_name(Value: UnicodeString);
    procedure Set_Short_name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAddress_componentTypeList }

  TXMLAddress_componentTypeList = class(TXMLNodeCollection, IXMLAddress_componentTypeList)
  protected
    { IXMLAddress_componentTypeList }
    function Add: IXMLAddress_componentType;
    function Insert(const Index: Integer): IXMLAddress_componentType;

    function Get_Item(Index: Integer): IXMLAddress_componentType;
  end;

{ TXMLGeometryType }

  TXMLGeometryType = class(TXMLNode, IXMLGeometryType)
  protected
    { IXMLGeometryType }
    function Get_Location: IXMLLocationType;
    function Get_Location_type: UnicodeString;
    function Get_Viewport: IXMLViewportType;
    function Get_Bounds: IXMLBoundsType;
    procedure Set_Location_type(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLocationType }

  TXMLLocationType = class(TXMLNode, IXMLLocationType)
  protected
    { IXMLLocationType }
    function Get_Lat: Double;
    function Get_Lng: Double;
    procedure Set_Lat(Value: Double);
    procedure Set_Lng(Value: Double);
  end;

{ TXMLViewportType }

  TXMLViewportType = class(TXMLNode, IXMLViewportType)
  protected
    { IXMLViewportType }
    function Get_Southwest: IXMLSouthwestType;
    function Get_Northeast: IXMLNortheastType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSouthwestType }

  TXMLSouthwestType = class(TXMLNode, IXMLSouthwestType)
  protected
    { IXMLSouthwestType }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
  end;

{ TXMLNortheastType }

  TXMLNortheastType = class(TXMLNode, IXMLNortheastType)
  protected
    { IXMLNortheastType }
    function Get_Lat: UnicodeString;
    function Get_Lng: UnicodeString;
    procedure Set_Lat(Value: UnicodeString);
    procedure Set_Lng(Value: UnicodeString);
  end;

{ TXMLBoundsType }

  TXMLBoundsType = class(TXMLNode, IXMLBoundsType)
  protected
    { IXMLBoundsType }
    function Get_Southwest: IXMLSouthwestType;
    function Get_Northeast: IXMLNortheastType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLString_List }

  TXMLString_List = class(TXMLNodeCollection, IXMLString_List)
  protected
    { IXMLString_List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetGeocodeResponse(Doc: IXMLDocument): IXMLGeocodeResponseType;
function LoadGeocodeResponse(const FileName: string): IXMLGeocodeResponseType;
function NewGeocodeResponse: IXMLGeocodeResponseType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetGeocodeResponse(Doc: IXMLDocument): IXMLGeocodeResponseType;
begin
  Result := Doc.GetDocBinding('GeocodeResponse', TXMLGeocodeResponseType, TargetNamespace) as IXMLGeocodeResponseType;
end;

function LoadGeocodeResponse(const FileName: string): IXMLGeocodeResponseType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('GeocodeResponse', TXMLGeocodeResponseType, TargetNamespace) as IXMLGeocodeResponseType;
end;

function NewGeocodeResponse: IXMLGeocodeResponseType;
begin
  Result := NewXMLDocument.GetDocBinding('GeocodeResponse', TXMLGeocodeResponseType, TargetNamespace) as IXMLGeocodeResponseType;
end;

{ TXMLGeocodeResponseType }

procedure TXMLGeocodeResponseType.AfterConstruction;
begin
  RegisterChildNode('result', TXMLResultType);
  FResult := CreateCollection(TXMLResultTypeList, IXMLResultType, 'result') as IXMLResultTypeList;
  inherited;
end;

function TXMLGeocodeResponseType.Get_Status: UnicodeString;
begin
  Result := ChildNodes['status'].Text;
end;

procedure TXMLGeocodeResponseType.Set_Status(Value: UnicodeString);
begin
  ChildNodes['status'].NodeValue := Value;
end;

function TXMLGeocodeResponseType.Get_Result: IXMLResultTypeList;
begin
  Result := FResult;
end;

{ TXMLResultType }

procedure TXMLResultType.AfterConstruction;
begin
  RegisterChildNode('address_component', TXMLAddress_componentType);
  RegisterChildNode('geometry', TXMLGeometryType);
  FAddress_component := CreateCollection(TXMLAddress_componentTypeList, IXMLAddress_componentType, 'address_component') as IXMLAddress_componentTypeList;
  inherited;
end;

function TXMLResultType.Get_Type_: UnicodeString;
begin
  Result := ChildNodes['type'].Text;
end;

procedure TXMLResultType.Set_Type_(Value: UnicodeString);
begin
  ChildNodes['type'].NodeValue := Value;
end;

function TXMLResultType.Get_Formatted_address: UnicodeString;
begin
  Result := ChildNodes['formatted_address'].Text;
end;

procedure TXMLResultType.Set_Formatted_address(Value: UnicodeString);
begin
  ChildNodes['formatted_address'].NodeValue := Value;
end;

function TXMLResultType.Get_Address_component: IXMLAddress_componentTypeList;
begin
  Result := FAddress_component;
end;

function TXMLResultType.Get_Geometry: IXMLGeometryType;
begin
  Result := ChildNodes['geometry'] as IXMLGeometryType;
end;

{ TXMLResultTypeList }

function TXMLResultTypeList.Add: IXMLResultType;
begin
  Result := AddItem(-1) as IXMLResultType;
end;

function TXMLResultTypeList.Insert(const Index: Integer): IXMLResultType;
begin
  Result := AddItem(Index) as IXMLResultType;
end;

function TXMLResultTypeList.Get_Item(Index: Integer): IXMLResultType;
begin
  Result := List[Index] as IXMLResultType;
end;

{ TXMLAddress_componentType }

procedure TXMLAddress_componentType.AfterConstruction;
begin
  FType_ := CreateCollection(TXMLString_List, IXMLNode, 'type') as IXMLString_List;
  inherited;
end;

function TXMLAddress_componentType.Get_Long_name: UnicodeString;
begin
  Result := ChildNodes['long_name'].Text;
end;

procedure TXMLAddress_componentType.Set_Long_name(Value: UnicodeString);
begin
  ChildNodes['long_name'].NodeValue := Value;
end;

function TXMLAddress_componentType.Get_Short_name: UnicodeString;
begin
  Result := ChildNodes['short_name'].Text;
end;

procedure TXMLAddress_componentType.Set_Short_name(Value: UnicodeString);
begin
  ChildNodes['short_name'].NodeValue := Value;
end;

function TXMLAddress_componentType.Get_Type_: IXMLString_List;
begin
  Result := FType_;
end;

{ TXMLAddress_componentTypeList }

function TXMLAddress_componentTypeList.Add: IXMLAddress_componentType;
begin
  Result := AddItem(-1) as IXMLAddress_componentType;
end;

function TXMLAddress_componentTypeList.Insert(const Index: Integer): IXMLAddress_componentType;
begin
  Result := AddItem(Index) as IXMLAddress_componentType;
end;

function TXMLAddress_componentTypeList.Get_Item(Index: Integer): IXMLAddress_componentType;
begin
  Result := List[Index] as IXMLAddress_componentType;
end;

{ TXMLGeometryType }

procedure TXMLGeometryType.AfterConstruction;
begin
  RegisterChildNode('location', TXMLLocationType);
  RegisterChildNode('viewport', TXMLViewportType);
  RegisterChildNode('bounds', TXMLBoundsType);
  inherited;
end;

function TXMLGeometryType.Get_Location: IXMLLocationType;
begin
  Result := ChildNodes['location'] as IXMLLocationType;
end;

function TXMLGeometryType.Get_Location_type: UnicodeString;
begin
  Result := ChildNodes['location_type'].Text;
end;

procedure TXMLGeometryType.Set_Location_type(Value: UnicodeString);
begin
  ChildNodes['location_type'].NodeValue := Value;
end;

function TXMLGeometryType.Get_Viewport: IXMLViewportType;
begin
  Result := ChildNodes['viewport'] as IXMLViewportType;
end;

function TXMLGeometryType.Get_Bounds: IXMLBoundsType;
begin
  Result := ChildNodes['bounds'] as IXMLBoundsType;
end;

{ TXMLLocationType }

function TXMLLocationType.Get_Lat: Double;
begin
  Result := ChildNodes['lat'].NodeValue;
end;

procedure TXMLLocationType.Set_Lat(Value: Double);
begin
  ChildNodes['lat'].NodeValue := Value;
end;

function TXMLLocationType.Get_Lng: Double;
begin
  Result := ChildNodes['lng'].NodeValue;
end;

procedure TXMLLocationType.Set_Lng(Value: Double);
begin
  ChildNodes['lng'].NodeValue := Value;
end;

{ TXMLViewportType }

procedure TXMLViewportType.AfterConstruction;
begin
  RegisterChildNode('southwest', TXMLSouthwestType);
  RegisterChildNode('northeast', TXMLNortheastType);
  inherited;
end;

function TXMLViewportType.Get_Southwest: IXMLSouthwestType;
begin
  Result := ChildNodes['southwest'] as IXMLSouthwestType;
end;

function TXMLViewportType.Get_Northeast: IXMLNortheastType;
begin
  Result := ChildNodes['northeast'] as IXMLNortheastType;
end;

{ TXMLSouthwestType }

function TXMLSouthwestType.Get_Lat: UnicodeString;
begin
  Result := ChildNodes['lat'].Text;
end;

procedure TXMLSouthwestType.Set_Lat(Value: UnicodeString);
begin
  ChildNodes['lat'].NodeValue := Value;
end;

function TXMLSouthwestType.Get_Lng: UnicodeString;
begin
  Result := ChildNodes['lng'].Text;
end;

procedure TXMLSouthwestType.Set_Lng(Value: UnicodeString);
begin
  ChildNodes['lng'].NodeValue := Value;
end;

{ TXMLNortheastType }

function TXMLNortheastType.Get_Lat: UnicodeString;
begin
  Result := ChildNodes['lat'].Text;
end;

procedure TXMLNortheastType.Set_Lat(Value: UnicodeString);
begin
  ChildNodes['lat'].NodeValue := Value;
end;

function TXMLNortheastType.Get_Lng: UnicodeString;
begin
  Result := ChildNodes['lng'].Text;
end;

procedure TXMLNortheastType.Set_Lng(Value: UnicodeString);
begin
  ChildNodes['lng'].NodeValue := Value;
end;

{ TXMLBoundsType }

procedure TXMLBoundsType.AfterConstruction;
begin
  RegisterChildNode('southwest', TXMLSouthwestType);
  RegisterChildNode('northeast', TXMLNortheastType);
  inherited;
end;

function TXMLBoundsType.Get_Southwest: IXMLSouthwestType;
begin
  Result := ChildNodes['southwest'] as IXMLSouthwestType;
end;

function TXMLBoundsType.Get_Northeast: IXMLNortheastType;
begin
  Result := ChildNodes['northeast'] as IXMLNortheastType;
end;

{ TXMLString_List }

function TXMLString_List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString_List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString_List.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.
