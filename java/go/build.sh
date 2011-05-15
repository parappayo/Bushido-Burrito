#!/bin/sh
javac *.java
mkdir -p com/bushidoburrito/go
cp *.class com/bushidoburrito/go
jar cvfm go.jar manifest.txt com img

