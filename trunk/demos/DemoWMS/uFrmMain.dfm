object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps WMS demo'
  ClientHeight = 440
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = WmsImage1Click
  PixelsPerInch = 96
  TextHeight = 13
  object wms: TWmsImage
    Left = 0
    Top = 0
    Width = 604
    Height = 440
    Align = alClient
    OnClick = WmsImage1Click
    URL = 
      '?SERVICE=WMS&VERSION=1.1.0&REQUEST=GetMap&LAYERS=&STYLES=&BBOX=0' +
      ',0,0,0&WIDTH=256&HEIGHT=256&SRS=&FORMAT=image%2FPng32&TRANSPAREN' +
      'T=TRUE'
    Version = '1.1.0'
    ImageFormat = mfPng32
    Transparent = True
    WWidth = 256
    WHeight = 256
    BackgroundColor = clNone
    Exceptions = 'application/vnd.ogc.se_inimage'
    ExplicitLeft = 64
    ExplicitTop = 48
    ExplicitWidth = 457
    ExplicitHeight = 321
  end
end
