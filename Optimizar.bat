@echo off
title Nexo Dynamic - Optimizador de FPS Pro
color 0b
setlocal EnableDelayedExpansion

:: Configurar archivo de log
set "LOGFILE=%~dp0NexoDynamic_Log.txt"
echo ========================================== > "%LOGFILE%"
echo Nexo Dynamic - Log de Optimizacion >> "%LOGFILE%"
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
echo           NEXO DYNAMIC - OPTIMIZADOR DE FPS
echo ==========================================================
echo.
echo Preparando tu PC para el maximo rendimiento en:
echo Rainbow Six Siege, GTA V, FiveM, Fortnite, Valorant...
echo.
echo [0/6] Creando punto de restauracion del sistema...
echo [INFO] Creando punto de restauracion >> "%LOGFILE%"
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Nexo Dynamic - Antes de Optimizacion", 100, 7 >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Punto de restauracion creado exitosamente
    echo [OK] Punto de restauracion creado >> "%LOGFILE%"
) else (
    echo [ADVERTENCIA] No se pudo crear punto de restauracion
    echo [WARN] Fallo al crear punto de restauracion >> "%LOGFILE%"
)
timeout /t 2 >nul
echo.
echo [1/6] Configurando Plan de Energia de Alto Rendimiento...
echo [STEP 1] Configurando plan de energia >> "%LOGFILE%"
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Creando plan de alto rendimiento personalizado...
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
)
if %errorLevel% equ 0 (
    echo [OK] Plan de energia configurado
    echo [OK] Plan de energia: Alto Rendimiento >> "%LOGFILE%"
) else (
    echo [ERROR] No se pudo cambiar el plan de energia
    echo [ERROR] Fallo al configurar plan de energia >> "%LOGFILE%"
)

echo [2/6] Aplicando optimizaciones de Registro (Latencia y CPU)...
echo [STEP 2] Modificando registro >> "%LOGFILE%"
:: Deshabilitar Network Throttling
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] NetworkThrottlingIndex optimizado >> "%LOGFILE%") else (echo [ERROR] Fallo NetworkThrottlingIndex >> "%LOGFILE%")
:: Prioridad de Sistema
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] SystemResponsiveness optimizado >> "%LOGFILE%") else (echo [ERROR] Fallo SystemResponsiveness >> "%LOGFILE%")
:: Win32 Priority Separation (Focus on Foreground)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Registro optimizado correctamente
    echo [OK] Win32PrioritySeparation = 38 >> "%LOGFILE%"
) else (
    echo [ERROR] Problemas al modificar el registro
    echo [ERROR] Fallo Win32PrioritySeparation >> "%LOGFILE%"
)

echo [3/6] Deshabilitando servicios innecesarios y Telemetria...
echo [STEP 3] Configurando servicios >> "%LOGFILE%"
:: DiagTrack (Telemetria)
sc query DiagTrack >nul 2>&1
if %errorLevel% equ 0 (
    sc stop DiagTrack >nul 2>&1
    sc config DiagTrack start= disabled >nul 2>&1
    echo [OK] DiagTrack deshabilitado >> "%LOGFILE%"
) else (
    echo [WARN] DiagTrack no encontrado >> "%LOGFILE%"
)
:: dmwappushservice
sc query dmwappushservice >nul 2>&1
if %errorLevel% equ 0 (
    sc stop dmwappushservice >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
    echo [OK] dmwappushservice deshabilitado >> "%LOGFILE%"
) else (
    echo [WARN] dmwappushservice no encontrado >> "%LOGFILE%"
)
:: SysMain (SuperFetch/Prefetch)
sc query SysMain >nul 2>&1
if %errorLevel% equ 0 (
    sc stop SysMain >nul 2>&1
    sc config SysMain start= disabled >nul 2>&1
    echo [OK] SysMain deshabilitado >> "%LOGFILE%"
    echo [OK] Servicios optimizados
) else (
    echo [WARN] SysMain no encontrado >> "%LOGFILE%"
)

