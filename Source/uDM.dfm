object DM: TDM
  Height = 231
  Width = 456
  object ADODB: TADOConnection
    ConnectionString = 
      'Provider=ADsDSOObject;User ID=FORVIP;Encrypt Password=False;Data' +
      ' Source="(DESCRIPTION=(ADDRESS = (PROTOCOL = tcp)(HOST = 211.177' +
      '.131.185)(PORT = 1522))";Mode=Read;Bind Flags=0;ADSI Flag=1'
    LoginPrompt = False
    Provider = 'ADsDSOObject'
    Left = 47
    Top = 24
  end
  object qryTemp: TADOQuery
    Connection = ADODB
    Parameters = <>
    Left = 159
    Top = 32
  end
  object UniConnection1: TUniConnection
    SpecificOptions.Strings = (
      'Oracle.Direct=True')
    Left = 48
    Top = 96
  end
  object OracleUniProvider1: TOracleUniProvider
    Left = 48
    Top = 152
  end
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    Left = 160
    Top = 96
  end
  object qryTemp2: TADOQuery
    Connection = ADODB
    Parameters = <>
    Left = 223
    Top = 32
  end
end
