{
   This is a basic wrapper for the routines in the Simulation unit.  It takes an argument and tells the Simulation unit to read it into a SimulationDetails record and then run that.
}
program coRvidReseed;

uses 
   Simulation;

var
   sim: SimulationDetails;
   inputfile: ansistring;
   newseeds: string;
begin
   if ParamCount > 1 then
   begin

      WriteLn('');
      WriteLn('coRvid mrc-ide Covid 19 simulation tool: Reseed');
      WriteLn('===============================================');
      WriteLn('');

      inputfile := ParamStr(1);
      sim := readSimulationDetails(inputfile);

      writeSimulationDetails(sim);
      
      newseeds := generateSeeds();
      WriteLn('');
      WriteLn('New seeds: ' + newseeds);
      WriteLn('');
      sim.Seeds := newseeds;
      writeSimulationDetails(sim);
      
      recordSimulationDetails(ParamStr(2), sim);
   end
   else
     WriteLn('[./]coRvidReseed.exe <old inifile> <new inifile>');
end.
