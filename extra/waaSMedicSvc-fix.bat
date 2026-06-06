reg add "HKLM\SYSTEM\CurrentControlSet\Control\MUI\StringCacheSettings" /f /v "StringCacheGeneration" /t REG_DWORD /d 0000038b
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /f /v "Description" /t REG_SZ /d "Enables remediation and protection of Windows Update components."
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /f /v "DisplayName" /t REG_SZ /d "Windows Update Medic Service"
