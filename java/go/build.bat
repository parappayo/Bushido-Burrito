@echo off
javac *.java
if not exist com\bushidoburrito\go mkdir com\bushidoburrito\go
copy *.class com\bushidoburrito\go