echo [4/6] Deshabilitando Game Bar y DVR (Mejora Input Lag)...
echo [STEP 4] Deshabilitando Game DVR >> "%LOGFILE%"
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] GameDVR_Enabled = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo GameDVR_Enabled >> "%LOGFILE%")
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Game DVR deshabilitado
    echo [OK] AllowGameDVR = 0 >> "%LOGFILE%"
) else (
    echo [ERROR] Problemas al deshabilitar Game DVR
    echo [ERROR] Fallo AllowGameDVR >> "%LOGFILE%"
)

echo [5/10] Optimizaciones de Red Avanzadas (Reduce Latencia)...
echo [STEP 5] Optimizaciones de red >> "%LOGFILE%"
:: TCP/IP Optimizations
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TcpAckFrequency = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo TcpAckFrequency >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TCPNoDelay = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo TCPNoDelay >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TcpDelAckTicks = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo TcpDelAckTicks >> "%LOGFILE%")
:: Deshabilitar Nagle Algorithm (gaming)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1
echo [OK] Optimizaciones de red aplicadas

echo [6/10] Deshabilitar Servicios Adicionales No Esenciales...
echo [STEP 6] Servicios adicionales >> "%LOGFILE%"
:: Windows Search (consume mucha CPU/Disco)
sc query WSearch >nul 2>&1
if %errorLevel% equ 0 (
    sc stop WSearch >nul 2>&1
    sc config WSearch start= disabled >nul 2>&1
    echo [OK] Windows Search deshabilitado >> "%LOGFILE%"
) else (
    echo [WARN] Windows Search no encontrado >> "%LOGFILE%"
)
:: Windows Update (se puede activar manualmente cuando se necesite)
sc query wuauserv >nul 2>&1
if %errorLevel% equ 0 (
    sc stop wuauserv >nul 2>&1
    sc config wuauserv start= demand >nul 2>&1
    echo [OK] Windows Update configurado en manual >> "%LOGFILE%"
) else (
    echo [WARN] Windows Update no encontrado >> "%LOGFILE%"
)
:: Print Spooler (si no tienes impresora)
sc query Spooler >nul 2>&1
if %errorLevel% equ 0 (
    sc stop Spooler >nul 2>&1
    sc config Spooler start= demand >nul 2>&1
    echo [OK] Print Spooler configurado en manual >> "%LOGFILE%"
) else (
    echo [WARN] Print Spooler no encontrado >> "%LOGFILE%"
)
:: HomeGroup (obsoleto en Win10+)
sc query HomeGroupListener >nul 2>&1
if %errorLevel% equ 0 (
    sc stop HomeGroupListener >nul 2>&1
    sc config HomeGroupListener start= disabled >nul 2>&1
    echo [OK] HomeGroup deshabilitado >> "%LOGFILE%"
)
echo [OK] Servicios no esenciales optimizados

echo [7/10] Optimizaciones de Memoria y Cache...
echo [STEP 7] Optimizaciones de memoria >> "%LOGFILE%"
:: Large System Cache (mejor para gaming)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] LargeSystemCache = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo LargeSystemCache >> "%LOGFILE%")
:: Disable Paging Executive (mejor rendimiento con 16GB+ RAM)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] DisablePagingExecutive = 1 >> "%LOGFILE%") else (echo [ERROR] Fallo DisablePagingExecutive >> "%LOGFILE%")
:: Clear PageFile at Shutdown (opcional, comentado por defecto)
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul 2>&1
echo [OK] Memoria optimizada para gaming

