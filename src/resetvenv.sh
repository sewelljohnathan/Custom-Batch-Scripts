#!/bin/bash
# Resets a python virtual environment

# Check for global environment
if [[ ${VIRTUAL_ENV} == "" ]]; then
    echo "Are you sure you want to reset the global environment? (Y/n) "
    read response

    if [[ ${response} != "Y" ]]; then
        exit 0
    fi

fi

# Create temporary file
temp_file = $(mktemp)
pip freeze > ${temp_file}

# Uninstall
if ![[ -s ${temp_file} ]]; then
    pip uninstall -r ${temp_file} -y
fi

# Cleanup
rm ${temp_file}
