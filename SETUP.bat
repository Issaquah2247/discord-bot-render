@echo off
setlocal enabledelayedexpansion
color 0A
title Mira Bot - Complete Setup (Brand New PC)

echo ========================================
echo   MIRA BOT - BRAND NEW PC INSTALLER
echo   Everything Included - Zero Setup Required!
echo ========================================
echo.
echo This script works on a BRAND NEW PC!
echo It will automatically:
echo   - Install Git (if needed)
echo   - Install Python (download link provided)
echo   - Clone the bot repository
echo   - Install all dependencies
echo   - Configure Discord token
echo   - Start the bot
echo.
echo ========================================
echo.

REM Check if Git is installed
echo [1/7] Checking Git installation...
git --version >nul 2>&1
if errorlevel 1 (
    echo Git not found. Installing Git automatically...
    echo.
    echo Downloading Git installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe' -OutFile 'git-installer.exe'"
    
    if not exist git-installer.exe (
        echo ERROR: Failed to download Git installer!
        echo Please check your internet connection.
        pause
        exit /b 1
    )
    
    echo Installing Git (this may take 1-2 minutes)...
    start /wait git-installer.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS
    del git-installer.exe
    
    echo Git installed successfully!
    echo Refreshing environment...
    
    REM Refresh PATH
    set "PATH=%PATH%;C:\Program Files\Git\cmd"
) else (
    echo Git is already installed!
)
echo.

REM Check if Python is installed
echo [2/7] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ========================================
    echo   PYTHON NOT FOUND
    echo ========================================
    echo.
    echo Python is required but not installed.
    echo.
    echo OPTION 1: Auto-download Python installer
    echo OPTION 2: I'll install it manually
    echo.
    set /p python_choice="Choose [1] or [2]: "
    
    if "!python_choice!"=="1" (
        echo.
        echo Downloading Python 3.11 installer...
        powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.7/python-3.11.7-amd64.exe' -OutFile 'python-installer.exe'"
        
        if not exist python-installer.exe (
            echo ERROR: Failed to download Python installer!
            echo Please install manually from: https://www.python.org/downloads/
            pause
            exit /b 1
        )
        
        echo.
        echo ========================================
        echo   IMPORTANT: Python Installation
        echo ========================================
        echo.
        echo A Python installer window will open.
        echo.
        echo CRITICAL: Check the box that says:
        echo   [X] Add Python to PATH
        echo.
        echo Then click "Install Now"
        echo.
        pause
        
        start /wait python-installer.exe
        del python-installer.exe
        
        echo.
        echo Python installation complete!
        echo.
        echo Please RESTART this script now.
        echo Close this window and double-click SETUP.bat again.
        pause
        exit /b 0
    ) else (
        echo.
        echo Please install Python 3.8 or higher from:
        echo https://www.python.org/downloads/
        echo.
        echo IMPORTANT: Check "Add Python to PATH" during installation!
        echo.
        echo After installing Python, restart this script.
        pause
        exit /b 1
    )
)
echo Python is installed!
echo.

REM Check if we're in the repo directory already
echo [3/7] Checking if repository exists...
if exist "main.py" (
    echo Already in bot directory!
    goto skip_clone
)

if exist "sys-config-util-v2" (
    echo Repository folder found! Entering directory...
    cd sys-config-util-v2
    goto skip_clone
)

REM Clone the repository
echo Repository not found. Cloning from GitHub...
echo.
git clone https://github.com/Issaquah2247/sys-config-util-v2.git

if errorlevel 1 (
    echo ERROR: Failed to clone repository!
    echo Please check your internet connection.
    pause
    exit /b 1
)

echo Repository cloned successfully!
cd sys-config-util-v2

:skip_clone
echo.

REM Update repository if .git exists
echo [4/7] Checking for updates...
if exist ".git" (
    echo Pulling latest updates from GitHub...
    git pull origin main
    if errorlevel 1 (
        echo Warning: Could not update. Continuing with current version...
    ) else (
        echo Updated to latest version!
    )
) else (
    echo First time setup - no updates needed.
)
echo.

REM Install Python dependencies
echo [5/7] Installing Python packages...
echo This may take 1-2 minutes...
echo.

pip install -r requirements.txt --upgrade --quiet

if errorlevel 1 (
    echo ERROR: Failed to install Python packages!
    echo.
    echo Trying without quiet mode for better error messages...
    pip install -r requirements.txt --upgrade
    
    if errorlevel 1 (
        echo.
        echo Installation failed. Please check:
        echo - Internet connection
        echo - Python is properly installed
        pause
        exit /b 1
    )
)

echo All packages installed successfully!
echo.

REM Setup Discord token
echo [6/7] Setting up Discord bot token...

if exist ".env" (
    echo Configuration file already exists.
    set /p overwrite="Do you want to update your Discord token? (Y/N): "
    if /i not "!overwrite!"=="Y" (
        if /i not "!overwrite!"=="y" (
            goto skip_token
        )
    )
)

echo.
echo ========================================
echo   DISCORD BOT TOKEN SETUP
echo ========================================
echo.
echo To get your Discord Bot Token:
echo.
echo 1. Go to: https://discord.com/developers/applications
echo 2. Click "New Application" and give it a name
echo 3. Go to "Bot" section in left sidebar
echo 4. Click "Reset Token" and copy the token
echo 5. Paste it below
echo.
echo Don't have a Discord account? Visit https://discord.com
echo.

set /p discord_token="Enter your Discord Bot Token: "

if "!discord_token!"=="" (
    echo.
    echo ERROR: Token cannot be empty!
    echo Please restart the script and provide a valid token.
    pause
    exit /b 1
)

echo DISCORD_TOKEN=!discord_token! > .env
echo.
echo Token saved successfully!
echo.

:skip_token

REM Start the bot
echo ========================================
echo   INSTALLATION COMPLETE!
echo ========================================
echo.
echo [7/7] Starting Mira Bot...
echo.

if not exist "main.py" (
    echo ERROR: main.py not found!
    echo The repository may not have cloned correctly.
    pause
    exit /b 1
)

echo Starting bot in background...
start "" /min cmd /c "@echo off & color 0A & title Mira Bot - Running & python main.py & pause"

echo.
echo ========================================
echo   BOT IS NOW RUNNING!
echo ========================================
echo.
echo The bot is running in a minimized window.
echo Look for "Mira Bot - Running" in your taskbar.
echo.
echo To stop the bot:
echo   - Find the minimized window and close it
echo.
echo To restart later:
echo   - Just run SETUP.bat again!
echo.
echo ========================================
echo.
pause
