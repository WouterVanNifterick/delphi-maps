unit DelphiMaps.WebImage;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, ExtActns, Menus,
  Graphics, PngImage, GifImg, Jpeg;

type
  TWebImage = class(TPaintBox)
  strict protected
    FIsLoaded:Boolean;
    FPicture:TPicture;
    FBitmap:Graphics.TBitmap;
    FPopupMenu:TPopupMenu;
    procedure UpdateBitmap;
  private
    procedure DrawBitmap;
  protected
    FURL:String;
    function GetURL: String;virtual;
    procedure SetURL(const Value: String);
    procedure Paint; override;
    procedure Resize; override;
    procedure OnMiCopyURLClick(Sender:TObject);
    procedure OnMiOpenURLClick(Sender:TObject);
    function GetPropertyString: String;virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Refresh;virtual;
    destructor Destroy; override;
    procedure CopyURL;
    procedure OpenURL;
    procedure OnDownloadProgressEvent(Sender: TDownLoadURL; Progress, ProgressMax: Cardinal; StatusCode: TURLDownloadStatus; StatusText: String; var Cancel: Boolean);
  published
    property URL: String read GetURL write SetURL;
    property PropertyString:String read GetPropertyString;
  end;

procedure Register;

implementation

uses
  Windows,
  StrUtils,
  ClipBrd,
  ShellAPI,
  IoUtils;

resourcestring
  StrLoading = 'Loading...';
  StrCopyURL = 'Copy URL';
  StrOpenInBrowser = 'Open in browser';

procedure Register;
begin
  RegisterComponents('DelphiMaps', []);
end;

{ TWebImage }

constructor TWebImage.Create(AOwner: TComponent);
var
  Mi:TMenuItem;
begin
  inherited;
  FIsLoaded := False;
  FBitmap := Graphics.TBitmap.Create;
  FPicture := TPicture.Create;

  FPopupMenu := TPopupMenu.Create(nil);
  PopupMenu := FPopupMenu;

  Mi := TMenuItem.Create(PopupMenu);
  Mi.Caption := StrCopyURL;
  Mi.OnClick := OnMiCopyURLClick;
  FPopupMenu.Items.Add(Mi);

  Mi := TMenuItem.Create(PopupMenu);
  Mi.Caption := StrOpenInBrowser;
  Mi.OnClick := OnMiOpenURLClick;
  FPopupMenu.Items.Add(Mi);


end;

destructor TWebImage.Destroy;
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FPicture);
  FreeAndNil(FPopupMenu);
  inherited;
end;

procedure TWebImage.OpenURL;
begin
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TWebImage.CopyURL;
begin
  ClipBoard.AsText := GetURL;
end;

function TWebImage.GetPropertyString: String;
begin
  Result := URL;
end;

function TWebImage.GetURL: String;
begin
  Result := FURL;
end;

procedure TWebImage.OnDownloadProgressEvent(Sender: TDownLoadURL; Progress,
  ProgressMax: Cardinal; StatusCode: TURLDownloadStatus; StatusText: String;
  var Cancel: Boolean);
