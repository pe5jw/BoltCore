@echo off
:: BoltCore verwijderen — Windows
:: Verwijdert de volledige BoltCore submap.
:: AnanCore blijft volledig intact.

setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

for %%i in ("%SCRIPT_DIR%\..") do set "ANACORE_DIR=%%~fi"

echo.
echo  =================================================
echo   BoltCore -- Verwijderen
echo  =================================================
echo.
echo   Te verwijderen : %SCRIPT_DIR%
echo   AnanCore       : %ANACORE_DIR%  (onaangeroerd)
echo.

set /p "confirm=  BoltCore verwijderen? (ja/nee): "
if /i not "!confirm!"=="ja" if /i not "!confirm!"=="j" (
  echo   Verwijderen afgebroken.
  pause & exit /b 0
)

:: Verwijder BoltCore map via een achtergrond-cmd zodat dit script
:: zichzelf niet blokkeert
start "" /b cmd /c "timeout /t 1 /nobreak >nul && rmdir /s /q ""%SCRIPT_DIR%"""

echo.
echo  =================================================
echo   BoltCore verwijderd.
echo  =================================================
echo.
echo   AnanCore in %ANACORE_DIR% is onaangeroerd.
echo   Start AnanCore normaal via OpenhpsdrZeus.exe
echo.
pause
