#!/bin/bash

# Скрипт для локального запуска приложения

set -e

echo "🚀 Starting FastAPI Pet Project..."

# Проверка виртуального окружения
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Активация виртуального окружения
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Установка зависимостей
echo "📥 Installing dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements-dev.txt

# Проверка кода
echo "✅ Running code checks..."
echo "  - Formatting with black..."
black app tests --check || (echo "❌ Code formatting failed. Run 'make format'" && exit 1)

echo "  - Linting with flake8..."
flake8 app tests || (echo "⚠️  Linting issues found" && true)

# Запуск тестов
echo "🧪 Running tests..."
pytest tests/ -v --cov=app --cov-report=term-missing

# Запуск приложения
echo ""
echo "✨ All checks passed! Starting application..."
echo "📍 API will be available at: http://localhost:8000"
echo "📚 Docs available at: http://localhost:8000/docs"
echo ""
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

