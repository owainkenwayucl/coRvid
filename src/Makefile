FPC=fpc
FPARGS=-Mobjfpc 
INSTALLDIR=..

ifneq ($(strip $(DESTDIR)),) 
	INSTALLDIR=$(DESTDIR)
endif

coRvid.exe: coRvid.pas Simulation.pas Makefile
	$(FPC) $(FPARGS) -ocoRvid.exe coRvid.pas

install: coRvid.exe
	cp coRvid.exe $(INSTALLDIR)

cleaneditor:
	rm -rf fp.cfg fp.ini fp.dsk fp___.out fp___.err .*.swp

clean:
	rm -f *.exe *.ppu *.o
