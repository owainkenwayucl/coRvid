FPC=fpc
FPARGS=-Mobjfpc

coRvid.exe: coRvid.pas Simulation.pas Makefile
	$(FPC) $(FPARGS) -ocoRvid.exe coRvid.pas

cleaneditor:
	rm -rf fp.cfg fp.ini fp.dsk fp___.out fp___.err .*.swp

clean:
	rm -f *.exe *.ppu *.o
