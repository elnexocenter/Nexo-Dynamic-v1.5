@echo off
title Nexo Dynamic - Revertir Cambios
color 0e
setlocal EnableDelayedExpansion

:: Configurar archivo de log
set "LOGFILE=%~dp0NexoDynamic_Revert_Log.txt"
echo ========================================== > "%LOGFILE%"
echo Nexo Dynamic - Log de Reversion >> "%LOGFILE%"
echo Fecha: %date% %time% >> "%LOGFILE%"
echo ========================================== >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: Verificar privilegios de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Por favor, ejecuta este script como ADMINISTRADOR.
    echo [ERROR] Permisos insuficientes >> "%LOGFILE%"
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

echo [1/8] Restaurando Plan de Energia Equilibrado...
echo [STEP 1] Restaurando plan de energia >> "%LOGFILE%"
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Plan de energia restaurado
    echo [OK] Plan restaurado: Equilibrado >> "%LOGFILE%"
) else (
    echo [WARN] No se pudo restaurar el plan de energia
    echo [WARN] Fallo al restaurar plan >> "%LOGFILE%"
)

echo [2/8] Restaurando valores de Registro...
echo [STEP 2] Restaurando registro >> "%LOGFILE%"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] NetworkThrottlingIndex = 10 >> "%LOGFILE%") else (echo [ERROR] Fallo NetworkThrottlingIndex >> "%LOGFILE%")
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] SystemResponsiveness = 20 >> "%LOGFILE%") else (echo [ERROR] Fallo SystemResponsiveness >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Registro restaurado
    echo [OK] Win32PrioritySeparation = 2 >> "%LOGFILE%"
) else (
    echo [ERROR] Problemas al restaurar el registro
    echo [ERROR] Fallo Win32PrioritySeparation >> "%LOGFILE%"
)

echo [3/8] Re-habilitando servicios esenciales...
echo [STEP 3] Restaurando servicios >> "%LOGFILE%"
sc query DiagTrack >nul 2>&1
if %errorLevel% equ 0 (
    sc config DiagTrack start= auto >nul 2>&1
    sc start DiagTrack >nul 2>&1
    echo [OK] DiagTrack rehabilitado >> "%LOGFILE%"
) else (
    echo [WARN] DiagTrack no encontrado >> "%LOGFILE%"
)
sc query SysMain >nul 2>&1
if %errorLevel% equ 0 (
    sc config SysMain start= auto >nul 2>&1
    sc start SysMain >nul 2>&1
    echo [OK] SysMain rehabilitado >> "%LOGFILE%"
    echo [OK] Servicios restaurados
) else (
    echo [WARN] SysMain no encontrado >> "%LOGFILE%"
)

echo [4/8] Re-habilitando Game Bar y DVR...
echo [STEP 4] Restaurando Game DVR >> "%LOGFILE%"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] GameDVR_Enabled = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo GameDVR_Enabled >> "%LOGFILE%")
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Game DVR restaurado
    echo [OK] AllowGameDVR eliminado >> "%LOGFILE%"
) else (
    echo [INFO] AllowGameDVR ya estaba eliminado
    echo [INFO] AllowGameDVR no existia >> "%LOGFILE%"
)

echo [5/8] Restaurando configuraciones de Red...
echo [STEP 5] Restaurando red >> "%LOGFILE%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TcpAckFrequency = 2 >> "%LOGFILE%") else (echo [ERROR] Fallo TcpAckFrequency >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TCPNoDelay = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo TCPNoDelay >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpDelAckTicks" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TcpDelAckTicks = 2 >> "%LOGFILE%") else (echo [ERROR] Fallo TcpDelAckTicks >> "%LOGFILE%")
echo [OK] Configuraciones de red restauradas

echo [6/8] Re-habilitando servicios adicionales...
echo [STEP 6] Restaurando servicios adicionales >> "%LOGFILE%"
sc query WSearch >nul 2>&1
if %errorLevel% equ 0 (
    sc config WSearch start= delayed-auto >nul 2>&1
    sc start WSearch >nul 2>&1
    echo [OK] Windows Search rehabilitado >> "%LOGFILE%"
) else (
    echo [WARN] Windows Search no encontrado >> "%LOGFILE%"
)
sc query wuauserv >nul 2>&1
if %errorLevel% equ 0 (
    sc config wuauserv start= delayed-auto >nul 2>&1
    echo [OK] Windows Update rehabilitado >> "%LOGFILE%"
) else (
    echo [WARN] Windows Update no encontrado >> "%LOGFILE%"
)
sc query Spooler >nul 2>&1
if %errorLevel% equ 0 (
    sc config Spooler start= auto >nul 2>&1
    sc start Spooler >nul 2>&1
    echo [OK] Print Spooler rehabilitado >> "%LOGFILE%"
) else (
    echo [WARN] Print Spooler no encontrado >> "%LOGFILE%"
)
echo [OK] Servicios adicionales restaurados

echo [7/8] Restaurando configuraciones de Memoria...
echo [STEP 7] Restaurando memoria >> "%LOGFILE%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] LargeSystemCache = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo LargeSystemCache >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] DisablePagingExecutive = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo DisablePagingExecutive >> "%LOGFILE%")
echo [OK] Configuraciones de memoria restauradas

echo [8/8] Restaurando Efectos Visuales y GPU...
echo [STEP 8] Restaurando efectos visuales y GPU >> "%LOGFILE%"
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] MinAnimate = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo MinAnimate >> "%LOGFILE%")
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] VisualFXSetting = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo VisualFXSetting >> "%LOGFILE%")
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] EnableTransparency = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo EnableTransparency >> "%LOGFILE%")
:: Restaurar GPU
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TdrDelay = 2 >> "%LOGFILE%")
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] Prioridades GPU eliminadas >> "%LOGFILE%")
echo [OK] Efectos visuales y GPU restaurados

echo.
echo ========================================== >> "%LOGFILE%"
echo Reversion finalizada: %date% %time% >> "%LOGFILE%"
echo ========================================== >> "%LOGFILE%"
echo.
echo ==========================================================
echo     RESTAURACION COMPLETADA POR NEXO DYNAMIC
echo ==========================================================
echo.
echo [i] Se ha generado un log en: NexoDynamic_Revert_Log.txt
echo [i] Los valores originales han sido aplicados
echo [i] Se recomienda REINICIAR tu PC
echo.
echo Presiona cualquier tecla para salir...
pause >nul
exit
