:: Download the latest update from https://github.com/CriBP/Windows_11_Clean
@echo off
TITLE: PC Info script
Color 07
@echo Self elevate
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights & ping 127.0.0.1 -n 5 & powershell -Command "Start-Process 'Export-PC-Info.bat' -Verb runAs" & exit /b 1)
if not "%1"=="max" start /max cmd /c %0 max & Exit /b >> CleanUp.log
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') do (set downloaddir=%%b)
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
@echo -%Green% Export Environment Variables -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Environment-Variables.txt %Reset%
set >> "%docdir%\%mb% %model% PC-info\%today%_Environment-Variables.txt"
::  use a simple for loop in the cmd prompt to import back all the variables:
:: for /F %a in (Environment-Variables.txt) do SET %a
wmic useraccount list full >"%docdir%\%mb% %model% PC-info\%today%_UserAccountDetails.txt"
@echo -%Green% Export WiFi passwords -%Cyan% https://www.elevenforum.com/t/backup-and-restore-wi-fi-network-profiles-in-windows-11.4472/ %Reset%
netsh wlan show profiles
netsh wlan export profile key=clear folder="%docdir%\%mb% %model% PC-info"
:: To import several profiles at once, you can use a loop in the command prompt:
:: for %a in (*.xml) do netsh wlan add profile filename="%a"
@echo -%Green% Check if Users are a Microsoft account or Local account -%Cyan% https://www.tenforums.com/tutorials/5387-how-tell-if-local-account-microsoft-account-windows-10-a.html %Reset%
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-LocalUser | Select-Object Name,PrincipalSource | Out-File -filepath '%docdir%\%mb% %model% PC-info\%today%_All_Accounts.txt'"
@echo -%SGreen% List all Optional Capabilities - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Capability-listing-before-cleanup.txt %Reset%
dism /Online /Get-Capabilities /Format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Capability-listing-before-cleanup.txt"
@echo -%SGreen% List all Optional Features - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Features-listing-before-cleanup.txt %Reset%
dism /Online /Get-Features /Format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Features-listing-before-cleanup.txt"
@echo -%SGreen% List of Provisioned Application Packages - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_AppPackages-before-cleanup.txt %Reset%
dism /Online /Get-ProvisionedAppxPackages > "%docdir%\%mb% %model% PC-info\%today%_AppPackages-before-cleanup.txt"
@echo -%SGreen% List of Drivers - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Drivers.txt %Reset%
dism /Online /Get-Drivers /format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Drivers.txt"
@echo -%SGreen% List of Packages - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Packages.txt %Reset%
dism /Online /Get-Packages /format:Table > "%docdir%\%mb% %model% PC-info\%today%_Windows-Packages.txt"
@echo -%SGreen% International Settings - Save to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_International-Settings.txt %Reset%
dism /Online /Get-Intl > "%docdir%\%mb% %model% PC-info\%today%_International-Settings.txt"
@echo -%SGreen% Saving PC information to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_SystemInfo.txt %Reset%
systeminfo > "%docdir%\%mb% %model% PC-info\%today%_SystemInfo.txt"
systeminfo /FO CSV > "%docdir%\%mb% %model% PC-info\%today%_SystemInfo.csv"
msinfo32 /report "%docdir%\%mb% %model% PC-info\%today%_Detailed-System-Information-MSInfo32.txt"
@echo -%SGreen% Windows Version Information - -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-version.txt %Reset%
ver > "%docdir%\%mb% %model% PC-info\%today%_Windows-version.txt"
@echo -%SGreen% Export Current Tasks to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Tasks-before-cleanup.csv %Reset%
schtasks /query /v /fo CSV > "%docdir%\%mb% %model% PC-info\%today%_Tasks-before-cleanup.csv"
@echo -%SGreen% Export Windows Services to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Services-before-cleanup.csv %Reset%
powershell -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "Get-CIMInstance -Class Win32_Service | Select-Object Name, DisplayName, Description, StartMode, DelayedAutoStart, StartName, PathName, State, ProcessId | Export-CSV -Path '%docdir%\%mb% %model% PC-info\%today%_Services-before-cleanup.csv'"
sc query state=all > "%docdir%\%mb% %model% PC-info\%today%_All-Services-before-cleanup.txt"
sc query > "%docdir%\%mb% %model% PC-info\%today%_Running-Services-before-cleanup.txt"
net start > "%docdir%\%mb% %model% PC-info\%today%_List-of-Running-Services-before-cleanup.txt"
@echo -%SGreen% Please Backup your credentials to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Credentials.crd %Reset% by running: %Cyan%Rundll32.exe keymgr.dll,KRShowKeyMgr%Reset%
Rundll32.exe keymgr.dll,KRShowKeyMgr
@echo -%SGreen% Export Windows Product Key to -%Cyan% %docdir%\%mb% %model% PC-info\%today%_Windows-Product-Key.txt %Reset%
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "BackupProductKeyDefault"') do (echo %%b > "%docdir%\%mb% %model% PC-info\%today%_Windows-Backup-Product-Key.txt")
@echo -%SRed%WINDOWS INFO %Reset%
systeminfo | findstr /c:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"System Type"
@echo -%SRed%HARDWARE INFO %Reset%
systeminfo | findstr /c:"Total Physical Memory"
wmic cpu get name
wmic diskdrive get name,model,size
wmic path win32_videocontroller get name
wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution
@echo -%SRed%NETWORK INFO %Reset%
ipconfig | findstr IPv4ipconfig | findstr IPv6

for /f "delims=: tokens=*" %%x in ('findstr /b ::: "%~f0"') do @echo(%%x
@echo %SWhite% 
pause
:End