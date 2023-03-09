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
  WindowState = wsMaximized
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
  object stat1: TStatusBar
    Left = 0
    Top = 412
    Width = 1023
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object pnlTables: TPanel
    Left = 0
    Top = 41
    Width = 225
    Height = 371
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object spl3: TSplitter
      Left = 0
      Top = 220
      Width = 225
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 339
    end
    object srchTable: TSearchBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 219
      Height = 21
      Align = alTop
      TabOrder = 0
      OnInvokeSearch = srchTableInvokeSearch
    end
    object lstTables: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 30
      Width = 219
      Height = 187
      Align = alTop
      ItemHeight = 13
      TabOrder = 1
      OnDblClick = lstTablesDblClick
    end
    object lstFields: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 226
      Width = 219
      Height = 142
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1023
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
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
    Left = 228
    Top = 41
    Width = 795
    Height = 371
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object edtSource: TSynEdit
      AlignWithMargins = True
      Left = 3
      Top = 44
      Width = 789
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
    end
    object pnlSourceToolbar: TPanel
      Left = 0
      Top = 0
      Width = 795
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btnSourceGenerator: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 35
        Action = acnSourceGenerate
        Align = alLeft
        TabOrder = 0
      end
      object cbbClassType: TComboBox
        Left = 88
        Top = 10
        Width = 145
        Height = 21
        Style = csDropDownList
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
