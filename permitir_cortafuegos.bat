@echo off
rem Permite que Coliseo PS2 reciba conexiones (multijugador) en el cortafuegos de Windows,
rem en redes privadas Y publicas (Radmin VPN y ZeroTier suelen contar como red publica).
rem Necesita permisos de administrador: si no los tiene, se vuelve a abrir pidiendolos.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Pidiendo permisos de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "EXE=%~dp0ColiseoPS2.exe"
if not exist "%EXE%" (
    echo No encuentro ColiseoPS2.exe junto a este archivo.
    echo Pon permitir_cortafuegos.bat en la misma carpeta que el juego.
    pause
    exit /b 1
)

netsh advfirewall firewall delete rule name="Coliseo PS2" >nul 2>&1
netsh advfirewall firewall add rule name="Coliseo PS2" dir=in action=allow program="%EXE%" enable=yes profile=any protocol=tcp localport=7777
netsh advfirewall firewall add rule name="Coliseo PS2" dir=in action=allow program="%EXE%" enable=yes profile=any protocol=udp localport=7778

echo.
echo Listo: Coliseo PS2 puede recibir jugadores (TCP 7777 y busqueda de partidas UDP 7778).
echo Para quitarlo: netsh advfirewall firewall delete rule name="Coliseo PS2"
pause
