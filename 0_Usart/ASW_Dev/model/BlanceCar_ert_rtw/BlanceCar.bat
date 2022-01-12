@if not "%MINGW_ROOT%" == "" (@set "PATH=%PATH%;%MINGW_ROOT%")

cd .

if "%1"=="" ("H:\0_MATL~1\bin\win64\gmake"  -f BlanceCar.mk all) else ("H:\0_MATL~1\bin\win64\gmake"  -f BlanceCar.mk %1)
@if errorlevel 1 goto error_exit

exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
