Program coRvid;

uses 
   Simulation, classes, sysutils, IniFiles;

var
   sim: SimulationDetails;

begin
   sim.Country.ShortName := 'uk';
   sim.Country.LongName := 'United Kingdom';

   sim.R := 3.0;
   
end.
