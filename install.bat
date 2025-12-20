@echo off
color 0A
title Mira Bot - Wild West Discord Bot Installer

echo ========================================
echo    MIRA BOT - ONE-CLICK INSTALLER
echo    Wild West Discord Bot Setup
echo ========================================
echo.

REM Check if Python is installed
echo [1/4] Checking Python installation...
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

REM Install dependencies
echo [2/4] Installing required packages...
echo This may take a minute...
echo.
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install dependencies!
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

echo.
echo Packages installed successfully!
echo.

REM Create .env file
echo [3/4] Setting up configuration...
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
echo [4/4] Initializing database...
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
echo To start the bot:
echo   - Double-click 'run.bat' OR
echo   - Run 'python main.py' in terminal
echo.
echo The terminal will show:
echo   - All available commands
echo   - Real-time bot activity
echo   - Server connections
echo.
echo Press any key to exit...
pause >nul
