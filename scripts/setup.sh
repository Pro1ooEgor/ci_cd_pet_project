#!/bin/bash

# Скрипт для первоначальной настройки проекта

set -e

echo "🎯 Setting up FastAPI Pet Project..."
echo ""

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.10 or higher."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✅ Found Python $PYTHON_VERSION"

# Создание виртуального окружения
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
else
    echo "✅ Virtual environment already exists"
fi

# Активация виртуального окружения
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Обновление pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip -q

# Установка зависимостей
echo "📥 Installing dependencies..."
pip install -r requirements-dev.txt -q

# Создание .env файла если его нет
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
# Environment Configuration
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=info
API_HOST=0.0.0.0
API_PORT=8000
EOF
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Установка pre-commit hooks (опционально)
if command -v pre-commit &> /dev/null; then
    echo "🎣 Installing pre-commit hooks..."
    pre-commit install
else
    echo "ℹ️  pre-commit not found. Skipping hooks installation."
fi

# Запуск тестов для проверки
echo ""
echo "🧪 Running tests to verify setup..."
pytest tests/ -v

echo ""
echo "✨ Setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "  1. Activate virtual environment: source venv/bin/activate"
echo "  2. Run the application: make run"
echo "  3. Open http://localhost:8000/docs"
echo ""
echo "📚 Useful commands:"
echo "  - make help           # Show all available commands"
echo "  - make test           # Run tests"
echo "  - make docker-up      # Run with Docker"
echo ""

