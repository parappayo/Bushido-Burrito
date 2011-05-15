@echo off
javac *.java
if not exist com\bushidoburrito\go mkdir com\bushidoburrito\go
copy *.class com\bushidoburrito\go
jar cvfm go.jar manifest.txt com img

