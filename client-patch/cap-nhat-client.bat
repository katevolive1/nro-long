@ECHO OFF
rem Cap nhat client long: chay moi script patch len client roi nen lai file tai tren web.
rem Script nao da ap roi thi tu bao "Da sua tu truoc" va bo qua, chay lai bao nhieu lan cung duoc.
rem Cach dung: bam dup (client mac dinh <o chua repo>:\nr-long, vd D:\nr-long, F:\nr-long) hoac: cap-nhat-client.bat "<thu muc client>"
setlocal
cd /d "%~dp0"
set "CLIENT=%~1"
if "%CLIENT%"=="" set "CLIENT=%~d0\nr-long"
set "DLL=%CLIENT%\GameAssembly.dll"
set "RAREXE=C:\Program Files\WinRAR\Rar.exe"
rem WinRAR cai cho khac: lay thu muc tu registry (exe64), roi toi PATH
if not exist "%RAREXE%" for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\WinRAR" /v exe64 2^>nul ^| find "exe64"') do set "RAREXE=%%~dpBRar.exe"
if not exist "%RAREXE%" for /f "delims=" %%P in ('where Rar.exe 2^>nul') do set "RAREXE=%%P"
for %%I in ("%~dp0..") do set "REPO=%%~fI"
rem File tai tren web nam trong repo (git bo qua): web\download\NRO-long.rar
set "OUT=%REPO%\web\download\NRO-long.rar"
if not exist "%REPO%\web\download" mkdir "%REPO%\web\download"

if not exist "%DLL%" ( echo Khong thay %DLL% & goto loi )
tasklist /FI "IMAGENAME eq DragonBoy.exe" | find /I "DragonBoy.exe" >nul && ( echo Tat game truoc da. & goto loi )

for %%S in (patch patch-khu-map patch-mac-dinh patch-khung-nhap patch-thoi-vang patch-thong-bao-boss patch-phim-q patch-giu-cua-hang patch-mua-nhanh) do (
    echo === %%S
    powershell -NoProfile -ExecutionPolicy Bypass -File "%%S.ps1" "%DLL%" || goto loi
)
echo === patch-port
powershell -NoProfile -ExecutionPolicy Bypass -File "patch-port.ps1" "%CLIENT%" || goto loi

echo === Nen %OUT%
if not exist "%RAREXE%" ( echo Khong thay WinRAR & goto loi )
if exist "%OUT%.moi" del "%OUT%.moi"
pushd "%CLIENT%"
"%RAREXE%" a -r -m5 -idq -x*.int-backup -x*.truoc-* -x*.bak "%OUT%.moi" * || ( popd & goto loi )
popd
"%RAREXE%" t -idq "%OUT%.moi" || goto loi
move /y "%OUT%.moi" "%OUT%" >nul
echo XONG: client da cap nhat, file tai moi o %OUT%
pause
exit /b 0

:loi
echo LOI: dung lai, xem dong bao loi o tren.
if exist "%OUT%.moi" del "%OUT%.moi"
pause
exit /b 1
