unit Simulation;

interface

type
   SimulationDetails = record
      Country: record
         ShortName, LongName: string;
      end;

      AdminDirectory, ParameterDirectory, PopulationsDirectory: string;
      Binary, OutputDirectory, Seeds: string;
      Threads, Run: integer;
      R: double;
   end;

implementation

end.
