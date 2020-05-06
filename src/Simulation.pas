{ 
   This unit contains definitions and methods for handling details of the simulation to be launched.
}
unit Simulation;

interface

type
   SimulationDetails = record
      Country: record
         ShortName, LongName: string;
      end;
      ControlRoots: string;
      AdminDirectory, ParameterDirectory, PopulationsDirectory: string;
      Binary, OutputDirectory: string; 
      Seeds: string; { TODO: This should be four integers really. }
      Threads, Run: integer;
      R: double;
   end;

function readSimulationDetails(const filename: string): SimulationDetails; 

function generateCommandLine(const sim: SimulationDetails): string;

procedure writeSimulationDetails(const sim: SimulationDetails);

implementation

uses classes, sysutils, IniFiles, Process;

var
   ini: Tinifile;
   stdout: ansistring;
   cmd: string;
   flags: TReplaceFlags;
{
   This function reads in an ini file with simulation parameters and returns a SimulationDetails record.
}
function readSimulationDetails(const filename: string): SimulationDetails;
   begin
      ini := Tinifile.Create(filename);
      readSimulationDetails.Country.ShortName := ini.ReadString('Country', 'ShortName','uk');
      readSimulationDetails.Country.LongName := ini.ReadString('Country', 'LongName','United Kingdom');

      readSimulationDetails.R := ini.ReadFloat('Parameters','R',3.0);
      readSimulationDetails.AdminDirectory := ini.ReadString('Parameters','AdminDirectory','data/admin_units');
      readSimulationDetails.ParameterDirectory := ini.ReadString('Parameters','ParameterDirectory','data/param_files');
      readSimulationDetails.PopulationsDirectory := ini.ReadString('Parameters','PopulationsDirectory','data/populations');
      readSimulationDetails.ControlRoots := ini.ReadString('Parameters','ControlRoots','NoInt');
      readSimulationDetails.Threads := ini.ReadInteger('Simulation','Threads',1);
      readSimulationDetails.Run := ini.ReadInteger('Simulation','Run',0); { Default to setup }
      readSimulationDetails.Seeds := ini.ReadString('Simulation','Seeds','98798150 729101 17389101 4797132');
      readSimulationDetails.Binary := ini.ReadString('Simulation','Binary',Concat('CovidSim_',readSimulationDetails.Country.ShortName));

      readSimulationDetails.OutputDirectory := ini.ReadString('Output','OutputDirectory','output');

      ini.Free;      
   end;

{
   Internal function to determine if we need to generate network files/use text density files.
}
function isStartup(const sim: SimulationDetails): boolean;
   begin 
      isStartup := FALSE;
      if (sim.Run < 1) then
         isStartup := TRUE;
   end;

{
   Internal function to work out the real path to the binary.
}
function getFullBinaryPath(const binary: string): string;
   begin
      getFullBinaryPath := '';
      if RunCommand('/bin/bash',['-c',Concat('which ', binary)],stdout) then
         getFullBinaryPath := Trim(stdout);
   end;

{
   Procedure to print what we know about a simulation.
}
procedure writeSimulationDetails(const sim: SimulationDetails);
   begin
      WriteLn('Country:               ', sim.Country.LongName);
      WriteLn('Country Code:          ', sim.Country.ShortName);
      WriteLn('R:                     ', sim.R:1:2);
      WriteLn('Admin Directory:       ', sim.AdminDirectory);
      WriteLn('Parameter Directory:   ', sim.ParameterDirectory);
      WriteLN('Control Roots:         ', sim.ControlRoots);
      WriteLn('Populations Directory: ', sim.PopulationsDirectory);
      WriteLn('Ouput Directory:       ', sim.OutputDirectory);
      WriteLn('Binary:                ', sim.Binary);
      WriteLn('Seeds:                 ', sim.Seeds);
      WriteLn('Threads:               ', sim.Threads);
      WriteLn('Run:                   ', sim.Run);
      WriteLn('');
      WriteLn('Derived information: ');
      if isStartup(sim) then
         WriteLn('This input file is in startup mode and will generate a network.')
      else
         WriteLn('This input file needs a network.');

      WriteLn('Full path to binary: ', getFullBinaryPath(sim.Binary));
      WriteLn('Generated Command Line: ', generateCommandLine(sim));

   end;

function generateCommandLine(const sim: SimulationDetails): string;
   begin
      cmd := '';
      flags := [rfReplaceAll];

      cmd := Concat(getFullBinaryPath(sim.Binary), ' /c:',IntToStr(sim.Threads),' /A:',sim.AdminDirectory,'/',StringReplace(sim.Country.LongName,' ','_',flags),'_admin.txt');
 {     if isStartup(sim) then
         begin
           
         end
      else
         begin

         end;
}
      generateCommandLine := cmd;
   end;

end.
