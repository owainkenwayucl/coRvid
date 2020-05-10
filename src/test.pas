program test;

uses
   TSVTools, classes, sysutils;

var
   st: TList;
   tmp: TStringList;

begin
   st := readTSV('file1.tsv');
   writeln(IntToStr(st.Count));
   writeln(inttostr(TStringList(st[0]).Count));
   writeln(TStringList(st[0])[0]);
   writeln(IntToStr(st.Count));

end.
