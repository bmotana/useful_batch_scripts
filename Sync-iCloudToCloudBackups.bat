@echo off
set "SOURCE=C:\Users\Bafana\iCloudDrive\backup_folder"
set "DEST1=C:\Users\Bafana\OneDrive\backup_folder"
set "DEST2=C:\Users\Bafana\Dropbox\backup_folder"

:: Check if source folder exists
if not exist "%SOURCE%" (
    echo Source folder does not exist: "%SOURCE%"
    pause
    exit /b
)

echo Copying files to OneDrive...
robocopy "%SOURCE%" "%DEST1%" /E /R:3 /W:5

echo.
echo Copying files to Dropbox...
robocopy "%SOURCE%" "%DEST2%" /E /R:3 /W:5

echo.
echo Backup completed successfully!
pause