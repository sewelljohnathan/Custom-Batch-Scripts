#!/bin/bash

# Compiles and tests a java file against all output files in the directory

# Compile the java file 
java_file="$1.java";
if [[ -f $java_file ]]; then
    javac $java_file
else
    echo "Could not find file $java_file"
    exit 1
fi

# Loop through all the files
for file in *; do

    # Check if the file is a .in
    if [ ${file: -3} == .in ]; then
        output_file=${file::-3}.out

    # Check if the file is .in.txt
    elif [[ ${file: -7} == .in.txt ]]; then
        output_file=${file::-7}.out.txt

    # Not an input file
    else
        continue
    fi

    # Make sure the output file exists
    if [[ -f $output_file ]]; then

        # Run the java program
        java $1 < $file > output.txt

        # Find the difference
        diff -w -B $output_file output.txt
        correct=$?

        if [[ $correct != 0 ]]; then
            echo "$file Failed"
        fi

    # Could not find the output file
    else
        echo "Could not find a corresponding output file $output_file"
        exit 1
    fi

done