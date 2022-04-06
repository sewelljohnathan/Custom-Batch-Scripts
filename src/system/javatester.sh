#!/bin/bash
# This is a script I made for automating the process of testing java programming assignments.


# Get cli flags
SHOW_DIFF=false
USE_BIN=false
for arg in "$@"; do
    case $arg in

    -s | --show-diff)
        SHOW_DIFF=true

        shift
        ;;

    -b | --bin)
        USE_BIN=true

        shift
        ;;

    -h | --help)
        printf "Usage: $0 [OPTIONS] [filename]\n\n"
        printf " Compiles and tests a java program using all available .in and cooresponding .out files.\n\n"
        printf "Options:\n\n"
        printf " %-20s" "-s, --show-diff"  
        printf "Displays the difference, if any, between the .out file and program output.\n\n"
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

        # Run the java program
        if [[ $USE_BIN == true ]]; then
            java -cp "../bin" $java_name < $file > output.txt
        else
            java $java_name < $file > output.txt
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

    # Could not find the output file
    else
        echo "Could not find a corresponding output file $output_file"
        exit 1
    fi

done