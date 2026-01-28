@echo off
title Nexo Dynamic - Optimizador de FPS Pro
color 0b

:: Verificar privilegios de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Por favor, ejecuta este script como ADMINISTRADOR.
    pause
    exit /b
)

cls
echo ==========================================================
echo           NEXO DYNAMIC - OPTIMIZADOR DE FPS
echo ==========================================================
echo.
echo Preparando tu PC para el maximo rendimiento en:
echo Rainbow Six Siege, GTA V, FiveM, Fortnite, Valorant...
echo.
echo [1/5] Configurando Plan de Energia de Alto Rendimiento...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

echo [2/5] Aplicando optimizaciones de Registro (Latencia y CPU)...
:: Deshabilitar Network Throttling
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
:: Prioridad de Sistema
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
:: Win32 Priority Separation (Focus on Foreground)
reg add "HKLM\LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul

echo [3/5] Deshabilitando servicios innecesarios y Telemetria...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

echo [4/5] Deshabilitando Game Bar y DVR (Mejora Input Lag)...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul

echo [5/5] Limpiando archivos temporales del sistema...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1

echo.
echo ==========================================================
echo   OPTIMIZACION COMPLETADA CON EXITO POR NEXO DYNAMIC
echo ==========================================================
echo Se recomienda reiniciar tu PC para aplicar todos los cambios.
echo.
pause
exit
