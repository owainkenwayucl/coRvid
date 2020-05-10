unit TSVTools;

interface

uses 
   classes, sysutils, math;

function numericCompare(const str1, str2: string): string;

function readTSV(const filename: string): TList;

function compareTSV(const file1, file2, outputfile: string): boolean;

implementation

var
   tempTlist, tempTlist2, tempSplit, resultList: TStringList;
   i, j, maxh, maxw: longint;
   tempDbl: double;
   list1, list2: TList;
   tstr1, tstr2, resultstr: ansistring;

{ Internal functions + procedures }

{ Can we compare two strings as numbers? }
function numericValid(const str1, str2: string): boolean;
   begin
      numericValid := TRUE;
      try
         tempDbl := StrToFloat(str1);
         tempDbl := StrToFloat(str2);
      except
         numericValid := FALSE;
      end;
      
   end;

{ 
   Compare two strings:
   if both are numeric, return the difference.
   if not and they are the same return the string.
   otherwise construct a string showing they differ.
}
function numericCompare(const str1, str2: string): string;
   begin
      numericCompare := str1;
      if (numericValid(str1,str2)) then
         begin
            tempDbl := StrToFloat(str2) - StrToFloat(str1);
            numericCompare := FloatToStr(tempDbl);
         end
      else if not (str1 = str2) then
         begin
            numericCompare := str1 + ' << >> ' + str2;
         end;
   end;


{ External functions + procedures }
function readTSV(const filename: string): TList;
   begin
      readTSV := TList.Create;
      tempTlist := TStringList.Create;
      tempTlist.LoadFromFile(filename);

      for i := 0 to tempTlist.Count -1 do
         begin
            tempSplit := TStringList.Create;
            tempSplit.Delimiter := #9;
            tempSplit.StrictDelimiter := TRUE;
            tempSplit.DelimitedText := tempTlist[i];
            readTSV.Add(tempSplit);
         end;

      tempTlist.Free;
   end;

function compareTSV(const file1, file2, outputfile: string): boolean;
   begin
      compareTSV := TRUE;
      resultList := TStringList.Create;
      list1 := readTSV(file1);
      list2 := readTSV(file2);

      maxh := max(list1.Count, list2.count);

      for i := 0 to maxh -1 do
         begin
            tempTlist := TStringList.Create;
            tempTlist2 := TStringList.Create;
            tempSplit := TStringList.Create;
            tempSplit.Delimiter := #9;
            tempSplit.StrictDelimiter := TRUE;

            if i < list1.Count then
               tempTlist := TStringList(list1[i]);

            if i < list2.Count then
               tempTlist2 := TStringList(list2[i]);

            maxw := max(tempTlist.Count, tempTlist2.Count);

            for j := 0 to maxw -1 do
               begin
                  tstr1 := ' ';
                  tstr2 := ' ';

                  if j < tempTlist.Count then
                     tstr1 := tempTlist[j];

                  if j < tempTlist2.Count then
                     tstr2 := tempTlist2[j];

                  if not (tstr1 = tstr2) then
                     compareTSV := FALSE;

                  resultstr := numericCompare(tstr1, tstr2);
                  tempSplit.Add(resultstr);

               end;

            resultList.Add(tempSplit.DelimitedText);
         end;

      resultList.SaveToFile(outputfile);
      resultList.Free;
      list2.Free;
      list1.Free;
   end;

end.
