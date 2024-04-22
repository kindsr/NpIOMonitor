unit uIONData;

interface

type
  TIONDataClass = class(TObject)
    private
      FParkNo        : Word;
      FUnitNo        : Word;
      FProcDate      : string;
      FProcTime      : string;
      FTKNo          : string;
      FTKType        : Word;
      FCarType       : Word;
      FInImage1      : string;
      FInCarNo1      : string;
      FInImage2      : string;
      FInCarNo2      : string;
      FStatus        : Word;
      FOutUnitNo     : Word;
      FOutDate       : string;
      FOutTime       : string;
      FOutChk        : Word;
      FOutImage1     : string;
      FOutCarNo1     : string;
      FOutImage2     : string;
      FOutCarNo2     : string;
      FInRecog1      : Word;
      FOutRecog1     : Word;
      FInRecog2      : Word;
      FOutRecog2     : Word;
      FFTPayGubun    : Word;
      FFTParkingMin  : Integer;
      FFTYogum       : Integer;
      FFTDate        : string;
      FFTTime        : string;
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
      FParkingMin    : Integer;
      FTelNo         : string;
      FBujaeType     : Word;
      FDelYN         : string;
      FJasmineDCTime : Integer;
      FUsedPoint     : Integer;
      FVisitDong     : Integer;
      FVisitHo       : Integer;
      FVisitReason   : string;
      FOutUnitName   : string;
      FInUnitName    : string;
      FInSync        : string;
      FOutSync       : string;
      FOverParkingMin: Integer;
    public
      property ParkNo         : Word              read FParkNo                write FParkNo;
      property UnitNo         : Word              read FUnitNo                write FUnitNo;
      property ProcDate       : string            read FProcDate              write FProcDate;
      property ProcTime       : string            read FProcTime              write FProcTime;
      property TKNo           : string            read FTKNo                  write FTKNo;
      property TKType         : Word              read FTKType                write FTKType;
      property CarType        : Word              read FCarType               write FCarType;
      property InImage1       : string            read FInImage1              write FInImage1;
      property InCarNo1       : string            read FInCarNo1              write FInCarNo1;
      property InImage2       : string            read FInImage2              write FInImage2;
      property InCarNo2       : string            read FInCarNo2              write FInCarNo2;
      property Status         : Word              read FStatus                write FStatus;
      property OutUnitNo      : Word              read FOutUnitNo             write FOutUnitNo;
      property OutDate        : string            read FOutDate               write FOutDate;
      property OutTime        : string            read FOutTime               write FOutTime;
      property OutChk         : Word              read FOutChk                write FOutChk;
      property OutImage1      : string            read FOutImage1             write FOutImage1;
      property OutCarNo1      : string            read FOutCarNo1             write FOutCarNo1;
      property OutImage2      : string            read FOutImage2             write FOutImage2;
      property OutCarNo2      : string            read FOutCarNo2             write FOutCarNo2;
      property InRecog1       : Word              read FInRecog1              write FInRecog1;
      property OutRecog1      : Word              read FOutRecog1             write FOutRecog1;
      property InRecog2       : Word              read FInRecog2              write FInRecog2;
      property OutRecog2      : Word              read FOutRecog2             write FOutRecog2;
      property FTPayGubun     : Word              read FFTPayGubun            write FFTPayGubun;
      property FTParkingMin   : Integer           read FFTParkingMin          write FFTParkingMin;
      property FTYogum        : Integer           read FFTYogum               write FFTYogum;
      property FTDate         : string            read FFTDate                write FFTDate;
      property FTTime         : string            read FFTTime                write FFTTime;
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
      property ParkingMin     : Integer           read FParkingMin            write FParkingMin;
      property TelNo          : string            read FTelNo                 write FTelNo;
      property BujaeType      : Word              read FBujaeType             write FBujaeType;
      property DelYN          : string            read FDelYN                 write FDelYN;
      property JasmineDCTime  : Integer           read FJasmineDCTime         write FJasmineDCTime;
      property UsedPoint      : Integer           read FUsedPoint             write FUsedPoint;
      property VisitDong      : Integer           read FVisitDong             write FVisitDong;
      property VisitHo        : Integer           read FVisitHo               write FVisitHo;
      property VisitReason    : string            read FVisitReason           write FVisitReason;
      property OutUnitName    : string            read FOutUnitName           write FOutUnitName;
      property InUnitName     : string            read FInUnitName            write FInUnitName;
      property InSync         : string            read FInSync                write FInSync;
      property OutSync        : string            read FOutSync               write FOutSync;
      property OverParkingMin : Integer           read FOverParkingMin        write FOverParkingMin;
  end;

implementation

{ TIONDataClass }

end.
