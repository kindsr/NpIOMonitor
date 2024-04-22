object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Nexpa In/Out Monitoring '
  ClientHeight = 562
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #45208#45588#49828#53272#50612' Bold'
  Font.Style = []
  Menu = mmMenu
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 349
    Width = 1012
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    ExplicitTop = 0
    ExplicitWidth = 352
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 1012
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
    ExplicitTop = 542
    ExplicitWidth = 1008
  end
  object pnlFormOption: TPanel
    Left = 0
    Top = 502
    Width = 1012
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 1
    Caption = 'pnlFormOption'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 501
    ExplicitWidth = 1008
    DesignSize = (
      1012
      41)
    object lbLprCount: TLabel
      Left = 876
      Top = 13
      Width = 22
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'LPR'
      ExplicitLeft = 892
    end
    object lbFramesInARow: TLabel
      Left = 680
      Top = 13
      Width = 90
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Frames in a row'
      ExplicitLeft = 696
    end
    object lbGridFontSize: TLabel
      Left = 480
      Top = 13
      Width = 97
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Font size of grids'
      ExplicitLeft = 496
    end
    object edtLprCount: TscGPSpinEdit
      Left = 904
      Top = 8
      Width = 74
      Height = 23
      FluentUIOpaque = False
      Options.NormalColor = clWindow
      Options.HotColor = clWindow
      Options.FocusedColor = clWindow
      Options.DisabledColor = clWindow
      Options.NormalColorAlpha = 200
      Options.HotColorAlpha = 255
      Options.FocusedColorAlpha = 255
      Options.DisabledColorAlpha = 150
      Options.FrameNormalColor = clBtnText
      Options.FrameHotColor = clHighlight
      Options.FrameFocusedColor = clHighlight
      Options.FrameDisabledColor = clBtnText
      Options.FrameWidth = 1
      Options.FrameNormalColorAlpha = 100
      Options.FrameHotColorAlpha = 255
      Options.FrameFocusedColorAlpha = 255
      Options.FrameDisabledColorAlpha = 50
      Options.FontNormalColor = clWindowText
      Options.FontHotColor = clWindowText
      Options.FontFocusedColor = clWindowText
      Options.FontDisabledColor = clGrayText
      Options.FocusedLineColor = clHighlight
      Options.FocusedLineWidth = 0
      Options.ShapeFillGradientAngle = 90
      Options.ShapeCornerRadius = 10
      Options.ShapeStyle = scgpessRect
      Options.ScaleFrameWidth = False
      Options.StyleColors = True
      ContentMarginLeft = 5
      ContentMarginRight = 5
      ContentMarginTop = 5
      ContentMarginBottom = 5
      PromptText = 'LprCount'
      HideMaskWithEmptyText = False
      HidePromptTextIfFocused = False
      PromptTextColor = clNone
      Transparent = True
      Increment = 1.000000000000000000
      UpDownKind = scupkLeftRight
      Alignment = taCenter
      ValueType = scvtInteger
      MaxValue = 16.000000000000000000
      MouseWheelSupport = True
      DisplayType = scedtNumeric
      ArrowGlyphColor = clWindowText
      ArrowGlyphColorAlpha = 180
      ArrowGlyphColorHotAlpha = 240
      ArrowGlyphColorPressedAlpha = 150
      Anchors = [akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      NumbersOnly = True
      TabOrder = 0
      OnChange = edtLprCountChange
      ExplicitLeft = 900
    end
    object edtFramesInARow: TscGPSpinEdit
      Left = 776
      Top = 8
      Width = 74
      Height = 23
      FluentUIOpaque = False
      Options.NormalColor = clWindow
      Options.HotColor = clWindow
      Options.FocusedColor = clWindow
      Options.DisabledColor = clWindow
      Options.NormalColorAlpha = 200
      Options.HotColorAlpha = 255
      Options.FocusedColorAlpha = 255
      Options.DisabledColorAlpha = 150
      Options.FrameNormalColor = clBtnText
      Options.FrameHotColor = clHighlight
      Options.FrameFocusedColor = clHighlight
      Options.FrameDisabledColor = clBtnText
      Options.FrameWidth = 1
      Options.FrameNormalColorAlpha = 100
      Options.FrameHotColorAlpha = 255
      Options.FrameFocusedColorAlpha = 255
      Options.FrameDisabledColorAlpha = 50
      Options.FontNormalColor = clWindowText
      Options.FontHotColor = clWindowText
      Options.FontFocusedColor = clWindowText
      Options.FontDisabledColor = clGrayText
      Options.FocusedLineColor = clHighlight
      Options.FocusedLineWidth = 0
      Options.ShapeFillGradientAngle = 90
      Options.ShapeCornerRadius = 10
      Options.ShapeStyle = scgpessRect
      Options.ScaleFrameWidth = False
      Options.StyleColors = True
      ContentMarginLeft = 5
      ContentMarginRight = 5
      ContentMarginTop = 5
      ContentMarginBottom = 5
      PromptText = 'Frame count in a row'
      HideMaskWithEmptyText = False
      HidePromptTextIfFocused = False
      PromptTextColor = clNone
      Transparent = True
      Increment = 1.000000000000000000
      UpDownKind = scupkLeftRight
      Alignment = taCenter
      ValueType = scvtInteger
      MinValue = 1.000000000000000000
      MaxValue = 6.000000000000000000
      MouseWheelSupport = True
      Value = 4.000000000000000000
      DisplayType = scedtNumeric
      ArrowGlyphColor = clWindowText
      ArrowGlyphColorAlpha = 180
      ArrowGlyphColorHotAlpha = 240
      ArrowGlyphColorPressedAlpha = 150
      Anchors = [akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 1
      OnChange = edtFramesInARowChange
      ExplicitLeft = 772
    end
    object edtGridFontSize: TscGPSpinEdit
      Left = 583
      Top = 8
      Width = 74
      Height = 23
      FluentUIOpaque = False
      Options.NormalColor = clWindow
      Options.HotColor = clWindow
      Options.FocusedColor = clWindow
      Options.DisabledColor = clWindow
      Options.NormalColorAlpha = 200
      Options.HotColorAlpha = 255
      Options.FocusedColorAlpha = 255
      Options.DisabledColorAlpha = 150
      Options.FrameNormalColor = clBtnText
      Options.FrameHotColor = clHighlight
      Options.FrameFocusedColor = clHighlight
      Options.FrameDisabledColor = clBtnText
      Options.FrameWidth = 1
      Options.FrameNormalColorAlpha = 100
      Options.FrameHotColorAlpha = 255
      Options.FrameFocusedColorAlpha = 255
      Options.FrameDisabledColorAlpha = 50
      Options.FontNormalColor = clWindowText
      Options.FontHotColor = clWindowText
      Options.FontFocusedColor = clWindowText
      Options.FontDisabledColor = clGrayText
      Options.FocusedLineColor = clHighlight
      Options.FocusedLineWidth = 0
      Options.ShapeFillGradientAngle = 90
      Options.ShapeCornerRadius = 10
      Options.ShapeStyle = scgpessRect
      Options.ScaleFrameWidth = False
      Options.StyleColors = True
      ContentMarginLeft = 5
      ContentMarginRight = 5
      ContentMarginTop = 5
      ContentMarginBottom = 5
      PromptText = 'Font size of grids'
      HideMaskWithEmptyText = False
      HidePromptTextIfFocused = False
      PromptTextColor = clNone
      Transparent = True
      Increment = 1.000000000000000000
      UpDownKind = scupkLeftRight
      Alignment = taCenter
      ValueType = scvtInteger
      MinValue = 8.000000000000000000
      MaxValue = 20.000000000000000000
      MouseWheelSupport = True
      Value = 12.000000000000000000
      DisplayType = scedtNumeric
      ArrowGlyphColor = clWindowText
      ArrowGlyphColorAlpha = 180
      ArrowGlyphColorHotAlpha = 240
      ArrowGlyphColorPressedAlpha = 150
      Anchors = [akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      TabOrder = 2
      OnChange = edtGridFontSizeChange
      ExplicitLeft = 579
    end
  end
  object pnlIOList: TPanel
    Left = 0
    Top = 352
    Width = 1012
    Height = 150
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlIOList'
    ShowCaption = False
    TabOrder = 2
    ExplicitTop = 351
    ExplicitWidth = 1008
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 497
      Height = 150
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'In List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #45208#45588#49828#53272#50612' Bold'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      VerticalAlignment = taAlignTop
      object sgIn: TAdvStringGrid
        AlignWithMargins = True
        Left = 3
        Top = 20
        Width = 491
        Height = 127
        Margins.Top = 20
        Align = alClient
        ColCount = 9
        DefaultColWidth = 75
        DefaultColAlignment = taCenter
        DefaultRowHeight = 30
        DefaultDrawing = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        HintColor = clYellow
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'MS Sans Serif'
        ActiveCellFont.Style = []
        ActiveCellColor = 10344697
        ActiveCellColorTo = 6210033
        CellNode.ShowTree = False
        ColumnHeaders.Strings = (
          #52264#47049#51333#47448
          #51077#52264#51068#51088
          #51077#52264#49884#44033
          #52264#47049#48264#54840
          #46041'/'#54840
          #49457#47749
          #50976#54952#44592#44036
          #48169#47928#47785#51201
          #51077#52264#46972#51064)
        ControlLook.FixedGradientFrom = 16513526
        ControlLook.FixedGradientTo = 15260626
        ControlLook.FixedGradientHoverFrom = clGray
        ControlLook.FixedGradientHoverTo = clWhite
        ControlLook.FixedGradientDownFrom = clGray
        ControlLook.FixedGradientDownTo = clSilver
        ControlLook.ControlStyle = csClassic
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'MS Sans Serif'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        DefaultAlignment = taCenter
        EnhRowColMove = False
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'MS Sans Serif'
        FilterDropDown.Font.Style = []
        FilterDropDown.TextChecked = 'Checked'
        FilterDropDown.TextUnChecked = 'Unchecked'
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedColWidth = 75
        FixedRowHeight = 30
        FixedFont.Charset = ANSI_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -16
        FixedFont.Name = #47569#51008' '#44256#46357
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HTMLSettings.ImageFolder = 'images'
        HTMLSettings.ImageBaseName = 'img'
        Navigation.AllowInsertRow = True
        Navigation.AllowDeleteRow = True
        Navigation.AdvanceOnEnter = True
        Navigation.AdvanceInsert = True
        Navigation.AdvanceAuto = True
        Navigation.InsertPosition = pInsertAfter
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.Centered = False
        PrintSettings.PagePrefix = 'page'
        PrintSettings.PageNumSep = '/'
        ScrollBarAlways = saBoth
        ScrollWidth = 16
        SearchFooter.Color = 16773091
        SearchFooter.ColorTo = 16765615
        SearchFooter.FindNextCaption = 'Find next'
        SearchFooter.FindPrevCaption = 'Find previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        SelectionColor = 6210033
        SelectionTextColor = clWindowText
        ShowDesignHelper = False
        URLColor = clBlack
        Version = '8.7.2.6'
        WordWrap = False
        ColWidths = (
          75
          75
          75
          75
          75
          75
          75
          75
          75)
        RowHeights = (
          30
          30)
      end
    end
    object pnlRight: TPanel
      Left = 497
      Top = 0
      Width = 515
      Height = 150
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Out List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #45208#45588#49828#53272#50612' Bold'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      VerticalAlignment = taAlignTop
      ExplicitWidth = 511
      object sgOut: TAdvStringGrid
        AlignWithMargins = True
        Left = 3
        Top = 20
        Width = 509
        Height = 127
        Margins.Top = 20
        Align = alClient
        ColCount = 9
        DefaultColWidth = 75
        DefaultColAlignment = taCenter
        DefaultRowHeight = 30
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #47569#51008' '#44256#46357
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        HintColor = clYellow
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'MS Sans Serif'
        ActiveCellFont.Style = []
        ActiveCellColor = 10344697
        ActiveCellColorTo = 6210033
        CellNode.ShowTree = False
        ColumnHeaders.Strings = (
          #52264#47049#51333#47448
          #52636#52264#51068#51088
          #52636#52264#49884#44033
          #52264#47049#48264#54840
          #46041'/'#54840
          #49457#47749
          #50976#54952#44592#44036
          #48169#47928#47785#51201
          #52636#52264#46972#51064)
        ControlLook.FixedGradientFrom = 16513526
        ControlLook.FixedGradientTo = 15260626
        ControlLook.FixedGradientHoverFrom = clGray
        ControlLook.FixedGradientHoverTo = clWhite
        ControlLook.FixedGradientDownFrom = clGray
        ControlLook.FixedGradientDownTo = clSilver
        ControlLook.ControlStyle = csClassic
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'MS Sans Serif'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        DefaultAlignment = taCenter
        EnhRowColMove = False
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'MS Sans Serif'
        FilterDropDown.Font.Style = []
        FilterDropDown.TextChecked = 'Checked'
        FilterDropDown.TextUnChecked = 'Unchecked'
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Clear')
        FixedColWidth = 75
        FixedRowHeight = 30
        FixedFont.Charset = ANSI_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -16
        FixedFont.Name = #47569#51008' '#44256#46357
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HTMLSettings.ImageFolder = 'images'
        HTMLSettings.ImageBaseName = 'img'
        Navigation.AllowInsertRow = True
        Navigation.AllowDeleteRow = True
        Navigation.AdvanceOnEnter = True
        Navigation.AdvanceInsert = True
        Navigation.AdvanceAuto = True
        Navigation.InsertPosition = pInsertAfter
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.Centered = False
        PrintSettings.PagePrefix = 'page'
        PrintSettings.PageNumSep = '/'
        ScrollBarAlways = saBoth
        ScrollWidth = 16
        SearchFooter.Color = 16773091
        SearchFooter.ColorTo = 16765615
        SearchFooter.FindNextCaption = 'Find next'
        SearchFooter.FindPrevCaption = 'Find previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        SelectionColor = 6210033
        SelectionTextColor = clWindowText
        ShowDesignHelper = False
        URLColor = clBlack
        Version = '8.7.2.6'
        WordWrap = False
        ColWidths = (
          75
          75
          75
          75
          75
          75
          75
          75
          75)
        RowHeights = (
          30
          30)
      end
    end
  end
  object pnlLprFrames: TPanel
    Left = 0
    Top = 0
    Width = 1012
    Height = 349
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlLprFrames'
    ShowCaption = False
    TabOrder = 3
    OnResize = pnlLprFramesResize
    ExplicitWidth = 1008
    ExplicitHeight = 348
  end
  object mmMenu: TMainMenu
    Left = 960
    Top = 48
    object miSetting: TMenuItem
      Caption = 'Setting'
      object miConfigOperating: TMenuItem
        Action = actConfigOperating
      end
      object miConfigUnit: TMenuItem
        Action = actConfigUnit
      end
      object miBlacklistAlarm: TMenuItem
        Action = actBlacklistAlarm
        Caption = 'Alarm Blacklist'
      end
    end
    object miIOList: TMenuItem
      Caption = 'In/Out List'
    end
  end
  object ActionList1: TActionList
    Left = 904
    Top = 48
    object actConfigUnit: TAction
      Category = 'Configuration'
      Caption = 'Set Unit'
    end
    object actConfigOperating: TAction
      Category = 'Configuration'
      Caption = 'Set Operating'
    end
    object actBlacklistAlarm: TAction
      Category = 'Configuration'
      Caption = 'Blacklist Alarm'
      SecondaryShortCuts.Strings = (
        'X')
    end
  end
end
