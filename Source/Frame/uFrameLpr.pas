unit uFrameLpr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  AdvSmoothSlider, Vcl.WinXCtrls, Vcl.StdCtrls, System.Win.ScktComp,
  uUnitInfo, Vcl.Menus, Vcl.Imaging.jpeg, System.ImageList, Vcl.ImgList, acImage,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxImage, cxImageList;

type
  TLprStatus = (lsDisconnected, lsConnected, lsReading, lsWarning);

type
  TFrameLpr = class(TFrame)
    pnlTitle: TPanel;
    pnlInfo: TPanel;
    pnlImage: TPanel;
    swEachLprState: TToggleSwitch;
    btnBarControl: TButton;
    imgCar: TImage;
    popGate: TPopupMenu;
    popOpen: TMenuItem;
    popClose: TMenuItem;
    popOpenLock: TMenuItem;
    popOpenUnLock: TMenuItem;
    lblUnitName: TLabel;
    lblCarType: TLabel;
    lblCarNo: TLabel;
    imgUnitNameBack: TImage;
    lblIndicator: TLabel;
    imgIndicatorList: TcxImageList;
    imgIndicator: TImage;
    lblDeptInfo: TLabel;
    procedure btnBarControlClick(Sender: TObject);
    procedure popOpenClick(Sender: TObject);
  private
    { Private declarations }
    FLprStatus: TLprStatus;
    FUnitName: string;
    FCarType: string;
    FCarNo: string;
    FDeptInfo: string;
    FImagePath: string;
    FActive: Boolean;
    FFrameIndex: Integer;
    FUnitInfo: TUnitInfoClass;
    LprClientSocket: TClientSocket;
    procedure SocketConnected(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketDisconnected(Sender: TObject; Socket: TCustomWinSocket);
    procedure SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SetActive(const Value: Boolean);
    procedure SetCarNo(const Value: string);
    procedure SetCarType(const Value: string);
    procedure SetUnitName(const Value: string);
    function GetUnitInfo: TUnitInfoClass;
    procedure SetUnitInfo(const Value: TUnitInfoClass);
    procedure SetImagePath(const Value: string);
    procedure tmrHeartbeatTimer(Sender: TObject);
    procedure SetLprStatus(const Value: TLprStatus);
    procedure SetDeptInfo(const Value: string);
  public
    { Public declarations }
    tmrHeartbeat: TTimer;
    procedure ClearFrame;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property LprStatus  : TLprStatus         read FLprStatus           write SetLprStatus;
    property UnitName   : string             read FUnitName            write SetUnitName;
    property CarType    : string             read FCarType             write SetCarType;
    property CarNo      : string             read FCarNo               write SetCarNo;
    property DeptInfo   : string             read FDeptInfo            write SetDeptInfo;
    property ImagePath  : string             read FImagePath           write SetImagePath;
    property Active     : Boolean            read FActive              write SetActive;
    property FrameIndex : Integer            read FFrameIndex          write FFrameIndex;
    property UnitInfo   : TUnitInfoClass     read GetUnitInfo          write SetUnitInfo;
  end;

implementation

uses
  uGlobal;

{$R *.dfm}

{ TFrameLpr }

constructor TFrameLpr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  LprClientSocket := TClientSocket.Create(Self);
  with LprClientSocket do
  begin
    ClientType := ctNonBlocking;
    OnConnect := SocketConnected;
    OnDisconnect := SocketDisconnected;
    OnRead := SocketRead;
    OnError := SocketError;
  end;

  FUnitInfo := TUnitInfoClass.Create;
  FillChar(FUnitInfo, SizeOf(TUnitInfoClass), #0);

  tmrHeartbeat := TTimer.Create(nil);
  tmrHeartbeat.Interval := 15000;
  tmrHeartbeat.OnTimer := tmrHeartbeatTimer;
  tmrHeartbeat.Enabled := True;
end;

destructor TFrameLpr.Destroy;
begin
  if LprClientSocket <> nil then
  begin
    if LprClientSocket.Active then
      LprClientSocket.Active := False;
    FreeAndNil(LprClientSocket);
  end;

  if FUnitInfo <> nil then
  begin
    FUnitInfo.Free;
    FUnitInfo := nil;
  end;

  if tmrHeartbeat <> nil then
  begin
    if tmrHeartbeat.Enabled then
      tmrHeartbeat.Enabled := False;

    tmrHeartbeat.Free;
    tmrHeartbeat := nil;
  end;

  inherited Destroy;
end;

procedure TFrameLpr.popOpenClick(Sender: TObject);
var
  msg: string;
begin
  if not LprClientSocket.Active then Exit;

  if TMenuItem(Sender).Name = 'popOpen' then
    msg := MSG_BAR_OPEN
  else if TMenuItem(Sender).Name = 'popClose' then
    msg := MSG_BAR_CLOSE
  else if TMenuItem(Sender).Name = 'popOpenLock' then
    msg := MSG_BAR_OPEN_LOCK
  else if TMenuItem(Sender).Name = 'popOpenUnLock' then
    msg := MSG_BAR_OPEN_UNLOCK;

  try
    LprClientSocket.Socket.SendText(msg);
    Log( UnitName + ' ' + TMenuItem(Sender).Name + ' Click' );
  except
    on E: Exception do
    begin
      Log( UnitName + ' ' + TMenuItem(Sender).Name + ' Click Exception : ' + E.Message );
    end;
  end;
end;

function TFrameLpr.GetUnitInfo: TUnitInfoClass;
begin
  Result := FUnitInfo;
end;

procedure TFrameLpr.SetActive(const Value: Boolean);
begin
  if LprClientSocket.Host = '' then
    FActive := False
  else
    FActive := Value;

  try
    LprClientSocket.Active := FActive;
  except
    on E: Exception do
    begin
      Log( UnitName + ' LprClientSocket Active Exception : ' + E.Message );
      FActive := False;
    end;
  end;
end;

procedure TFrameLpr.SetCarNo(const Value: string);
begin
  FCarNo := Value;
  lblCarNo.Caption := FCarNo;
end;

procedure TFrameLpr.SetCarType(const Value: string);
begin
  FCarType := Value;
  lblCarType.Caption := FCarType;
end;

procedure TFrameLpr.SetDeptInfo(const Value: string);
begin
  FDeptInfo := Value;
  lblDeptInfo.Caption := FDeptInfo;
end;

procedure TFrameLpr.SetImagePath(const Value: string);
begin
  FImagePath := Value;
  try
    imgCar.Picture.LoadFromFile(FImagePath);
  except
    on E:Exception do
    begin
      Log( UnitName + ' SetImagePath Exception : ' + E.Message );
      FImagePath := EmptyStr;
    end;
  end;
end;

procedure TFrameLpr.SetLprStatus(const Value: TLprStatus);
begin
  FLprStatus := Value;
  case FLprStatus of
    lsDisconnected:
      begin
        lblIndicator.Color := clRed;
        imgIndicatorList.GetBitmap(0, imgIndicator.Picture.Bitmap);
      end;
    lsConnected:
      begin
        lblIndicator.Color := clGreen;
        imgIndicatorList.GetBitmap(1, imgIndicator.Picture.Bitmap);

      end;
    lsReading:
      begin
        lblIndicator.Color := clBlue;
        imgIndicatorList.GetBitmap(2, imgIndicator.Picture.Bitmap);
      end;
    lsWarning:
      begin
        lblIndicator.Color := clYellow;
        imgIndicatorList.GetBitmap(3, imgIndicator.Picture.Bitmap);
      end;
  end;
  imgIndicator.Repaint;
end;

procedure TFrameLpr.SetUnitName(const Value: string);
begin
  FUnitName := Value;
  lblUnitName.Caption := FUnitName;
end;

procedure TFrameLpr.SetUnitInfo(const Value: TUnitInfoClass);
begin
  FUnitInfo := Value;
  LprClientSocket.Host := FUnitInfo.IPNo;
  LprClientSocket.Port := FUnitInfo.PortNo;
  LprClientSocket.Tag := FUnitInfo.UnitNo;
end;

procedure TFrameLpr.btnBarControlClick(Sender: TObject);
var
  TempPoint: TPoint;
begin
  TempPoint := TButton(Sender).ClientToScreen(Point(0, 0));
  popGate.Popup(TempPoint.X, TempPoint.Y);
end;

procedure TFrameLpr.ClearFrame;
var
  i: Integer;
begin
  FillChar(FUnitInfo, SizeOf(TUnitInfoClass), #0);

  CarType := '';
  CarNo := '';

  // Initialize all components in the Frame
  for i := 0 to ComponentCount-1 do
  begin
    if Components[i].ClassType = TLabel then
    begin
      if TLabel(Components[i]).Name = 'lblUnitName' then Continue;

      TLabel(Components[i]).Caption := '';
    end
    else if Components[i].ClassType = TImage then
    begin
      TImage(Components[i]).Picture.Assign(nil);
    end
    else if Components[i].ClassType = TToggleSwitch then
    begin
//      TToggleSwitch(Components[i]).State := tssOn;
    end;
  end;
end;

procedure TFrameLpr.tmrHeartbeatTimer(Sender: TObject);
begin
  if LprClientSocket.Active then
  begin
    try
      LprClientSocket.Socket.SendText('OK');
      Log( UnitName + ' sent heartbeat text. ', 1 );
    except
      on E:Exception do
      begin
        Log( UnitName + ' tmrHeartbeatTimer Exception : ' + E.Message );
        LprClientSocket.Active := False;
      end;
    end;
  end
  else
  begin
    if LprClientSocket.Host <> '' then
      LprClientSocket.Active := True;
  end;
end;

{LprClientSocket}

procedure TFrameLpr.SocketConnected(Sender: TObject; Socket: TCustomWinSocket);
begin
  LprStatus := lsConnected;
  Log( UnitName + ' Socket connected' );
//  Socket.SendText('hello');
//  tmrHeartbeat.Enabled := True;
end;

procedure TFrameLpr.SocketDisconnected(Sender: TObject; Socket: TCustomWinSocket);
begin
  LprStatus := lsDisconnected;
  Log( UnitName + ' Socket disconnected' );
end;

procedure TFrameLpr.SocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Raw: String;
  LprBuf: TR_LPR_CLIENT;
begin
  Raw := Socket.ReceiveText;
  Log( UnitName + ' Recv: ' + Raw , 1 );

  Raw := RecursiveReplace(Raw, 'LPR_N');

  if Length(Raw) < 15 then Exit;

  Log( UnitName + ' Recv: ' + Raw );
  LprStatus := lsReading;
  Log( '-----(+) ' + UnitName + ' PACKET贸府--------' );
//  InLPRRead(Sender, Socket);
  // Insert global queue for in/out seperate
  if UnitInfo.UnitKind = 8 then
  begin
    with LprBuf do
    begin
      nCurrParkNo := UnitInfo.ParkNo;
      nIndex := Self.Tag;
      nIO := 1;
      nNo := Self.Tag;
      sLprIP := UnitInfo.IPNo;
      if UnitInfo.DspUnitInfo <> nil then
        sDspIP := UnitInfo.DspUnitInfo.IPNo;
//      csLPR := LprClientSocket;
      uFrame := Self;
      sLprData := Raw;
    end;
    InQueue.Enqueue(LprBuf);
    Log( 'InQueue.Enqueue : ' + LprBuf.sLprData );
  end
  else if UnitInfo.UnitKind = 9 then
  begin
    with LprBuf do
    begin
      nCurrParkNo := UnitInfo.ParkNo;
      nIndex := Self.Tag;
      nIO := 2;
      nNo := Self.Tag;
      sLprIP := UnitInfo.IPNo;
      if UnitInfo.DspUnitInfo <> nil then
        sDspIP := UnitInfo.DspUnitInfo.IPNo;
//      csLPR := LprClientSocket;
      uFrame := Self;
      sLprData := Raw;
    end;
    OutQueue.Enqueue(LprBuf);
    Log( 'OutQueue.Enqueue : ' + LprBuf.sLprData );
  end;
  Log( '-----(-) ' + UnitName + ' PACKET贸府--------' );
  LprStatus := lsConnected;
end;

procedure TFrameLpr.SocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  LprStatus := lsWarning;
  Log( UnitName + ' Socket error' );
  ErrorCode := 0;
end;

end.
