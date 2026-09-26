@echo off
setlocal enabledelayedexpansion
rem ===== gtasa_crashfix one-click build =====
rem Builds Release Win32, prints the absolute path of the produced .asi.
rem MSBuild is auto-detected: vswhere, then common VS roots, then PATH.

set "PROJECT=%~dp0crashes\crashes\crashes.vcxproj"
set "OUT=%~dp0crashes\crashes\Release\crashes.asi"
set "MSBUILD="

rem Keep x86 path text out of any parenthesized block.
set "PF86=%ProgramFiles(x86)%"
set "PF=%ProgramFiles%"

rem 1) vswhere
set "VSWHERE=!PF86!\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "!VSWHERE!" for /f "usebackq delims=" %%i in (`""!VSWHERE!" -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe"`) do if not defined MSBUILD set "MSBUILD=%%i"

rem 2) Explicit VS roots / editions (covers custom drive D:\ProgramFiles).
if not defined MSBUILD call :try "!PF!" 2022
if not defined MSBUILD call :try "!PF!" 2019
if not defined MSBUILD call :try "!PF86!" 2022
if not defined MSBUILD call :try "!PF86!" 2019
if not defined MSBUILD call :try "D:\ProgramFiles" 2022
if not defined MSBUILD call :try "D:\ProgramFiles" 2019
if not defined MSBUILD call :try "D:\Program Files" 2022
if not defined MSBUILD call :try "D:\Program Files" 2019
if not defined MSBUILD call :try "E:\ProgramFiles" 2022
if not defined MSBUILD call :try "E:\ProgramFiles" 2019

rem 3) PATH
if not defined MSBUILD for /f "delims=" %%i in ('where msbuild 2^>nul') do if not defined MSBUILD set "MSBUILD=%%i"

if not defined MSBUILD echo [ERROR] MSBuild not found. Install Visual Studio C++ workload or add MSBuild to PATH.& goto :end
if not exist "%PROJECT%" echo [ERROR] Project not found: "%PROJECT%"& goto :end

echo Using MSBuild: %MSBUILD%
echo Building crashes.asi (Release^|Win32)...
"%MSBUILD%" "%PROJECT%" /p:Configuration=Release /p:Platform=Win32 /m /v:m /nologo /t:Build
if errorlevel 1 echo [FAILED] See errors above.& goto :end

echo.
echo [OK] Output file:
echo %OUT%

:end
echo.
pause
exit /b %ERRORLEVEL%

:try
rem %~1 = root, %~2 = VS year; pick the edition folder if present.
for /d %%E in ("%~1\Microsoft Visual Studio\%~2\*") do if exist "%%~E\MSBuild\Current\Bin\MSBuild.exe" if not defined MSBUILD set "MSBUILD=%%~E\MSBuild\Current\Bin\MSBuild.exe"
goto :eof
