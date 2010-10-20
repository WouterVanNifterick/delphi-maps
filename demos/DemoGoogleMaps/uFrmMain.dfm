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
  end
  object GoogleMaps1: TGoogleMaps
    Left = 0
    Top = 29
    Width = 393
    Height = 292
    JsVarName = 'GoogleMaps1'
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
end
