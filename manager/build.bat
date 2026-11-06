@echo off
rem Bien dich NroManager.exe bang csc.exe co san trong Windows (C# 5), khong can cai them gi.
rem Bam dup thi dung lai cho doc ket qua; goi tu script khac thi them /q de khong dung.
cd /d "%~dp0"
set CSC=%windir%\Microsoft.NET\Framework64\v4.0.30319\csc.exe
if not exist "%CSC%" set CSC=%windir%\Microsoft.NET\Framework\v4.0.30319\csc.exe
"%CSC%" /nologo /codepage:65001 /target:winexe /win32icon:app.ico /out:NroManager.exe /r:System.dll /r:System.Core.dll /r:System.Windows.Forms.dll /r:System.Drawing.dll /r:System.Security.dll src\Core.cs src\UI.cs src\Control.cs
if errorlevel 1 (
  echo.
  echo LOI BIEN DICH. Neu bao "being used by another process" thi dong NroManager.exe roi chay lai.
  if /i not "%~1"=="/q" pause
  exit /b 1
)
echo Xong: NroManager.exe
if /i not "%~1"=="/q" pause
