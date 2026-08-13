@echo off
setlocal enableextensions enabledelayedexpansion

:: Get file path from command line / drag-and-drop argument or prompt the user
set "FILE_PATH=%~1"
if "%FILE_PATH%"=="" (
    set /p "FILE_PATH=Drag and drop a file here or enter path: "
)

:: Remove extra quotes if present
set "FILE_PATH=%FILE_PATH:"=%"

:: Validate file existence
if not exist "%FILE_PATH%" (
    echo.
    echo Error: The specified file does not exist.
    echo.
    pause
    exit /b 1
)

echo.
echo Locking file: "%FILE_PATH%"
echo.

:: 1. Set Read-Only attribute (+r)
attrib +r "%FILE_PATH%"

:: 2. Deny Write (W), Delete (D), Write Attributes (WA), and Write Extended Attributes (WEA)
:: Uses SID *S-1-1-0 (Everyone) to ensure language independence across OS localized versions
icacls "%FILE_PATH%" /deny *S-1-1-0:(W,D,WA,WEA) >nul 2>&1

if %errorlevel% equ 0 (
    echo [SUCCESS] File is now strictly read-only for all users.
) else (
    echo [WARNING] Permission modification failed. Please right-click the batch file and 'Run as Administrator'.
)

echo.
pause