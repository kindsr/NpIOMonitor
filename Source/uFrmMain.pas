unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Math,
  Vcl.StdCtrls, Vcl.Mask, scGPExtControls, System.Actions, Vcl.ActnList,
  Vcl.Menus, Vcl.WinXCtrls, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid,
  System.Win.Registry, IOUtils, uGlobal, Generics.Collections, StrUtils;

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    pnlFormOption: TPanel;
    edtLprCount: TscGPSpinEdit;
    mmMenu: TMainMenu;
    miSetting: TMenuItem;
    miIOList: TMenuItem;
    ActionList1: TActionList;
    actConfigOperating: TAction;
    miConfigOperating: TMenuItem;
    miConfigUnit: TMenuItem;
    actConfigUnit: TAction;
    miBlacklistAlarm: TMenuItem;
    actBlacklistAlarm: TAction;
    pnlIOList: TPanel;
    pnlLprFrames: TPanel;
    edtFramesInARow: TscGPSpinEdit;
    Splitter1: TSplitter;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    sgIn: TAdvStringGrid;
    sgOut: TAdvStringGrid;
    edtGridFontSize: TscGPSpinEdit;
    lbLprCount: TLabel;
    lbFramesInARow: TLabel;
    lbGridFontSize: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtLprCountChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure edtFramesInARowChange(Sender: TObject);
    procedure pnlLprFramesResize(Sender: TObject);
    procedure edtGridFontSizeChange(Sender: TObject);
  private
    procedure DrawFrames(AFrameCount: Integer; const AFrameGroup: TArray<TFrame>; const AFlag: Integer =0);
    procedure DrawAutoSizeGrid(const ASize: Integer; var AGrid: TAdvStringGrid);
    procedure AddFrame(var AFrameGroup: TArray<TFrame>);
    procedure RemoveFrame(var AFrameGroup: TArray<TFrame>);
    procedure CreateLprThread;
    { Private declarations }
  public
    procedure LoadState;
    procedure SaveState;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  _preLprCount: Word;
  _preFramesInARow: Word;
  _LprFrameGroup: TArray<TFrame>;
  _FramesInARow: Word;
  _GridFontSize: Word;

implementation

uses
  uFrameLpr, uDM, uUnitInfo;

{$R *.dfm}

procedure TfrmMain.edtFramesInARowChange(Sender: TObject);
begin
  _FramesInARow := TscGPSpinEdit(Sender).ValueAsInt;
  DrawFrames(_preLprCount, _LprFrameGroup, 1);
  _preFramesInARow := _FramesInARow;
end;

procedure TfrmMain.edtGridFontSizeChange(Sender: TObject);
var
  i, j: Integer;
begin
  _GridFontSize := TscGPSpinEdit(Sender).ValueAsInt;
  DrawAutoSizeGrid(_GridFontSize, sgIn);
  DrawAutoSizeGrid(_GridFontSize, sgOut);
end;

procedure TfrmMain.edtLprCountChange(Sender: TObject);
var
  LprCount, LastIndex: Word;
  iLeft, iTop, i: Integer;
begin
  LprCount := TscGPSpinEdit(Sender).ValueAsInt;

  try
    if LprCount > _preLprCount then
    begin
      // Increasement
      for i := 0 to (LprCount - _preLprCount) - 1 do
        AddFrame(_LprFrameGroup);
    end
    else if LprCount < _preLprCount then
    begin
      // Decreasement
      for i := 0 to (_preLprCount - LprCount) - 1 do
        RemoveFrame(_LprFrameGroup);
    end
    else
    begin
      if LprCount = Length(_LprFrameGroup) then Exit;

      for i := 1 to LprCount do
      begin
        AddFrame(_LprFrameGroup);
      end;
    end;
  except
    on E: Exception do
      Assert(False, E.Message);
  end;

  _preLprCount := LprCount;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveState;
  Action := TCloseAction.caNone;
  Hide;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if not IsInitialized then Exit;
  
  DrawFrames(_preLprCount, _LprFrameGroup, 1);
  pnlLeft.Width := pnlIOList.Width div 2;
  DrawAutoSizeGrid(_GridFontSize, sgIn);
  DrawAutoSizeGrid(_GridFontSize, sgOut);

  StatusBar1.Top := ClientHeight - 1;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  TmpLprCount,i: Integer;
