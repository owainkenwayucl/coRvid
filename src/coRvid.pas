Program coRvid;

uses 
   Simulation;

var
   sim1,sim2: SimulationDetails;

begin
   sim1 := readSimulationDetails('../input/uk-sim-initial.ini');
   sim2 := readSimulationDetails('../input/uk-sim.ini');

   WriteLn('Sim1:');
   writeSimulationDetails(sim1);
   WriteLn('Sim2:');
   writeSimulationDetails(sim2);
end.
