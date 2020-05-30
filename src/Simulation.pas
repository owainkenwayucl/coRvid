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

function isStartup(const sim: SimulationDetails): boolean;

function compareSimulationDetails(const sim1, sim2: SimulationDetails): boolean;

function readSimulationDetails(const filename: string): SimulationDetails; 

function copySimulationDetails(const orig: SimulationDetails): SimulationDetails;

function generateSeeds(): string;

procedure recordSimulationDetails(const filename: string; sim: SimulationDetails);

procedure writeSimulationDetails(const sim: SimulationDetails);

procedure runSimulation(const sim: SimulationDetails);

implementation

uses classes, sysutils, IniFiles, Process;

var
   ini: Tinifile;
   stdout: ansistring;
   cmd: ansistring;
   flags: TReplaceFlags;
   r, i: LongInt;
   seeded : boolean = FALSE;

{ NOTE: INTERNAL FUNCTIONS AND PROCEDURES BELOW. }

{
   Internal function to work out the real path to the binary.
}
function getFullBinaryPath(const binary: string): ansistring;
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
   Generate a command line either to be printed out and used later or to be used by runSimulation.
   binary - boolean as to whether or not to include the binary in the command line or just the arguments.

   Using ansistring as the return value as due to the significant length of arguments passed to the mrc-ide covid sim, command line exceeds 255 characters.
}
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

{ NOTE: PUBLIC FUNCTIONS AND PROCEDURES BELOW. }

{
   Function to determine if we need to generate network files/use text density files.
}
function isStartup(const sim: SimulationDetails): boolean;
   begin 
      isStartup := FALSE;
      if (sim.Run < 1) then
         isStartup := TRUE;
   end;

{
   This function compares two SimulationDetails records to see if they refer to the same simulation.
}
function compareSimulationDetails(const sim1, sim2: SimulationDetails): boolean;
   begin
      compareSimulationDetails := TRUE;

      if not (Trim(sim1.Country.ShortName) = Trim(sim2.Country.ShortName)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.Country.LongName) = Trim(sim2.Country.LongName)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.ControlRoots) = Trim(sim2.ControlRoots)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.AdminDirectory) = Trim(sim2.AdminDirectory)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.ParameterDirectory) = Trim(sim2.ParameterDirectory)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.PopulationsDirectory) = Trim(sim2.PopulationsDirectory)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.Binary) = Trim(sim2.binary)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.OutputDirectory) = Trim(sim2.OutputDirectory)) then compareSimulationDetails := FALSE;
      if not (Trim(sim1.Seeds) = Trim(sim2.Seeds)) then compareSimulationDetails := FALSE;
      if not (sim1.Threads = sim2.Threads) then compareSimulationDetails := FALSE;
      if not (sim1.Run = sim2.Run) then compareSimulationDetails := FALSE;
      if not (sim1.R = sim2.R) then compareSimulationDetails := FALSE;
      
   end;

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

      if isStartup(readSimulationDetails) = FALSE then
         readSimulationDetails.OutputDirectory := readSimulationDetails.OutputDirectory  + '-' + IntToStr(readSimulationDetails.Run);

      ini.Free;      
   end;

{
   Safely duplicate a SimulationDetails record.
}
function copySimulationDetails(const orig: SimulationDetails): SimulationDetails;
   begin
      copySimulationDetails.Country.ShortName := orig.Country.ShortName;
      copySimulationDetails.Country.LongName := orig.Country.LongName;
      copySimulationDetails.R := orig.R;
      copySimulationDetails.AdminDirectory := orig.AdminDirectory;
      copySimulationDetails.ParameterDirectory := orig.ParameterDirectory;
      copySimulationDetails.PopulationsDirectory := orig.PopulationsDirectory;
      copySimulationDetails.ControlRoots := orig.ControlRoots;
      copySimulationDetails.Threads := orig.Threads;
      copySimulationDetails.Run := orig.Run;
      copySimulationDetails.Seeds := orig.Seeds;
      copySimulationDetails.Binary := orig.Binary;
      copySimulationDetails.OutputDirectory := orig.OutputDirectory;

   end;
{
   Generate a seed string.
}
function generateSeeds(): string;
   begin
      generateSeeds := '';
      if not seeded then
         begin
            seeded := TRUE;
            Randomize;
         end;
      for i := 1 to 4 do
         begin
            r := Random(maxint);
            generateSeeds := generateSeeds + IntToStr(r) + ' ';
         end;
      generateSeeds := trim(generateSeeds);
      
   end;

{
   This procedure writes a SimulationDetails record out to an ini file.
}
procedure recordSimulationDetails(const filename: string; sim: SimulationDetails);
   begin
      ini := Tinifile.Create(filename);
      ini.WriteString('Country', 'ShortName',sim.Country.ShortName);
      ini.Writestring('Country', 'LongName',sim.Country.LongName);

      ini.WriteFloat('Parameters','R',sim.R);
      ini.WriteString('Parameters','AdminDirectory',sim.AdminDirectory);
      ini.WriteString('Parameters','ParameterDirectory',sim.ParameterDirectory);
      ini.WriteString('Parameters','PopulationsDirectory',sim.PopulationsDirectory);
      ini.WriteString('Parameters','ControlRoots',sim.ControlRoots);
      ini.WriteInteger('Simulation','Threads',sim.Threads);
      ini.WriteInteger('Simulation','Run',sim.Run); 
      ini.WriteString('Simulation','Seeds',sim.Seeds);
      ini.WriteString('Simulation','Binary',sim.Binary);

      ini.WriteString('Output','OutputDirectory',sim.OutputDirectory);
         
      ini.UpdateFile;

      ini.Free;
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


{
   Procedure to actually run a simulation.
   Currently using ExecuteProcess which is arguably bad style but does what I want.
}
procedure runSimulation(const sim: SimulationDetails);
   begin
      cmd := generateCommandLine(sim, FALSE);
      ExecuteProcess(getFullBinaryPath(sim.Binary), cmd, []);
   end;


end.
