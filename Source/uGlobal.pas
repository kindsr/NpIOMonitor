unit uGlobal;

interface

uses
  Forms, Vcl.Controls, System.Classes, System.SysUtils, IniFiles, Winapi.Windows,
  uUnitInfo, System.Win.ScktComp, Generics.Collections, uThreadFileLog, AdvGrid,
  StrUtils;

const
  MSG_BAR_OPEN = 'BAR_OPEN_1';
  MSG_BAR_CLOSE = 'BAR_CLOSE_1';
  MSG_BAR_OPEN_LOCK = 'BAR_OPEN_LOCK_1';
  MSG_BAR_OPEN_UNLOCK = 'BAR_OPEN_UNLOCK_1';
  PRG_NAME = 'NpIOMonitor';
  REG_KEY = 'Software\Nexpa\';

type
  TCarType = (ctSeason, ctVisit, ctNormal, ctEmergency, ctCommercial);
  TCarTypeHelper = record Helper for TCarType
    function ToString: string; inline;
  end;

type
  TUnitInfoArray = array of TUnitInfoClass;

type
  TR_MAINFORM_OPTION = record
    Visible: Boolean;
    LogLevel: Word;
    LprCount: Word;
    FrameInARow: Word;
    GridFontSize: Word;
  end;

  TR_DATABASE_INFO = record
    ServerIP: string;
    UserID: string;
    Password: string;
    DBName: string;
  end;

  TR_CONFIG = packed record
    ParkNo: Word;
    UnitGroupNo: Word;
    LprImagePath: string;
    MainFormOption: TR_MAINFORM_OPTION;
    DBOption: TR_DATABASE_INFO;
  end;

type
  TR_LPR_CLIENT = packed record
    nCurrParkNo : Integer;
    nIndex      : Integer;
    nIO         : Integer;
    nNo         : Integer;
    sLprIP      : AnsiString;
    sDspIP      : AnsiString;
    sLprData    : AnsiString;
//    csLPR       : TClientSocket;
    uFrame      : TFrame;
  end;

  TR_LPR_MAINSUB = packed record
    MainLpr: TR_LPR_CLIENT;
    SubLpr : TR_LPR_CLIENT;
  end;

  TR_LPR_PACKET_PARSE = packed record
    bResult,
    bUP        : Boolean;
    bExit      : Boolean;
    sLocal1    : string;
    sLocal2    : string;
    sTemp      : string;
    sTime      : string;
    sGroup     : string;
    sCarNo1    : string;
    sCarNo2    : string;
    sFile1     : string;
    sFile2     : string;
    nRecog1    : integer;
    nRecog2    : integer;
    bInBarOpen : Boolean;
    nNo        : Integer;
    sDir       : string;
    sImgFile1  : string;
    sImgFile2  : string;
  end;

  TR_CAR_INFO = packed record
    ParkNo    : Word;
    TKType    : Word;
    GroupNo   : Word;
    CarType   : TCarType;
    UnitNo    : Word;
    UnitName  : string;
    LprDate   : string;
    LprTime   : string;
    CarNo     : string;
    CompName  : string;
    DeptName  : string;
    Name      : string;
    ExpDate   : string;
    Status    : string;
  end;

var
  sCurrRunDir: AnsiString;
  //환경설정 저장용 IniFile
  iSetup: TIniFile;
  ConfigInfo: TR_CONFIG;
  IsDBConnected: Boolean;
  MainFormState: Integer; // 0 : 기본 , 1 : 최대화
  IsInitialized: Boolean = False;
  AllUnitInfo: TUnitInfoArray;
  InLprInfo: TUnitInfoArray;
  OutLprInfo: TUnitInfoArray;

  // Global Queue
  InQueue: TQueue<TR_LPR_CLIENT>;
  OutQueue: TQueue<TR_LPR_CLIENT>;

  // LogFileThread
  ThreadFileLog : TThreadFileLog;

function RecursiveReplace(const s, ARemoveStr: string): string;
procedure DelaySleep(SleepSecs : Cardinal; Flg : Boolean = True);

