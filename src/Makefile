FPC=fpc
FPARGS=-Mobjfpc

coRvid.exe: coRvid.pas Simulation.pas Makefile
	$(FPC) $(FPARGS) -ocoRvid.exe coRvid.pas

clean:
	rm -f *.exe *.ppu *.o
