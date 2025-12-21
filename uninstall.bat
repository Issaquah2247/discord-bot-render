@echo off
color 0C
title Mira Bot - Uninstaller

echo ========================================
echo   MIRA BOT - COMPLETE UNINSTALLER
echo   Wild West Discord Bot Removal
echo ========================================
echo.
echo WARNING: This will permanently delete:
echo   - All bot files and scripts
echo   - Your Discord token configuration
echo   - Bot database (all user data, gangs, money)
echo   - Python packages (discord.py, python-dotenv)
echo.
echo ========================================
echo.

set /p confirm="Are you sure you want to uninstall everything? (Y/N): "
if /i not "!confirm!"=="Y" (
    if /i not "!confirm!"=="y" (
        echo.
        echo Uninstall cancelled.
        pause
        exit /b 0
    )
)

echo.
echo ========================================
echo   UNINSTALLING MIRA BOT
echo ========================================
echo.

REM Stop any running bot processes
echo [1/4] Stopping bot processes...
taskkill /F /FI "WINDOWTITLE eq Mira Bot - Running*" 2>nul
if errorlevel 1 (
    echo No running bot processes found.
) else (
    echo Bot processes stopped.
)
echo.

REM Uninstall Python packages
echo [2/4] Removing Python packages...
pip uninstall discord.py python-dotenv -y --quiet 2>nul
if errorlevel 1 (
    echo Warning: Could not uninstall packages.
) else (
    echo Python packages removed.
)
echo.

REM Delete bot files
echo [3/4] Deleting bot files...
if exist .env (
    del /F /Q .env
    echo Deleted: .env
)
if exist mira_bot.db (
    del /F /Q mira_bot.db
    echo Deleted: mira_bot.db
)
if exist main.py (
    del /F /Q main.py
    echo Deleted: main.py
)
if exist requirements.txt (
    del /F /Q requirements.txt
    echo Deleted: requirements.txt
)
if exist run.bat (
    del /F /Q run.bat
    echo Deleted: run.bat
)
if exist run_background.bat (
    del /F /Q run_background.bat
    echo Deleted: run_background.bat
)
if exist quick-install.ps1 (
    del /F /Q quick-install.ps1
    echo Deleted: quick-install.ps1
)
if exist .env.example (
    del /F /Q .env.example
    echo Deleted: .env.example
)
if exist README.md (
    del /F /Q README.md
    echo Deleted: README.md
)
if exist .gitignore (
    del /F /Q .gitignore
    echo Deleted: .gitignore
)
if exist .git (
    rmdir /S /Q .git
    echo Deleted: .git folder
)
echo.
echo All bot files removed!
echo.

REM Self-delete
echo [4/4] Cleaning up installer...
if exist install.bat (
    del /F /Q install.bat
    echo Deleted: install.bat
)
echo.

echo ========================================
echo   UNINSTALL COMPLETE!
echo ========================================
echo.
echo Mira Bot has been completely removed.
echo.
echo To reinstall:
echo   1. Clone the repository again
echo   2. Run install.bat
echo.
echo This window will close in 5 seconds...
echo.

REM Delete uninstall.bat itself after a delay
(goto) 2>nul & del "%~f0" & timeout /t 5 >nul
