#!/bin/bash
# Compiles and tests a java file against all output files in the directory

# Get cli flags
SHOW_DIFF=false
for arg in "$@"; do
    case $arg in

    -s | --show-diff)
        SHOW_DIFF=true
        shift
        ;;

    *)
        # Compile the java file
        java_file="$1.java";
        if [[ -f $java_file ]]; then
            javac $java_file
        else
            echo "Could not find file $java_file"
            exit 1
        fi

        ;;
    esac
done


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

        # Run the java program
        echo -n "${file::-3}: "
        java $1 < $file > output.txt

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