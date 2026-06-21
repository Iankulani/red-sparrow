# ================================================
# RedSparrow v2.0.0 - PowerShell Installation
# ================================================

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║                         🐦 RED_SPARROW INSTALLER                            ║" -ForegroundColor Red
Write-Host "║                              v2.0.0                                         ║" -ForegroundColor Red
Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

# Check Python
Write-Host "[INFO] Checking Python version..." -ForegroundColor Cyan
try {
    $pythonVersion = python --version 2>&1
    Write-Host "[OK] $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Python not found. Please install Python 3.7+ from python.org" -ForegroundColor Red
    Write-Host "[INFO] Visit: https://www.python.org/downloads/" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Create virtual environment
Write-Host "[INFO] Creating virtual environment..." -ForegroundColor Cyan
python -m venv venv
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to create virtual environment" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Activate virtual environment
Write-Host "[INFO] Activating virtual environment..." -ForegroundColor Cyan
& .\venv\Scripts\Activate.ps1

# Upgrade pip
Write-Host "[INFO] Upgrading pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip

# Install requirements
Write-Host "[INFO] Installing Python packages..." -ForegroundColor Cyan
if (Test-Path requirements.txt) {
    pip install -r requirements.txt
} else {
    Write-Host "[WARNING] requirements.txt not found. Installing core packages..." -ForegroundColor Yellow
    pip install cryptography paramiko requests psutil colorama Flask flask-socketio discord.py telethon slack-sdk selenium webdriver-manager scapy python-whois qrcode pyshorteners
}

# Create directories
Write-Host "[INFO] Creating directories..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force .red_sparrow | Out-Null
New-Item -ItemType Directory -Force reports | Out-Null
New-Item -ItemType Directory -Force phishing_pages | Out-Null
New-Item -ItemType Directory -Force captured_credentials | Out-Null
New-Item -ItemType Directory -Force ssh_keys | Out-Null
New-Item -ItemType Directory -Force nmap_results | Out-Null
New-Item -ItemType Directory -Force curl_results | Out-Null
New-Item -ItemType Directory -Force spoof_logs | Out-Null
New-Item -ItemType Directory -Force web_ui | Out-Null

# Setup configuration
Write-Host "[INFO] Setting up configuration..." -ForegroundColor Cyan
if (-not (Test-Path .red_sparrow\config.json)) {
    $config = @'
{
    "monitoring": {"enabled": true, "port_scan_threshold": 10},
    "scanning": {"default_ports": "1-1000", "timeout": 30},
    "security": {"auto_block": false, "log_level": "INFO"},
    "nikto": {"enabled": true, "timeout": 300},
    "traffic_generation": {"enabled": true, "max_duration": 300, "allow_floods": false},
    "social_engineering": {"enabled": true, "default_port": 8080, "capture_credentials": true},
    "ssh": {"enabled": true, "default_timeout": 30, "max_connections": 5},
    "discord": {"enabled": false, "token": "", "prefix": "!"},
    "telegram": {"enabled": false, "api_id": "", "api_hash": "", "bot_token": ""},
    "slack": {"enabled": false, "bot_token": "", "channel_id": "", "prefix": "!"},
    "whatsapp": {"enabled": false, "phone_number": "", "prefix": "/"},
    "imessage": {"enabled": false, "phone_numbers": [], "prefix": "!"},
    "signal": {"enabled": false, "webhook_url": "", "prefix": "!"},
    "web": {"enabled": true, "port": 8080},
    "phishing": {"default_port": 8080, "capture_credentials": true},
    "red_sparrow": {"theme": "red", "version": "2.0.0"},
    "spoofing": {"enabled": true, "allow_arp_spoof": false}
}
'@
    $config | Out-File -FilePath .red_sparrow\config.json -Encoding UTF8
    Write-Host "[OK] Configuration created" -ForegroundColor Green
}

# Create log file
New-Item -ItemType File -Force .red_sparrow\red_sparrow.log | Out-Null

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                        ✅ INSTALLATION COMPLETE                             ║" -ForegroundColor Green
Write-Host "╠══════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║  🐦 RedSparrow v2.0.0 installed successfully!                              ║" -ForegroundColor White
Write-Host "║                                                                             ║" -ForegroundColor White
Write-Host "║  📁 Installation Directory: $PWD                                            ║" -ForegroundColor White
Write-Host "║  🐍 Virtual Environment: $PWD\venv                                          ║" -ForegroundColor White
Write-Host "║                                                                             ║" -ForegroundColor White
Write-Host "║  🚀 To start RedSparrow:                                                   ║" -ForegroundColor White
Write-Host "║     .\venv\Scripts\activate                                                 ║" -ForegroundColor Yellow
Write-Host "║     python red_sparrow.py                                                   ║" -ForegroundColor Yellow
Write-Host "║                                                                             ║" -ForegroundColor White
Write-Host "║  🌐 Web Interface: http://localhost:8080                                   ║" -ForegroundColor White
Write-Host "║                                                                             ║" -ForegroundColor White
Write-Host "║  📖 Documentation:                                                         ║" -ForegroundColor White
Write-Host "║     Type 'help' in the terminal                                             ║" -ForegroundColor White
Write-Host "║                                                                             ║" -ForegroundColor White
Write-Host "║  ⚠️  For full functionality, run as Administrator:                         ║" -ForegroundColor Yellow
Write-Host "║     Right-click PowerShell -> Run as Administrator                          ║" -ForegroundColor Yellow
Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Quick test
Write-Host "[INFO] Running quick test..." -ForegroundColor Cyan
try {
    python -c "import red_sparrow; print('✅ Module loaded successfully')"
    Write-Host "[OK] Quick test passed" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Quick test failed. Check dependencies manually." -ForegroundColor Yellow
}

Write-Host "[OK] Installation complete!" -ForegroundColor Green
Read-Host "Press Enter to exit"