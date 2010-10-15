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

unit DelphiMaps.Browser;

interface

uses
  Classes,
  SHDocVw,
  MSHTML;


type
  TBrowser=class(TWebBrowser)
  private
   procedure OnMouseOver;
  public
    constructor Create(AOwner: TComponent); override;
  published
    procedure ExecJavaScript(const aScript:String);
    procedure WebBrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    function GetJsValue(aJavaScript:String):OleVariant;
  end;

  TJsObjectProcedure = procedure of object;

  TJsEventObject = class(TInterfacedObject, IDispatch)
  private
    FOnEvent: TJsObjectProcedure;
  protected
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  public
    constructor Create(const OnEvent: TJsObjectProcedure) ;
    property OnEvent: TJsObjectProcedure read FOnEvent write FOnEvent;
  end;




implementation

uses
  ActiveX;

{ TBrowser }

constructor TBrowser.Create(AOwner: TComponent);
begin
  inherited;
//  Navigate('about:blank');
//  OleObject.document.body.style.overflowX := 'hidden';
//  OleObject.document.body.style.overflowY := 'hidden';

  // Switch off borders
//  OleObject.document.body.style.borderstyle := 'none';

end;

procedure TBrowser.ExecJavaScript(const aScript: String);
begin
  if (ReadyState <> READYSTATE_COMPLETE) then
    exit;

  if Assigned(Document) then
    try
      (Document as IHTMLDocument2).parentWindow.execScript(aScript, 'JavaScript');
    except
      //
    end;
end;


function TBrowser.GetJsValue(aJavaScript: String): OleVariant;
  function GetFormByNumber(document: IHTMLDocument2;
      formNumber: integer): IHTMLFormElement;
  var
    forms: IHTMLElementCollection;
  begin
    forms := document.Forms as IHTMLElementCollection;
    if formNumber < forms.Length then
      result := forms.Item(formNumber,'') as IHTMLFormElement
    else
      result := nil;
  end;

  function GetFieldValue(fromForm: IHTMLFormElement; const fieldName: string): string;
  var
    field: IHTMLElement;
    inputField: IHTMLInputElement;
    selectField: IHTMLSelectElement;
    textField: IHTMLTextAreaElement;
  begin
    field := fromForm.Item(fieldName,'') as IHTMLElement;
    if not Assigned(field) then
      result := ''
    else
    begin
      if field.tagName = 'INPUT' then
      begin
        inputField := field as IHTMLInputElement;
        result := inputField.value
      end
      else if field.tagName = 'SELECT' then
      begin
        selectField := field as IHTMLSelectElement;
        result := selectField.value
      end
      else if field.tagName = 'TEXTAREA' then
      begin
        textField := field as IHTMLTextAreaElement;
        result := textField.value;
      end;
    end
  end;


var
  document: IHTMLDocument2;
  theForm: IHTMLFormElement;

begin
  ExecJavaScript('ReturnValue('+aJavaScript+')');

  document := Document as IHTMLDocument2;
  theForm := GetFormByNumber(Document as IHTMLDocument2,0);
  Result := GetFieldValue(theForm,'retVal');
end;



procedure TBrowser.OnMouseOver;
var
  element : IHTMLElement;
begin
  element := (Document as IHTMLDocument2).parentWindow.event.srcElement;
{
  if LowerCase(element.tagName) = 'a' then
  begin
    FLogLines.Add('LINK info...');
    FLogLines.Add(Format('HREF : %s',[element.getAttribute('href',0)]));
  end
  else if LowerCase(element.tagName) = 'img' then
  begin
    FLogLines.Add('IMAGE info...');
    FLogLines.Add(Format('SRC : %s',[element.getAttribute('src',0)]));
  end
  else
  begin
    FLogLines.Add(Format('TAG : %s',[element.tagName]));
  end;
}
end;


procedure TBrowser.WebBrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  if Assigned(Document) then
  begin
    (Document as IHTMLDocument2).onmouseover := (TJsEventObject.Create(OnMouseOver) as IDispatch) ;
//    (FWebBrowser.Document as IHTMLDocument2).parentWindow.alert((FWebBrowser.Document as IHTMLDocument2).parentWindow.toString);
  end;
end;

{ TEventObject }

constructor TJsEventObject.Create(const OnEvent: TJsObjectProcedure) ;
begin
   inherited Create;
   FOnEvent := OnEvent;
end;

function TJsEventObject.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;


function TJsEventObject.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJsEventObject.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJsEventObject.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
begin
   if (DispID = DISPID_VALUE) then
   begin
     if Assigned(FOnEvent) then FOnEvent;
     Result := S_OK;
   end
   else Result := E_NOTIMPL;
end;





end.
