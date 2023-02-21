object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 431
  ClientWidth = 637
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
  object spl1: TSplitter
    Left = 407
    Top = 41
    Height = 371
    ExplicitLeft = 200
    ExplicitTop = 80
    ExplicitHeight = 100
  end
  object spl2: TSplitter
    Left = 196
    Top = 41
    Height = 371
    ExplicitLeft = 190
    ExplicitTop = 35
  end
  object lstTables: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 190
    Height = 365
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = lstTablesDblClick
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
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
  object stat1: TStatusBar
    Left = 0
    Top = 412
    Width = 637
    Height = 19
    Panels = <>
  end
  object lstFields: TListBox
    AlignWithMargins = True
    Left = 202
    Top = 44
    Width = 202
    Height = 365
    Align = alLeft
    ItemHeight = 13
    TabOrder = 3
    ExplicitLeft = 199
  end
  object edtSource: TSynEdit
    AlignWithMargins = True
    Left = 413
    Top = 44
    Width = 221
    Height = 365
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 4
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
    FontSmoothing = fsmNone
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
end
