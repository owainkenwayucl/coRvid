{
   This is a basic wrapper for the routines in the Simulation unit.  It takes an argument and tells the Simulation unit to read it into a SimulationDetails record and then run that.
}
Program coRvid;

uses 
   Simulation;

var
   sim: SimulationDetails;
   inputfile: ansistring;

begin
   if ParamCount > 0 then
   begin
      inputfile := ParamStr(1);
      sim := readSimulationDetails(inputfile);

      writeSimulationDetails(sim);
      runSimulation(sim);
   end
   else
     WriteLn('[./]coRvid.exe <inifile>');
end.
