@ECHO OFF
set IS_ELEVATED=0
whoami /groups | findstr /b /c:"Mandatory Label\High Mandatory Level" > nul: && set IS_ELEVATED=1
if %IS_ELEVATED% == 0 (
    echo You must run the command prompt as administrator...
    pause
    exit /b 1
) else (
    echo The command prompt is run as administrator...
    echo Place the code you want to execute in this else block
)
