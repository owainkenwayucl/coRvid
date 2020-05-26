unit coRvid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Simulation;

type

  { TSimulationDetailsForm }

  TSimulationDetailsForm = class(TForm)
    AdminDir: TEdit;
    Binary: TEdit;
    ControlRoots: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LoadDialog: TOpenDialog;
    RunNumVal: TEdit;
    InitialSimulation: TRadioButton;
    RunNumber: TRadioButton;
    RunDetails: TGroupBox;
    SaveDialog: TSaveDialog;
    Seeds: TEdit;
    Threads: TEdit;
    Label7: TLabel;
    OutputDir: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ParamDir: TEdit;
    PopulationDir: TEdit;
    R: TEdit;
    Save: TButton;
    Load: TButton;
    Country: TGroupBox;
    Output: TGroupBox;
    Simulation: TGroupBox;
    Parameters: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ShortName: TEdit;
    LongName: TEdit;
    Run: TButton;

    procedure LoadClick(Sender: TObject);

  private

  public

  end;

var
  SimulationDetailsForm: TSimulationDetailsForm;
  LoadFileName: string;
  SimDetails: SimulationDetails;

implementation

{$R *.lfm}

{ TSimulationDetailsForm }
procedure UpdateForm(s: SimulationDetails);
   begin
      SimulationDetailsForm.LongName.text := s.Country.LongName;
      SimulationDetailsForm.ShortName.text := UpperCase(s.Country.ShortName);

      SimulationDetailsForm.R.text := FloatToStr(s.R);
      SimulationDetailsForm.AdminDir.text := s.AdminDirectory;
      SimulationDetailsForm.ParamDir.text := s.ParameterDirectory;
      SimulationDetailsForm.PopulationDir.text := s.PopulationsDirectory;
      SimulationDetailsForm.ControlRoots.text := s.ControlRoots;

      SimulationDetailsForm.Binary.text := s.Binary;
      SimulationDetailsForm.Threads.text := IntToStr(s.Threads);
      SimulationDetailsForm.Seeds.text := s.Seeds;
      SimulationDetailsForm.RunNumVal.text := IntToStr(s.Run);

      SimulationDetailsForm.OutputDir.text := s.OutputDirectory;

      if isStartup(s) then
         begin
            SimulationDetailsForm.InitialSimulation.Checked := TRUE;
         end
      else
         begin
            SimulationDetailsForm.RunNumber.Checked :=TRUE;
         end;
   end;

procedure TSimulationDetailsForm.LoadClick(Sender: TObject);
   begin
      if LoadDialog.Execute then
         begin
            LoadFileName := LoadDialog.FileName;
            {ShowMessage(LoadFileName);}
            SimDetails := readSimulationDetails(LoadFileName);
            UpdateForm(SimDetails);
         end;
   end;



end.

