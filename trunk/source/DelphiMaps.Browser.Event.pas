unit DelphiMaps.Browser.Event;

interface

uses
  Generics.Collections,
  DelphiMaps.Browser,
  DelphiMaps.Browser.External,
  DelphiMaps.Browser.ExternalContainer;

type
  TJsEventHandler = reference to procedure;

  TJsListener = class (TJsClassWrapper)
  private
    FHandler: TJsEventHandler;
    FEventName: string;
    FInstance: IJsClassWrapper;
    FHandlerJs: string;

    procedure SetEventName(const Value: string);
    procedure SetHandler(const Value: TJsEventHandler);
    procedure SetInstance(const Value: IJsClassWrapper);
    procedure SetHandlerJs(const Value: string);
    function GetFullName: string;
  public
    constructor Create; overload;override;
    constructor Create(aInstance: IJsClassWrapper; aEventName: string; aHandler: TJsEventHandler;  aHandlerJs: string);reintroduce;overload;
    function JsClassName: string; override;
    function Clone: TJsClassWrapper; override;
    function ToJavaScript: string; override;

    property Instance:IJsClassWrapper read FInstance write SetInstance;
    property EventName:string read FEventName write SetEventName;
    property Handler:TJsEventHandler read FHandler write SetHandler;
    property HandlerJs:string read FHandlerJs write SetHandlerJs;
    property FullName:string read GetFullName;
  end;

  TListenerList=class(TObjectList<TJsListener>)
  end;

  TEvent = class
  private
    FBrowser: TBrowser;
    FListeners: TListenerList;
    FContainer:TExternalContainer<TDelphiMapsExternal>;

    procedure HandleShowMessageEvent(const aText: WideString);
    procedure HandleTriggerEventEvent(const EventName: WideString);

  public
    constructor Create(aBrowser:TBrowser);
    procedure AddListener(aInstance: IJsClassWrapper; aEventName: string; aHandler: TJsEventHandler;  aHandlerJs: string='');
    destructor Destroy; override;
  end;

implementation

uses SysUtils, StrUtils, Dialogs;

{ TEvent }

function TJsListener.Clone: TJsClassWrapper;
begin
  Result := TJsListener.Create;
  with Result as TJsListener do
  begin
    Handler   := FHandler;
    HandlerJs := FHandlerJs;
    Instance  := FInstance;
    EventName := FEventName;
  end;
end;

constructor TJsListener.Create;
begin
  inherited;

end;

constructor TJsListener.Create(aInstance: IJsClassWrapper; aEventName: string; aHandler: TJsEventHandler;  aHandlerJs: string);
begin
  FHandler  := aHandler;
  FEventName:= aEventName;
  FInstance := aInstance;
  FHandlerJs:= aHandlerJs;
end;


function TJsListener.GetFullName: string;
begin
  result:= Format('%s_%s',[ Instance.JsVarName, EventName ]);
end;

function TJsListener.JsClassName: string;
begin
  result := 'google.maps.event';
end;

procedure TJsListener.SetEventName(const Value: string);
begin
  FEventName := Value;
end;

procedure TJsListener.SetHandler(const Value: TJsEventHandler);
begin
  FHandler := Value;
end;

procedure TJsListener.SetHandlerJs(const Value: string);
begin
  FHandlerJs := Value;
end;

procedure TJsListener.SetInstance(const Value: IJsClassWrapper);
begin
  FInstance := Value;
end;

function TJsListener.ToJavaScript: string;
var
  EscapedJs:string;
begin
//  EscapedJs := ReplaceStr(HandlerJs,'"','\"');

  EscapedJs := HandlerJs;

  result := format('%s.addListener(%s,"%s",function(){%s;%s});',[
     JsClassName,
     Instance.JsVarName,
     EventName,
     EscapedJs,
     Format('external.triggerEvent("%s");',[ FullName ])
     ]);
end;

{ TEvents }

procedure TEvent.AddListener(aInstance: IJsClassWrapper; aEventName: string; aHandler: TJsEventHandler;  aHandlerJs: string='');
var
  Listener:TJsListener;
begin
  Listener := TJsListener.Create(aInstance,aEventName,aHandler,aHandlerJs);
  FListeners.Add(Listener);
  FBrowser.ExecJavaScript( Listener.ToJavaScript );

end;

constructor TEvent.Create(aBrowser: TBrowser);
begin
  FListeners := TListenerList.Create;
  FListeners.OwnsObjects := True;
  FBrowser := aBrowser;
  FContainer := TExternalContainer<TDelphiMapsExternal>.Create(FBrowser);
  FContainer.ExternalObj.OnShowMessage  := HandleShowMessageEvent;
  FContainer.ExternalObj.OnTriggerEvent := HandleTriggerEventEvent;
end;

destructor TEvent.Destroy;
begin
  FreeAndNil(FListeners);
  FreeAndNil(FContainer);
  inherited;
end;

procedure TEvent.HandleShowMessageEvent(const aText: WideString);
begin
  Dialogs.ShowMessage(aText);
end;

procedure TEvent.HandleTriggerEventEvent(const EventName: WideString);
var
  Listener: TJsListener;
begin
  for Listener in FListeners do
  begin
    if Listener.FullName = EventName then
      Listener.FHandler();
  end;

end;

end.
