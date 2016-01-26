@setlocal
@ECHO off

if .%TEST_CATEGORIES%. == .. set TEST_CATEGORIES="TestCategory=BVT"

SET CONFIGURATION=Release

SET CMDHOME=%~dp0
@REM Remove trailing backslash \
set CMDHOME=%CMDHOME:~0,-1%

if "%FrameworkDir%" == "" set FrameworkDir=%WINDIR%\Microsoft.NET\Framework
if "%FrameworkVersion%" == "" set FrameworkVersion=v4.0.30319

if NOT "%VS120COMNTOOLS%" == "" set VSIDEDIR=%VS120COMNTOOLS%..\IDE
if NOT "%VS140COMNTOOLS%" == "" set VSIDEDIR=%VS140COMNTOOLS%..\IDE
SET VSTESTEXEDIR=%VSIDEDIR%\CommonExtensions\Microsoft\TestWindow
SET VSTESTEXE=%VSTESTEXEDIR%\VSTest.console.exe

cd "%CMDHOME%"
@cd

SET OutDir=%CMDHOME%\..\Binaries\%CONFIGURATION%

set TESTS=%OutDir%\TesterInternal.dll 
@Echo Test assemblies = %TESTS%

set TEST_ARGS= /Settings:%CMDHOME%\Local.testsettings
set TEST_ARGS= %TEST_ARGS% /TestCaseFilter:%TEST_CATEGORIES% /Logger:trx

REM ---- Temporary script while we migrate TesterInternal project.
@echo on

"%VSTESTEXE%" %TEST_ARGS% %TESTS%

@echo off

set TESTER=%OutDir%\Tester.dll
if .%FILTERS%. == .. set FILTERS=-trait "Category=BVT"

@echo on
packages\xunit.runner.console.2.1.0\tools\xunit.console %TESTER% %FILTERS% -xml "TestResults/xUnit-Results.xml" -parallel none -noshadow