begin
  LoadState;
  pnlFormOption.Visible := ConfigInfo.MainFormOption.Visible;
  if IsInitialized then Exit;

  // 업무 시작 로직
  // Load ParkInfo

  // Load UnitInfo
  Log('*** Load All UnitInfo Setting ');
  DM.GetUnitInfoAll(AllUnitInfo, ConfigInfo.ParkNo, ConfigInfo.UnitGroupNo);

  // InLpr, OutLpr 갯수 및 세팅
  SetLength(InLprInfo, 0);
  SetLength(OutLprInfo, 0);
  TmpLprCount := 0;
  for i := Low(AllUnitInfo) to High(AllUnitInfo) do
  begin
    if (AllUnitInfo[i].UnitKind in [8,9]) then
    begin
      case AllUnitInfo[i].UnitKind of
        8:
          begin
            SetLength(InLprInfo, Length(InLprInfo)+1);
            InLprInfo[Length(InLprInfo)-1] := TUnitInfoClass.Create;
            InLprInfo[Length(InLprInfo)-1] := AllUnitInfo[i];
          end;
        9:
          begin
            SetLength(OutLprInfo, Length(OutLprInfo)+1);
            OutLprInfo[Length(OutLprInfo)-1] := TUnitInfoClass.Create;
            OutLprInfo[Length(OutLprInfo)-1] := AllUnitInfo[i];
          end;
      end;
      Inc(TmpLprCount);
    end;
  end;
  Log('*** Set In/Out Lpr List : ' + IntToStr(TmpLprCount));

  // 세팅불러온 값과 DB상 LPR갯수가 맞지 않으면 화면 다시 그림
  if TmpLprCount <> _preLprCount then
  begin
    edtLprCount.Value := TmpLprCount;
    _preLprCount := TmpLprCount;

    for i := 0 to Length(_LprFrameGroup)-1 do
    begin
      RemoveFrame(_LprFrameGroup);
    end;
    for i := 1 to _preLprCount do
    begin
      AddFrame(_LprFrameGroup);
    end;
  end;

  // LPR Socket Connect
  Log('*** LPR Socket Connect at each frame ');
  i := 0;
  ConnectToSocketServer(InLprInfo, _LprFrameGroup, i);
  ConnectToSocketServer(OutLprInfo, _LprFrameGroup, i);

  // Set Dsp UnitInfo if exists
  Log('*** Set Dsp UnitInfo at the LprInfo ');
  for i  := Low(AllUnitInfo) to High(AllUnitInfo) do
  begin
    for var tmp := Low(InLprInfo) to High(InLprInfo) do
    begin
      if (AllUnitInfo[i].MyNo = InLprInfo[tmp].MyNo) and (AllUnitInfo[i].IPNo = InLprInfo[tmp].Reserve1) and (AllUnitInfo[i].UnitKind in [10,11]) then
      begin
        InLprInfo[tmp].DspUnitInfo := AllUnitInfo[i];
      end;
    end;

    for var tmp := Low(OutLprInfo) to High(OutLprInfo) do
    begin
      if (AllUnitInfo[i].MyNo = OutLprInfo[tmp].MyNo) and (AllUnitInfo[i].IPNo = OutLprInfo[tmp].Reserve1) and (AllUnitInfo[i].UnitKind in [10,11]) then
      begin
        OutLprInfo[tmp].DspUnitInfo := AllUnitInfo[i];
      end;
    end;
  end;

  // Create LprThread in/out
  CreateLprThread;

  IsInitialized := True;
end;

procedure TfrmMain.pnlLprFramesResize(Sender: TObject);
begin
  DrawFrames(_preLprCount, _LprFrameGroup, 1);
end;

procedure TfrmMain.DrawFrames(AFrameCount: Integer; const AFrameGroup: TArray<TFrame>; const AFlag: Integer =0 );
begin
  for var i := Low(AFrameGroup) to High(AFrameGroup) do
  begin
    AFrameGroup[i].Height := pnlLprFrames.Height div (((AFrameCount-AFlag) div _FramesInARow)+1);
    AFrameGroup[i].Top := AFrameGroup[i].Height * (i div _FramesInARow);
    AFrameGroup[i].Width := pnlLprFrames.Width div _FramesInARow;
    AFrameGroup[i].Left := AFrameGroup[i].Width * (i mod _FramesInARow);
  end;
