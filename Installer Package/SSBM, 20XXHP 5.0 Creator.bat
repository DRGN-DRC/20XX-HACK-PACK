:: 20XXHP created by Achilles
:: xdelta program created by Josh Macdonald
:: This script and xdelta file created by DRGN.
:: Script version 2.4

@echo off
title 20XX HP Creator
color 0b

set version=5.0.0
set patchFilename=SSBM, 20XXHP %version% xdelta patch.xdelta
set finishedDiscFilename=SSBM, 20XXHP %version%.iso
set twentyExExMD5=17756217401a39227feea1ebb8542376

set originalISO=%~1



	:: First, ensure a file was provided to the script.

if NOT "%originalISO%"=="" goto :sourceProvided

echo.
echo  Welcome to the 20XX HP Creator.
echo.
echo  To use this script, drag-and-drop your Vanilla 1.02 ISO onto the batch file.
echo  (That is, the actual file icon in the folder, not this window.)
echo. 
echo  Press any key to exit. . . && pause > nul

goto eof
:sourceProvided



	:: Make sure the correct xdelta patch is present.

if exist "%patchFilename%" goto :patchFound

echo.
echo  Unable to find the patch file ^("%patchFilename"^).
echo  Make sure that the correct patch for this script is included in this directory.
echo. 
echo  Press any key to exit. . . && pause > nul

goto eof
:patchFound



	:: Confirm that the CertUtil utility (to perform the hash check) exists on the system.

where CertUtil >nul 2>nul

if %ERRORLEVEL%==0 goto :validateHash

set certUtilExists=false

echo.
echo  The hash checking utility (CertUtil) was not found installed on your system.
echo  You can still skip the hash check and force the build anyway, if you'd like,
echo  by pressing any key. (Or click the window's close button to cancel.)

pause > nul
goto :buildISO



	:: Verify that the given file is a vanilla 1.02 copy of SSBM.

:validateHash

set certUtilExists=true

echo.
echo  Verifying that the given file is a vanilla v1.02 copy of SSBM.
echo.
echo        This will take a few moments....

for /F "skip=1 delims=*" %%i in ('CertUtil -hashfile "%originalISO%" MD5') do if not defined vanillaHash set vanillaHash=%%i

 :: Remove spaces from the hash string, to normalize output from different versions of CertUtil, and then compare them
set vanillaHash=%vanillaHash: =%
if "%vanillaHash%"=="0e63d4223b01d9aba596259dc155a174" goto :validISO

echo.
echo  The file provided doesn't appear to be a vanilla 1.02 copy of the game.
echo  You can ignore this and build the new ISO anyway, but there's a fairly
echo  good chance you'll run into problems.
echo.
set /p continue=- Would you like to build a new ISO anyway? (y/n): 

if %continue%==n goto eof
if %continue%==no goto eof
goto :buildISO



	:: The ISO has been verified, or the user has chosen to proceed anyway.

:validISO

echo. && echo.
echo        The ISO has been verified!

:buildISO

echo.
echo  Constructing 20XXHP %version%. Please stand by....

cd /d %~dp0

xdelta3-3.0.11-x86_64.exe -d -s "%originalISO%" "%patchFilename%" "%finishedDiscFilename%"

echo. && echo.
echo        Construction complete!



	:: If the hash checking utility is available, and the build was not forced, 
	:: offer to generate a hash of the new 20XX build. 
	:: Display it and also output it to a txt file.

if %certUtilExists%==true if NOT defined continue goto :getBetaHash

echo.
echo  Press any key to exit. . .
pause > nul
goto eof

:getBetaHash

echo.
set /p getHash=- Would you like to check the hash of your new 20XX copy? (y/n): 

if %getHash%==n goto eof
if %getHash%==no goto eof

echo.
echo  Generating MD5 hash....

for /F "skip=1 delims=*" %%i in ('CertUtil -hashfile "%finishedDiscFilename%" MD5') do if not defined hash set hash=%%i

 :: Remove spaces from the hash string, to normalize output from different versions of CertUtil
set hash=%hash: =%

echo. && echo.
echo        Correct MD5 hash: %twentyExExMD5%
echo  Your 20XX ISO MD5 hash: %hash%

if "%hash%"=="%twentyExExMD5%" echo. && echo        Hashes match; ISO verified!
if not "%hash%"=="%twentyExExMD5%" echo. && echo        Hashes do not match; ISO could not be verified!

echo %hash% > "Your 20XX %version% MD5 hash.txt"

echo.
echo  Press any key to exit. . . && pause > nul