function GetNow(): string;

procedure NormalLogging(sMsg: AnsiString);

procedure ExceptLogging(sMsg: AnsiString; isStartEnd: boolean = False);

procedure HomeInfoLogging(sMsg: AnsiString);

procedure Log(AText: string; ALevel: Integer=0);

procedure ClearComponent(AComponent: TComponent);

function GetCarTypeName(ACarType: TCarType): string;
function GetCarTypeByName(ACarTypeName: string): TCarType;

procedure ConnectToSocketServer(var ALprInfoArray: TUnitInfoArray; const ALprFrameGroup: TArray<TFrame>; var ANextIndex: Integer);
function fParsingLprPacket(const buf: TR_LPR_CLIENT): TR_LPR_PACKET_PARSE;
function fSaveImgFiles( var buf: TR_LPR_PACKET_PARSE; clit: TR_LPR_CLIENT ): Boolean;

procedure InsertGridData(var AGrid: TAdvStringGrid; const ACarInfo: TR_CAR_INFO);

function MG_StrToStr(cStr: AnsiString; cFmt: AnsiString): AnsiString;
function MG_ReplaceStr(src, cSrcChar, cDestChar: AnsiString): AnsiString;
function MG_StrConvert(sSrc, sOrg, sDet: AnsiString): AnsiString;

implementation

uses
  DateUtils, uFrmConfig, uFrameLpr;


function RecursiveReplace(const s, ARemoveStr: string): string;
begin
  if Pos(ARemoveStr, s) > 0 then
    Result := RecursiveReplace(StringReplace(s, ARemoveStr, '', [rfReplaceAll]), ARemoveStr)
  else
    Result := s;
end;

procedure DelaySleep(SleepSecs : Cardinal; Flg : Boolean = True);
var
  StartValue : LongInt;
begin
  StartValue := GetTickCount;
  while ((GetTickCount - StartValue) <= (SleepSecs)) do
  begin
    if Flg then Sleep(63);
    Application.ProcessMessages;
  end;
end;

function GetNow(): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ';
end;

procedure NormalLogging(sMsg: AnsiString);
var
  nFile: Integer;
  sFile: AnsiString;
begin
  sFile := sCurrRunDir + '\Non_Reg\' + FormatDateTime('YYMMDD', Now) + '_Non_Reg.log';

  if FileExists(sFile) then
  begin
    nFile := FileOpen(sFile, fmOpenWrite);
    FileSeek(nFile, 0, 2);
  end
  else
  begin
    nFile := FileCreate(sFile);
  end;

  if nFile <> -1 then
  begin
    sFile := '[' + FormatDateTime('hh:nn:ss', Now) + '] ' + sMsg + #13 + #10;
    FileWrite(nFile, PAnsichar(sFile)^, Length(sFile));
    FileClose(nFile);
  end;
end;

procedure ExceptLogging(sMsg: AnsiString; isStartEnd: boolean = False);
var
  nFile: Integer;
  sFile: AnsiString;
