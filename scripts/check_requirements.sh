#!/bin/bash

# Скрипт для проверки системных требований

echo "🔍 Checking system requirements for FastAPI Pet Project..."
echo ""

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

all_good=true

# Проверка Python
echo -n "Checking Python 3... "
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version | cut -d' ' -f2)
    major=$(echo $python_version | cut -d'.' -f1)
    minor=$(echo $python_version | cut -d'.' -f2)
    
    if [ "$major" -ge 3 ] && [ "$minor" -ge 10 ]; then
        echo -e "${GREEN}✓${NC} Python $python_version"
    else
        echo -e "${YELLOW}⚠${NC} Python $python_version (recommended 3.10+)"
    fi
else
    echo -e "${RED}✗${NC} Not installed"
    echo "   Install: https://www.python.org/downloads/"
    all_good=false
fi

# Проверка pip
echo -n "Checking pip... "
if command -v pip3 &> /dev/null; then
    pip_version=$(pip3 --version | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} pip $pip_version"
else
    echo -e "${RED}✗${NC} Not installed"
    all_good=false
fi

# Проверка Git
echo -n "Checking Git... "
if command -v git &> /dev/null; then
    git_version=$(git --version | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} Git $git_version"
else
    echo -e "${YELLOW}⚠${NC} Not installed (optional)"
fi

# Проверка Docker
echo -n "Checking Docker... "
if command -v docker &> /dev/null; then
    docker_version=$(docker --version | cut -d' ' -f3 | tr -d ',')
    echo -e "${GREEN}✓${NC} Docker $docker_version"
    
    # Проверка Docker daemon
    if docker ps &> /dev/null; then
        echo -e "   ${GREEN}✓${NC} Docker daemon is running"
    else
        echo -e "   ${YELLOW}⚠${NC} Docker daemon is not running"
    fi
else
    echo -e "${YELLOW}⚠${NC} Not installed (optional but recommended)"
    echo "   Install: https://docs.docker.com/get-docker/"
fi

# Проверка Docker Compose
echo -n "Checking Docker Compose... "
if command -v docker-compose &> /dev/null; then
    compose_version=$(docker-compose --version | cut -d' ' -f3 | tr -d ',')
    echo -e "${GREEN}✓${NC} Docker Compose $compose_version"
elif docker compose version &> /dev/null; then
    compose_version=$(docker compose version | cut -d' ' -f3 | tr -d ',')
    echo -e "${GREEN}✓${NC} Docker Compose $compose_version (plugin)"
else
    echo -e "${YELLOW}⚠${NC} Not installed (optional)"
fi

# Проверка curl
echo -n "Checking curl... "
if command -v curl &> /dev/null; then
    curl_version=$(curl --version | head -1 | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} curl $curl_version"
else
    echo -e "${YELLOW}⚠${NC} Not installed (optional)"
fi

# Проверка make
echo -n "Checking make... "
if command -v make &> /dev/null; then
    make_version=$(make --version | head -1 | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} make $make_version"
else
    echo -e "${YELLOW}⚠${NC} Not installed (optional but useful)"
fi

# Опциональные инструменты
echo ""
echo "📦 Optional tools (for advanced features):"

echo -n "  kubectl... "
if command -v kubectl &> /dev/null; then
    kubectl_version=$(kubectl version --client --short 2>/dev/null | cut -d' ' -f3)
    echo -e "${GREEN}✓${NC} $kubectl_version"
else
    echo -e "${YELLOW}⚠${NC} Not installed"
fi

echo -n "  minikube... "
if command -v minikube &> /dev/null; then
    minikube_version=$(minikube version --short 2>/dev/null)
    echo -e "${GREEN}✓${NC} $minikube_version"
else
    echo -e "${YELLOW}⚠${NC} Not installed"
fi

# Итоги
echo ""
echo "════════════════════════════════════════"
if [ "$all_good" = true ]; then
    echo -e "${GREEN}✨ All required tools are installed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./scripts/setup.sh"
    echo "  2. Or read: QUICKSTART.md"
else
    echo -e "${RED}❌ Some required tools are missing${NC}"
    echo ""
    echo "Please install missing tools and run this script again."
fi
echo "════════════════════════════════════════"

exit 0

