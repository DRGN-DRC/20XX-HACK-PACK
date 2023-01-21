:: 20XXHP created by Achilles
:: xdelta program created by Josh Macdonald
:: This script and xdelta patch files created by DRGN.
::
:: Script version 4.0

@echo off
title 20XX HP Creator
color 0A

set newVersion=5.0.2
set new20xxIsoMD5=d926ba5b39551f5245fd655bc1dfeb3f

set patchFile=SSBM, 20XXHP %newVersion% patch.xdelta
set xDeltaExe=xdelta3-3.0.11-x86_64.exe
set finishedDiscFilename=SSBM, 20XXHP %newVersion%.iso

set vanillaIsoMD5=0e63d4223b01d9aba596259dc155a174
set ntsc101IsoMD5=67136bd167b471e0ad72e98d10cf4356
set ntsc100IsoMD5=3a62f8d10fd210d4928ad37e3816e33c
set palv100IsoMD5=5e118fc2d85350b7b092d0192bfb0f1a
set vimm102IsoMD5=570f5ba46604d17f2d9c4fabe4b8c34d

:: Build full filepaths and avoid relative paths in case the drag-and-dropped file was from another drive
set sourceDisc=%~1
set xDeltaPath=%~dp0%xDeltaExe%
set outputPath=%~dp0%finishedDiscFilename%


echo.
echo.
echo            /$$$$$$   /$$$$$$  /$$   /$$ /$$   /$$
echo           /$$__  $$ /$$$_  $$^| $$  / $$^| $$  / $$
echo          ^|__/  \ $$^| $$$$\ $$^|  $$/ $$/^|  $$/ $$/
echo            /$$$$$$/^| $$ $$ $$ \  $$$$/  \  $$$$/ 
echo           /$$____/ ^| $$\ $$$$  ^>$$  $$   ^>$$  $$ 
echo          ^| $$      ^| $$ \ $$$ /$$/\  $$ /$$/\  $$
echo          ^| $$$$$$$$^|  $$$$$$/^| $$  \ $$^| $$  \ $$
echo          ^|________/ \______/ ^|__/  ^|__/^|__/  ^|__/
echo.
echo.
echo      Welcome to the 20XX HP Creator!

	:: Ensure a file was provided to the script.

if NOT "%sourceDisc%"=="" goto :sourceProvided

echo.
echo  To create the 20XX ISO/disc, you must have a copy of a 
echo  vanilla (unmodified) NTSC 1.02 disc.
echo.
echo  Drag-and-drop your vanilla source disc onto this script's 
echo  file icon, or drag-and-drop your source disc into this 
echo  window and then press Enter.
echo. 
:getSourceDisc
:: Get user input and remove double quotes
set /p sourceDisc=
set sourceDisc=%sourceDisc:"=%

if exist "%sourceDisc%" goto :sourceProvided

echo  Invalid or nonexistent file path. Please try again.
goto :getSourceDisc

:sourceProvided



	:: Confirm that the CertUtil utility (for performing the hash check) exists on this system.

where CertUtil >nul 2>nul

if %ERRORLEVEL%==0 goto :validateHash

set certUtilExists=false

echo.
echo      Warning!
echo.
echo  The hash checking utility, CertUtil, was not found on your system!
echo.
echo  If you're confident that your source disc is correct (a vanilla NTSC 1.02
echo  disc) then you can try to build anyway, and the resulting disc may be fine.
echo  However, there will be no way to verfify it besides playtesting it.
echo.
echo  If your source disc is not a vanilla copy of the game or has any modifications, 
echo  it's likely that the resulting disc will not be correct or functional.
echo.
echo  Would you like to try to force the build anyway? (y/n)
echo.
set /p confirmation=

if [%confirmation%]==[y] goto :buildISO
if [%confirmation%]==[yes] goto :buildISO
:: If anything else was entered, abort and exit.
goto :eof


	:: Verify that the given file is a vanilla 1.02 copy of SSBM,
	:: or the prior latest 20XX HP version.

:validateHash

set certUtilExists=true

echo.
echo  Verifying the provided source disc.
echo.
echo  This will take a few moments . . .

for /F "skip=1 delims=*" %%i in ('CertUtil -hashfile "%sourceDisc%" MD5') do if not defined thisFileHash set thisFileHash=%%i

