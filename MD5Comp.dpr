program MD5Comp;

uses
  Vcl.Forms,
  fmMain in 'fmMain.pas' {fmCompare};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmCompare, fmCompare);
  Application.Run;
end.
