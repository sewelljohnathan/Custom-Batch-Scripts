:: A complimentary script to javacbin that runs compiled java programs

@echo off
if not exist ../bin/%1.class (
    cmd /c "javacbin %1.java"
)
cmd /k "java -cp ../bin %1"