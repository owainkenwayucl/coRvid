{ 
   This unit contains definitions and methods for handling details of the 
   simulation to be launched.
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

implementation

end.
