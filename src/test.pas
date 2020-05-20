program test;

uses
   classes, sysutils, Simulation;

var
   insim, outsim:  SimulationDetails;

begin
   insim := readSimulationDetails('../input/uk-sim-initial.ini');
   recordSimulationDetails('test.ini', insim);
   outsim := readSimulationDetails('test.ini');
   if (compareSimulationDetails(insim, outsim)) then
      WriteLn('Tests passed.')
   else
      WriteLn('Tests Failed.');
end.