end;

procedure TfrmMain.DrawAutoSizeGrid(const ASize: Integer; var AGrid: TAdvStringGrid);
var
  i, j: Integer;
begin
  with AGrid do
  begin
    MinRowHeight := 10;
    Font.Size := ASize;
    FixedFont.Size := ASize;
    DefaultRowHeight := ASize + 4;

    for i := 1 to RowCount-1 do
    begin
      for j := 0 to ColCount-1 do
      begin
        FontSizes[j, i] := ASize;
//        AutoSizeCol(j);
      end;
//      AutoSizeRow(i);
    end;

    AutoSizeRows(True, ASize);
    AutoSizeColumns(True, ASize + 20);
  end;
end;

procedure TfrmMain.AddFrame(var AFrameGroup: TArray<TFrame>);
var
  LastIndex: Word;
begin
  SetLength(AFrameGroup, Length(AFrameGroup)+1);
  LastIndex := Length(AFrameGroup)-1;

  AFrameGroup[LastIndex] := TFrameLpr.Create(pnlLprFrames);
  with AFrameGroup[LastIndex] do
  begin
    Name := 'FrameLpr'+IntToStr(LastIndex);
    Tag := LastIndex;
    Width := pnlLprFrames.Width div _FramesInARow;
    Height := pnlLprFrames.Height div ((LastIndex div _FramesInARow)+1);
    Left := Width * (LastIndex mod _FramesInARow);
    Top := Height * (LastIndex div _FramesInARow);
    Parent := pnlLprFrames;
  end;

  TFrameLpr(pnlLprFrames.FindChildControl(AFrameGroup[LastIndex].Name)).UnitName := AFrameGroup[LastIndex].Name;
  TFrameLpr(pnlLprFrames.FindChildControl(AFrameGroup[LastIndex].Name)).FrameIndex := LastIndex;

  DrawFrames(LastIndex, AFrameGroup, 0);
end;

procedure TfrmMain.RemoveFrame(var AFrameGroup: TArray<TFrame>);
var
  LastIndex: Word;
begin
  LastIndex := Length(AFrameGroup)-1;
  AFrameGroup[LastIndex].Free;
  AFrameGroup[LastIndex] := nil;
  SetLength(AFrameGroup, LastIndex);
  DrawFrames(LastIndex, AFrameGroup, 1);
end;

procedure TfrmMain.CreateLprThread;
var
  InLprThread: TThread;
  OutLprThread: TThread;
