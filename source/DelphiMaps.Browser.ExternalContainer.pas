{
  This demo application accompanies the article
  "How to call Delphi code from scripts running in a TWebBrowser" at
  http://www.delphidabbler.com/articles?article=22.

  This unit defines the IDocHostUIHandler implementation that provides the
  external object to the TWebBrowser.

  This code is copyright (c) P D Johnson (www.delphidabbler.com), 2005-2006.

  v1.0 of 2005/05/09 - original version named UExternalUIHandler.pas
  v2.0 of 2006/02/11 - revised to descend from new TNulWBContainer class

  vX.X of 2010/10/24 - (Wouter van Nifterick) : Made TExternalContainer a generic class
}

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
unit DelphiMaps.Browser.ExternalContainer;

interface

uses
  // Delphi
  ActiveX, SHDocVw,
  // Project
  ComObj,
  DelphiMaps.Browser.IntfDocHostUIHandler,
  DelphiMaps.Browser.NulContainer,
  DelphiMaps.Browser.External;

type

  TExternalContainer<T: TAutoIntfObject, constructor> = class(TNulWBContainer, IDocHostUIHandler, IOleClientSite)
  private
    fExternalObj: IDispatch;
    function GEtExternalObj: T;
  protected
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
  public
    constructor Create(const HostedBrowser: TWebBrowser);
    property ExternalObj : T read GEtExternalObj;
  end;

implementation

{ TExternalContainer }

constructor TExternalContainer<T>.Create(const HostedBrowser: TWebBrowser);
begin
  inherited;
  fExternalObj := T.Create;
end;

function TExternalContainer<T>.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  ppDispatch := fExternalObj;
  Result := S_OK; // indicates we've provided script
end;

function TExternalContainer<T>.GEtExternalObj: T;
begin
  Result := Self.fExternalObj as T;
end;


end.
