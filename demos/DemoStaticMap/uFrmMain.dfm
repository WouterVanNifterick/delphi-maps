object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps Static Demo'
  ClientHeight = 414
  ClientWidth = 668
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 29
    Width = 668
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    OnResize = Panel1Resize
    ExplicitWidth = 746
    object StaticMap1: TStaticMap
      Left = 40
      Top = 8
      Width = 620
      Height = 369
      Align = alClient
      URL = 
        'http://maps.google.com/maps/api/staticmap?sensor=false&center=&m' +
        'aptype=satellite&size=620x369&zoom=12'
      Zoom = 12
      MapType = ST_SATELLITE
      Format = mfPng
      Sensor = False
      MapProvider = mpGoogleMaps
      ExplicitLeft = 46
      ExplicitTop = 6
      ExplicitWidth = 698
    end
    object TrackBar1: TTrackBar
      Left = 8
      Top = 8
      Width = 32
      Height = 369
      Align = alLeft
      Max = 18
      Orientation = trVertical
      Position = 14
      PositionToolTip = ptRight
      TabOrder = 0
      OnChange = TrackBar1Change
    end
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 668
    Height = 29
    Align = alTop
    AutoSize = True
    TabOrder = 1
    ExplicitWidth = 746
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 40
      Height = 13
      Caption = 'Center: '
    end
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 50
      Top = 4
      Width = 121
      Height = 21
      Hint = 'Type address or coordinates, and press [ENTER]'
      TabOrder = 0
      OnKeyDown = Edit1KeyDown
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 177
      Top = 4
      Width = 54
      Height = 13
      Caption = 'Map Type: '
    end
    object ComboBox1: TComboBox
      AlignWithMargins = True
      Left = 237
      Top = 4
      Width = 145
      Height = 21
      Align = alLeft
      Style = csDropDownList
      TabOrder = 1
      OnChange = ComboBox1Change
    end
    object Label3: TLabel
      AlignWithMargins = True
      Left = 388
      Top = 4
      Width = 47
      Height = 13
      Caption = 'Provider: '
    end
    object cmbProvider: TComboBox
      AlignWithMargins = True
      Left = 441
      Top = 4
      Width = 145
      Height = 21
      Align = alLeft
      Style = csDropDownList
      TabOrder = 2
      OnChange = cmbProviderChange
    end
    object LinkLabel1: TLinkLabel
      AlignWithMargins = True
      Left = 4
      Top = 31
      Width = 83
      Height = 17
      Caption = '<a href="xxx">Open in browser</a>'
      TabOrder = 3
      UseVisualStyle = True
      OnLinkClick = LinkLabel1LinkClick
    end
  end
end