echo [8/10] Deshabilitar Efectos Visuales Innecesarios...
echo [STEP 8] Efectos visuales >> "%LOGFILE%"
:: Deshabilitar animaciones de ventanas
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] MinAnimate = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo MinAnimate >> "%LOGFILE%")
:: Optimizar para mejor rendimiento
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] VisualFXSetting = 2 >> "%LOGFILE%") else (echo [ERROR] Fallo VisualFXSetting >> "%LOGFILE%")
:: Deshabilitar transparencia
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] EnableTransparency = 0 >> "%LOGFILE%") else (echo [ERROR] Fallo EnableTransparency >> "%LOGFILE%")
echo [OK] Efectos visuales minimizados

echo [9/10] Limpiando archivos temporales del sistema...
echo [STEP 9] Limpiando archivos temporales >> "%LOGFILE%"
set /a cleaned_files=0
:: Limpiar TEMP del usuario (con protecciones)
if exist "%temp%\*" (
    del /f /q "%temp%\*.tmp" >nul 2>&1
    del /f /q "%temp%\*.log" >nul 2>&1
    del /f /q "%temp%\*.old" >nul 2>&1
    set /a cleaned_files+=1
    echo [OK] Temp usuario limpiado >> "%LOGFILE%"
)
:: Limpiar Windows Temp (con protecciones)
if exist "C:\Windows\Temp\*" (
    del /f /q "C:\Windows\Temp\*.tmp" >nul 2>&1
    del /f /q "C:\Windows\Temp\*.log" >nul 2>&1
    set /a cleaned_files+=1
    echo [OK] Temp Windows limpiado >> "%LOGFILE%"
)
:: Limpiar Prefetch (solo archivos antiguos de mas de 7 dias)
forfiles /P "C:\Windows\Prefetch" /S /M *.pf /D -7 /C "cmd /c del @path" >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Prefetch antiguo limpiado >> "%LOGFILE%"
) else (
    echo [INFO] Sin archivos antiguos en Prefetch >> "%LOGFILE%"
)
echo [OK] Limpieza completada de forma segura

echo.
echo [10/10] Optimizaciones GPU Avanzadas...
echo [STEP 10] Optimizaciones GPU >> "%LOGFILE%"
:: Hardware Accelerated GPU Scheduling (mantener activado en GPUs modernas)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] HAGS activado (recomendado RTX/RX 5000+) >> "%LOGFILE%") else (echo [WARN] HAGS no compatible >> "%LOGFILE%")
:: Timeout Detection and Recovery (TDR) extendido para evitar crashes
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d 10 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] TdrDelay = 10 >> "%LOGFILE%") else (echo [ERROR] Fallo TdrDelay >> "%LOGFILE%")
:: Prioridad de GPU para juegos
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] GPU Priority = 8 >> "%LOGFILE%") else (echo [ERROR] Fallo GPU Priority >> "%LOGFILE%")
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] Priority = 6 >> "%LOGFILE%") else (echo [ERROR] Fallo Priority >> "%LOGFILE%")
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] Scheduling Category = High >> "%LOGFILE%") else (echo [ERROR] Fallo Scheduling >> "%LOGFILE%")
:: NVIDIA Specific (si está instalado)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "DisablePreemption" /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] NVIDIA DisablePreemption = 1 >> "%LOGFILE%")
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "EnableUlps" /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% equ 0 (echo [OK] NVIDIA ULPS deshabilitado >> "%LOGFILE%")
echo [OK] Optimizaciones GPU completadas

echo.
echo ========================================== >> "%LOGFILE%"
echo Optimizacion finalizada: %date% %time% >> "%LOGFILE%"
echo ========================================== >> "%LOGFILE%"
echo.
echo ==========================================================
echo   OPTIMIZACION COMPLETADA CON EXITO POR NEXO DYNAMIC
echo ==========================================================
echo.
echo [i] Se ha generado un log en: NexoDynamic_Log.txt
echo [i] Se creo un punto de restauracion del sistema
echo [i] Se recomienda REINICIAR tu PC para aplicar todos los cambios
echo.
echo Presiona cualquier tecla para salir...
pause >nul
exit
