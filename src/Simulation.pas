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

      AdminDirectory, ParameterDirectory, PopulationsDirectory: string;
      Binary, OutputDirectory: string; 
      Seeds: string; { TODO: This should be four integers really. }
      Threads, Run: integer;
      R: double;
   end;

function readSimulationDetails(const filename: string): SimulationDetails; 

implementation

uses classes, sysutils, IniFiles;

var
   ini: Tinifile;

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

      readSimulationDetails.Threads := ini.ReadInteger('Simulation','Threads',1);
      readSimulationDetails.Run := ini.ReadInteger('Simulation','Run',0); { Default to setup }
      readSimulationDetails.Seeds := ini.ReadString('Simulation','Seeds','98798150 729101 17389101 4797132');
      readSimulationDetails.Binary := ini.ReadString('Simulation','Binary',Concat('CovidSim_',readSimulationDetails.Country.ShortName));

      readSimulationDetails.OutputDirectory := ini.ReadString('Output','OutputDirectory','output');

      ini.Free;      
   end;

end.
