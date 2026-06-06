:: Download the latest update from https://github.com/CriBP/Windows_11_Clean
TITLE: Export WiFi profiles script
@echo off
Color 07
@echo Self elevate
net.exe session 1>NUL 2>NUL || (Echo This script requires elevated rights. Please accept Administrator rights  & ping 127.0.0.1 -n 5 & powershell -Command "Start-Process 'terminate_CrossDeviceResume.bat' -Verb runAs" & exit /b 1)
if not "%1"=="max" start /max cmd /c %0 max & Exit /b >> CleanUp.log
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "{374DE290-123F-4565-9164-39C4925E467B}"') do (set downloaddir=%%b)
@echo Generate ANSI ESC characters for color codes
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set ESC=%%b
@echo %Bold%- Changed the Encoding to chcp 65001 > nul %SCyan% [ Unicode Encoding ] %Reset%
chcp 65001 > nul

@echo -%Green% Save important PC information to Documents\PC-info %Reset% -%Cyan% https://www.tenforums.com/tutorials/3443-view-user-account-details-windows-10-a.html %Reset%
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardManufacturer"') do (set mb=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\BIOS" /v "BaseBoardProduct"') do (set model=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v "ProcessorNameString"') do (set cpu=%%b)
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') do (set docdir=%%b)
@echo %cpu% on %mb% - %model%
md "%docdir%\%mb% %model% PC-info"
cd "%docdir%\%mb% %model% PC-info"
@echo -%Green% Add date and time to files %Reset%
set today=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%h%time:~3,2%m%time:~6,2%

@echo -%Green% Turn Resume off manually: -%Cyan% https://www.elevenforum.com/t/enable-or-disable-resume-app-from-device-and-continue-on-this-windows-11-pc.29671/ %Reset%
ms-settings:system-resume
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume\Configuration" /f /v "IsResumeAllowed" /t REG_DWORD /d "0"

@echo  -%Green% Turn Resume off at start: -%Cyan% https://www.elevenforum.com/t/enable-or-disable-resume-app-from-device-and-continue-on-windows-11-pc.29671/page-2
schtasks /create /sc OnLogon /delay 0000:03 /tn "\Microsoft\Windows\Shell\Kill CrossDeviceResume.exe" /tr "taskkill /im CrossDeviceResume.exe /f" /ru SYSTEM /f
pause
:End