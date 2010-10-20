object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps GeoCoding Demo'
  ClientHeight = 347
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 415
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox2: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 237
      Height = 75
      Align = alClient
      Caption = 'Search'
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 219
      ExplicitHeight = 78
      DesignSize = (
        237
        75)
      object edSearch: TEdit
        Left = 10
        Top = 19
        Width = 211
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnChange = edSearchChange
        ExplicitWidth = 193
      end
      object edFound: TEdit
        Left = 10
        Top = 46
        Width = 211
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
        ExplicitWidth = 193
      end
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 246
      Top = 3
      Width = 166
      Height = 75
      Align = alRight
      Caption = 'Position'
      TabOrder = 1
      ExplicitLeft = 248
      ExplicitTop = 1
      ExplicitHeight = 103
      DesignSize = (
        166
        75)
      object edLat: TLabeledEdit
        Left = 35
        Top = 19
        Width = 121
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 15
        EditLabel.Height = 13
        EditLabel.Caption = 'Lat'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object edLon: TLabeledEdit
        Left = 35
        Top = 46
        Width = 121
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 17
        EditLabel.Height = 13
        EditLabel.Caption = 'Lon'
        LabelPosition = lpLeft
        TabOrder = 1
      end
    end
  end
  object GoogleMaps1: TGoogleMaps
    Left = 0
    Top = 81
    Width = 415
    Height = 266
    Align = alClient
    MapType = MT_ROADMAP
    ExplicitLeft = 8
    ExplicitTop = 108
    ExplicitWidth = 196
    ExplicitHeight = 69
  end
end
