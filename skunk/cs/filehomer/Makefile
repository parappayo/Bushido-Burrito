#
#  Generic one-shot build Makefile for C# Mono projects.
#
#  Tip: use ":set noexpandtab" in vim for tab editing
#

EXE=filehomer.exe
MCS=gmcs
LIBS=/r:System.Data /r:System.Windows.Forms /r:System.Drawing

all: $(EXE)

clean:
	rm $(EXE)

$(EXE): *.cs
	$(MCS) $(LIBS) $? -out:$(EXE)

