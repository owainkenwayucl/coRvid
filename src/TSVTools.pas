unit TSVTools;

interface

uses 
   classes, sysutils;

function readTSV(const filename: string): TList;


implementation

var
   tempTlist, tempSplit: TStringList;
   i: longint;

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
end.
