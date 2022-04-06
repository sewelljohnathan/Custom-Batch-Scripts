#!/bin/bash
# This is a script I wrote to condense compiling and running a java file into one step.


# Get cli flags
USE_BIN=false
for arg in "$@"; do
    case $arg in

    -b | --bin)
        USE_BIN=true

        shift
        ;;

    -h | --help)
        printf "Usage: $0 [OPTIONS] [filename]\n\n"
        printf " Compiles and runs a java program.\n\n"
        printf "Options:\n\n"
        printf " %-20s" "-b, --bin"
        printf "Compile java file to ../bin.\n\n"
        printf " %-20s" "-h, --help"
        printf "Show this message.\n\n"

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


# Compile 
if [[ $USE_BIN == true ]]; then
    javac -d "../bin" $java_file
else
    javac $java_file
fi


# Check if compiled
compiled=$?
if [[ $compiled != 0 ]];
    echo "Failed to compile."
    exit 1


# Run 
if [[ $USE_BIN == true ]]; then
    java -cp "../bin" $java_name
else
    java $java_name
fi

