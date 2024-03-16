@echo off
setlocal enabledelayedexpansion

set CWD=%cd%

:: Function definitions
call :make_boa
if %errorlevel% neq 0 exit /b %errorlevel%

call :make_dsp
if %errorlevel% neq 0 exit /b %errorlevel%

call :make_room_plans
if %errorlevel% neq 0 exit /b %errorlevel%

goto :eof

:make_boa
    cd LaTeX\Book_of_abstracts
    if %errorlevel% neq 0 exit /b 3
    latexmk -pdf BookOfAbstracts.tex
    if %errorlevel% neq 0 exit /b 4
    copy BookOfAbstracts.pdf "%CWD%"
    cd "%CWD%"
    if %errorlevel% neq 0 exit /b 255
goto :eof

:make_dsp
    cd LaTeX\Daily_Scientific_Program
    if %errorlevel% neq 0 exit /b 5
    latexmk -pdf Daily_Scientific_Program.tex
    if %errorlevel% neq 0 exit /b 6
    copy Daily_Scientific_Program.pdf "%CWD%"
    cd "%CWD%"
    if %errorlevel% neq 0 exit /b 255
goto :eof

:make_room_plans
    cd LaTeX\Daily_Scientific_Program\rooms
    if %errorlevel% neq 0 exit /b 7
    for %%f in (*.tex) do (
        latexmk -pdf "%%f"
    )
    copy *.pdf "%CWD%"
    cd "%CWD%"
    if %errorlevel% neq 0 exit /b 255
goto :eof

:: Fetch data from ConfTool Pro
get_conftool_data.py
if %errorlevel% neq 0 exit /b 1
:: create LaTeX files
BoA_DSP_generator.py
if %errorlevel% neq 0 exit /b 2

:: Default action if no option is provided
set action=all

:: Parse command-line options
:parse_opts
if "%~1"=="" goto :execute_action
if "%~1"=="-b" set action=boa & goto :shift_and_parse
if "%~1"=="-d" set action=dsp & goto :shift_and_parse
if "%~1"=="-s" set action=dsp & goto :shift_and_parse
if "%~1"=="-r" set action=rooms & goto :shift_and_parse
if "%~1"=="-a" set action=all & goto :shift_and_parse
if "%~1"=="-h" echo Usage: RunMe.bat [option] & echo Options: & echo  -h,-?    print this help text & echo  -b       generate book of abstracts & echo  -d,-s    generate daily scientific program & echo  -r       generate room plans & echo  -a       generate all PDFs & exit /b 0
echo Invalid option: %~1 & exit /b 1

:shift_and_parse
shift
goto :parse_opts

:execute_action
if "%action%"=="boa" call :make_boa
if "%action%"=="dsp" call :make_dsp
if "%action%"=="rooms" call :make_room_plans
if "%action%"=="all" (
    call :make_boa
    call :make_dsp
    call :make_room_plans
)
