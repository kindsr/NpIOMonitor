program NpIOMonitor;
uses
  Forms,
  Windows,
  uCommandsClass in 'uCommandsClass.pas',
  uCommon in 'uCommon.pas',
  uFilterClass in 'uFilterClass.pas',
  uFrmFilters in 'uFrmFilters.pas' {frmExtensions},
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  uLangs in 'uLangs.pas',
  RCPopupMenu in 'RCPopupMenu.pas',
  uFrmCommandConfig in 'uFrmCommandConfig.pas' {frmCommandConfig: TFrame},
  uDM in 'uDM.pas' {DM: TDataModule},
  uFrmConfig in 'uFrmConfig.pas' {frmConfig},
  uGlobal in 'uGlobal.pas',
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uFrameHomenet in 'Frame\uFrameHomenet.pas' {FrameHomenet: TFrame},
  uFrameLpr in 'Frame\uFrameLpr.pas' {FrameLpr: TFrame},
  uIONData in 'DataObject\uIONData.pas',
  uAPI in 'Http\uAPI.pas',
  uUnitInfo in 'DataObject\uUnitInfo.pas',
  uThreadUtilities in 'Thread\uThreadUtilities.pas',
  uThreadFileLog in 'Thread\uThreadFileLog.pas';

{$R *.res}

var
  Mutex: THandle;

begin
  Mutex := CreateMutex(nil, True, PChar(ExtractFileName(Application.ExeName)));

  if (Mutex > 0) and (GetLastError = 0) then
  begin
    try
      Application.Initialize;
      Application.CreateForm(TDM, DM);
      Application.CreateForm(TfrmMain, frmMain);
      Application.CreateForm(TfrmConfig, frmConfig);
      Application.ShowMainForm := True;

      GenDefaultFileLang;

      with frmConfig do
      begin
        cbLangs.ItemIndex := LangFillListAndGetCurrent(cbLangs.Items);
        cbLangsChange(cbLangs);
      end;
//      {$IFDEF DEBUG} ReportMemoryLeaksOnShutdown := True; {$ENDIF}
      Application.Run;
    except
      Application.Terminate;
    end;

    if Mutex > 0 then
      CloseHandle(Mutex);
  end;
end.
