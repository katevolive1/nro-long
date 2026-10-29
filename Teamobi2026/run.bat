@ECHO OFF
cd /d "%~dp0"
rem Co ban build san (build.bat) thi thay vao truoc khi chay
if exist build\Teamobi2026.next.jar move /y build\Teamobi2026.next.jar Teamobi2026.jar >nul
java -server -Xms256m -Xmx512m -Dfile.encoding=UTF-8 -jar Teamobi2026.jar
PAUSE