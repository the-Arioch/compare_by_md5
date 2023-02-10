// This utility loads 1 or more .MD5 files and then checks if the files in 
//      all of them has the same MD5 checksum.
// Useful to check if unexpected unmatching duplicates exist in one
//      or, mainly, across many computers.
// Licensed under GPL 3

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
