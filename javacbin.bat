:: A simple batch script that outputs compiled java .class files into a bin folder
:: Only meant as a shorthand.
:: Created with the intention to be run in src/, for which there is a sibing directory bin/

@echo off
javac -d ../bin %*