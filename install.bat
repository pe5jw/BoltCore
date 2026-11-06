@echo off
:: BoltCore installer — Windows
:: Gebruik: install.bat [anacore-dir] [bolt-web-dir]
::
:: Installeert bolt-web als BoltCore submap naast de AnanCore executable.
:: AnanCore blijft volledig onaangeroerd.

setlocal EnableDelayedExpansion

set "ANACORE_DIR=%~1"
set "BOLT_WEB_DIR=%~2"

echo.
echo  =================================================
echo   BoltCore -- Installatie
echo  =================================================
echo.

:: ── AnanCore locatie ─────────────────────────────────────────────────────────
if "%ANACORE_DIR%"=="" (
  :: Probeer map boven dit script
  set "PARENT=%~dp0.."
  if exist "!PARENT!\OpenhpsdrZeus.exe" (
    set "ANACORE_DIR=!PARENT!"
  ) else (
    set /p "ANACORE_DIR=  AnanCore map (bevat OpenhpsdrZeus.exe): "
  )
)

:: Normaliseer pad
for %%i in ("%ANACORE_DIR%") do set "ANACORE_DIR=%%~fi"

if not exist "%ANACORE_DIR%\OpenhpsdrZeus.exe" (
  echo   FOUT: OpenhpsdrZeus.exe niet gevonden in: %ANACORE_DIR%
  pause & exit /b 1
)
echo   OK  AnanCore gevonden: %ANACORE_DIR%

:: ── bolt-web dist locatie ────────────────────────────────────────────────────
if "%BOLT_WEB_DIR%"=="" (
  :: Zoek automatisch
  for %%c in (
    "%USERPROFILE%\dev\BoltSDRv2\bolt-web\dist"
    "C:\dev\BoltSDRv2\bolt-web\dist"
    "%~dp0..\bolt-web\dist"
  ) do (
    if exist "%%~c\index.html" (
      set "BOLT_WEB_DIR=%%~c"
      goto :found_web
    )
  )
  set /p "BOLT_WEB_DIR=  bolt-web dist map (bevat index.html): "
  :found_web
)

for %%i in ("%BOLT_WEB_DIR%") do set "BOLT_WEB_DIR=%%~fi"

if not exist "%BOLT_WEB_DIR%\index.html" (
  echo   FOUT: index.html niet gevonden in: %BOLT_WEB_DIR%
  pause & exit /b 1
)
echo   OK  bolt-web dist gevonden: %BOLT_WEB_DIR%

:: ── Doelmap ──────────────────────────────────────────────────────────────────
set "BOLTCORE_DIR=%ANACORE_DIR%\BoltCore"

if exist "%BOLTCORE_DIR%" (
  echo   ! BoltCore map bestaat al: %BOLTCORE_DIR%
  set /p "confirm=  Overschrijven? (ja/nee): "
  if /i not "!confirm!"=="ja" if /i not "!confirm!"=="j" (
    echo   Installatie afgebroken.
    pause & exit /b 0
  )
)
echo   Doelmap: %BOLTCORE_DIR%

:: ── Kopieer bolt-web ─────────────────────────────────────────────────────────
if not exist "%BOLTCORE_DIR%\bolt-web" mkdir "%BOLTCORE_DIR%\bolt-web"
echo   Kopiëren bolt-web...
xcopy /E /I /Y "%BOLT_WEB_DIR%\*" "%BOLTCORE_DIR%\bolt-web\" > nul
echo   OK  bolt-web gekopieerd

:: ── Kopieer scripts ───────────────────────────────────────────────────────────
set "SCRIPT_DIR=%~dp0"
for %%f in (start-boltcore.bat start-anacore.bat uninstall.bat README.md) do (
  if exist "%SCRIPT_DIR%%%f" (
    copy /Y "%SCRIPT_DIR%%%f" "%BOLTCORE_DIR%\" > nul
    echo   OK  Script: %%f
  )
)

:: ── Verificatie ──────────────────────────────────────────────────────────────
echo.
echo   Verificatie...
if exist "%BOLTCORE_DIR%\bolt-web\index.html" (echo   OK  bolt-web\index.html) else (echo   FOUT: bolt-web\index.html ONTBREEKT)
if exist "%BOLTCORE_DIR%\start-boltcore.bat"  (echo   OK  start-boltcore.bat)  else (echo    !   start-boltcore.bat ontbreekt)
if exist "%BOLTCORE_DIR%\start-anacore.bat"   (echo   OK  start-anacore.bat)   else (echo    !   start-anacore.bat ontbreekt)
if exist "%BOLTCORE_DIR%\uninstall.bat"       (echo   OK  uninstall.bat)       else (echo    !   uninstall.bat ontbreekt)

:: ── Klaar ─────────────────────────────────────────────────────────────────────
echo.
echo  =================================================
echo   BoltCore geinstalleerd!
echo  =================================================
echo.
echo   Locatie : %BOLTCORE_DIR%
echo.
echo   Starten:
echo     BoltCore  --^>  %BOLTCORE_DIR%\start-boltcore.bat
echo     AnanCore  --^>  %BOLTCORE_DIR%\start-anacore.bat
echo.
echo   Let op: start nooit BoltCore en AnanCore tegelijk --
echo   ze gebruiken dezelfde poorten (6060/6443).
echo.
pause
