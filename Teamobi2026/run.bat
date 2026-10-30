@ECHO OFF
cd /d "%~dp0"
rem Server tat (bao tri 4h30, lenh bt, loi...) thi tu chay lai sau 10 giay. Muon tat han thi dong cua so nay.
:chay
rem Co ban build san (build.bat) thi thay vao truoc khi chay
if exist build\Teamobi2026.next.jar move /y build\Teamobi2026.next.jar Teamobi2026.jar >nul
java -server -Xms256m -Xmx512m -Dfile.encoding=UTF-8 -jar Teamobi2026.jar
echo.
echo Server da tat luc %TIME%. Tu chay lai sau 10 giay (dong cua so de tat han)...
timeout /t 10 >nul
goto chay
