{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  http://www.delphidabbler.com/articles?article=22.

  This unit defines a class that extends the TWebBrowser's external object.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2005-2006.

  v1.0 of 2005/05/09 - original version
  v1.1 of 2006/02/11 - changed base URL of programs to reflect current use
}


{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$WARN UNSAFE_TYPE OFF}


unit
DelphiMaps.Browser.External;

interface

uses
  Classes, ComObj, DelphiMapsBrowserExternal_TLB;

type
  TShowMessageEvent = procedure(const aText: WideString) of object;
  TTriggerEventEvent = procedure (const EventName: WideString)  of object;

  TDelphiMapsExternal = class(TAutoIntfObject, IDelphiMaps , IDispatch)
  private
    FOnTriggerEvent: TTriggerEventEvent;
    FOnShowMessage: TShowMessageEvent;
    procedure SetOnTriggerEvent(const Value: TTriggerEventEvent);
    procedure SetOnShowMessage(const Value: TShowMessageEvent);

  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure showMessage(const aText: WideString); safecall;
    procedure triggerEvent(const EventName: WideString); safecall;

  public
    property OnTriggerEvent:TTriggerEventEvent read FOnTriggerEvent write SetOnTriggerEvent;
    property OnShowMessage:TShowMessageEvent read FOnShowMessage write SetOnShowMessage;
  end;

implementation

uses
  Dialogs, SysUtils, ActiveX, StdActns;

{ TMyExternal }


constructor TDelphiMapsExternal.Create;
var
  TypeLib: ITypeLib;    // type library information
  ExeName: WideString;  // name of our program's exe file
begin
  // Get name of application
  ExeName := ParamStr(0);
  // Load type library from application's resources
  OleCheck(LoadTypeLib(PWideChar(ExeName), TypeLib));
  // Call inherited constructor
  inherited Create(TypeLib, IDelphiMaps);
end;


destructor TDelphiMapsExternal.Destroy;
begin
  inherited;
end;

procedure TDelphiMapsExternal.SetOnShowMessage(const Value: TShowMessageEvent);
begin
  FOnShowMessage := Value;
end;

procedure TDelphiMapsExternal.SetOnTriggerEvent(
  const Value: TTriggerEventEvent);
begin
  FOnTriggerEvent := Value;
end;

procedure TDelphiMapsExternal.showMessage(const aText: WideString);
begin
  if Assigned(FOnShowMessage) then
    FOnShowMessage(aText);
end;

procedure TDelphiMapsExternal.triggerEvent(const EventName: WideString);
begin
  if Assigned(FOnTriggerEvent) then
    FOnTriggerEvent(EventName);
end;

end.
