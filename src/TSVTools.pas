unit TSVTools;

interface

uses 
   classes, sysutils;

function numericCompare(const str1, str2: string): string;

function readTSV(const filename: string): TList;

function compareTSV(const file1, file2, outputfile: string): boolean;

implementation

var
   tempTlist, tempSplit: TStringList;
   i: longint;
   tempDbl: double;

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
   end;

end.
