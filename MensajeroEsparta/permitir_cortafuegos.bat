@echo off
rem Permite que Mensajero de Esparta reciba conexiones (multijugador) en el cortafuegos de Windows,
rem en redes privadas Y publicas (Radmin VPN y ZeroTier suelen contar como red publica).
rem Necesita permisos de administrador: si no los tiene, se vuelve a abrir pidiendolos.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Pidiendo permisos de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "EXE=%~dp0MensajeroEsparta.exe"
if not exist "%EXE%" (
    echo No encuentro MensajeroEsparta.exe junto a este archivo.
    echo Pon permitir_cortafuegos.bat en la misma carpeta que el juego.
    pause
    exit /b 1
)

netsh advfirewall firewall delete rule name="Mensajero de Esparta" >nul 2>&1
netsh advfirewall firewall add rule name="Mensajero de Esparta" dir=in action=allow program="%EXE%" enable=yes profile=any protocol=tcp localport=7787
netsh advfirewall firewall add rule name="Mensajero de Esparta" dir=in action=allow program="%EXE%" enable=yes profile=any protocol=udp localport=7788

echo.
echo Listo: Mensajero de Esparta puede recibir jugadores (TCP 7787 y busqueda de partidas UDP 7788).
echo Para quitarlo: netsh advfirewall firewall delete rule name="Mensajero de Esparta"
pause
