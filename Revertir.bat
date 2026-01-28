@echo off
title Nexo Dynamic - Revertir Cambios
color 0e

:: Verificar privilegios de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Por favor, ejecuta este script como ADMINISTRADOR.
    pause
    exit /b
)

cls
echo ==========================================================
echo           NEXO DYNAMIC - REVERTIR CAMBIOS
echo ==========================================================
echo.
echo Restaurando los valores por defecto de Windows...
echo.

echo [1/4] Restaurando Plan de Energia Equilibrado...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1

echo [2/4] Restaurando valores de Registro...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul
reg add "HKLM\LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f >nul

echo [3/4] Re-habilitando servicios esenciales...
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
sc config SysMain start= auto >nul 2>&1
sc start SysMain >nul 2>&1

echo [4/4] Re-habilitando Game Bar y DVR...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /f >nul 2>&1

echo.
echo ==========================================================
echo     RESTAURACION COMPLETADA POR NEXO DYNAMIC
echo ==========================================================
echo Los valores originales han sido aplicados. Reinicia tu PC.
echo.
pause
exit
