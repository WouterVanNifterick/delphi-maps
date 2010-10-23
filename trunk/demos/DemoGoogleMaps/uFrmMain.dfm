object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'DelphiMaps GoogleMaps Demo'
  ClientHeight = 321
  ClientWidth = 609
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 393
    Top = 29
    Width = 7
    Height = 292
    Align = alRight
    ExplicitLeft = 432
    ExplicitTop = 0
    ExplicitHeight = 321
  end
  object GoogleMapsLayersList1: TGoogleMapsLayersList
    Left = 400
    Top = 29
    Width = 209
    Height = 292
    Align = alRight
    Indent = 19
    TabOrder = 0
    GoogleMaps = GoogleMaps1
  end
  object GoogleMaps1: TGoogleMaps
    Left = 121
    Top = 29
    Width = 272
    Height = 292
    JsVarName = 'map'
    Align = alClient
    MapType = MT_ROADMAP
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 609
    Height = 29
    Align = alTop
    AutoSize = True
    TabOrder = 2
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 277
      Height = 21
      Align = alLeft
      TabOrder = 0
      OnKeyDown = Edit1KeyDown
    end
    object ComboBox1: TComboBox
      AlignWithMargins = True
      Left = 287
      Top = 4
      Width = 145
      Height = 21
      Align = alLeft
      Style = csDropDownList
      TabOrder = 1
      OnChange = ComboBox1Change
    end
    object LinkLabel1: TLinkLabel
      AlignWithMargins = True
      Left = 438
      Top = 4
      Width = 83
      Height = 17
      Caption = '<a href="xxx">Open in browser</a>'
      TabOrder = 2
      UseVisualStyle = True
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 29
    Width = 121
    Height = 292
    Align = alLeft
    TabOrder = 3
    object btnTestPolygon1: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Polygon'
      TabOrder = 0
      OnClick = btnTestPolygon1Click
      ExplicitLeft = 2
      ExplicitTop = -13
    end
    object btnTestMarkers: TButton
      AlignWithMargins = True
      Left = 4
      Top = 97
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Markers 2'
      TabOrder = 1
      OnClick = btnTestMarkersClick
      ExplicitLeft = 2
    end
    object btnMarker: TButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Markers 1'
      TabOrder = 2
      OnClick = btnMarkerClick
      ExplicitTop = 35
    end
    object btnTestPolyGon2: TButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Polygon'
      TabOrder = 3
      OnClick = btnTestPolyGon2Click
      ExplicitLeft = 2
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 4
      Top = 128
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Eval'
      TabOrder = 4
      OnClick = Button1Click
      ExplicitLeft = 48
      ExplicitTop = 152
      ExplicitWidth = 75
    end
    object btnGetBounds: TButton
      AlignWithMargins = True
      Left = 4
      Top = 159
      Width = 113
      Height = 25
      Align = alTop
      Caption = 'Get Bounds'
      TabOrder = 5
      OnClick = btnGetBoundsClick
      ExplicitLeft = 2
      ExplicitTop = 200
    end
  end
end
