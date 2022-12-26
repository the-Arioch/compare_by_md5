unit fmMain;

interface

uses
  System.Generics.Collections, JclStringLists,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids;

type
  TFileEntry = record MD5, Path, Source: string end;
  TFileClones = TList<TFileEntry>;
  TFileSet = TObjectDictionary<string,TFileClones>;

  TfmCompare = class(TForm)
    pnlDetails: TPanel;
    pnlSums: TPanel;
    pnlFiles: TPanel;
    spl1: TSplitter;
    spl2: TSplitter;
    gridMD5: TStringGrid;
    gridFiles: TStringGrid;
    gridDetails: TStringGrid;
    btnAdd: TButton;
    btnDel: TButton;
    btnSave: TButton;
    dlgOpenMD5: TOpenDialog;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure gridFilesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure gridDetailsDblClick(Sender: TObject);
  private
    MD5s: IJclStringList;
    MyFiles: TFileSet;
    procedure RebuildList;
    function FileToKey(const fn: string): string;
    procedure AddList(const fn5: string);
    function FileToCount(const fn: string): string;
  public

  end;

var
  fmCompare: TfmCompare;

implementation

Uses
  JclStrings, System.StrUtils,
  Vcl.Clipbrd, IOUtils, Character, System.Generics.Defaults;

{$R *.dfm}

procedure TfmCompare.btnAddClick(Sender: TObject);
var
  fn: string;
begin
  if dlgOpenMD5.Execute then begin
     for fn in dlgOpenMD5.Files do
       if MD5s.IndexOf(fn) < 0 then
          MD5s.Add(fn);
     RebuildList;
  end;
end;

procedure TfmCompare.btnCompareClick(Sender: TObject);
begin
  RebuildList;
end;

procedure TfmCompare.btnDelClick(Sender: TObject);
var
  fn: string; i: integer;
begin
  i := gridMD5.Row;
  if (i <= 0) or (i >= gridMD5.RowCount) then
      exit;
  fn := Trim(gridMD5.Cells[1, i]);
  MD5s.Delete(fn);
  RebuildList;
end;

procedure TfmCompare.btnSaveClick(Sender: TObject);
var
  fn, s: string;
  sl: IJclStringList;
  fe: TFileEntry;
  fc: TFileClones;
  i, mx, l: integer;
begin
  fn := '5Compare.txt';
  if not PromptForFileName(fn, '*.txt|*.txt', 'txt','','',True) then
    exit;

  RebuildList;

  sl := JclStringList;

  sl.Add('== Sources ==');
  sl.AddStrings(MD5s as TStrings);

  sl.Add('');

  for i := 1 to gridFiles.RowCount-1 do begin
    sl.Add('= ' + gridFiles.Cells[1,i] + ' :  ' + gridFiles.Cells[0,i] + ' =');

     fc := MyFiles[gridFiles.Cells[0,i]];
     mx := 0;
     for fe in fc do begin
       l := Length(fe.Path);
       if mx < l then mx := l;
     end;
     Inc(mx,3); s := '';
     for fe in fc do begin
       if s = '' then s := fe.MD5;
       if s <> fe.MD5 then begin
          s := fe.MD5;
          sl.Add('');
       end;

       sl.Add( fe.MD5 + ' : '
               + StrPadRight(fe.Path + ' ', mx, '.')
               + '// ' + fe.Source);
     end;
     sl.Add('');
     sl.Add('');
  end;

  sl.SaveToFile(fn);
end;

function TfmCompare.FileToKey(const fn: string): string;
begin
  Result := AnsiUpperCase(Trim(ExtractFileName(fn)));
end;

procedure TfmCompare.FormCreate(Sender: TObject);
begin
  MD5s := JclStringList();
  MD5s.CaseSensitive := False;
  MD5s.Duplicates := dupIgnore;
//  MD5s.Sorted := True;

  MyFiles := TFileSet.Create([doOwnsValues]);

  gridMD5.Rows[0].Text := 'Файл MD5'#13#10'Путь';
  gridFiles.Rows[0].Text := 'Файл'#13#10'N';
  gridDetails.Rows[0].Text := 'MD5'#13#10'Путь'#13#10'Источник';
end;

procedure TfmCompare.FormDestroy(Sender: TObject);
begin
  MyFiles.Free;
