object fmCompare: TfmCompare
  Left = 0
  Top = 0
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1085#1072#1073#1086#1088#1072' MD5'
  ClientHeight = 669
  ClientWidth = 921
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
    Left = 612
    Top = 0
    Height = 320
    Align = alRight
    ExplicitLeft = 331
    ExplicitTop = -39
    ExplicitHeight = 146
  end
  object spl2: TSplitter
    Left = 0
    Top = 320
    Width = 921
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 293
  end
  object pnlDetails: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 326
    Width = 915
    Height = 340
    Align = alBottom
    Caption = 'pnlDetails'
    ShowCaption = False
    TabOrder = 0
    object gridDetails: TStringGrid
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 907
      Height = 332
      Align = alClient
      ColCount = 3
      DrawingStyle = gdsClassic
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
      TabOrder = 0
      OnDblClick = gridDetailsDblClick
      ExplicitHeight = 182
      ColWidths = (
        210
        560
        110)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object pnlSums: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 606
    Height = 314
    Align = alClient
    Caption = 'pnlDetails'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 334
    ExplicitHeight = 404
    DesignSize = (
      606
      314)
    object gridMD5: TStringGrid
      AlignWithMargins = True
      Left = 4
      Top = 49
      Width = 598
      Height = 261
      Margins.Top = 48
      Align = alClient
      ColCount = 2
      DrawingStyle = gdsClassic
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
      TabOrder = 0
      ExplicitWidth = 326
      ExplicitHeight = 306
      ColWidths = (
        85
        211)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
    object btnAdd: TButton
      Left = 4
      Top = 16
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDel: TButton
      Left = 248
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = btnDelClick
    end
    object btnSave: TButton
      Left = 504
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = btnSaveClick
    end
  end
  object pnlFiles: TPanel
    AlignWithMargins = True
    Left = 618
    Top = 3
    Width = 300
    Height = 314
    Align = alRight
    Caption = 'pnlDetails'
    ShowCaption = False
    TabOrder = 2
    ExplicitHeight = 408
    object gridFiles: TStringGrid
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 292
      Height = 306
      Align = alClient
      ColCount = 2
      DrawingStyle = gdsClassic
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
      TabOrder = 0
      OnSelectCell = gridFilesSelectCell
      ExplicitWidth = 564
      ExplicitHeight = 396
      ColWidths = (
        201
        51)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object dlgOpenMD5: TOpenDialog
    Filter = '*.md5|*.md5|*.sha1|*.sha1'
    Options = [ofReadOnly, ofAllowMultiSelect, ofPathMustExist, ofShareAware, ofEnableIncludeNotify, ofEnableSizing]
    Left = 43
    Top = 251
  end
end
