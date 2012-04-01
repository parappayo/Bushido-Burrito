#
#  Generic one-shot build Makefile for C# Mono projects.
#
#  Tip: use ":set noexpandtab" in vim for tab editing
#

EXE=tilemap.exe
MCS=gmcs
LIBS=/r:System.Data /r:System.Windows.Forms /r:System.Drawing /r:System.Xml

all: $(EXE)

clean:
	rm $(EXE)

$(EXE): *.cs
	$(MCS) $(LIBS) $? -out:$(EXE)