begin
  sFile := sCurrRunDir + '\Log\' + FormatDateTime('YYMMDD', Now) + '.log';

  ForceDirectories(sCurrRunDir + '\Log\');

  if FileExists(sFile) then
  begin
    nFile := FileOpen(sFile, fmOpenWrite);
    FileSeek(nFile, 0, 2);
  end
  else
  begin
    nFile := FileCreate(sFile);
  end;

  if nFile <> -1 then
  begin
    if isStartEnd = True then
      sFile := '**************************************************************' + #13#10 + '[' + FormatDateTime('hh:nn:ss', Now) + '] ' + sMsg + #13 + #10
    else
      sFile := '[' + FormatDateTime('hh:nn:ss', Now) + '] ' + sMsg + #13 + #10;
    FileWrite(nFile, PAnsichar(sFile)^, Length(sFile));
    FileClose(nFile);
  end;
end;

procedure HomeInfoLogging(sMsg: AnsiString);
var
  nFile: Integer;
  sFile: AnsiString;
begin
  sFile := sCurrRunDir + '\Log\' + FormatDateTime('YYMMDD', Now) + '_HomeInfo.log';

  if FileExists(sFile) then
  begin
    nFile := FileOpen(sFile, fmOpenWrite);
    FileSeek(nFile, 0, 2);
  end
  else
  begin
    nFile := FileCreate(sFile);
  end;

  if nFile <> -1 then
  begin
    sFile := '[' + FormatDateTime('hh:nn:ss', Now) + '] ' + sMsg + #13 + #10;
    FileWrite(nFile, PAnsichar(sFile)^, Length(sFile));
    FileClose(nFile);
  end;
end;

procedure Log(AText: string; ALevel: Integer=0);
begin
//  if ALevel >  then
//  begin
//    {$IFDEF DEBUG}
//    Assert(False, AText);
//    {$ENDIF}
//  end
//  else
//  begin
//    Assert(False, AText);
//  end;
  if ALevel <= ConfigInfo.MainFormOption.LogLevel then
    Assert(False, AText);
end;

procedure ClearComponent(AComponent: TComponent);
begin

end;

function GetCarTypeName(ACarType: TCarType): string;
begin
  case ACarType of
    ctSeason: Result := '정기차량';
    ctVisit: Result := '방문차량';
    ctNormal: Result := '일반차량';
    ctEmergency: Result := '긴급차량';
    ctCommercial: Result := '영업차량';
  end;
end;

function GetCarTypeByName(ACarTypeName: string): TCarType;
var
  TmpCarType: TCarType;
begin
  for TmpCarType := Low(TCarType) to High(TCarType) do
  begin
    if Pos(ACarTypeName, GetCarTypeName(TmpCarType)) > 0 then
    begin
      Result := TmpCarType;
      Exit;
    end;
  end;
end;

procedure ConnectToSocketServer(var ALprInfoArray: TUnitInfoArray; const ALprFrameGroup: TArray<TFrame>; var ANextIndex: Integer);
begin
  for var i := Low(ALprInfoArray) to High(ALprInfoArray) do
  begin
    with TFrameLpr(ALprFrameGroup[ANextIndex]) do
    begin
      UnitName := ALprInfoArray[i].UnitName;
      UnitInfo := ALprInfoArray[i];
      Active := True;
    end;
    Inc(ANextIndex);
  end;
end;

function fParsingLprPacket(const buf: TR_LPR_CLIENT): TR_LPR_PACKET_PARSE;
var
  sTemp: string;
begin

  FillChar(Result, SizeOf(TR_LPR_PACKET_PARSE), #0);

  Result.bResult := True;

  try
    // NW, NP, UP가 올 경우는 차단기를 오픈하지 않는다. 2012-06-15...
    Result.bInBarOpen := False; //bInBarOpen1 := False;

    if (Copy(buf.sLprData, 1, 2) = 'NW') then
    begin
      Result.sGroup := 'NW';

      // 후면촬영결과가 전면촬영차량과 다르다. (새로운 차량이다)
      // NW제거
      Result.sTemp := Copy(buf.sLprData, Pos('#', buf.sLprData) + 1, Length(buf.sLprData) - Pos('#', buf.sLprData));

      // CH제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 차량번호 추출
      Result.sCarNo1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog1 := 1
      else if Copy(Result.sTemp, 1, 1) = 'P' then
        Result.nRecog1 := 2
      else
        Result.nRecog1 := 3;

      Result.sFile1 := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - (Pos('#', Result.sTemp)));
      Result.sLocal1 := Copy(Result.sFile1, Pos('CH', Result.sFile1), Length(Result.sFile1) - (Pos('CH', Result.sFile1) - 1));

      Result.sTime := MG_StrToStr(Copy(Result.sFile1, Pos('_', Result.sFile1) + 1, 14), '####-##-## ##:##:##');

      // 인식여부제거하여 파일명 추출
      Result.sFile1 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Result.sFile1, '\', '/');
    end
    else if (Copy(buf.sLprData, 1, 2) = 'UP') then
    begin
      Result.sGroup := 'UP';

      // 오인식으로 전면과 후면촬영결과가 다르다...
      // 이때는 CarNo1과 CarNo2, Image1, Image2를 구분하여 넣는다.
      // 전면차량번호와 입차일시를 가지고 DB검색하여 CarNo2와 Image2를 업데이트한다.

      // UP제거
      Result.sTemp := Copy(buf.sLprData, Pos('#', buf.sLprData) + 1, Length(buf.sLprData) - Pos('#', buf.sLprData));

      // CH제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 차량번호1 추출
      Result.sCarNo1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부1 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog1 := 1
      else if (Copy(Result.sTemp, 1, 1) = 'P') then
        Result.nRecog1 := 2
      else
        Result.nRecog1 := 3;

      // 인식여부1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 파일명1 추출
      // Copy(Results.sTemp, Pos('#', Results.sTemp)+1, Length( Results.sTemp)-Pos('#', Results.sTemp));
      Result.sFile1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);
      Result.sLocal1 := Copy(Result.sFile1, Pos('CH', Result.sFile1), Length(Result.sFile1) - (Pos('CH', Result.sFile1) - 1));

      Result.sTime := MG_StrToStr(Copy(Result.sFile1, Pos('_', Result.sFile1) + 1, 14), '####-##-## ##:##:##');

      // 인식여부제거하여 파일명 추출
      Result.sFile1 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Result.sFile1, '\', '/');

      // 파일명1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // CH제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 차량번호2 추출
      Result.sCarNo2 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호2제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부2 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog2 := 1
      else if (Copy(Result.sTemp, 1, 1) = 'P') then
        Result.nRecog2 := 2
      else
        Result.nRecog2 := 3;

      Result.sLocal2 := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));
      Result.sLocal2 := Copy(Result.sLocal2, Pos('CH', Result.sLocal2), Length(Result.sLocal2) - (Pos('CH', Result.sLocal2) - 1));

      // 인식여부2제거하여 파일명2 추출
      Result.sFile2 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp)), '\', '/');

      Result.bUP := True;
      Result.bExit := True;

    end
    else if (Copy(buf.sLprData, 1, 2) = 'NP') then
    begin
      Result.sGroup := 'NP';

      // 전면촬영된 차량과 후면촬영된 차량이 다르다.
      // 이때는 CarNo2를 개별차량으로 하여 신규입차처리한다.
      // CarNo2, File2, Recog2, Time2 로 신규입차 처리.

      // NP제거
      Result.sTemp := Copy(buf.sLprData, Pos('#', buf.sLprData) + 1, Length(buf.sLprData) - Pos('#', buf.sLprData));

      // CH제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 차량번호1 추출
      Result.sCarNo1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부1 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog1 := 1
      else if Copy(Result.sTemp, 1, 1) = 'P' then
        Result.nRecog1 := 2
      else
        Result.nRecog1 := 3;

      // 인식여부1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 파일명1 추출
      Result.sFile1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1); // Copy(Results.sTemp, Pos('#', Results.sTemp)+1, Length(Results.sTemp)-Pos('#', Results.sTemp));
      Result.sLocal1 := Copy(Result.sFile1, Pos('CH', Result.sFile1), Length(Result.sFile1) - (Pos('CH', Result.sFile1) - 1));
      Result.sTime := MG_StrToStr(Copy(Result.sFile1, Pos('_', Result.sFile1) + 1, 14), '####-##-## ##:##:##');

      // 인식여부제거하여 파일명 추출
      Result.sFile1 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Result.sFile1, '\', '/');

      // 파일명1제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // CH제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 차량번호2 추출
      Result.sCarNo2 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호2제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부2 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog2 := 1
      else if Copy(Result.sTemp, 1, 1) = 'P' then
        Result.nRecog2 := 2
      else
        Result.nRecog2 := 3;

      Result.sLocal2 := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));
      Result.sLocal2 := Copy(Result.sLocal2, Pos('CH', Result.sLocal2), Length(Result.sLocal2) - (Pos('CH', Result.sLocal2) - 1));
      Result.sFile2 := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));
      Result.sTime := MG_StrToStr(Copy(Result.sFile2, Pos('_', Result.sFile2) + 1, 14), '####-##-## ##:##:##');

      // 인식여부2제거하여 파일명2 추출
      Result.sFile2 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Result.sFile2, '\', '/');
      Result.sCarNo1 := Result.sCarNo2;
      Result.sFile1 := Result.sFile2;
      Result.nRecog1 := Result.nRecog2;
      Result.sLocal1 := Result.sLocal2;
      Result.sCarNo2 := '';
      Result.sFile2 := '';
      Result.nRecog2 := 0;
      Result.sLocal2 := '';
    end
    else
    begin
      //---------
      // in case
      //---------
      //bInBarOpen1 := True;
      Result.bInBarOpen := True;
      Result.sGroup := 'ETC';

      // CH제거
      Result.sTemp := Copy(buf.sLprData, Pos('#', buf.sLprData) + 1, Length(buf.sLprData) - Pos('#', buf.sLprData));

      // 차량번호 추출
      Result.sCarNo1 := Copy(Result.sTemp, 1, Pos('#', Result.sTemp) - 1);

      // 차량번호제거
      Result.sTemp := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));

      // 인식여부 추출
      if (Copy(Result.sTemp, 1, 1) = 'N') or (Copy(Result.sTemp, 1, 1) = 'O') then
        Result.nRecog1 := 1
      else if Copy(Result.sTemp, 1, 1) = 'P' then
        Result.nRecog1 := 2
      else
        Result.nRecog1 := 3;

      // 인식여부제거하여 파일명 추출
      Result.sFile1 := Copy(Result.sTemp, Pos('#', Result.sTemp) + 1, Length(Result.sTemp) - Pos('#', Result.sTemp));
      Result.sLocal1 := Copy(Result.sFile1, Pos('CH', Result.sFile1), Length(Result.sFile1) - (Pos('CH', Result.sFile1) - 1));
      Result.sTime := MG_StrToStr(Copy(Result.sFile1, Pos('_', Result.sFile1) + 1, 14), '####-##-## ##:##:##');

      // 인식여부제거하여 파일명 추출
      Result.sFile1 := 'http://' + buf.sLprIP + ':9080/MSImage' + MG_ReplaceStr(Result.sFile1, '\', '/');
    end;

    sTemp := Format('sCarNo1(%s),sCarNo2(%s),sFile1(%s),sFile2(%s),nRecog1(%d),nRecog2(%d),sGroup(%s)', [Result.sCarNo1, Result.sCarNo2, Result.sFile1, Result.sFile2, Result.nRecog1, Result.nRecog2, Result.sGroup]);
    Log(sTemp);

  except
    on E: Exception do
    begin
      Result.bResult := False;
      Log(E.Message);
    end;
  end;
end;

function fSaveImgFiles( var buf: TR_LPR_PACKET_PARSE; clit: TR_LPR_CLIENT ): Boolean;
begin

  buf.sDir := ConfigInfo.LprImagePath+ '\' +
              Copy( buf.sTime, 1, 4) + '\' +
              Copy( buf.sTime, 6, 2) + '\' +
              Copy( buf.sTime, 9, 2) + '\' + IntToStr(clit.nNo);

  if( not DirectoryExists( buf.sDir ) )then
  begin
    if( not ForceDirectories( buf.sDir ) )then
    begin
      Assert( false, '*이미지저장폴더 생성실패: ' + buf.sDir );
    end;
  end;

  buf.sImgFile1 := buf.sDir + '\' + buf.sLocal1;
  buf.sImgFile2 := buf.sDir + '\' + buf.sLocal2;

  if( buf.sFile1 <> '' )then
  begin
    buf.sTemp     := Copy( buf.sFile1, 6, Length( buf.sFile1 ) - 5);
    buf.sImgFile1 := Copy( buf.sTemp, 1, Pos(':9080', buf.sTemp) - 1);
    buf.sImgFile1 := buf.sImgFile1 + Copy( buf.sTemp, Pos(':9080', buf.sTemp ) + 5, Length( buf.sTemp ) - (Pos(':9080', buf.sTemp ) + 4));
    buf.sImgFile1 := MG_StrConvert( buf.sImgFile1, '/', '\');

    Assert( false, '*Save File(1): ' + buf.sImgFile1);
  end;

  if( buf.sFile2 <> '' )then
  begin
    buf.sTemp := Copy( buf.sFile2, 6, Length( buf.sFile2) - 5);
    buf.sImgFile2 := Copy( buf.sTemp, 1, Pos(':9080', buf.sTemp) - 1);
    buf.sImgFile2 := buf.sImgFile2 + Copy(buf.sTemp, Pos(':9080', buf.sTemp) + 5, Length( buf.sTemp) - (Pos(':9080', buf.sTemp) + 4));
    buf.sImgFile2 := MG_StrConvert( buf.sImgFile2, '/', '\');

    Assert( false, '*Save File(2): ' + buf.sImgFile2);
  end;
end;

procedure InsertGridData(var AGrid: TAdvStringGrid; const ACarInfo: TR_CAR_INFO);
begin
  with AGrid do
  begin
    InsertRows(1, 1, True);
    Cells[0, 1] := ACarInfo.CarType.ToString;
    Cells[1, 1] := ACarInfo.LprDate;
    Cells[2, 1] := ACarInfo.LprTime;
    Cells[3, 1] := ACarInfo.CarNo;
    Cells[4, 1] := IfThen(string.IsNullOrEmpty(ACarInfo.CompName), '', ACarInfo.CompName + '/' + ACarInfo.DeptName);
    Cells[5, 1] := ACarInfo.Name;
    Cells[6, 1] := ACarInfo.ExpDate;
    Cells[7, 1] := ACarInfo.Status;
    Cells[8, 1] := ACarInfo.UnitName;

    if RowCount > 30 then
      RemoveRows(RowCount-1, 1);

    AutoSizeRows(False, Font.Size);
    DefaultRowHeight := RowHeights[RowCount-1];
  end;
end;

function MG_StrToStr(cStr: AnsiString; cFmt: AnsiString): AnsiString;
var
  cBuf: AnsiString;
  i, j, nSrcLen: Integer;
begin
  j := 0;
  nSrcLen := Length(cStr);
  cBuf := '';

  for i := 1 to Length(cFmt) do
  begin
    case cFmt[i] of
      '#':
        begin
          j := j + 1;
          if j > nSrcLen then
            cBuf := cBuf + ' '
          else
            cBuf := cBuf + cStr[j];
        end;
    else
      cBuf := cBuf + cFmt[i];
    end;
  end;
  Result := cBuf;
end;

function MG_ReplaceStr(src, cSrcChar, cDestChar: AnsiString): AnsiString;
var
  sBuf: AnsiString;
  i: Integer;
begin
  sBuf := '';

  for i := 1 to Length(src) do
  begin
    if src[i] = cSrcChar then
      sBuf := sBuf + cDestChar
    else
      sBuf := sBuf + src[i];
  end;
  Result := sBuf;
end;

function MG_StrConvert(sSrc, sOrg, sDet: AnsiString): AnsiString;
var
  sBuf: AnsiString;
  i: Integer;
begin
  sBuf := '';

  for i := 1 to Length(sSrc) do
    if sSrc[i] = sOrg then
      sBuf := sBuf + sDet
    else
      sBuf := sBuf + sSrc[i];

  MG_StrConvert := sBuf;
end;


{ TCarTypeHelper }

function TCarTypeHelper.ToString: string;
begin
  Result := GetCarTypeName(Self);
end;

initialization
  InQueue := TQueue<TR_LPR_CLIENT>.Create;
  OutQueue := TQueue<TR_LPR_CLIENT>.Create;
  ThreadFileLog := TThreadFileLog.Create;

finalization
  if InQueue <> nil then
  begin
    InQueue.Free;
    InQueue := nil;
  end;
  if OutQueue <> nil then
  begin
    OutQueue.Free;
    OutQueue := nil;
  end;
  ThreadFileLog.Free;

end.

