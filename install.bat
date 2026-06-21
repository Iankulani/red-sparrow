@echo off
REM ================================================
REM RedSparrow v2.0.0 - Windows Installation
REM ================================================

setlocal enabledelayedexpansion

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                         🐦 RED_SPARROW INSTALLER                            ║
echo ║                              v2.0.0                                         ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

REM Check Python
echo [INFO] Checking Python version...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.7+ from python.org
    echo [INFO] Visit: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [OK] Python %PYTHON_VERSION% found

REM Create virtual environment
echo [INFO] Creating virtual environment...
python -m venv venv
if errorlevel 1 (
    echo [ERROR] Failed to create virtual environment
    pause
    exit /b 1
)

REM Activate virtual environment
echo [INFO] Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo [INFO] Upgrading pip...
python -m pip install --upgrade pip

REM Install requirements
echo [INFO] Installing Python packages...
if exist requirements.txt (
    pip install -r requirements.txt
) else (
    echo [WARNING] requirements.txt not found. Installing core packages...
    pip install cryptography paramiko requests psutil colorama Flask flask-socketio discord.py telethon slack-sdk selenium webdriver-manager scapy python-whois qrcode pyshorteners
)

REM Create directories
echo [INFO] Creating directories...
mkdir .red_sparrow 2>nul
mkdir reports 2>nul
mkdir phishing_pages 2>nul
mkdir captured_credentials 2>nul
mkdir ssh_keys 2>nul
mkdir nmap_results 2>nul
mkdir curl_results 2>nul
mkdir spoof_logs 2>nul
mkdir web_ui 2>nul

REM Setup configuration
echo [INFO] Setting up configuration...
if not exist .red_sparrow\config.json (
    echo { > .red_sparrow\config.json
    echo     "monitoring": {"enabled": true, "port_scan_threshold": 10}, >> .red_sparrow\config.json
    echo     "scanning": {"default_ports": "1-1000", "timeout": 30}, >> .red_sparrow\config.json
    echo     "security": {"auto_block": false, "log_level": "INFO"}, >> .red_sparrow\config.json
    echo     "nikto": {"enabled": true, "timeout": 300}, >> .red_sparrow\config.json
    echo     "traffic_generation": {"enabled": true, "max_duration": 300, "allow_floods": false}, >> .red_sparrow\config.json
    echo     "social_engineering": {"enabled": true, "default_port": 8080, "capture_credentials": true}, >> .red_sparrow\config.json
    echo     "ssh": {"enabled": true, "default_timeout": 30, "max_connections": 5}, >> .red_sparrow\config.json
    echo     "discord": {"enabled": false, "token": "", "prefix": "!"}, >> .red_sparrow\config.json
    echo     "telegram": {"enabled": false, "api_id": "", "api_hash": "", "bot_token": ""}, >> .red_sparrow\config.json
    echo     "slack": {"enabled": false, "bot_token": "", "channel_id": "", "prefix": "!"}, >> .red_sparrow\config.json
    echo     "whatsapp": {"enabled": false, "phone_number": "", "prefix": "/"}, >> .red_sparrow\config.json
    echo     "imessage": {"enabled": false, "phone_numbers": [], "prefix": "!"}, >> .red_sparrow\config.json
    echo     "signal": {"enabled": false, "webhook_url": "", "prefix": "!"}, >> .red_sparrow\config.json
    echo     "web": {"enabled": true, "port": 8080}, >> .red_sparrow\config.json
    echo     "phishing": {"default_port": 8080, "capture_credentials": true}, >> .red_sparrow\config.json
    echo     "red_sparrow": {"theme": "red", "version": "2.0.0"}, >> .red_sparrow\config.json
    echo     "spoofing": {"enabled": true, "allow_arp_spoof": false} >> .red_sparrow\config.json
    echo } >> .red_sparrow\config.json
    echo [OK] Configuration created
)

REM Create log file
type nul > .red_sparrow\red_sparrow.log 2>nul

echo.
echo ╔══════════════════════════════════════════════════════════════════════════════╗
echo ║                        ✅ INSTALLATION COMPLETE                             ║
echo ╠══════════════════════════════════════════════════════════════════════════════╣
echo ║  🐦 RedSparrow v2.0.0 installed successfully!                              ║
echo ║                                                                             ║
echo ║  📁 Installation Directory: %CD%                                            ║
echo ║  🐍 Virtual Environment: %CD%\venv                                          ║
echo ║                                                                             ║
echo ║  🚀 To start RedSparrow:                                                   ║
echo ║     venv\Scripts\activate                                                   ║
echo ║     python red_sparrow.py                                                   ║
echo ║                                                                             ║
echo ║  🌐 Web Interface: http://localhost:8080                                   ║
echo ║                                                                             ║
echo ║  📖 Documentation:                                                         ║
echo ║     Type 'help' in the terminal                                             ║
echo ║                                                                             ║
echo ║  ⚠️  For full functionality, run as Administrator:                         ║
echo ║     Right-click Command Prompt -> Run as Administrator                      ║
echo ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

REM Quick test
echo [INFO] Running quick test...
python -c "import red_sparrow; print('✅ Module loaded successfully')" 2>nul
if errorlevel 1 (
    echo [WARNING] Quick test failed. Check dependencies manually.
)

echo [OK] Installation complete!
pause