#!/usr/bin/env bash
# ================================================
# RedSparrow v2.0.0 - Linux/macOS Installation
# ================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${RED}"
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                         🐦 RED_SPARROW INSTALLER                            ║"
echo "║                              v2.0.0                                         ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check Python version
echo -e "${BLUE}🔍 Checking Python version...${NC}"
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
if [[ $(echo "$PYTHON_VERSION < 3.7" | bc) -eq 1 ]]; then
    echo -e "${RED}❌ Python 3.7+ is required. Found: $PYTHON_VERSION${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $PYTHON_VERSION found${NC}"

# Install dependencies
echo -e "${BLUE}📦 Installing system dependencies...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-pip python3-venv nmap nikto hping3 \
            traceroute dnsutils whois openssh-client iptables net-tools \
            tcpdump build-essential libpcap-dev libssl-dev curl wget git
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-pip python3-virtualenv nmap nikto hping3 \
            traceroute bind-utils whois openssh-clients iptables net-tools \
            tcpdump gcc libpcap-devel openssl-devel curl wget git
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y python3-pip python3-virtualenv nmap nikto hping3 \
            traceroute bind-utils whois openssh-clients iptables net-tools \
            tcpdump gcc libpcap-devel openssl-devel curl wget git
    else
        echo -e "${YELLOW}⚠️ Unknown package manager. Installing Python packages only.${NC}"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}⚠️ Homebrew not found. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python3 nmap nikto hping3 traceroute bind whois openssh iptables net-tools tcpdump
fi

# Create virtual environment
echo -e "${BLUE}🐍 Creating Python virtual environment...${NC}"
python3 -m venv venv
source venv/bin/activate

# Upgrade pip
echo -e "${BLUE}⬆️ Upgrading pip...${NC}"
pip install --upgrade pip

# Install requirements
echo -e "${BLUE}📦 Installing Python packages...${NC}"
if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
else
    echo -e "${YELLOW}⚠️ requirements.txt not found. Installing core packages...${NC}"
    pip install cryptography paramiko requests psutil colorama Flask \
        flask-socketio discord.py telethon slack-sdk selenium \
        webdriver-manager scapy python-whois qrcode pyshorteners
fi

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p .red_sparrow reports phishing_pages captured_credentials \
    ssh_keys nmap_results curl_results spoof_logs web_ui

# Setup configuration
echo -e "${BLUE}⚙️ Setting up configuration...${NC}"
if [[ ! -f .red_sparrow/config.json ]]; then
    cat > .red_sparrow/config.json << 'EOF'
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
EOF
    echo -e "${GREEN}✅ Configuration created${NC}"
fi

# Make script executable
chmod +x red_sparrow.py

# Setup logging
touch .red_sparrow/red_sparrow.log
chmod 666 .red_sparrow/red_sparrow.log

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                        ✅ INSTALLATION COMPLETE                             ║"
echo "╠══════════════════════════════════════════════════════════════════════════════╣"
echo "║  🐦 RedSparrow v2.0.0 installed successfully!                              ║"
echo "║                                                                             ║"
echo "║  📁 Installation Directory: $(pwd)                                         ║"
echo "║  🐍 Virtual Environment: $(pwd)/venv                                       ║"
echo "║                                                                             ║"
echo "║  🚀 To start RedSparrow:                                                   ║"
echo "║     source venv/bin/activate                                                ║"
echo "║     python3 red_sparrow.py                                                  ║"
echo "║                                                                             ║"
echo "║  🌐 Web Interface: http://localhost:8080                                   ║"
echo "║                                                                             ║"
echo "║  📖 Documentation:                                                         ║"
echo "║     Type 'help' in the terminal                                             ║"
echo "║                                                                             ║"
echo "║  ⚠️  For full functionality, run with sudo:                                ║"
echo "║     sudo python3 red_sparrow.py                                             ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Run a quick test
echo -e "${BLUE}🔍 Running quick test...${NC}"
python3 -c "import red_sparrow; print('✅ Module loaded successfully')" 2>/dev/null || \
    echo -e "${YELLOW}⚠️ Quick test failed. Check dependencies manually.${NC}"

echo -e "${GREEN}🎉 Installation complete!${NC}"