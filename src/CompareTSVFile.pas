program CompareTSVFile;

uses
   TSVTools;

var
   file1, file2, outfile: ansistring;
   match: boolean;

begin
   outfile := 'CompareTSV.out';
   if ParamCount > 1 then
   begin
      file1 := ParamStr(1);
      file2 := ParamStr(2);
      if ParamCount > 2 then
         outfile := ParamStr(3);

      match := compareTSV(file1,file2,outfile);
      if not match then
         begin
            WriteLn('Files do not match - see ' + outfile + ' for differences.');
            halt(1);
         end
      else
         WriteLn('Files Match');
   end
   else
     WriteLn('[./]CompareTSVFile.exe <file1> <file2> <outputfile>');
end.
