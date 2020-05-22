program test;

uses
   classes, sysutils, Simulation;

var
   insim, outsim:  SimulationDetails;
   failed: integer;

begin
   failed := 0;
   insim := readSimulationDetails('../input/uk-sim-initial.ini');
   recordSimulationDetails('test.ini', insim);
   outsim := readSimulationDetails('test.ini');
   if (compareSimulationDetails(insim, outsim)) then
      begin
         WriteLn('Test passed.');
      end
   else
      begin
         WriteLn('Test Failed.');
         failed := failed + 1;
      end;
   outsim.R := 1.2;
   if not (compareSimulationDetails(insim, outsim)) then
      begin
         WriteLn('Test passed.')
      end
   else
      begin
         WriteLn('Test Failed.');
         failed := failed + 1;
      end;
   halt(failed);
end.
