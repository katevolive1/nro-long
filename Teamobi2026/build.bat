@echo off
rem Bien dich src roi cap nhat class vao Teamobi2026.jar (jar gop da chua thu vien).
rem Can JDK 21: dat JAVA_HOME hoac de javac/jar trong PATH.
setlocal
cd /d "%~dp0"
set "JBIN="
if defined JAVA_HOME set "JBIN=%JAVA_HOME%\bin\"
if not defined JAVA_HOME if exist "C:\Program Files\Java\jdk-21.0.12.1\bin\javac.exe" set "JBIN=C:\Program Files\Java\jdk-21.0.12.1\bin\"

if exist build\classes-cli rmdir /s /q build\classes-cli
mkdir build\classes-cli
dir /s /b src\*.java > build\sources.txt

"%JBIN%javac" -encoding UTF-8 -nowarn -cp "lib/*" -d build\classes-cli @build\sources.txt
if errorlevel 1 (
  echo.
  echo BUILD LOI - jar chua bi thay doi.
  pause
  exit /b 1
)

"%JBIN%jar" uf Teamobi2026.jar -C build\classes-cli nro -C build\classes-cli models
if errorlevel 1 (
  echo Cap nhat jar loi.
  pause
  exit /b 1
)
echo.
echo BUILD XONG: Teamobi2026.jar da cap nhat. Khoi dong lai server de ap dung.
pause
