@echo off
color 0A
title Mira Bot - Wild West Discord Bot

echo ========================================
echo    MIRA BOT - WILD WEST DISCORD BOT
echo ========================================
echo.
echo Starting bot...
echo.

python main.py

if errorlevel 1 (
    echo.
    echo ========================================
    echo    ERROR: Bot stopped unexpectedly!
    echo ========================================
    echo.
    echo Common issues:
    echo - Discord token is missing or invalid
    echo - Python packages not installed (run install.bat)
    echo - Internet connection issues
    echo.
    pause
) else (
    echo.
    echo Bot has stopped.
    pause
)
