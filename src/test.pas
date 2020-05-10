program test;

uses
   TSVTools, classes, sysutils;

var
   st: TList;
   tmp: TStringList;
   fail: boolean;
   t: double;
   ts: string;

begin
   st := readTSV('../input/file1.tsv');
   writeln(IntToStr(st.Count));
   writeln(inttostr(TStringList(st[0]).Count));
   writeln(TStringList(st[0])[0]);
   writeln(IntToStr(st.Count));

   writeln(numericCompare('test','test'));
   writeln(numericCompare('1','test'));
   writeln(numericCompare('test','1'));
   writeln(numericCompare('1.5','1'));

end.
