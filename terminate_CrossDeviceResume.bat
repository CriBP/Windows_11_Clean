@Echo Turn Resume off manually:
ms-settings:system-resume
:: Created by: Shawn Brink Created on: October 18, 2024 Updated on: November 22, 2024
:: Tutorial: https://www.elevenforum.com/t/enable-or-disable-resume-app-from-device-and-continue-on-this-windows-11-pc.29671/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume\Configuration" /f /v "IsResumeAllowed" /t REG_DWORD /d "0"

@Echo inspired by https://www.elevenforum.com/t/enable-or-disable-resume-app-from-device-and-continue-on-windows-11-pc.29671/page-2
schtasks /create /sc OnLogon /delay 0000:03 /tn "\Microsoft\Windows\Shell\Kill CrossDeviceResume.exe" /tr "taskkill /im CrossDeviceResume.exe /f" /ru SYSTEM /f
