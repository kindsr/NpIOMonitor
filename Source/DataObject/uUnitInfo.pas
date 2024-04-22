unit uUnitInfo;

interface

type
  TUnitInfoClass = class(TObject)
    private
      FParkNo        : Word;
      FUnitNo        : Word;
      FUnitName      : string;
      FUnitKind      : Word;
      FMyNo          : Word;
      FComport       : Integer;
      FBaudRate      : Integer;
      FIPNo          : string;
      FPortNo        : Integer;
      FReserve1      : string;
      FReserve2      : string;
      FReserve3      : string;
      FReserve4      : string;
      FReserve5      : string;
      FReserve6      : string;
      FReserve7      : string;
      FReserve8      : string;
      FReserve9      : string;
      FReserve10     : string;
      FFullDspGroupNo: string;
      FDspType       : Word;
      FRestrictionNo : Word;
      FDspUnitInfo   : TUnitInfoClass;
    procedure SetDspUnitInfo(const Value: TUnitInfoClass);
    public
      property ParkNo         : Word              read FParkNo                write FParkNo;
      property UnitNo         : Word              read FUnitNo                write FUnitNo;
      property UnitName       : string            read FUnitName              write FUnitName;
      property UnitKind       : Word              read FUnitKind              write FUnitKind;
      property MyNo           : Word              read FMyNo                  write FMyNo;
      property Comport        : Integer           read FComport               write FComport;
      property BaudRate       : Integer           read FBaudRate              write FBaudRate;
      property IPNo           : string            read FIPNo                  write FIPNo;
      property PortNo         : Integer           read FPortNo                write FPortNo;
      property Reserve1       : string            read FReserve1              write FReserve1;
      property Reserve2       : string            read FReserve2              write FReserve2;
      property Reserve3       : string            read FReserve3              write FReserve3;
      property Reserve4       : string            read FReserve4              write FReserve4;
      property Reserve5       : string            read FReserve5              write FReserve5;
      property Reserve6       : string            read FReserve6              write FReserve6;
      property Reserve7       : string            read FReserve7              write FReserve7;
      property Reserve8       : string            read FReserve8              write FReserve8;
      property Reserve9       : string            read FReserve9              write FReserve9;
      property Reserve10      : string            read FReserve10             write FReserve10;
      property FullDspGroupNo : string            read FFullDspGroupNo        write FFullDspGroupNo;
      property DspType        : Word              read FDspType               write FDspType;
      property RestrictionNo  : Word              read FRestrictionNo         write FRestrictionNo;
      property DspUnitInfo    : TUnitInfoClass    read FDspUnitInfo           write SetDspUnitInfo;
  end;

implementation

{ TUnitInfoClass }

procedure TUnitInfoClass.SetDspUnitInfo(const Value: TUnitInfoClass);
begin
  if FDspUnitInfo = nil then
    FDspUnitInfo := TUnitInfoClass.Create;

  FDspUnitInfo := Value;
end;

end.