:: Remove spaces from the hash string to normalize output from different versions of CertUtil, and then compare them
set thisFileHash=%thisFileHash: =%
if [%thisFileHash%]==[%vanillaIsoMD5%] goto :validISO

:: The hash didn't match NTSC 1.02. Display the hash and see if we can identify it.
echo.
echo      MD5 hash: %thisFileHash%
echo.
if [%thisFileHash%]==[%ntsc101IsoMD5%] goto :ntsc101Detected
if [%thisFileHash%]==[%ntsc100IsoMD5%] goto :ntsc100Detected
if [%thisFileHash%]==[%palv100IsoMD5%] goto :palv100Detected
if [%thisFileHash%]==[%vimm102IsoMD5%] goto :vimm102Detected

:: Unrecognized disc
echo  The given disc is an unrecognized revision or has been modified.
echo  This build process is only designed to work with an unmodified 
echo  vanilla copy of the game.
goto :askToBuild

:ntsc101Detected
echo  The given disc appears to be an NTSC v1.01 revision. However,
echo  this build process is only designed to work with an unmodified 
echo  vanilla copy of the game.
echo.
echo  You can check the ReadMe.txt file for potential conversion solutions.
goto :askToBuild

:ntsc100Detected
echo  The given disc appears to be an NTSC v1.00 revision. However,
echo  this build process is only designed to work with an unmodified 
echo  vanilla copy of the game.
echo.
echo  You can check the ReadMe.txt file for potential conversion solutions.
goto :askToBuild

:palv100Detected
echo  The given disc appears to be a PAL v1.00 revision. However,
echo  this build process is only designed to work with an unmodified 
echo  vanilla copy of the game.
echo.
echo  You can check the ReadMe.txt file for potential conversion solutions.
goto :askToBuild

:vimm102Detected
echo  The given disc appears to be a compressed NTSC 1.02 revision from 
echo  Vimm's Lair. However, this build process is only designed to work 
echo  with an unmodified vanilla copy of the game. You may be able to 
echo  convert it back using a process linked to in the ReadMe.txt file.

:askToBuild
echo.
echo  You can ignore this and build the new ISO anyway, 
echo  but it's pretty likely that you'll run into problems.
echo.
echo  Would you like to build a new ISO anyway? (y/n)
echo.
set /p continue=

if %continue%==n goto :Exit
if %continue%==no goto :Exit
goto :buildISO



	:: The ISO has been verified, or the user has chosen to proceed anyway.

:validISO

echo. && echo.
echo      The ISO has been verified!

:buildISO

echo.
echo  Constructing 20XXHP %newVersion%. Please stand by . . .

cd /d %~dp0

"%xDeltaPath%" -d -s "%sourceDisc%" "%~dp0%patchFile%" "%outputPath%"

if not [%ERRORLEVEL%]==[0] goto :Error

echo.
echo      Construction complete!


	:: If the hash checking utility is available, and the build was not forced, 
	:: offer to generate a hash of the new 20XX build. 
	:: Display it here and also output it to a txt file.

if %certUtilExists%==true if NOT defined continue goto :getBetaHash
goto :Exit
:getBetaHash

echo.
echo  Would you like to check the hash of your new 20XX copy? (y/n)
echo.
set /p getHash=

if %getHash%==n goto :eof
if %getHash%==no goto :eof

echo.
echo  Generating MD5 hash....

for /F "skip=1 delims=*" %%i in ('CertUtil -hashfile "%finishedDiscFilename%" MD5') do if not defined hash set hash=%%i

 :: Remove spaces from the hash string to normalize output from different versions of CertUtil
set hash=%hash: =%

echo. && echo.
echo        Correct MD5 hash: %new20xxIsoMD5%
echo  Your 20XX ISO MD5 hash: %hash%

if "%hash%"=="%new20xxIsoMD5%" echo. && echo      Hashes match; ISO verified!
if not "%hash%"=="%new20xxIsoMD5%" echo. && echo      Hashes do not match; ISO could not be verified!

echo %hash% > "Your 20XX %newVersion% MD5 hash.txt"
goto :Exit


:Error
echo.
echo  There was an unknown problem in creating the new disc.
echo  xDelta error code: %ERRORLEVEL%
echo.
echo  You may want to make sure xDelta has write permissions.


:Exit
echo.
echo  Press any key to exit . . .
pause > nul