object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DelphiMaps Directions Demo'
  ClientHeight = 462
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 258
    Top = 29
    Width = 4
    Height = 405
    ExplicitLeft = 177
    ExplicitTop = 57
    ExplicitHeight = 221
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 29
    Align = alTop
    TabOrder = 0
    object lblStart: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 31
      Height = 21
      Align = alLeft
      Caption = 'From: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object lblEnd: TLabel
      AlignWithMargins = True
      Left = 239
      Top = 4
      Width = 19
      Height = 21
      Align = alLeft
      Caption = 'To: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object edStart: TEdit
      AlignWithMargins = True
      Left = 41
      Top = 4
      Width = 192
      Height = 21
      Align = alLeft
      TabOrder = 0
      Text = 'Ypenburg, Den Haag'
    end
    object btnGetDirections: TButton
      AlignWithMargins = True
      Left = 594
      Top = 4
      Width = 93
      Height = 21
      Align = alRight
      Caption = 'Get Directions'
      TabOrder = 2
      OnClick = btnGetDirectionsClick
    end
    object edEnd: TEdit
      AlignWithMargins = True
      Left = 264
      Top = 4
      Width = 177
      Height = 21
      Align = alLeft
      TabOrder = 1
      Text = 'Haagweg, Rijswijk'
    end
  end
  object pnlURL: TPanel
    Left = 0
    Top = 434
    Width = 691
    Height = 28
    Align = alBottom
    TabOrder = 1
    object edURL: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 683
      Height = 20
      Align = alClient
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      ExplicitHeight = 21
    end
  end
  object TreeView1: TTreeView
    AlignWithMargins = True
    Left = 3
    Top = 32
    Width = 255
    Height = 399
    Margins.Right = 0
    Align = alLeft
    Indent = 19
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 262
    Top = 29
    Width = 429
    Height = 405
    Align = alClient
    TabOrder = 3
    ExplicitLeft = 280
    ExplicitTop = 248
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Splitter2: TSplitter
      Left = 1
      Top = 300
      Width = 427
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 314
    end
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 427
      Height = 299
      Align = alClient
      Columns = <
        item
          Caption = '#'
          Width = 45
        end
        item
          Caption = 'Start'
          Width = 0
        end
        item
          Caption = 'End'
          Width = 0
        end
        item
          Caption = 'Duration'
          Width = 60
        end
        item
          Caption = 'Distance'
          Width = 60
        end
        item
          AutoSize = True
          Caption = 'Instructions'
        end>
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 1
      Top = 304
      Width = 424
      Height = 97
      Margins.Left = 0
      Margins.Top = 0
      Align = alBottom
      TabOrder = 1
      WordWrap = False
    end
  end
end
