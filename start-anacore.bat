@echo off
title AnanCore
:: AnanCore starten vanuit BoltCore map — Windows
:: Start AnanCore normaal met de standaard zeus-web interface.
:: Poorten 6060 (HTTP) en 6443 (HTTPS).
::
:: Nooit tegelijk met start-boltcore.bat draaien.

setlocal

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

for %%i in ("%SCRIPT_DIR%\..") do set "ANACORE_DIR=%%~fi"
set "ANACORE_EXE=%ANACORE_DIR%\OpenhpsdrZeus.exe"

:: ── Controles ────────────────────────────────────────────────────────────────
if not exist "%ANACORE_EXE%" (
  echo.
  echo   FOUT: OpenhpsdrZeus.exe niet gevonden in: %ANACORE_DIR%
  echo.
  pause & exit /b 1
)

:: ── Banner ────────────────────────────────────────────────────────────────────
echo.
echo  =================================================
echo   AnanCore -- zeus-web interface
echo  =================================================
echo.
echo   Interface : zeus-web (AnanCore standaard)
echo   HTTP      : http://localhost:6060
echo   HTTPS     : https://localhost:6443
echo.
echo   Sluit dit venster of druk Ctrl+C om te stoppen.
echo.

:: ── Start AnanCore normaal (zonder ZEUS_WEBROOT) ─────────────────────────────
:: Zorg dat ZEUS_WEBROOT niet gezet is (bijv. na eerder BoltCore gebruik)
set "ZEUS_WEBROOT="
set "ZEUS_DISABLE_UPDATE_CHECK=1"

cd /d "%ANACORE_DIR%"
OpenhpsdrZeus.exe
