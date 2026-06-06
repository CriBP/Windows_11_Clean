:: Download the latest update from https://github.com/CriBP/Windows_11_Clean
TITLE: Stop specific Windows Update script
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

@echo -%Green% To prevent a specific update from installing Download the "Show or hide updates" troubleshooter package from the Microsoft website: %Cyan% https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab %Reset%
powershell -c "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab' -OutFile '%docdir%\%mb% %model% PC-info\%today%_wushowhide.diagcab'"

pause
:End
https://github.com/ShadowWhisperer/Remove-MS-Edge/blob/b9172d58bfe95f46cbe01fafdf661fa526623bb7/Batch/Both.bat