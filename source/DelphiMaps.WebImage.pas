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
  TWebImage = class(TImage)
  strict private
    FIsLoaded:Boolean;
    FPicture:TPicture;
    procedure UpdateBitmap;
  protected
    FURL:String;
    function GetURL: String;virtual;
    procedure SetURL(const Value: String);
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

procedure Register;
begin
  RegisterComponents('DelphiMaps', []);
end;

{ TWebImage }

constructor TWebImage.Create(AOwner: TComponent);
begin
  inherited;
  FIsLoaded := False;
  FPicture := Tpicture.Create;
end;

destructor TWebImage.Destroy;
begin
  FreeAndNil(FPicture);
  inherited;
end;

function TWebImage.GetURL: String;
begin
  Result := FURL;
end;

procedure TWebImage.Refresh;
begin
  //
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
    Canvas.Rectangle( 5, 5,Width-5, 35 );
    Canvas.TextOut( 10, 10, 'Loading...' );
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
      Canvas.Draw(0,0,FPicture.Graphic);
      FIsLoaded := true;
      TFile.Delete(TmpName);
    end;
  finally
    FreeAndNil(Download)
  end;
end;


end.
