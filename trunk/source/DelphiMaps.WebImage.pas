unit DelphiMaps.WebImage;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls,
  ExtActns,
  Graphics,
  PngImage,
  GifImg,
  Jpeg;

type
  TWebImage = class(TPaintBox)
  strict private
    FIsLoaded:Boolean;
    FPicture:TPicture;
    FBitmap:TBitmap;
    procedure UpdateBitmap;
  protected
    FURL:String;
    function GetURL: String;virtual;
    procedure SetURL(const Value: String);
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Refresh;virtual;
    destructor Destroy; override;

  published
    property URL: String read GetURL write SetURL;
  end;

procedure Register;

implementation

uses
  IoUtils;

resourcestring
  StrLoading = 'Loading...';

procedure Register;
begin
  RegisterComponents('DelphiMaps', []);
end;

{ TWebImage }

constructor TWebImage.Create(AOwner: TComponent);
begin
  inherited;
  FIsLoaded := False;
  FBitmap := TBitmap.Create;
  FPicture := TPicture.Create;
end;

destructor TWebImage.Destroy;
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FPicture);
  inherited;
end;

function TWebImage.GetURL: String;
begin
  Result := FURL;
end;

procedure TWebImage.Paint;
begin
  inherited;
  if Assigned(FBitmap) then
    Canvas.Draw(
      (Width div 2)-(FBitmap.Width div 2),
      (Height div 2)-(FBitmap.Height div 2),
      FBitmap
    );
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
    Download.URL := FURL;
    TmpName := TPath.GetTempFileName;
    TmpName := ChangeFileExt(TmpName,'.png');
    Download.Filename := TmpName;
    Download.ExecuteTarget(nil);
    if FileExists(TmpName) then
    begin
      FPicture.LoadFromFile(TmpName);
      FBitmap.SetSize( FPicture.Width, FPicture.Height );
      FBitmap.Canvas.Draw(0,0,FPicture.Graphic);
      Canvas.StretchDraw(Canvas.ClipRect,FBitmap);
      FIsLoaded := true;
      TFile.Delete(TmpName);
    end;
  finally
    FreeAndNil(Download)
  end;
end;

end.
