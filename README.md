# coRvid
Tools for Reproducibly running the mrc-ide covid sim

## Introductory rant 
The world has ended, everything is terrible, and some aspect of it is related to a bit of code.  Which code?  This code: https://github.com/mrc-ide/covid-sim - henceforth "mics" for short.

For various reasons I'm interested in the operation of mics and honestly as a programmer *and not an epidemiologist* I find a lot of its construction and documentation confusing.  At the same time I realised a few weeks ago that I miss Pascal in a way that's uncomfortable.  Slowly the two ideas gelled together in my head - I could use Pascal as a tool to help investigate the behaviour of mics.  It's genius because Pascal should disuade anyone from using my code, right?

*Disclaimer* - this is the first large Pascal project I've done in 20 years.  The code is probably bad.

I'm stuck indoors, obtuse and grumpy and this is what happens.

## What's this coRvid thing then?

Well coRvid is my set of tools for launching the mics code reproducibly with input files in the form of good old traditional `.ini` files.  I'll probaby also write some tools for comparing outputs of the simulations because these are very interestingly tab-separated files with a `.xls` extension (for reasons) and the current regression testing regime checksums said files and therefore tells you nothing about the degree of error.

What the name tells you is I really wanted to name it after a crow.

## Installation

This code requires FreePascal 3 *(ish)*, and is definitely intentionally and definitely not due to incompetence/lack of caring only going to work on a Unix-like system due to path separators.

Check out the repo and then:

```
cd src
make 
make install DESTDIR=/some/install/path
```

This binary is static so you do not need the FreePascal compiler in your environment to use it.

## Use

### `coRvid.exe` 

*(yeah - `.exe`, deal with it)* 

This is main executable which launches simulations.  To use it, you need to write a `.ini` file - you can see examples in `input/`.  For reasons I don't understand, `mics` *appears* to have to operational modes - one where it creates a subset of input files and runs a simulation and one which re-uses the input files from the earlier run.  In the Python wrapper it first does this setup run with a "no intervention" set of constraints and then does a second run with a set of constraints.  These correspond to `input/uk-sim-initial.ini` and `input/uk-sim.ini` respectively.

You will need to copy the `data` directory from mics somewhere.  On UCL resources this along with the code is provided in a module file so we'll assume this configuration, and assume `coRvid.exe` is in your `$PATH`.

On a UCL system, in a directory with your `.ini` files in it:

```bash
# Setup modules
module purge
module load rcps-core compilers/intel/2020 python3/3.7 covid-19-spatial-sim/0.8.0

# Get a copy of the data, and un-gzip the gzipped files
cp -R SPATIALSIM_DATA .
cd data/populations
for a in *.gz
do
  gzip -d $a
done
cd ../..

# Run the zero intervention sim
coRvid.exe uk-sim-initial.ini

# Create a copy of the data for the next sim
cp -R output output-1

# Run the sim with the test intervention
coRvid.exe uk-sim.ini
```