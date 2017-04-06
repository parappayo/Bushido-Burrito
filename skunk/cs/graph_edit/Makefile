
EXE=graph_edit.exe
MCS=mcs
LIBS=-pkg:dotnet -lib:/usr/lib/mono/2.0

$(EXE): *.cs UI/*.cs Graph/*.cs
	$(MCS) $(LIBS) $? -out:$(EXE)

all: $(EXE)

clean:
	rm $(EXE)
