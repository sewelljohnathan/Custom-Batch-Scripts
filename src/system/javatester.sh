#!/bin/bash
# This is a script I made for automating the process of testing java programming assignments.


# Print the help screen
function print_help {
    printf "Usage: ${0##*/} <OPTIONS> [filename]\n\n"
    printf " Compiles and tests a java program using all available .in and cooresponding .out files.\n\n"
    printf "Options:\n\n"
    printf " %-20s" "-d, --diff"  
    printf "Displays the difference, if any, between the .out file and program output.\n\n"
    printf " %-20s" "-b, --bin"
    printf "Compile java file to ../bin.\n\n"
    printf " %-20s" "-t, --time"
    printf "Time the program execution.\n\n"
    printf " %-20s" "-h, --help"
    printf "Show this message.\n\n"
}

# If no input is given, just print the help screen
if [[ $# == 0 ]]; then
    print_help
    exit 0
fi

# Get cli flags
SHOW_DIFF=false
USE_BIN=false
TIMEIT=false
for arg in $@; do
    case $arg in

    -d | --diff)
        SHOW_DIFF=true

        shift
        ;;

    -b | --bin)
        USE_BIN=true

        shift
        ;;

    -t | --time)
        TIMEIT=true
        shift
        ;;

    -h | --help)
        print_help

        exit 0
        ;;

    esac
done


# Check if the argument is more than 5 characters and extract the filename
java_file=$1;
if [[ ${#java_file} -gt 5 ]]; then
    java_name=${1::-5}
else
    echo "Not a valid file."
    exit 1
fi

# Check if it is a .java file
if [[ ${java_file: -5} != ".java" ]]; then
    echo "Not a java file."
    exit 1
fi

# Compile the java file
if [[ -f $java_file ]]; then

    # Determine if to compile to ../bin
    if [[ $USE_BIN == true ]]; then
        javac -d "../bin" $java_file
    else
        javac $java_file
    fi

else
    echo "Could not find file $java_file"
    exit 1
fi


# Loop through all the files
for file in *; do

    # Check if the file is a .in file
    if [ ${file: -3} == .in ]; then
        output_file=${file::-3}.out
    else
        continue
    fi

    # Make sure the output file exists
    if [[ -f $output_file ]]; then
        echo -n "${file::-3}: "

        # Get the start time
        if [[ $TIMEIT == true ]]; then
            start_time=$(date +%s%N)
        fi

        # Run the java program
        if [[ $USE_BIN == true ]]; then
            java -cp "../bin" $java_name < $file > output.txt
        else
            java $java_name < $file > output.txt
        fi

        # Get the end time
        if [[ $TIMEIT == true ]]; then
            end_time=$(date +%s%N)
        fi

        # Find the difference
        if [[ $SHOW_DIFF == true ]]; then  
            diff -w -B $output_file output.txt
            correct=$?

            # Only print the success, since errors will be seen
            if [[ $correct == 0 ]]; then
                echo "───==≡≡ΣΣ((( つºل͜º)つ"
            fi

        else
            diff -w -B $output_file output.txt &> /dev/null
            correct=$?

            # Print the boolean correctness
            if [[ $correct == 0 ]]; then
                echo "───==≡≡ΣΣ((( つºل͜º)つ"
            else
                echo ":'("
            fi
        fi

        # Print the time
        if [[ $TIMEIT == true ]]; then
            seconds=$((($end_time - $start_time) / 1000000000))
            milliseconds=$(((($end_time - $start_time) / 1000000) - ($seconds * 1000)))
            echo " Time: ${seconds}.${milliseconds}s"
        fi

    # Could not find the output file
    else
        echo "Could not find a corresponding output file $output_file"
        exit 1
    fi

done