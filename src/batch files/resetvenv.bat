:: Resets a python virtual environment

@echo off

:: Make sure that this is run in a venv
if not defined VIRTUAL_ENV (

    echo Will not run on a global environment
    exit /b
)

:: Save the contents of pip freeze into a file and then use it for pip uninstall
pip freeze > requirements.txt.tmp
pip uninstall -r requirements.txt.tmp -y
del requirements.txt.tmp

:: If a file is provided, use it to install new requirements
if not "%1"=="" (
    pip install -r %1
)
