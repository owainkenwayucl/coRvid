FPC=fpc
# Turn on object FPC mode and ansistrings.
FPARGS=-Mobjfpc -Sh
INSTALLDIR=..

ifneq ($(strip $(DESTDIR)),) 
	INSTALLDIR=$(DESTDIR)
endif

all: coRvid.exe CompareTSV.exe coRvidReseed.exe

tests: test.exe
	./test.exe

coRvid.exe: coRvid.pas Simulation.pas Makefile
	$(FPC) $(FPARGS) -ocoRvid.exe coRvid.pas

coRvidReseed.exe: coRvidReseed.pas Simulation.pas Makefile
	$(FPC) $(FPARGS) -ocoRvidReseed.exe coRvidReseed.pas

CompareTSV.exe: CompareTSVFile.pas TSVTools.pas Makefile
	$(FPC) $(FPARGS) -oCompareTSV.exe CompareTSVFile.pas

# This is dev only and not for unit testing
test.exe: test.pas *.pas
	$(FPC) $(FPARGS) -otest.exe test.pas

install: coRvid.exe CompareTSV.exe
	cp coRvid.exe $(INSTALLDIR)
	cp CompareTSV.exe $(INSTALLDIR)
	cp coRvidReseed.exe $(INSTALLDIR)

cleaneditor:
	rm -rf fp.cfg fp.ini fp.dsk fp___.out fp___.err .*.swp

clean: tidy
	rm -f *.exe 

tidy:
	rm -f *.ppu *.o tests/ouput/*.ini
	
