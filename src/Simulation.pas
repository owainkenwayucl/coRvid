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

function generateCommandLine(const sim: SimulationDetails; const binary: boolean): ansistring;

procedure writeSimulationDetails(const sim: SimulationDetails);
procedure runSimulation(const sim: SimulationDetails);

implementation

uses classes, sysutils, IniFiles, Process;

var
   ini: Tinifile;
   stdout: ansistring;
   cmd: ansistring;
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
   TODO: This function is bad and needs redesign.
}
function getContinent(const sim: SimulationDetails): string;
   begin
      if (sim.Country.ShortName = 'uk') then
         getContinent := 'eur'
      else
         getContinent := 'usacan';
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
      WriteLn('Generated Command Line: ', generateCommandLine(sim, TRUE));

   end;

procedure runSimulation(const sim: SimulationDetails);
   begin
      cmd := generateCommandLine(sim, FALSE);
      WriteLn(cmd);
      ExecuteProcess(getFullBinaryPath(sim.Binary), cmd, []);
   end;

function generateCommandLine(const sim: SimulationDetails; const binary: boolean): ansistring;
   begin
      cmd := '';
      if binary then
         cmd := getFullBinaryPath(sim.Binary);
      flags := [rfReplaceAll];

      cmd := cmd + ' /c:'+IntToStr(sim.Threads) + ' /A:'+sim.AdminDirectory + '/' + StringReplace(sim.Country.LongName,' ' , '_',flags) + '_admin.txt /PP:' + sim.ParameterDirectory + '/pre'+UpperCase(sim.Country.ShortName) + '_R0=2.0.txt /P:' + sim.ParameterDirectory + '/p_' + sim.ControlRoots + '.txt /O:' + sim.OutputDirectory + '/' + UpperCase(sim.Country.ShortName) + '_' + sim.ControlRoots + '_R0=' + FloatToStr(sim.R);
      if isStartup(sim) then
         begin
            cmd := cmd + ' /D:' + sim.PopulationsDirectory + '/wpop_' + getContinent(sim) + '.txt /M:' + sim.OutputDirectory + '/'+UpperCase(sim.Country.ShortName) + '_pop_density.bin /S:' + sim.OutputDirectory + '/Network_' + UpperCase(sim.Country.ShortName) + '_T' + IntToStr(Sim.Threads) + '_R' + FloatToStr(sim.R) + '.bin /R:' + FloatToStr(sim.R/2) + ' ' + sim.Seeds;
         end
      else
         begin
            cmd := cmd + ' /D:' + sim.OutputDirectory + '/' + UpperCase(sim.Country.ShortName) + '_pop_density.bin /L:' + sim.OutputDirectory + '/Network_' + UpperCase(sim.Country.ShortName) + '_T' + IntToStr(Sim.Threads) + '_R' + FloatToStr(sim.R) + '.bin /R:'+FloatToStr(sim.R/2)+' '+sim.Seeds;

         end;

      generateCommandLine := cmd;
   end;

end.
