object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 431
  ClientWidth = 1023
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object spl2: TSplitter
    Left = 225
    Top = 41
    Height = 371
    ExplicitLeft = 190
    ExplicitTop = 35
  end
  object spl1: TSplitter
    Left = 436
    Top = 41
    Height = 371
    ExplicitLeft = 442
    ExplicitTop = 47
  end
  object stat1: TStatusBar
    Left = 0
    Top = 412
    Width = 1023
    Height = 19
    Panels = <>
    ExplicitWidth = 637
  end
  object lstFields: TListBox
    AlignWithMargins = True
    Left = 231
    Top = 44
    Width = 202
    Height = 365
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
    ExplicitLeft = 234
    ExplicitTop = 41
  end
  object pnlTables: TPanel
    Left = 0
    Top = 41
    Width = 225
    Height = 371
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 35
    object srchTable: TSearchBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 219
      Height = 21
      Align = alTop
      TabOrder = 0
      OnInvokeSearch = srchTableInvokeSearch
      ExplicitLeft = 24
      ExplicitTop = 0
      ExplicitWidth = 121
    end
    object lstTables: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 30
      Width = 219
      Height = 338
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = lstTablesDblClick
      ExplicitTop = 44
      ExplicitWidth = 190
      ExplicitHeight = 365
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1023
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 1
    ExplicitTop = 1
    ExplicitWidth = 223
    object btnFillTables: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 35
      Align = alLeft
      Caption = 'btnFillTables'
      TabOrder = 0
      OnClick = btnFillTablesClick
    end
  end
  object pnlSource: TPanel
    Left = 439
    Top = 41
    Width = 584
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitLeft = 560
    ExplicitTop = 104
    ExplicitWidth = 377
    ExplicitHeight = 241
    object edtSource: TSynEdit
      AlignWithMargins = True
      Left = 3
      Top = 44
      Width = 578
      Height = 324
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 0
      CodeFolding.CollapsedLineColor = clGrayText
      CodeFolding.FolderBarLinesColor = clGrayText
      CodeFolding.ShowCollapsedLine = True
      CodeFolding.IndentGuidesColor = clGray
      CodeFolding.IndentGuides = True
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.ShowLineNumbers = True
      Highlighter = SynPasSyn1
      Lines.Strings = (
        'edtSource')
      WantTabs = True
      FontSmoothing = fsmNone
      ExplicitLeft = 442
      ExplicitHeight = 365
    end
    object pnlSourceToolbar: TPanel
      Left = 0
      Top = 0
      Width = 584
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 128
      ExplicitTop = 64
      ExplicitWidth = 185
      object btnSourceGenerator: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 35
        Action = acnSourceGenerate
        Align = alLeft
        TabOrder = 0
        ExplicitLeft = 8
        ExplicitTop = 16
        ExplicitHeight = 25
      end
      object cbbClassType: TComboBox
        Left = 88
        Top = 10
        Width = 145
        Height = 21
        ItemIndex = 0
        TabOrder = 1
        Text = 'Main'
        Items.Strings = (
          'Main'
          'Entity'
          'Dao')
      end
    end
  end
  object SynPasSyn1: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    KeyAttri.Foreground = clBlue
    Left = 480
    Top = 104
  end
  object aclSource: TActionList
    Left = 487
    Top = 177
    object acnSourceGenerate: TAction
      Caption = 'Generate'
      OnExecute = acnSourceGenerateExecute
    end
  end
end
