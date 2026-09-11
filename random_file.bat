@echo off
setlocal EnableDelayedExpansion

:: Initialize variables
set "folder="
set "recursive=0"

:: Parse arguments
:parse_loop
if "%~1"=="" goto validate_args

if /i "%~1"=="/s" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="-s" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="/r" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="-r" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="/recursive" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="--recursive" (
    set "recursive=1"
    shift
    goto parse_loop
)
if /i "%~1"=="/?" goto show_usage
if /i "%~1"=="-h" goto show_usage
if /i "%~1"=="--help" goto show_usage

if not defined folder (
    set "folder=%~1"
    shift
    goto parse_loop
)

shift
goto parse_loop

:validate_args
if not defined folder goto show_usage

:: Check if the folder exists
if not exist "%folder%" (
    echo The folder "%folder%" does not exist.
    exit /b 1
)

:: Collect files into an array
set i=0
if "!recursive!"=="1" (
    for /r "%folder%" %%f in (*) do (
        set /a i+=1
        set "file[!i!]=%%f"
    )
) else (
    for %%f in ("%folder%\*") do (
        set /a i+=1
        set "file[!i!]=%%f"
    )
)

:: If no files found
if %i%==0 (
    echo No files found in "%folder%"
    exit /b 1
)

:: Generate a random number between 1 and i
if %i% LEQ 32768 (
    set /a "rand=(!random! %% i) + 1"
) else (
    set /a "big_rand=(!random! * 32768 + !random!)"
    set /a "rand=(big_rand %% i) + 1"
)
set "selected=!file[%rand%]!"

:: Copy the selected file path to the clipboard
echo(!selected!| clip

:: Open the random file
start "" "!selected!"
exit /b 0

:show_usage
echo Usage: %~nx0 "folder_path" [/s]
echo.
echo Options:
echo(  /s, -s, /r, -r, --recursive   Include files from subdirectories ^(recursive^)
echo(  /?, -h, --help                Show this help message
echo.
echo Examples:
echo   %~nx0 "C:\Music"
echo   %~nx0 "C:\Music" /s
exit /b 1
