object FrameHomenet: TFrameHomenet
  Left = 0
  Top = 0
  Width = 867
  Height = 70
  TabOrder = 0
  object gbHomenet: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 861
    Height = 64
    Align = alClient
    Caption = 'Homenet'
    TabOrder = 0
    ExplicitHeight = 54
    object edtHomenetServer: TAdvEdit
      Left = 320
      Top = 27
      Width = 121
      Height = 23
      EmptyTextStyle = []
      FlatLineColor = 11250603
      FocusColor = clWindow
      FocusFontColor = 3881787
      LabelCaption = 'Server IP'
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
    object cmbUseHomenet1: TAdvComboBox
      Left = 120
      Top = 27
      Width = 121
      Height = 23
      Color = clWindow
      Version = '2.0.0.6'
      Visible = True
      ButtonWidth = 17
      EmptyTextStyle = []
      DropWidth = 0
      Enabled = True
      ItemIndex = -1
      Items.Strings = (
        #49324#50857#50504#54632
        #49324#50857)
      LabelCaption = 'To use'
      LabelPosition = lpLeftCenter
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -12
      LabelFont.Name = 'Segoe UI'
      LabelFont.Style = []
      TabOrder = 1
    end
    object AdvEdit1: TAdvEdit
      Left = 520
      Top = 27
      Width = 121
      Height = 23
      EmptyTextStyle = []
      FlatLineColor = 11250603
      FocusColor = clWindow
      FocusFontColor = 3881787
      LabelCaption = 'Port'
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
  end
end
