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
