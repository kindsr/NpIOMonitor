object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 637
  ClientWidth = 1293
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 856
    Height = 637
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 852
    ExplicitHeight = 636
    inline FrameHomenet1: TFrameHomenet
      Left = 0
      Top = 0
      Width = 856
      Height = 113
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 852
      ExplicitHeight = 113
      inherited gbHomenet: TGroupBox
        Width = 850
        Height = 107
        ExplicitWidth = 846
        ExplicitHeight = 107
      end
    end
  end
  object Panel2: TPanel
    Left = 856
    Top = 0
    Width = 437
    Height = 637
    Align = alRight
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 852
    ExplicitHeight = 636
    object gbMainButtons: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 565
      Width = 431
      Height = 69
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #47569#51008' '#44256#46357
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitTop = 564
      object Label1: TLabel
        Left = 186
        Top = 7
        Width = 4
        Height = 13
        Color = clBtnFace
        ParentColor = False
      end
      object lbLangs: TLabel
        Left = 7
        Top = 13
        Width = 96
        Height = 13
        Caption = 'Interface language:'
      end
      object btnApply: TButton
        Left = 346
        Top = 36
        Width = 75
        Height = 25
        Action = actApply
        TabOrder = 4
      end
      object btnClose: TButton
        Left = 263
        Top = 36
        Width = 75
        Height = 25
        Action = actClose
        Cancel = True
        TabOrder = 3
      end
      object btnOK: TButton
        Left = 180
        Top = 36
        Width = 75
        Height = 25
        Action = actOK
        TabOrder = 1
      end
      object cbRunOnWindowsStart: TCheckBox
        Left = 7
        Top = 39
        Width = 167
        Height = 19
        Caption = 'Run at Windows start'
        TabOrder = 0
        OnClick = cbRunOnWindowsStartChange
      end
      object cbLangs: TComboBox
        Left = 180
        Top = 9
        Width = 241
        Height = 21
        AutoCloseUp = True
        Style = csDropDownList
        TabOrder = 2
        OnChange = cbLangsChange
      end
    end
    object gbBasicInfo: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 431
      Height = 86
      Align = alTop
      Caption = 'DB Info'
      TabOrder = 1
      object edtDbIP: TAdvEdit
        Left = 72
        Top = 21
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'Server'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 0
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
      object edtDbID: TAdvEdit
        Left = 272
        Top = 21
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'ID'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 2
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
      object edtDbPW: TAdvEdit
        Left = 272
        Top = 50
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'Password'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 3
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
      object edtDbName: TAdvEdit
        Left = 72
        Top = 50
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'DB Name'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 1
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
    end
    object gbOperating: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 95
      Width = 431
      Height = 464
      Align = alClient
      Caption = 'Operating'
      TabOrder = 2
      ExplicitHeight = 463
      object edtUnitNo: TAdvEdit
        Left = 72
        Top = 24
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'UnitNo'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 0
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
      object edt: TAdvEdit
        Left = 72
        Top = 53
        Width = 138
        Height = 23
        EmptyTextStyle = []
        FlatLineColor = 11250603
        FocusColor = clWindow
        FocusFontColor = 3881787
        LabelCaption = 'UnitNo'
        LabelPosition = lpLeftCenter
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -12
        LabelFont.Name = 'Segoe UI'
        LabelFont.Style = []
        Lookup.Font.Charset = DEFAULT_CHARSET
        Lookup.Font.Color = clWindowText
        Lookup.Font.Height = -11
        Lookup.Font.Name = 'Segoe UI'
        Lookup.Font.Style = []
        Lookup.Separator = ';'
        Color = clWindow
        TabOrder = 1
        Text = ''
        Visible = True
        Version = '4.0.4.1'
      end
    end
  end
  object ppConfigMenu: TPopupMenu
    Left = 1247
    Top = 144
    object ppCMConfig: TMenuItem
      Caption = 'Options...'
      OnClick = ppCMConfigClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object ppCMExit: TMenuItem
      Caption = 'Exit'
      OnClick = ppCMExitClick
    end
  end
  object TrayIcon: TTrayIcon
    Hint = 'Nexpa IO Monitoring '
    PopupMenu = ppConfigMenu
    Visible = True
    OnDblClick = TrayIconDblClick
    Left = 1247
    Top = 82
  end
  object ActionList: TActionList
    Left = 1247
    Top = 21
    object actAdd: TAction
      Category = 'Elements'
      Caption = 'Add'
    end
    object actAddSub: TAction
      Category = 'Elements'
      Caption = 'Add child'
    end
    object actCopy: TAction
      Category = 'Elements'
      Caption = 'Copy'
    end
    object actDel: TAction
      Category = 'Elements'
      Caption = 'Delete'
    end
    object actOK: TAction
      Category = 'Main'
      Caption = 'OK'
      Hint = 'Save and close options'
      OnExecute = actOKExecute
      OnUpdate = actOKUpdate
    end
    object actApply: TAction
      Category = 'Main'
      Caption = 'Apply'
      Hint = 'Apply options without closing window'
      OnExecute = actApplyExecute
      OnUpdate = actApplyUpdate
    end
    object actClose: TAction
      Category = 'Main'
      Caption = 'Close'
      Hint = 'Cancel and close options'
      OnExecute = actCloseExecute
      OnUpdate = actCloseUpdate
    end
    object actItemUp: TAction
      Category = 'Main'
      Caption = 'Up'
    end
    object actItemDown: TAction
      Category = 'Main'
      Caption = 'Down'
    end
  end
end
