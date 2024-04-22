unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.Win.ADODB, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, Forms,
  FireDAC.Phys.Oracle, FireDAC.Phys.OracleDef, DBAccess, Uni, IniFiles,
  SQLServerUniProvider, OracleUniProvider, UniProvider, ODBCUniProvider, MemDS,
  uGlobal;

type
  TDM = class(TDataModule)
    ADODB: TADOConnection;
    qryTemp: TADOQuery;
    UniConnection1: TUniConnection;
    OracleUniProvider1: TOracleUniProvider;
    UniQuery1: TUniQuery;
    qryTemp2: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function ConnectDB: Boolean;
    procedure GetUnitInfoAll(var AUnitInfoArray: TUnitInfoArray; AParkNo: Word; AMyNo: Word);
    procedure GetCarInfo(var ACarInfo: TR_CAR_INFO);
    function TableCreateChk: Boolean;
    function SqlRunExec(var sqlTemp: TADOQuery; BufSql: string): Boolean;
    function SqlRunOpen(var sqlTemp: TADOQuery; BufSql: string): Boolean;
  end;

var
  DM: TDM;

implementation

uses
  uUnitInfo;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.ConnectDB: Boolean;
var
  sDBString: string;
begin
  Result := True;
  Log('ConnectDB : Start');

  //ini에서 DB접속 정보 획득
  iSetup := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\ParkSet.ini');
  with ConfigInfo do
  begin
    DBOption.ServerIP := iSetup.ReadString('PARKING', 'DB IP', '127.0.0.1,42130');
    DBOption.UserID   := iSetup.ReadString('PARKING', 'DB ID', 'sa');
    DBOption.Password := iSetup.ReadString('PARKING', 'DB PW', 'nexpa1234');
    DBOption.DBName   := iSetup.ReadString('PARKING', 'DB Name', 'PARKING');
  end;

  try
    with DM do
    begin
      // 넥스파 DB연결
      ADODB.Connected := False;
      sDBString := 'Provider=SQLOLEDB.1;Persist Security Info=True;';
      sDBString := sDBString + 'User ID=' + ConfigInfo.DBOption.UserID;
      sDBString := sDBString + ';Password=' + ConfigInfo.DBOption.Password;
      sDBString := sDBString + ';Initial Catalog=' + ConfigInfo.DBOption.DBName;
      sDBString := sDBString + ';Data Source=' + ConfigInfo.DBOption.ServerIP;
      ADODB.ConnectionString := sDBString;
      ADODB.Connected := True;
      Log('Nexpa ConnectDB : 넥스파 DB연동');
    end;
  except
    on E: exception do
    begin
      Log('Nexpa DB Connect Error:' + E.Message);
      Result := False;
      Exit;
    end;
  end;

  Log('ConnectDB : End');
end;

procedure TDM.GetUnitInfoAll(var AUnitInfoArray: TUnitInfoArray; AParkNo: Word; AMyNo: Word);
var
  BufSql: string;
  i: Integer;
