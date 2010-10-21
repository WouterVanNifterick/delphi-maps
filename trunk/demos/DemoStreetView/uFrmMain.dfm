object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps StreetView demo'
  ClientHeight = 421
  ClientWidth = 736
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 121
    Top = 29
    Height = 392
    ExplicitLeft = 160
    ExplicitTop = 104
    ExplicitHeight = 100
  end
  object StreetView1: TStreetView
    Left = 124
    Top = 29
    Width = 612
    Height = 392
    JsVarName = 'StreetView1'
    Align = alClient
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 29
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
    object LinkLabel1: TLinkLabel
      AlignWithMargins = True
      Left = 204
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
    Height = 392
    Align = alLeft
    TabOrder = 2
    object lblHeading: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 113
      Height = 13
      Align = alTop
      Caption = 'Heading'
      ExplicitWidth = 39
    end
    object lblPitch: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 46
      Width = 113
      Height = 13
      Align = alTop
      Caption = 'Pitch'
      ExplicitWidth = 23
    end
    object lblZoom: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 88
      Width = 113
      Height = 13
      Align = alTop
      Caption = 'Zoom'
      ExplicitWidth = 26
    end
    object sbHeading: TScrollBar
      AlignWithMargins = True
      Left = 4
      Top = 23
      Width = 113
      Height = 17
      Align = alTop
      Max = 3600
      PageSize = 0
      Position = 180
      TabOrder = 0
      OnChange = OnPovChange
    end
    object sbPitch: TScrollBar
      AlignWithMargins = True
      Left = 4
      Top = 65
      Width = 113
      Height = 17
      Align = alTop
      Max = 500
      Min = -500
      PageSize = 0
      TabOrder = 1
      OnChange = OnPovChange
    end
    object sbZoom: TScrollBar
      AlignWithMargins = True
      Left = 4
      Top = 107
      Width = 113
      Height = 17
      Align = alTop
      Max = 30
      PageSize = 0
      Position = 15
      TabOrder = 2
      OnChange = OnPovChange
    end
  end
end
