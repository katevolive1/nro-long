@ECHO OFF
rem Doi version server: doi-version.bat <so version | moi>   (xem version\VERSION.md)
rem Chep version.ps1 ra %TEMP% roi chay, vi git checkout se doi file trong repo.
setlocal
if "%~1"=="" ( echo Cach dung: doi-version.bat ^<so version ^| moi^> & pause & exit /b 1 )
for %%I in ("%~dp0..") do set "REPO=%%~fI"
copy /y "%~dp0version.ps1" "%TEMP%\nro-version.ps1" >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\nro-version.ps1" doi %1 "%REPO%"
if errorlevel 1 echo LOI: dung lai, xem dong bao loi o tren.
pause
