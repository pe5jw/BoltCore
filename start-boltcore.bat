@echo off
title BoltCore
:: BoltCore starten — Windows
:: Start AnanCore (OpenhpsdrZeus.exe) met bolt-web als interface.
:: Poorten 6060 (HTTP) en 6443 (HTTPS) — dezelfde als AnanCore.
::
:: Nooit tegelijk met start-anacore.bat draaien.

setlocal

set "SCRIPT_DIR=%~dp0"
:: Verwijder trailing backslash
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

for %%i in ("%SCRIPT_DIR%\..") do set "ANACORE_DIR=%%~fi"
set "ANACORE_EXE=%ANACORE_DIR%\OpenhpsdrZeus.exe"
set "BOLT_WEBROOT=%SCRIPT_DIR%\bolt-web"

:: ── Controles ────────────────────────────────────────────────────────────────
if not exist "%ANACORE_EXE%" (
  echo.
  echo   FOUT: OpenhpsdrZeus.exe niet gevonden in: %ANACORE_DIR%
  echo   Zorg dat BoltCore in een submap van de AnanCore installatie staat.
  echo.
  pause & exit /b 1
)

if not exist "%BOLT_WEBROOT%\index.html" (
  echo.
  echo   FOUT: bolt-web niet gevonden in: %BOLT_WEBROOT%
  echo   Voer eerst install.bat uit.
  echo.
  pause & exit /b 1
)

:: ── Banner ────────────────────────────────────────────────────────────────────
echo.
echo  =================================================
echo   BoltCore -- bolt-web interface
echo  =================================================
echo.
echo   Interface : bolt-web
echo   HTTP      : http://localhost:6060
echo   HTTPS     : https://localhost:6443
echo   wwwroot   : %BOLT_WEBROOT%
echo.
echo   Sluit dit venster of druk Ctrl+C om te stoppen.
echo.

:: ── Start AnanCore met bolt-web als wwwroot ───────────────────────────────────
:: ZEUS_WEBROOT overschrijft de standaard wwwroot naast de executable.
set "ZEUS_WEBROOT=%BOLT_WEBROOT%"
set "ZEUS_DISABLE_UPDATE_CHECK=1"

cd /d "%ANACORE_DIR%"
OpenhpsdrZeus.exe
