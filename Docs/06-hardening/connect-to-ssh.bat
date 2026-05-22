@echo off
REM Batch script to connect via SSH
REM Replace 'Esther' and '10.10.10.10' with the desired username and IP if needed

set username=Esther
set ip=10.10.10.10
set port=2000

echo Connecting to %username%@%ip% on port %port%...
ssh %username%@%ip% -p %port%

REM Pause the script to see output after execution
pause