begin
  InLprThread := TThread.CreateAnonymousThread(
    procedure
    var
      LprBuf: TR_LPR_CLIENT;
      Parse: TR_LPR_PACKET_PARSE;
      CarInfo: TR_CAR_INFO;
    begin
      while not Application.Terminated do
      begin
        Sleep(20);

        if InQueue.Count > 0 then
        begin
          LprBuf := InQueue.Dequeue;
          Log( 'InQueue.Dequeue : ' + LprBuf.sLprData);

          // LprData Parse
          Log( '**step.1) LPR.패킷.파싱하기');
          Parse := fParsingLprPacket(LprBuf);
          Log( LprBuf.sLprIP + ' : ' + Parse.sCarNo1 + '/' + Parse.sCarNo2 + ' - ' + Parse.sImgFile1);

          // Save image file
          fSaveImgFiles(Parse, LprBuf);

          // Set Car Info
          FillChar(CarInfo, SizeOf(TR_CAR_INFO), #0);
          CarInfo.ParkNo := LprBuf.nCurrParkNo;
          CarInfo.UnitName := TFrameLpr(LprBuf.uFrame).UnitName;
          CarInfo.LprDate := Copy(Parse.sTime, 1, 10);
          CarInfo.LprTime := Copy(Parse.sTime, 12, 8);
          CarInfo.CarNo := Parse.sCarNo1;
          DM.GetCarInfo(CarInfo);

          // Find the frame to show info
          with TFrameLpr(LprBuf.uFrame) do
          begin
            CarType := Copy(CarInfo.CarType.ToString, 1, 2);
            CarNo := CarInfo.CarNo;
            DeptInfo := IfThen(string.IsNullOrEmpty(CarInfo.CompName), '', CarInfo.CompName + '/' + CarInfo.DeptName);
            ImagePath := Parse.sImgFile1;
          end;

          // Insert Car Data into the grid
          InsertGridData(sgIn, CarInfo);

          // StatusBar text
          frmMain.StatusBar1.Panels[0].Text := TFrameLpr(LprBuf.uFrame).UnitName + ' : ' + CarInfo.CarType.ToString + ' ' + CarInfo.CarNo;
        end;
      end;
    end
  );

  InLprThread.FreeOnTerminate := True;
  InLprThread.Start;

  if InLprThread.Started then
    Log( '*** InLprThread Start! ' );

  OutLprThread := TThread.CreateAnonymousThread(
    procedure
    var
      LprBuf: TR_LPR_CLIENT;
      Parse: TR_LPR_PACKET_PARSE;
      CarInfo: TR_CAR_INFO;
    begin
      while not Application.Terminated do
      begin
        Sleep(20);

        if OutQueue.Count > 0 then
        begin
          LprBuf := OutQueue.Dequeue;
          Log( 'OutQueue.Dequeue : ' + LprBuf.sLprData);

          // LprData Parse
          Log( '**step.1) LPR.패킷.파싱하기');
          Parse := fParsingLprPacket(LprBuf);
          Log( LprBuf.sLprIP + ' : ' + Parse.sCarNo1 + '/' + Parse.sCarNo2 + ' - ' + Parse.sImgFile1);

          // Save image file
          fSaveImgFiles(Parse, LprBuf);

          // Set Car Info
          FillChar(CarInfo, SizeOf(TR_CAR_INFO), #0);
          CarInfo.ParkNo := LprBuf.nCurrParkNo;
          CarInfo.UnitName := TFrameLpr(LprBuf.uFrame).UnitName;
          CarInfo.LprDate := Copy(Parse.sTime, 1, 10);
          CarInfo.LprTime := Copy(Parse.sTime, 12, 8);
          CarInfo.CarNo := Parse.sCarNo1;
          DM.GetCarInfo(CarInfo);

          // Find the frame to show info
          with TFrameLpr(LprBuf.uFrame) do
          begin
            CarType := CarInfo.CarType.ToString;
            CarNo := CarInfo.CarNo;
            DeptInfo := IfThen(string.IsNullOrEmpty(CarInfo.CompName), '', CarInfo.CompName + '/' + CarInfo.DeptName);
            ImagePath := Parse.sImgFile1;
          end;

          // Insert Car Data into the grid
          InsertGridData(sgOut, CarInfo);

          // StatusBar text
          frmMain.StatusBar1.Panels[0].Text := TFrameLpr(LprBuf.uFrame).UnitName + ' : ' + CarInfo.CarType.ToString + ' ' + CarInfo.CarNo;
        end;
      end;
    end
  );

  OutLprThread.FreeOnTerminate := True;
  OutLprThread.Start;

  if OutLprThread.Started then
    Log( '*** OutLprThread Start! ' );

end;

{$region 'Registry'}
procedure TfrmMain.LoadState;
var
  R: TRegistry;
  iMonitorSearch, iMonitorCount: Integer;
  iScreenWidth, iScreenHeight: Integer;
  i: Integer;
begin
  R := TRegistry.Create(KEY_READ);
  try
    try
      R.RootKey := HKEY_CURRENT_USER;
      if R.KeyExists(REG_KEY+TPath.GetFileNameWithoutExtension(Application.ExeName)+'\') then
      begin
        if R.OpenKey(REG_KEY+TPath.GetFileNameWithoutExtension(Application.ExeName)+'\', False) then
        begin
          try
            if R.ValueExists('MainFormState') then
              MainFormState := R.ReadInteger('MainFormState')
            else
              MainFormState := 0;

            if R.ValueExists('Left') then
              Left := R.ReadInteger('Left')
            else
              Left := (Screen.monitors[0].Width div 2) - (ClientWidth div 2);

            if R.ValueExists('Top') then
            begin
              Top := R.ReadInteger('Top');
              if Top < 0 then
                Top := 0;
            end
            else
              Top := (Screen.monitors[0].Height div 2) - (ClientHeight div 2);

            if R.ValueExists('ClientHeight') then
              ClientHeight := R.ReadInteger('ClientHeight')
            else
              ClientHeight := 620;

            if R.ValueExists('ClientWidth') then
              ClientWidth := R.ReadInteger('ClientWidth')
            else
              ClientWidth := 1024;

            // event 오류 방지를 위해 전역변수 먼저 로드
            if R.ValueExists('edtLprCount') then
              _preLprCount := R.ReadInteger('edtLprCount')
            else
              _preLprCount := 0;

            if R.ValueExists('edtFramesInARow') then
              _FramesInARow := R.ReadInteger('edtFramesInARow')
            else
              _FramesInARow := 4;

            if R.ValueExists('edtGridFontSize') then
              _GridFontSize := R.ReadInteger('edtGridFontSize')
            else
              _GridFontSize := 12;

            for i := 0 to ComponentCount-1 do
            begin
              if Components[i].ClassType = TscGPSpinEdit then
              begin
                if R.ValueExists(TscGPSpinEdit(Components[i]).Name) then
                  TscGPSpinEdit(Components[i]).Value := R.ReadInteger(TscGPSpinEdit(Components[i]).Name);
              end
              else if Components[i].ClassType = TPanel then
              begin
                if (Pos('pnlIOList', TPanel(Components[i]).Name) > 0) and (R.ValueExists(TPanel(Components[i]).Name))  then
                begin
                  TPanel(Components[i]).Align := alBottom;
                  TPanel(Components[i]).Height := R.ReadInteger(TPanel(Components[i]).Name);
                  pnlFormOption.Align := alBottom;
                  pnlFormOption.Top := TPanel(Components[i]).Top + TPanel(Components[i]).Height + 1;
                  Splitter1.Align := alBottom;
                  Splitter1.Top := TPanel(Components[i]).Top - 1;
                end;
              end;
            end;
          finally
            R.CloseKey;
          end;
        end
        else
        begin
          //Failed to open registry key
        end;
      end
      else
      begin
        //Registry key does not exist
        Left := (Screen.Width div 2) - (ClientWidth div 2);
        Top := (Screen.Height div 2) - (ClientHeight div 2);
        _preLprCount := 0;
        _FramesInARow := 4;
        _GridFontSize := 12;
      end;
    except

    end;
  finally
    R.Free;
  end;
end;

procedure TfrmMain.SaveState;
var
  R: TRegistry;
  i: Integer;
begin
  R := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    try
      R.RootKey := HKEY_CURRENT_USER;
      if R.OpenKey(REG_KEY+TPath.GetFileNameWithoutExtension(Application.ExeName)+'\', True) then
      begin
        try
          if MainFormState = 0 then
          begin
            R.WriteInteger('Left', Left);
            if Top < 0 then
              R.WriteInteger('Top', 0)
            else
              R.WriteInteger('Top', Top);
            R.WriteInteger('ClientHeight', ClientHeight);
            R.WriteInteger('ClientWidth', ClientWidth);
          end;

          // 화면최대화 여부확인(0 : 기본, 1: 최소화(바모드), 2 : 최대화)
          R.WriteInteger('MainFormState', MainFormState);

          for i := 0 to ComponentCount-1 do
          begin
            if Components[i].ClassType = TscGPSpinEdit then
            begin
              R.WriteInteger(TscGPSpinEdit(Components[i]).Name, TscGPSpinEdit(Components[i]).ValueAsInt);
            end
            else if Components[i].ClassType = TPanel then
            begin
              if TPanel(Components[i]).Name = 'pnlIOList' then
              begin
                R.WriteInteger(TPanel(Components[i]).Name, TPanel(Components[i]).Height);
              end;
            end;
          end;
        finally
          R.CloseKey;
        end;
      end
      else
      begin
        //Failed to open registry key
      end;
    except

    end;
  finally
    R.Free;
  end;
end;
{$endregion}

end.
