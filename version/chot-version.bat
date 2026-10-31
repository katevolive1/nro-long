@ECHO OFF
rem Chot version: chot-version.bat <so version>   (xuat du lieu game ra version\vN.sql, xem version\VERSION.md)
setlocal
if "%~1"=="" ( echo Cach dung: chot-version.bat ^<so version^> & pause & exit /b 1 )
for %%I in ("%~dp0..") do set "REPO=%%~fI"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0version.ps1" chot %1 "%REPO%"
if errorlevel 1 echo LOI: dung lai, xem dong bao loi o tren.
pause
