:: A script that compiles java files to a bin/ folder, then runs them

@echo off
if not exist %1.java (
    echo Could not find %1.java
    exit /b
)
if not exist ../bin/%1.class (
    javac -d ../bin %1.java
)
java -cp ../bin %*