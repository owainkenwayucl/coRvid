program test;

uses
   classes, sysutils, Simulation;

var
   insim, outsim:  SimulationDetails;
   failed: integer;

{
   Test that if we read and then write out and then read a file it
   has the same values.
}
function test_readwrite_sim(): boolean;
   begin
      insim := readSimulationDetails('tests/input/uk-sim-initial.ini');
      recordSimulationDetails('tests/output/test.ini', insim);
      outsim := readSimulationDetails('tests/output/test.ini');

      test_readwrite_sim := (compareSimulationDetails(insim, outsim));
   end;

{
   Test that compareSimulationDetails works.
}
function test_change_sim(): boolean;
   begin
      insim := readSimulationDetails('tests/input/uk-sim-initial.ini');
      outsim := copySimulationDetails(insim);
      outsim.R := 1.2;

      test_change_sim := not (compareSimulationDetails(insim, outsim));
   end;

{
   Test that copySimulationDetails works.
}
function test_copy_sim(): boolean;
   begin
      insim := readSimulationDetails('tests/input/uk-sim-initial.ini');
      outsim := copySimulationDetails(insim);

      test_copy_sim := compareSimulationDetails(insim, outsim);
   end;

{
   Handle test pass/fail:
    * Output to terminal
    * increment fail counter
}
function failadd(test: boolean; current: integer) :integer;
   begin
      failadd := current;
      if not test then 
         begin
             failadd := current + 1;
             Write('F');
         end
      else
         begin
             Write('.');
         end;
   end;

{ 
   Run test suite.
}
begin
   failed := 0;

   WriteLn('Running tests: ');

   failed := failadd(test_readwrite_sim(), failed);
   failed := failadd(test_copy_sim(), failed);
   failed := failadd(test_change_sim(), failed);

   WriteLn('');
   WriteLn('Tests Failed: ' + IntToStr(failed));

   halt(failed);
end.
