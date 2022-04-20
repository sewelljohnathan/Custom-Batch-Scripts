:: Compiles and tests a java file against all output files in the directory

@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Compile the java file 
if exist %1.java (
    javac %1.java
) else (
    echo Could not find file %1.java
    exit /b
)

:: Loop through all input files
for %%f in (*) do (
    
    set filename=%%~nf
    set extension=%%~xf
    set /a is_input=0

    :: Check if the file is a .in
    if !extension! == .in (

        set input_file=!filename!.in
        set output_file=!filename!.out
        set /a is_input=1
    )

    :: Check if the file is a .txt (e.g. file.in.txt)
    if !extension! == .txt (
        
        :: Check if the file is input
        if !filename:~-3! == .in (
            set input_file=!filename:~0,-3!.in.txt
            set output_file=!filename:~0,-3!.out.txt
            set /a is_input=1
        )
    )

    :: Check if the input/output files exists
    if !is_input! == 1 (
        if exist !input_file! (
            if exist !output_file! (

                :: Run the program
                java %1 < !input_file! > output.txt
                fc !output_file! output.txt
            )
        )
    )
)