end;

procedure TfmCompare.gridDetailsDblClick(Sender: TObject);
begin
  Clipboard.AsText :=
    gridDetails.Cells[gridDetails.Col, gridDetails.Row];
end;

procedure TfmCompare.gridFilesSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  fn: string;
  fe: TFileEntry;
  fc: TFileClones;
  i: integer;
begin
  if ARow > 0 then begin
     fn := gridFiles.Cells[0, ARow];
     fc := MyFiles[fn];
     gridDetails.RowCount := 1 + fc.Count;
     i := 0;
     for fe in fc do begin
       Inc(i);
       gridDetails.Cells[0,i] := fe.MD5;
       gridDetails.Cells[1,i] := fe.Path;
       gridDetails.Cells[2,i] := fe.Source;
     end;
  end;
end;

function _Srt(const Left, Right: TPair<string,string>): Integer;
begin
  Result := - CompareStr(Left.Key, Right.Key);
  if Result = 0 then
     Result := CompareStr(Left.Value, Right.Value);
end;

procedure TfmCompare.RebuildList;
var
  fn: string;
  i: Integer;
  fc: TFileClones;

  pre_sort: TList<TPair<string,string>>;
  ps1: TPair<string,string>;
begin
  MyFiles.Clear;

  gridMD5.RowCount := 1 + MD5s.Count;
  i := 0;
  for fn in MD5s do begin
    Inc(i);
    gridMD5.Cells[0, i] := ExtractFileName(fn);
    gridMD5.Cells[1, i] := fn;
  end;

  for fn in MD5s do
    AddList(fn);

  for fc in MyFiles.Values do
    fc.Sort;

  gridFiles.RowCount := 1 + MyFiles.Count;

  pre_sort := TList<TPair<string,string>>.Create;
  try
    pre_sort.Capacity := MyFiles.Count;

    for fn in MyFiles.Keys do begin
      ps1.Key := FileToCount(fn);
      ps1.Value := fn;
      pre_sort.Add(ps1);
    end;

    pre_sort.Sort(
      TComparer<TPair<string,string>>.Construct(_Srt)
    );

    i := 0;
    for ps1 in pre_sort do begin
      Inc(i);
      gridFiles.Cells[0, i] := ps1.Value;
      gridFiles.Cells[1, i] := ps1.Key;
    end;

  finally
    pre_sort.Free;
  end;
end;

function _Srt_fc(const Left, Right: TFileEntry): Integer;
begin
  Result := CompareStr(Left.MD5, Right.MD5);
  if Result = 0 then
     Result := CompareStr(Left.Path, Right.Path);
end;

procedure TfmCompare.AddList(const fn5: string);
var
  s, s2, fn, m: string;
  i: Integer;
  fc: TFileClones;
  fe: TFileEntry;
begin
  for s in TFile.ReadAllLines(fn5) do begin
    if s = '' then Continue;
    if not TCharacter.IsLetterOrDigit(s[1]) then Continue;
    i := Pos(' ', s);
    if i <= 0 then Continue;

    s2 := Copy(s, i+2, Length(s));
    m := LowerCase(Copy(s, 1, i-1));
    fn := FileToKey(s2);

    if not MyFiles.TryGetValue(fn, fc) then begin
       fc := TFileClones.Create(
         TComparer<TFileEntry>.Construct(_Srt_fc)
       );
       MyFiles.Add(fn, fc);
    end;

    fe.MD5 := m;
    fe.Path := s2;
    fe.Source := fn5;

    fc.Add(fe);
  end;
end;

function TfmCompare.FileToCount(const fn: string): string;
var
  m: string;
  fc: TFileClones;
  fe: TFileEntry;
  c: integer;
begin
  Result := 'ERR';
  if not MyFiles.TryGetValue(FileToKey(fn),fc) then exit;
  Result := '---';
  if fc.Count <= 0 then Exit;

  c := 0;
  fc.Sort;

  for fe in fc do begin
    if m = '' then
       m := fe.MD5;

    if m <> fe.MD5 then begin
       Inc(c);
       m := fe.MD5;
    end;
  end;

  if c = 0 then Exit('...'+IntToStr(fc.Count));

  Result := IntToStr(1+c) + ' of ' + IntToStr(fc.Count);
end;

end.


