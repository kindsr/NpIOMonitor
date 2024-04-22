unit uFrameHomenet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvCombo,
  AdvEdit;

type
  TFrameHomenet = class(TFrame)
    gbHomenet: TGroupBox;
    edtHomenetServer: TAdvEdit;
    cmbUseHomenet1: TAdvComboBox;
    AdvEdit1: TAdvEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
