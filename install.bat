@echo off
color 0A
title Mira Bot - Auto-Installer & Updater

echo ========================================
echo    MIRA BOT - AUTO INSTALLER/UPDATER
echo    Wild West Discord Bot Setup
echo ========================================
echo.

REM Check if Git is installed
echo [1/5] Checking Git installation...
git --version >nul 2>&1
if errorlevel 1 (
    echo Git not found. Installing Git...
    echo Downloading Git installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe' -OutFile 'git-installer.exe'"
    echo Installing Git (this may take a moment)...
    start /wait git-installer.exe /VERYSILENT /NORESTART
    del git-installer.exe
    echo Git installed successfully!
) else (
    echo Git is installed!
)

echo.

REM Check if Python is installed
echo [2/5] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed!
    echo Please install Python 3.8 or higher from:
    echo https://www.python.org/downloads/
    echo.
    echo Make sure to check "Add Python to PATH" during installation!
    pause
    exit /b 1
)

echo Python is installed!
echo.

REM Auto-update from GitHub
echo [3/5] Checking for updates from GitHub...
if exist .git (
    echo Pulling latest updates...
    git pull origin main
    if errorlevel 1 (
        echo Warning: Could not update from GitHub.
        echo Continuing with existing files...
    ) else (
        echo Successfully updated to latest version!
    )
) else (
    echo First time setup - cloning repository...
    echo Note: Already in repository directory.
)

echo.

REM Install dependencies
echo [4/5] Installing/Updating required packages...
echo This may take a minute...
echo.
pip install -r requirements.txt --upgrade
if errorlevel 1 (
    echo ERROR: Failed to install dependencies!
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

echo.
echo Packages installed/updated successfully!
echo.

REM Create .env file
echo [5/5] Setting up configuration...
if exist .env (
    echo .env file already exists.
    set /p overwrite="Do you want to update your Discord token? (Y/N): "
    if /i "!overwrite!"=="Y" goto setup_token
    if /i "!overwrite!"=="y" goto setup_token
    goto skip_token
)

:setup_token
echo.
echo ----------------------------------------
echo    DISCORD BOT TOKEN SETUP
echo ----------------------------------------
echo.
echo To get your Discord Bot Token:
echo 1. Go to: https://discord.com/developers/applications
echo 2. Create a new application or select existing one
echo 3. Go to "Bot" section in the left sidebar
echo 4. Click "Reset Token" and copy it
echo 5. Paste it below
echo.
set /p discord_token="Enter your Discord Bot Token: "

if "!discord_token!"=="" (
    echo ERROR: Token cannot be empty!
    pause
    exit /b 1
)

echo DISCORD_TOKEN=!discord_token! > .env
echo.
echo Token saved successfully!
echo.

:skip_token

REM Create database
if not exist mira_bot.db (
    echo Database will be created on first run.
) else (
    echo Database already exists.
)

echo.
echo ========================================
echo    INSTALLATION COMPLETE!
echo ========================================
echo.
echo Your bot is ready to run!
echo.
echo IMPORTANT: This script also serves as an AUTO-UPDATER.
echo Run this file anytime to update to the latest version!
echo.
echo To start the bot:
echo   - Double-click 'run_background.bat' to run in background OR
echo   - Double-click 'run.bat' for normal mode
echo.
echo.
echo Would you like to start the bot now?
set /p start_bot="Start in [B]ackground, [N]ormal mode, or [S]kip? (B/N/S): "

if /i "!start_bot!"=="B" (
    echo.
    echo Starting bot in background mode...
    start run_background.bat
    exit
) else if /i "!start_bot!"=="N" (
    echo.
    echo Starting bot in normal mode...
    start run.bat
    exit
) else (
    echo.
    echo Skipping auto-start.
    echo You can run the bot anytime by double-clicking:
    echo   - run_background.bat (background mode)
    echo   - run.bat (normal mode)
    echo.
    pause
)
