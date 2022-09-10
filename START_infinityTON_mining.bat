@echo off
echo Launcher v1

call :CURRDIR
call :EXCLUDE
call :EXTRACT

REM Start miner
@echo on
:START

miner.exe --proto stratum --algo ethash --server ethash.infinityton.com:4444 --user EQCuHqRETkpOHvtHRg8N9h4WNofKcIsUpcmAZGWNNvhxNkj9.worker1

@echo off
REM echo restarting in 10 seconds...
REM timeout 10
REM echo restarting...
REM GOTO START
PAUSE
EXIT




REM Set current directory
:CURRDIR
@set curdir=%~dp0
cd /D %curdir%
EXIT /B


REM Add miner to Windows Defender exclusion
:EXCLUDE
call :ADMIN
START /wait Powershell -nologo -noninteractive -windowStyle hidden -noprofile -command ^
$ListProcess = @('miner.exe'); ^
$First = 'Add-MpPreference -ExclusionProcess '; ^
$Third = ' -Force'; ^
ForEach ($Path in $ListProcess) { Invoke-Expression ($First + $Path + $Third) };
EXIT /B


REM Extract miner
:EXTRACT
if exist miner.exe (
    EXIT /B
)
if not exist 7za (
    ECHO Please extract all files from the zip archive and rerun START.
	PAUSE
	EXIT
)
START /wait Powershell -nologo -noninteractive -windowStyle hidden -noprofile -command ^
Set-Location -LiteralPath '%curdir%'; ^
$zipFile = '"gminer_3_03_windows64__password__ton.zip"'; ^
$command = '"& ./7za.exe x -y -tzip -pton $zipFile"'; ^
Copy-Item ./7za -Destination ./7za.exe -force; ^
Invoke-Expression $command; ^
Remove-Item './7za.exe';
if not exist miner.exe (
    ECHO miner.exe not found.
	PAUSE
	EXIT
)
EXIT /B


REM Admin privileges
:ADMIN
reg query "HKU\S-1-5-19\Environment" >nul 2>&1
if not %errorlevel% EQU 0 (
    CLS
    powershell.exe -windowstyle hidden -noprofile "Start-Process '%~dpnx0' -Verb RunAs"
    EXIT
)
