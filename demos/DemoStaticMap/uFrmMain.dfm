object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps Static Demo'
  ClientHeight = 474
  ClientWidth = 703
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
    Top = 52
    Width = 703
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object StaticMap1: TStaticMap
      Left = 39
      Top = 0
      Width = 664
      Height = 422
      Align = alClient
      Zoom = 0
      MapType = ST_ROADMAP
      Format = mfPng
      Sensor = False
      MapProvider = mpGoogleMaps
      ExplicitLeft = 192
      ExplicitTop = 56
      ExplicitWidth = 441
      ExplicitHeight = 313
    end
    object TrackBar1: TTrackBar
      Left = 0
      Top = 0
      Width = 39
      Height = 422
      Hint = 'ZoomLevel'
      Align = alLeft
      Max = 18
      Orientation = trVertical
      Position = 14
      PositionToolTip = ptRight
      TabOrder = 0
      TickMarks = tmBoth
      OnChange = TrackBar1Change
    end
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 703
    Height = 52
    Align = alTop
    AutoSize = True
    TabOrder = 1
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 40
      Height = 13
      Caption = 'Center: '
    end
    object edCenter: TEdit
      AlignWithMargins = True
      Left = 50
      Top = 4
      Width = 121
      Height = 21
      Hint = 'Type address or coordinates, and press [ENTER]'
      TabOrder = 0
      OnKeyDown = edCenterKeyDown
    end
    object btnSetCenter: TButton
      Left = 174
      Top = 1
      Width = 27
      Height = 25
      Caption = 'Go'
      TabOrder = 1
      OnClick = btnSetCenterClick
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 204
      Top = 4
      Width = 54
      Height = 13
      Caption = 'Map Type: '
    end
    object cmbMapType: TComboBox
      AlignWithMargins = True
      Left = 264
      Top = 4
      Width = 145
      Height = 21
      Align = alLeft
      Style = csDropDownList
      TabOrder = 2
      OnChange = cmbMapTypeChange
    end
    object Label3: TLabel
      AlignWithMargins = True
      Left = 415
      Top = 4
      Width = 47
      Height = 13
      Caption = 'Provider: '
    end
    object cmbProvider: TComboBox
      AlignWithMargins = True
      Left = 468
      Top = 4
      Width = 145
      Height = 21
      Align = alLeft
      Style = csDropDownList
      TabOrder = 3
      OnChange = cmbProviderChange
    end
    object LinkLabel1: TLinkLabel
      AlignWithMargins = True
      Left = 4
      Top = 31
      Width = 83
      Height = 17
      Caption = '<a href="xxx">Open in browser</a>'
      TabOrder = 4
      UseVisualStyle = True
      OnLinkClick = LinkLabel1LinkClick
    end
  end
end
