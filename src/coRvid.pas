Program coRvid;

uses 
   Simulation;

var
   sim: SimulationDetails;

begin
   sim := readSimulationDetails('../input/uk-sim.ini');

   writeln(sim.Country.ShortName);
end.
