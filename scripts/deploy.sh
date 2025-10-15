#!/bin/bash

# Скрипт для деплоя приложения на сервер

set -e

# Настройки (переопределите через переменные окружения)
SERVER_HOST=${SERVER_HOST:-"your-server.com"}
SERVER_USER=${SERVER_USER:-"deploy"}
APP_DIR=${APP_DIR:-"/opt/fastapi-app"}
DOCKER_IMAGE=${DOCKER_IMAGE:-"ghcr.io/yourusername/ci_cd_pet_project:latest"}

echo "🚀 Deploying FastAPI Pet Project..."
echo "📍 Target: $SERVER_USER@$SERVER_HOST:$APP_DIR"
echo ""

# Проверка переменных окружения
if [ "$SERVER_HOST" = "your-server.com" ]; then
    echo "❌ Please set SERVER_HOST environment variable"
    echo "   Example: export SERVER_HOST=192.168.1.100"
    exit 1
fi

# Функция для выполнения команд на сервере
run_remote() {
    ssh "$SERVER_USER@$SERVER_HOST" "$@"
}

# Проверка соединения с сервером
echo "🔍 Checking connection to server..."
if ! ssh -o ConnectTimeout=5 "$SERVER_USER@$SERVER_HOST" "echo 'Connected'" &> /dev/null; then
    echo "❌ Cannot connect to server. Check your SSH configuration."
    exit 1
fi
echo "✅ Connected to server"

# Создание директории приложения если её нет
echo "📁 Preparing application directory..."
run_remote "mkdir -p $APP_DIR"

# Копирование docker-compose файла
echo "📤 Uploading docker-compose.yml..."
scp docker-compose.yml "$SERVER_USER@$SERVER_HOST:$APP_DIR/"

# Остановка старой версии
echo "🛑 Stopping old version..."
run_remote "cd $APP_DIR && docker-compose down || true"

# Загрузка нового образа
echo "📥 Pulling new Docker image..."
run_remote "docker pull $DOCKER_IMAGE"

# Запуск новой версии
echo "🚀 Starting new version..."
run_remote "cd $APP_DIR && docker-compose up -d"

# Ожидание запуска
echo "⏳ Waiting for application to start..."
sleep 10

# Проверка здоровья приложения
echo "🏥 Health check..."
if run_remote "curl -f http://localhost:8000/health" &> /dev/null; then
    echo "✅ Application is healthy!"
else
    echo "❌ Health check failed!"
    echo "📋 Checking logs..."
    run_remote "cd $APP_DIR && docker-compose logs --tail=50"
    exit 1
fi

# Проверка статуса контейнеров
echo "📊 Container status:"
run_remote "cd $APP_DIR && docker-compose ps"

echo ""
echo "✨ Deployment completed successfully!"
echo "🌐 Application URL: http://$SERVER_HOST:8000"
echo "📚 API Docs: http://$SERVER_HOST:8000/docs"
echo ""