begin
  case StatusCode of
    dsFindingResource   : Canvas.TextOut(5,Height-30,'Finding Resource...');
    dsConnecting        : Canvas.TextOut(5,Height-30,'Connecting...');
    dsRedirecting       : Canvas.TextOut(5,Height-30,'Redirecting...');
    dsBeginDownloadData : Canvas.TextOut(5,Height-30,'Begin download');
    dsDownloadingData   : Canvas.TextOut(5,Height-30,'Downloading...');
    dsEndDownloadData   : Canvas.TextOut(5,Height-30,'Done.');
    dsBeginDownloadComponents: ;
    dsInstallingComponents: ;
    dsEndDownloadComponents: ;
    dsUsingCachedCopy: ;
    dsSendingRequest: ;
    dsClassIDAvailable: ;
    dsMIMETypeAvailable: ;
    dsCacheFileNameAvailable: ;
    dsBeginSyncOperation: ;
    dsEndSyncOperation: ;
    dsBeginUploadData: ;
    dsUploadingData: ;
    dsEndUploadData: ;
    dsProtocolClassID: ;
    dsEncoding: ;
    dsVerifiedMIMETypeAvailable: ;
    dsClassInstallLocation: ;
    dsDecoding: ;
    dsLoadingMIMEHandler: ;
    dsContentDispositionAttach: ;
    dsFilterReportMIMEType: ;
    dsCLSIDCanInstantiate: ;
    dsIUnKnownAvailable: ;
    dsDirectBind: ;
    dsRawMIMEType: ;
    dsProxyDetecting: ;
    dsAcceptRanges: ;
    dsCookieSent: ;
    dsCompactPolicyReceived: ;
    dsCookieSuppressed: ;
    dsCookieStateUnknown: ;
    dsCookieStateAccept: ;
    dsCookeStateReject: ;
    dsCookieStatePrompt: ;
    dsCookieStateLeash: ;
    dsCookieStateDowngrade: ;
    dsPolicyHREF: ;
    dsP3PHeader: ;
    dsSessionCookieReceived: ;
    dsPersistentCookieReceived: ;
    dsSessionCookiesAllowed: ;
  end;
end;

procedure TWebImage.DrawBitmap;
begin
  if Assigned(FBitmap) then
    if Assigned(Canvas) then
      Canvas.Draw((Width div 2) - (FBitmap.Width div 2), (Height div 2) - (FBitmap.Height div 2), FBitmap);
end;

procedure TWebImage.OnMiCopyURLClick(Sender: TObject);
begin
  CopyURL;
end;

procedure TWebImage.OnMiOpenURLClick(Sender: TObject);
begin
  OpenURL;
end;

procedure TWebImage.Paint;
begin
//  inherited;
  DrawBitmap;
end;

procedure TWebImage.Refresh;
begin
  //
end;

procedure TWebImage.Resize;
begin
  inherited;
  Paint;
end;

procedure TWebImage.SetURL(const Value: String);
begin
  if FURL=Value then
    Exit;

  FURL := Value;
  UpdateBitmap;
end;

procedure TWebImage.UpdateBitmap;
var
  Download : TDownLoadURL;
  tmpName:string;
  S:String;
begin
  if Width = 0 then
    Exit;

  if csLoading in ComponentState then
    Exit;

  Refresh;

  if FIsLoaded then
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle( 5, 5,Canvas.TextWidth(StrLoading)+25, 30 );
    Canvas.TextOut( 10, 10, StrLoading );
    Update;
  end;

  Download := TDownLoadURL.Create(nil);
  try
    Download.OnDownloadProgress := OnDownloadProgressEvent;
    Download.URL := FURL;
    TmpName := TPath.GetTempFileName;
    TmpName := ChangeFileExt(TmpName,'.png');
    Download.Filename := TmpName;
    Download.ExecuteTarget(nil);
    if FileExists(TmpName) then
    begin
      try
        try
          FPicture.LoadFromFile(TmpName);
          FBitmap.SetSize( FPicture.Width, FPicture.Height );
          FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);
          FBitmap.Canvas.Draw(0,0,FPicture.Graphic);
          DrawBitmap;
          FIsLoaded := true;
        except
          S := TFile.ReadAllText(TmpName);
          if Pos('<ServiceException>',S)>0 then
          begin
            S := Copy( S, Pos('<ServiceException>',S)+18, Pos('</ServiceException>',S) - Pos('<ServiceException>',S)-18);
            S := Trim(S);
            S := ReplaceStr(S,'&quot;','"');
            raise Exception.Create( S );
          end
          else
            raise;
        end;
      finally
        TFile.Delete(TmpName);
      end;
    end;
  finally
    FreeAndNil(Download)
  end;
end;

end.
