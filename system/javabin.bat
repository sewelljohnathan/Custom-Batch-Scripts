:: A script that compiles java files to a sibling folder bin/, then runs them

@echo off

:: Check if the java file exists
if not exist %1.java (
    echo Could not find %1.java
    exit /b
)

:: Check if the java file is compiled
if not exist ../bin/%1.class (
    javac -d ../bin %1.java
)

:: Run the java program
java -cp ../bin %*