begin
  AUnitInfoArray := nil;

  BufSql := '';
  BufSql := BufSql + ' SELECT ParkNo, UnitNo, UnitName, UnitKind, MyNo, ';
  BufSql := BufSql + '        Comport, Baudrate, IPNo, PortNo, ';
  BufSql := BufSql + '        Reserve1, Reserve2, Reserve3, Reserve4, Reserve5, ';
  BufSql := BufSql + '        Reserve6, Reserve7, Reserve8, Reserve9, Reserve10, ';
  BufSql := BufSql + '        FullDspGroupNo, DspType, RestrictionNo ';
  BufSql := BufSql + '   FROM UnitInfo ';
  BufSql := BufSql + '  WHERE ParkNo = ' + IntToStr(AParkNo);
  BufSql := BufSql + '    AND MyNo = ' + IntToStr(AMyNo);

  try
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      with qryTemp do
      begin
        SetLength(AUnitInfoArray, RecordCount);
        i := 0;
        if RecordCount > 0 then
        begin
          while not Eof do
          begin
            AUnitInfoArray[i] := TUnitInfoClass.Create;
            with AUnitInfoArray[i] do
            begin
              ParkNo := FieldByName('ParkNo').AsInteger;
              UnitNo := FieldByName('UnitNo').AsInteger;
              UnitName := FieldByName('UnitName').AsString;
              UnitKind := FieldByName('UnitKind').AsInteger;
              MyNo := FieldByName('MyNo').AsInteger;
              Comport := FieldByName('Comport').AsInteger;
              BaudRate := FieldByName('BaudRate').AsInteger;
              IPNo := FieldByName('IPNo').AsString;
              PortNo := FieldByName('PortNo').AsInteger;
              Reserve1 := FieldByName('Reserve1').AsString;
              Reserve2 := FieldByName('Reserve2').AsString;
              Reserve3 := FieldByName('Reserve3').AsString;
              Reserve4 := FieldByName('Reserve4').AsString;
              Reserve5 := FieldByName('Reserve5').AsString;
              Reserve6 := FieldByName('Reserve6').AsString;
              Reserve7 := FieldByName('Reserve7').AsString;
              Reserve8 := FieldByName('Reserve8').AsString;
              Reserve9 := FieldByName('Reserve9').AsString;
              Reserve10 := FieldByName('Reserve10').AsString;
              FullDspGroupNo := FieldByName('FullDspGroupNo').AsString;
              DspType := FieldByName('DspType').AsInteger;
              RestrictionNo := FieldByName('RestrictionNo').AsInteger;
            end;
            Inc(i);
            Next;
          end;
        end;
      end;
    end;
  except
    on E: exception do
    begin
      Log(' GetUnitInfoAll Exception : ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TDM.GetCarInfo(var ACarInfo: TR_CAR_INFO);
var
  BufSql: string;
begin
  BufSql := '';
  BufSql := BufSql + ' SELECT ParkNo, TKType, GroupNo, TKNo,   ';
  BufSql := BufSql + '        Name, CarNo, CompName, DeptName, ExpDateT ';
  BufSql := BufSql + '   FROM CustInfo ';
  BufSql := BufSql + '  WHERE ParkNo = ' + IntToStr(ACarInfo.ParkNo);
  BufSql := BufSql + '    AND CarNo = ' + QuotedStr(ACarInfo.CarNo);

  try
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      with qryTemp do
      begin
        if RecordCount > 0 then
        begin
          with ACarInfo do
          begin
            TKType := 2;
            GroupNo := FieldByName('GroupNo').AsInteger;
            CarType := TCarType.ctSeason;
            CompName := FieldByName('CompName').AsString;
            DeptName := FieldByName('DeptName').AsString;
            ;
            Name := FieldByName('Name').AsString;
            ExpDate := FieldByName('ExpDateT').AsString;
          end;
        end
        else
        begin
          with ACarInfo do
          begin
            TKType := 1;
            GroupNo := 0;
            CarType := TCarType.ctNormal;
            CompName := '';
            DeptName := '';
            Name := '';
            ExpDate := '';
          end;
        end;
      end;
    end;
  except
    on E: exception do
    begin
      Log(' GetCarInfo Exception : ' + E.Message);
      Exit;
    end;
  end;
end;

function TDM.TableCreateChk: Boolean;
var
  BufSql: string;
begin
  Result := True;

  {$region 'Menu'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''Menu''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if qryTemp.IsEmpty then
      begin
        BufSql := '';
        BufSql := BufSql + 'CREATE TABLE [dbo].[Menu](                        ';
        BufSql := BufSql + '    [MenuID] [int] NOT NULL,                      ';
        BufSql := BufSql + '    [MenuName] [nvarchar](50) NOT NULL,           ';
        BufSql := BufSql + '    [ParentID] [int] NULL,                        ';
        BufSql := BufSql + '    [Enabled] [tinyint] NULL,                     ';
        BufSql := BufSql + '    [Auth1] [tinyint] NULL,                       ';
        BufSql := BufSql + '    [Auth2] [tinyint] NULL,                       ';
        BufSql := BufSql + '    [Auth3] [tinyint] NULL,                       ';
        BufSql := BufSql + '    [Auth4] [tinyint] NULL,                       ';
        BufSql := BufSql + '    [Auth5] [tinyint] NULL,                       ';
        BufSql := BufSql + '  CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED (    ';
        BufSql := BufSql + '    [MenuID] ASC                                  ';
        BufSql := BufSql + ') WITH (PAD_INDEX = OFF                           ';
        BufSql := BufSql + '     , STATISTICS_NORECOMPUTE = OFF               ';
        BufSql := BufSql + '     , IGNORE_DUP_KEY = OFF                       ';
        BufSql := BufSql + '     , ALLOW_ROW_LOCKS = ON                       ';
        BufSql := BufSql + '     , ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]        ';
        BufSql := BufSql + ') ON [PRIMARY]                                    ';

        SqlRunExec(qryTemp, BufSql);

        BufSql := 'ALTER TABLE [dbo].[Menu] ADD  CONSTRAINT [DF_Menu_ParentID]  DEFAULT ((0)) FOR [ParentID]';
        SqlRunExec(qryTemp, BufSql);
      end;
    end;
  except

  end;
  {$endregion}

  {$region 'ParkInfo - HourlyFee, DaylyFeeMax column'}
  try
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        BufSql := '';
        BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
        BufSql := BufSql + ' WHERE TABLE_NAME = ''ParkInfo''          ';
        BufSql := BufSql + '   AND COLUMN_NAME = ''HourlyFee''               ';

        if SqlRunOpen(qryTemp, BufSql) then
        begin
          if qryTemp.IsEmpty then
          begin
            BufSql := '';
            BufSql := BufSql + 'ALTER TABLE [dbo].[ParkInfo]              ';
            BufSql := BufSql + '  ADD [HourlyFee] [int] DEFAULT 0         ';

            SqlRunExec(qryTemp, BufSql);
          end;
        end;

        //테이블이 있는 경우 특정 컬럼유무 확인
        BufSql := '';
        BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
        BufSql := BufSql + ' WHERE TABLE_NAME = ''ParkInfo''          ';
        BufSql := BufSql + '   AND COLUMN_NAME = ''DaylyFeeMax''               ';

        if SqlRunOpen(qryTemp, BufSql) then
        begin
          if qryTemp.IsEmpty then
          begin
            BufSql := '';
            BufSql := BufSql + 'ALTER TABLE [dbo].[ParkInfo]              ';
            BufSql := BufSql + '  ADD [DaylyFeeMax] [int] DEFAULT 0         ';

            Log(BufSql, 1);
            SqlRunExec(qryTemp, BufSql);
          end;
        end;
      end;
    end;
  except

  end;
  {$endregion}

  {$region 'CustInfoWP'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''CustInfo_WP''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if qryTemp.IsEmpty then
      begin
        BufSql := '';
        BufSql := BufSql + 'CREATE TABLE [dbo].[CustInfo_WP](                 ';
        BufSql := BufSql + '    [dong] [varchar](50) NOT NULL,                ';
        BufSql := BufSql + '    [ho] [varchar](50) NOT NULL,                  ';
        BufSql := BufSql + '    [AllotmentTime] [int] NULL,                   ';
        BufSql := BufSql + '    [UseTime] [int] NULL,                         ';
        BufSql := BufSql + '    [RemainTime] [int] NULL,                      ';
        BufSql := BufSql + '    [UpdateTime] [varchar](100) NULL,             ';
        BufSql := BufSql + '    [Yogum] [int] NULL,                           ';
        BufSql := BufSql + ' CONSTRAINT [PK_CustInfo_WP] PRIMARY KEY CLUSTERED (';
        BufSql := BufSql + '    [dong] ASC,                                   ';
        BufSql := BufSql + '    [ho] ASC                                      ';
        BufSql := BufSql + ') WITH (PAD_INDEX = OFF                           ';
        BufSql := BufSql + '     , STATISTICS_NORECOMPUTE = OFF               ';
        BufSql := BufSql + '     , IGNORE_DUP_KEY = OFF                       ';
        BufSql := BufSql + '     , ALLOW_ROW_LOCKS = ON                       ';
        BufSql := BufSql + '     , ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]        ';
        BufSql := BufSql + ') ON [PRIMARY]                                    ';

        SqlRunExec(qryTemp, BufSql);

        BufSql := 'ALTER TABLE [dbo].[CustInfo_WP] ADD  CONSTRAINT [DF_Table_1_allotment time]  DEFAULT ((0)) FOR [AllotmentTime]';
        SqlRunExec(qryTemp, BufSql);

        BufSql := 'ALTER TABLE [dbo].[CustInfo_WP] ADD  CONSTRAINT [DF_CustInfo_WP_Use Time]  DEFAULT ((0)) FOR [UseTime]';
        SqlRunExec(qryTemp, BufSql);

        BufSql := 'ALTER TABLE [dbo].[CustInfo_WP] ADD  CONSTRAINT [DF_CustInfo_WP_Remain Time]  DEFAULT ((0)) FOR [RemainTime]';
        SqlRunExec(qryTemp, BufSql);

        BufSql := 'ALTER TABLE [dbo].[CustInfo_WP] ADD  CONSTRAINT [DF_CustInfo_WP_Yogum]  DEFAULT ((0)) FOR [Yogum]';
        SqlRunExec(qryTemp, BufSql);
      end;
    end;
  except

  end;
  {$endregion}

  {$region 'CustInfo - WP column'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''CustInfo''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        BufSql := '';
        BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
        BufSql := BufSql + ' WHERE TABLE_NAME = ''CustInfo''          ';
        BufSql := BufSql + '   AND COLUMN_NAME = ''WP''               ';

        if SqlRunOpen(qryTemp, BufSql) then
        begin
          if qryTemp.IsEmpty then
          begin
            BufSql := '';
            BufSql := BufSql + 'ALTER TABLE [dbo].[CustInfo]          ';
            BufSql := BufSql + '  ADD [WP] [int] DEFAULT 0            ';

            SqlRunExec(qryTemp, BufSql);
          end;
        end;

      end;
    end;
  except

  end;
  {$endregion}

  {$region 'GGroup - WP column'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''GGroup''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        BufSql := '';
        BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
        BufSql := BufSql + ' WHERE TABLE_NAME = ''GGroup''            ';
        BufSql := BufSql + '   AND COLUMN_NAME = ''WP''               ';

        if SqlRunOpen(qryTemp, BufSql) then
        begin
          if qryTemp.IsEmpty then
          begin
            BufSql := '';
            BufSql := BufSql + 'ALTER TABLE [dbo].[GGroup]            ';
            BufSql := BufSql + '  ADD [WP] [int] DEFAULT 0            ';

            SqlRunExec(qryTemp, BufSql);
          end;
        end;

      end;
    end;
  except

  end;
  {$endregion}

  {$region 'VisitInfo - Visit_flag, updatetime, no, sSync_YN, sDelete_YN, period column'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''VisitInfo''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Visit_flag''       ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [Visit_flag] [varchar](1)       ';

              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''updatetime''       ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [updatetime] [varchar](50)      ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''no''               ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [no] [int] DEFAULT 0            ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''sSync_YN''         ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [sSync_YN] [varchar](1)         ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''sDelete_YN''       ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [sDelete_YN] [varchar](1)       ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''VisitInfo''         ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''period''           ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[VisitInfo]         ';
              BufSql := BufSql + '  ADD [period] [varchar](50)          ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;
      end;
    end;
  except

  end;
  {$endregion}

  {$region 'UnitInfo - Reserve6~10, RestrictionNo, DspType column'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''UnitInfo''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Reserve6''         ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]          ';
              BufSql := BufSql + '  ADD [Reserve6] [varchar](50)        ';

              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Reserve7''         ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]          ';
              BufSql := BufSql + '  ADD [Reserve7] [varchar](50)        ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Reserve8''         ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]          ';
              BufSql := BufSql + '  ADD [Reserve8] [varchar](50)        ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Reserve9''         ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]          ';
              BufSql := BufSql + '  ADD [Reserve9] [varchar](50)        ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''Reserve10''        ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]          ';
              BufSql := BufSql + '  ADD [Reserve10] [varchar](50)       ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;

        try
          BufSql := '';
          BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
          BufSql := BufSql + ' WHERE TABLE_NAME = ''UnitInfo''          ';
          BufSql := BufSql + '   AND COLUMN_NAME = ''RestrictionNo''    ';

          if SqlRunOpen(qryTemp, BufSql) then
          begin
            if qryTemp.IsEmpty then
            begin
              BufSql := '';
              BufSql := BufSql + 'ALTER TABLE [dbo].[UnitInfo]                ';
              BufSql := BufSql + '  ADD [RestrictionNo] [tinyint] DEFAULT 0   ';

              Log(BufSql, 1);
              SqlRunExec(qryTemp, BufSql);
            end;
          end;
        except

        end;
      end;
    end;
  except

  end;
  {$endregion}

  {$region 'Visit_Point - EndDateTime column'}
  try
    BufSql := 'SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''Visit_Point''';
    if SqlRunOpen(qryTemp, BufSql) then
    begin
      if not qryTemp.IsEmpty then
      begin
        //테이블이 있는 경우 특정 컬럼유무 확인
        BufSql := '';
        BufSql := BufSql + 'SELECT * FROM INFORMATION_SCHEMA.COLUMNS  ';
        BufSql := BufSql + ' WHERE TABLE_NAME = ''Visit_Point''       ';
        BufSql := BufSql + '   AND COLUMN_NAME = ''EndDateTime''      ';

        if SqlRunOpen(qryTemp, BufSql) then
        begin
          if qryTemp.IsEmpty then
          begin
            BufSql := '';
            BufSql := BufSql + 'ALTER TABLE [dbo].[Visit_Point]       ';
            BufSql := BufSql + '  ADD [EndDateTime] [datetime]        ';

            SqlRunExec(qryTemp, BufSql);
          end;
        end;

      end;
    end;
  except

  end;
  {$endregion}
end;

function TDM.SqlRunExec(var sqlTemp: TADOQuery; BufSql: string): Boolean;
begin
  Result := True;

  BufSql := StringReplace(BufSql, #9, '', [rfReplaceAll]);
  Log('** SqlRunExec : ' + BufSql, 2);

  with sqlTemp do
  try
    Close;
    SQL.Clear;
    SQL.Add(BufSql);
    ExecSQL;
  except
    on E: Exception do
    begin
      Result := False;
      Log(E.Message);
    end;
  end;
end;

function TDM.SqlRunOpen(var sqlTemp: TADOQuery; BufSql: string): Boolean;
begin
  Result := True;

  BufSql := StringReplace(BufSql, #9, '', [rfReplaceAll]);
  Log('** SqlRunOpen : ' + BufSql, 2);

  with sqlTemp do
  try
    Close;
    SQL.Clear;
    SQL.Add(BufSql);
    Open;
  except
    on E: Exception do
    begin
      Result := False;
      Log(E.Message);
    end;
  end;

end;

end.

