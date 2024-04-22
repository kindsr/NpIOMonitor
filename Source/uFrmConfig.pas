unit uFrmConfig;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, Menus, StdCtrls, ActnList, registry,
  uCommandsClass, windows, Messages, IniFiles, TimeSpan, StrUtils,
  TypInfo, System.Actions, Vcl.ImgList, uFrmCommandConfig, RCPopupMenu,
  Winapi.CommCtrl, System.Math, System.ImageList, Vcl.WinXCtrls, AdvEdit,
  uFrameHomenet;

type
  TfrmConfig = class(TForm)
    ppConfigMenu: TPopupMenu;
    ppCMConfig: TMenuItem;
    MenuItem1: TMenuItem;
    ppCMExit: TMenuItem;
    TrayIcon: TTrayIcon;
    ActionList: TActionList;
    actAdd: TAction;
    actAddSub: TAction;
    actCopy: TAction;
    actDel: TAction;
    actOK: TAction;
    actClose: TAction;
    actApply: TAction;
    actItemUp: TAction;
    actItemDown: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    gbMainButtons: TGroupBox;
    Label1: TLabel;
    lbLangs: TLabel;
    btnApply: TButton;
    btnClose: TButton;
    btnOK: TButton;
    cbRunOnWindowsStart: TCheckBox;
    cbLangs: TComboBox;
    gbBasicInfo: TGroupBox;
    gbOperating: TGroupBox;
    edtDbIP: TAdvEdit;
    edtDbID: TAdvEdit;
    edtDbPW: TAdvEdit;
    edtDbName: TAdvEdit;
    edtUnitNo: TAdvEdit;
    edt: TAdvEdit;
    FrameHomenet1: TFrameHomenet;
    procedure ppCMExitClick(Sender: TObject);
    procedure ppCMConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actApplyExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actCloseUpdate(Sender: TObject);
    procedure actApplyUpdate(Sender: TObject);
    procedure cbLangsChange(Sender: TObject);
    procedure ppTrayMenuMenuRightClick(Sender: TObject; Item: TMenuItem);
    procedure actRunExecute(Sender: TObject);
    procedure cbRunOnWindowsStartChange(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
    procedure actOKUpdate(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    { Private declarations }
    IsModified: Boolean;
    MouseButtonSwapped: Boolean;
    ppTrayMenu: TRCPopupMenu;
    procedure SyncData(Sender: TObject);

  public
    { Public declarations }
    procedure WMClose(var Message: TMessage); message WM_CLOSE;
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

var
  frmConfig: TfrmConfig;

  _sReset, _sResetCulture, _sJCode : string;   //VIP최종 업뎃일자 , 점코드
  _sUpdateTime, _sUpdateTimeCulture: string;
  _bIsRepeatVip, _bIsRepeatCulture: Boolean;
  _bIsRepeatVipByMin, _bIsRepeatCultureByMin: Boolean;
  _sRepeatTimeVip, _sRepeatTimeCulture: string;
  _sRepeatTimeVipByMin, _sRepeatTimeCultureByMin: string;

  WM_TASKBARCREATED: UINT = 0;

implementation

uses uCommon, uFrmFilters, uFilterClass, uLangs, XMLDoc, XMLIntf, DateUtils,
     Winapi.ShellAPI, System.UITypes, uGlobal, uDM, uFrmMain;

{$R *.dfm}

{$region 'OnAssertError'}
procedure OnAssertError(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);
var
  nResult, nLogType: Integer;
  sMsg: string;
  sFile: AnsiString;
begin
  sFile := sCurrRunDir + '\Log\' + FormatDateTime('YYMMDD', Now) + '.log';
  if not DirectoryExists(sCurrRunDir + '\Log\') then
    ForceDirectories(sCurrRunDir + '\Log\');
  sMsg := Format('[%s] %s: Line: %d, %s', [FormatDateTime('hh:nn:ss', Now), ExtractFileName(Filename), LineNumber, Message]);

  if (Assigned(frmMain)) then
  begin
    ThreadFileLog.Log(sFile, sMsg);
  end;
end;
{$endregion}

procedure TfrmConfig.actApplyExecute(Sender: TObject);
var
  timeSpanVip, timeSpanCulture: TTimeSpan;
  oldCommonData: TList;
  procedure AddToOldCommonDataRecurse(AMenuItems: TMenuItem);
  var
    i: Integer;
    vmi: TMenuItem;
  begin
    for i := 0 to AMenuItems.Count - 1 do
    begin
      vmi := AMenuItems[i];
      oldCommonData.Add(Pointer(vmi.Tag));
      if vmi.Count > 0 then
        AddToOldCommonDataRecurse(vmi);
    end;
  end;
begin
  // if not IsModified then Exit;
  // 편집된 데이터를 저장하세요


  with TRegistry.Create(KEY_READ or KEY_WRITE or KEY_SET_VALUE) do
    try
      RootKey := HKEY_CURRENT_USER;
      if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
        if cbRunOnWindowsStart.Checked then
          WriteString(PRG_NAME, ParamStr(0))
        else
          DeleteValue(PRG_NAME);
    finally
      Free;
    end;
  IsModified := False;
end;

procedure TfrmConfig.actApplyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := IsModified; // or frmCommandConfig.IsModified;
end;

procedure TfrmConfig.actCloseExecute(Sender: TObject);
begin
  if (IsModified) then // or frmCommandConfig.IsModified) then
  begin
    if AskForConfirmation(Self, GetLangString('LangStrings', 'CancelConfirm'))
    then
    begin
      Hide;
      ppTrayMenu.Items.Clear; // Data will be cleared below

      IsModified := False;
    end
  end
  else
  begin
    Hide;
  end;
  { else
    begin
    Hide;
    Application.Title := TrayIcon.Hint; //'Quick run from Tray';
    end; }
end;
procedure TfrmConfig.actCloseUpdate(Sender: TObject);
begin
  if IsModified then // or frmCommandConfig.IsModified then
    actClose.Caption := GetLangString('LangStrings', 'Cancel') // 'Cancel'
  else
    actClose.Caption := GetLangString('LangStrings', 'Close'); // 'Close';
end;

procedure TfrmConfig.actOKExecute(Sender: TObject);
begin
  actApplyExecute(actApply);
  Hide;
end;

procedure TfrmConfig.actOKUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := IsModified; // or frmCommandConfig.IsModified;
end;

procedure TfrmConfig.actRunExecute(Sender: TObject);
begin
  if not IsDBConnected then IsDBConnected := DM.ConnectDB;

  SyncData(Sender);
end;

procedure TfrmConfig.cbLangsChange(Sender: TObject);
begin
  SetLang(StrPas(PChar(cbLangs.Items.Objects[cbLangs.ItemIndex])));
end;

procedure TfrmConfig.cbRunOnWindowsStartChange(Sender: TObject);
begin
  IsModified := True;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  // ShowMessage('Test');
  MouseButtonSwapped := GetSystemMetrics(SM_SWAPBUTTON) <> 0;
  ShowMsgIfDebug('MouseButtonSwapped', BoolToStr(MouseButtonSwapped, True));
  ppTrayMenu := TRCPopupMenu.Create(Self);
  with ppTrayMenu do
  begin
//    Images := TreeImageList;
    Images := nil;
    OwnerDraw := True;
    OnMenuRightClick := ppTrayMenuMenuRightClick;
  end;
  // if not Swapped then tbRightButton else tbLeftButton
  // ppTrayMenu.TrackButton := TTrackButton(MouseButtonSwapped);
  ppConfigMenu.TrackButton := TTrackButton(MouseButtonSwapped);
  TrayIcon.Icon := Application.Icon;

  with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_CURRENT_USER;
      cbRunOnWindowsStart.Checked :=
        OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Run') and
        ValueExists(PRG_NAME);
      IsModified := False;
    finally
      Free;
    end;
  // tvItems.FullExpand;
  { RunAtTime := TRunAtTime.Create;
    RunAtTime.LoadDataFromTreeNodes(tvItems.Items); // загрузить запланированное время }
  IsModified := False;
  WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');

  sCurrRunDir := AnsiString(ExtractFileDir(Application.ExeName));
  iSetup := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\ParkSet.ini');
  with ConfigInfo do
  begin
    ParkNo := iSetup.ReadInteger('PARKING', 'ParkNo', 1);
    UnitGroupNo := iSetup.ReadInteger('PARKING', 'UnitNo', 10);
    LprImagePath  := iSetup.ReadString('PARKING', 'LPRImage', 'C:\LPRImage');

    MainFormOption.Visible := iSetup.ReadBool('PARKING', 'MainFormOptionVisible', False);
    MainFormOption.LogLevel := iSetup.ReadInteger('PARKING', 'LogLevel', 0);
  end;

  Log('');
  Log('');
  Log('Program : Start');

  IsDBConnected := DM.ConnectDB;

end;

procedure TfrmConfig.FormDestroy(Sender: TObject);
begin
  // FreeAndNil(RunAtTime);
end;

procedure TfrmConfig.FormHide(Sender: TObject);
begin
  Application.Title := TrayIcon.Hint;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
var
  timeSpanVip, timeSpanCulture: TTimeSpan;
begin
  Application.Title := TrayIcon.Hint + ' - ' + Caption;
  // LangStrings['frmConfig.Caption']; // 'Quick run from Tray - Options';
//  tvItems.SetFocus;

end;

procedure TfrmConfig.ppCMConfigClick(Sender: TObject);
begin
  Show;
end;

procedure TfrmConfig.ppCMExitClick(Sender: TObject);
begin
  frmMain.SaveState;

  if AllUnitInfo <> nil then
  begin
    FillChar(AllUnitInfo, SizeOf(AllUnitInfo), #0);
    AllUnitInfo := nil;
  end;

  if InLprInfo <> nil then
  begin
    FillChar(InLprInfo, SizeOf(InLprInfo), #0);
    InLprInfo := nil;
  end;

  if OutLprInfo <> nil then
  begin
    FillChar(OutLprInfo, SizeOf(OutLprInfo), #0);
    OutLprInfo := nil;
  end;

  Application.Terminate;
end;

procedure TfrmConfig.WMClose(var Message: TMessage);
begin
  actCloseExecute(actClose);
  // Application.Title := TrayIcon.Hint; //'Quick run from Tray';
  // Hide;
end;
procedure TfrmConfig.WndProc(var Message: TMessage);
// var vWM_TASKBARCREATED: UINT;
begin
  if (WM_TASKBARCREATED > 0) and (Message.Msg = WM_TASKBARCREATED) then
  begin
    // возможно надо заново регистрировать (вроде не надо)
    // vWM_TASKBARCREATED := WM_TASKBARCREATED;
    WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');
    // ShowMessage('Debug: Begin. WM_TASKBARCREATED: Old = ' + IntToStr(vWM_TASKBARCREATED) + '; New = ' + IntToStr(WM_TASKBARCREATED));
    // Иногда оно True, но реально не отображается, поэтому False не прокатит.
    try
      TrayIcon.Visible := False;
      // если не будет работать, то смотреть в сторону Shell_NotifyIcon, NIM_ADD, node(типа NOTIFYICONDATA_
    except
      { ShowMessage('Debug: Begin. WM_TASKBARCREATED: Old = ' + IntToStr(vWM_TASKBARCREATED) + '; New = ' + IntToStr(WM_TASKBARCREATED) + #13#10 +
        'Except: GetLastError = ' + IntToStr(GetLastError)); }
    end;
    TrayIcon.Visible := True;
  end;
  inherited WndProc(Message);
end;

procedure TfrmConfig.ppTrayMenuMenuRightClick(Sender: TObject; Item: TMenuItem);
var
  vCommandData: TCommandData;
begin
  if Item.Count = 0 then
  begin
    vCommandData := TCommandData(Item.Tag);
    if not MouseButtonSwapped then
      vCommandData.Edit
    else
      vCommandData.Run(crtNormalRun);
  end;
end;

procedure TfrmConfig.SyncData(Sender: TObject);
var
  sCallClassName: string;
  sNowTime, sNowDateOnlyNo, sLastWeek : AnsiString;
  sHQ, sStore, sYY, sCus_No, sCar_Kind, sCar_No_1, sCar_No_2, sPark_Type, sPark_Time,
  sSvc_Store, sSvc_Date_FR, sSVC_Date_To, sCreate_RESI_No, sCreate_Date, sUpdate_RESI_No, sUpdate_Date, sDelete_Fg : string;
  nCar_seq : Integer;

  sStore2, sSale_YMD, sMgmt_No, sCar_No, sPark_fg, sDC_Time, sPos_No,
  sRecpt_No, sSale_Time, sSale_Amt, sDelete_yn, sCreate_resi_no2, sCreate_Date2,
  sUpdate_RESI_No2, sUpDate_Date2: string;
begin
  sCallClassName := TComponent(Sender).Name;

  sNowTime := FormatDateTime('YYYY-MM-DD HH:NN:SS', Now);
  sNowDateOnlyNo := FormatDateTime('YYYYMMDDHHNNSS', Now);
  sLastWeek := FormatDateTime('YYYYMMDD', Now - 7);

  try
    if not not DM.ADODB.Connected then
      DM.ADODB.Connected := True;
  except
    on E: Exception do
      Log('Exception of MSSQL DB Connection');
  end;

end;

procedure TfrmConfig.TrayIconDblClick(Sender: TObject);
begin
  frmMain.Show;
end;

initialization
  AssertErrorProc := OnAssertError;

end.
