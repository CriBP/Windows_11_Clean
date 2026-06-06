:: Download the latest update from https://github.com/CriBP/Windows_11_Clean
TITLE: Remove Edge script
Color 07
@echo Self elevate
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & powershell -Command "Start-Process '%downloaddir%\WinClean\winclean.bat' -Verb runAs" & exit /b 1) > "%downloaddir%\WinClean\admin.log"
if not "%1"=="max" start /max cmd /c %0 max & Exit /b >> CleanUp.log
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') do (set downloaddir=%%b)
md %downloaddir%\WinClean
cd %downloaddir%\WinClean
@echo Generate ANSI ESC characters for color codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set ESC=%%b
@echo Set Color variables
@echo STYLES
set Bold=%ESC%[1m && set Underline=%ESC%[4m && set Inverse=%ESC%[7m && set Reset=%ESC%[0m
@echo NORMAL FOREGROUND COLORS
set Black=%ESC%[30m && set Red=%ESC%[31m && set Green=%ESC%[32m && set Yellow=%ESC%[33m && set Blue=%ESC%[34m && set Magenta=%ESC%[35m && set Cyan=%ESC%[36m && set White=%ESC%[37m
@echo NORMAL BACKGROUND COLORS
set BBlack=%ESC%[40m && set BRed=%ESC%[41m && set BGreen=%ESC%[42m && set BYellow=%ESC%[43m && set BBlue=%ESC%[44m && set BMagenta=%ESC%[45m && set BCyan=%ESC%[46m && set BWhite=%ESC%[47m
@echo STRONG FOREGROUND COLORS
set LWhite=%ESC%[90m && set SRed=%ESC%[91m && set SGreen=%ESC%[92m && set SYellow=%ESC%[93m && set SBlue=%ESC%[94m && set SMagenta=%ESC%[95m && set SCyan=%ESC%[96m && set SWhite=%ESC%[97m
@echo STRONG BACKGROUND COLORS
set SBBlack=%ESC%[100m && set SBRed=%ESC%[101m && set SBGreen=%ESC%[102m && set SBYellow=%ESC%[103m && set SBBlue=%ESC%[104m && set SBMagenta=%ESC%[105m && set SBCyan=%ESC%[106m && set SBWhite=%ESC%[107m
@echo COMBINATIONS: inverse foreground-background %ESC%[7m , inverse red foreground color %ESC%[7;31m , and nested %ESC%[7m before %ESC%[31m  nested , nested %ESC%[7m %ESC%[31m before %ESC%[7m  nested %ESC%[0m
@echo %Bold%- Commands sintax and utils @ %Cyan% https://ss64.com %Reset%
@echo "Color" Sets the default console foreground and background colours. %Cyan% https://ss64.com/nt/color.html %Reset%

@echo %Bold%- Changed the Encoding to chcp 65001 > nul %SCyan% [ Unicode Encoding ] %Reset%
chcp 65001 > nul

@echo -%Green% Save important PC information to Documents\PC-info %Reset% -%Cyan% https://www.tenforums.com/tutorials/3443-view-user-account-details-windows-10-a.html %Reset%
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardManufacturer"') do (set mb=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardProduct"') do (set model=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v "ProcessorNameString"') do (set cpu=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (set docdir=%%b)
@echo %cpu% on %mb% - %model%
md "%docdir%\%mb% %model% PC-info"
@echo -%Green% Add date and time to files %Reset%
set today=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%h%time:~3,2%m%time:~6,2%
echo Download the files from https://github.com/ShadowWhisperer/Remove-MS-Edge
powershell -c "Invoke-WebRequest -Uri 'https://github.com/ShadowWhisperer/Remove-MS-Edge/raw/refs/heads/main/Batch/Both.bat' -OutFile %downloaddir%\WinClean\remove-Edge.bat"
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & powershell -Command "Start-Process '%downloaddir%\WinClean\remove-Edge.bat' -Verb runAs" & exit /b 1) > %downloaddir%\WinClean\CleanUp.log
pause